#include "mex.h"
#include <math.h>
#include "memory.h"
#include "stdio.h"
#define Dim 6

inline double * GMean(double *pImg[], const int * dimz, double *P1, double *P2)
{
	double *pData=new double[Dim];
	for (int d=0;d<Dim;d++)
	{
		double tmp=0.0;
		for (int i=(int)P1[0]-1;i<=(int)P2[0]-1;i++)
		{
			for (int j=(int)P1[1]-1;j<=(int)P2[1]-1;j++)
			{
				tmp+=pImg[d][i*dimz[1]+j];
			}
		}
		pData[d]=tmp/((P2[0]-P1[0]+1)*((P2[1]-P1[1]+1)));
	}
	return pData;
}


inline void VecProduct(double *a, double *pData)
{
	for (int i=0;i<Dim;i++)
    {
		for (int j=0;j<Dim;j++)
		{
			pData[i*Dim+j]+=a[i]*a[j];
		}	
    }
}


inline double * VecAdd(double *a,double *b)
{
    double *pData=new double[Dim*Dim];
	for (int i=0;i<Dim*Dim;i++)
    {
	    pData[i]=a[i]+b[i];
    }
    return pData;
}


inline void VecSub(double *a,double *b)
{
	for (int i=0;i<Dim;i++)
    {
        a[i]=a[i]-b[i];
    }
}


inline void ConstProduct(double *a,double lamda)
{
	for (int i=0;i<Dim*Dim;i++)
    {
        a[i]=a[i]*lamda;
    }
}


inline void VecFlat(double *a,double *b)
{
	int index=0;
	for (int i=0;i<Dim;i++)
    {
		for (int j=i;j<Dim;j++)
		{
			if(j==i)
			{
				b[index]=a[i*Dim+j];
			}
			else
			{
                b[index]=sqrt(double(2))*a[i*Dim+j];
			}
			index++;
		}
	}
	
}


//-----------------------------------------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  const int CP_1=Dim;
  const int CP_2=Dim+1;
  double *P1 = mxGetPr(prhs[CP_1]);
  double *P2 = mxGetPr(prhs[CP_2]);
  const int *dimz = mxGetDimensions(prhs[0]);
  mxArray *F=NULL,*FVec=NULL;
  F = plhs[0] = mxCreateDoubleMatrix(Dim,Dim, mxREAL);
  
  const mxArray  *Q[Dim];
  double *InData[Dim];

    
  for (int ii=0;ii<Dim;ii++)
  {
     Q[ii] = prhs[ii];
	 InData[ii]=mxGetPr(Q[ii]);
  }
  
  double * RM=GMean(InData,dimz,P1,P2);
  
  double *Cov=mxGetPr(F);

  for(int kk=0;kk<Dim*Dim;kk++)
  {
      Cov[kk]=0.0;
  }
 
  for (int i=(int)P1[0]-1;i<=(int)P2[0]-1;i++)
  {
	  for (int j=(int)P1[1]-1;j<=(int)P2[1]-1;j++)
	  {
          double *tmp=new double[Dim];
		  for (int d=0;d<Dim;d++)
          {
			  tmp[d]=InData[d][i*dimz[1]+j]-RM[d];
          }

          VecProduct(tmp,Cov);
		  delete []tmp;
	  }
  }
  double lamda=1.0/((P2[0]-P1[0]+1)*((P2[1]-P1[1]+1)));
  ConstProduct(Cov,lamda);
}
  




  

  
  
  
  
