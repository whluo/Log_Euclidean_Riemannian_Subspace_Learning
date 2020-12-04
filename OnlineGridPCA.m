function [U,D,M]=OnlineGridPCA(X,R,U,D,M,lamda,n)
%--------------------------------------------------
%To update the subspace for each block via R_SVD
%   X -- feature data of each block (buffered data)
%   R -- maximum number of the output largest base vector
%   U (input) -- base vector of the subspace before updating
%   D (input) -- diagonal matrix before updating
%   M (input) -- mean before updating
%   lamda -- an factor used in R_SVD
%   n -- the number of frames which have been processed  
%   U (output) -- base vector of the subspace after updating
%   D (output) -- diagonal matrix after updating
%   M (output) -- mean after updating
%--------------------------------------------------

I = size(X);
A_1 = [];
if length(I) == 2
    M_0 = mean(X,2);
    M_e = repmat(M_0,[1 I(2)]);
    A_1 = [A_1 X(:,:)-M_e sqrt(I(2)*n/(I(2)+n))*(M-M_0)];
    if ~isempty(R)
        [U,D] = R_SVD_r(A_1,U,D,R,lamda);
    else
        [U,D] = R_SVD(A_1,U,D);
    end
    M = (n*M+I(2)*M_0)/(n+I(2));
    A_1 = [];
else
    for i=1:I(3)
        M_0(:,i) = mean(X(:,:,i),2);
        M_e(:,:,i) = repmat(M_0(:,i),[1 I(2)])
        A_1(:,:,i) = [X(:,:,i)-M_e(:,:,i) sqrt(I(2)*n/(I(2)+n))*(M(:,i)-M_0(:,i))];
        if ~isempty(R)
            [U{i},D{i}] = R_SVD_r(A_1(:,:,i),U{i},D{i},R{i},lamda);
        else
            [U{i},D{i}] = R_SVD(A_1(:,:,i),U{i},D{i});
        end
        M(:,i) = (n*M(:,i)+I(2)*M_0(:,i))/(n+I(2));
        A_1 = [];
    end
end