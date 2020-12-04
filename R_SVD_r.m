function [U,D]=R_SVD_r(data,U0,D0,r,lamda)
%--------------------------------------------------
%To update the subspace for each block via R_SVD
%   data -- feature data of each block (buffered data)
%   r -- maximum number of the output largest base vector
%   U0 -- base vector of the subspace before updating
%   D0 -- diagonal matrix before updating
%   lamda -- an factor
%   U -- base vector of the subspace after updating
%   D -- diagonal matrix after updating
%--------------------------------------------------

[Q,R] = qr([lamda*U0*D0, data ]);
[U,D,V] = svds(R,r);
U = Q * U;