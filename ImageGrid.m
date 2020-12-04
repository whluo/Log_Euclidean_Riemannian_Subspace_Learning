function GridCovArray = ImageGrid(I,GridNum,GridCovArray)
%--------------------------------------------------
%Divide the normalized template into blocks and extract covariance matrix 
%as feature to represent each block. 
%   I -- the normalized template
%   GridNum -- number of blocks 
%   GridCovArray -- Array to save the covariance matrix 
%NOTE: each covariance matrix is vectorized before being saved
%--------------------------------------------------
sz         = [size(I,1) size(I,2)];
GridSize   = floor(sz./GridNum);

for i = 1:GridNum(1)
    Idx = (i-1)*GridSize(1) + [1:GridSize(1)];
    for j = 1:GridNum(2)
        Idy = (j-1)*GridSize(2) + [1:GridSize(2)];
        GridCovArray{i,j} = [GridCovArray{i,j} ...
            Matrix2Vector(logm(eye(6)*1e-5+GPC(I(Idx,Idy),[1 1],[GridSize(1)-2 GridSize(2)-2])),'reduce')];     
    end
end
