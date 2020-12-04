This code is a Matlab implementation for single object tracking of the tracking algorithm
described in "Single and Multiple Object Tracking Using Log-Euclidean 
Riemannian Subspace and Block-Division Appearance Model" by W.M. Hu,
X. Li, W.H. Luo, X.Q. Zhang, S. Maybank, Z.F. Zhang (2012).

Matlab script file to start:
  trackparam.m : loads a data set and sets parameters up
  Main_Tracking.m : run tracking
so you can try 'trackparam; Main_Tracking;' in matlab command window.

Note that the performance depends on the setting of parameters. For example, larger 
covariance values of the motion model and more particles will possibly lead
to better results, however, at the cost of increased computation.

citation bibtex:
@article{hu2012single,
	title={Single and Multiple Object Tracking Using Log-Euclidean Riemannian Subspace and Block-Division Appearance Model},  
	author={Hu, Weiming and Li, Xi and Luo, Wenhan and Zhang, Xiaoqin and Maybank, Stephen and Zhang, Zhongfei},
    journal={Pattern Analysis and Machine Intelligence, IEEE Transactions on},
    number={99},  
    pages={1--1},
    year={2012},
	publisher={IEEE}
}

Questions regarding the code may be directed to Dr. Xi Li
(xi.li03@adelaide.edu.au) or Wenhan Luo (w.luo12@imperial.ac.uk).