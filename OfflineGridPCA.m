function [U,D,M]=OfflineGridPCA(X,R)
%--------------------------------------------------
%To set up the subspace for each block via PCA
%   X -- feature data of each block
%   R -- maximum number of the output largest base vector
%   U -- base vector of the subspace
%   D -- diagonal matrix 
%   M -- mean
%--------------------------------------------------
I   = size(X);
A_1 = [];
if length(I) == 2
    M   = mean(X,2);
    M_e = repmat(M,[1 I(2)]);
    A_1 = [A_1 X(:,:)-M_e];
    if ~isempty(R)
        [U,D,V] = svds(A_1,R);
    else
        [U,D,V] = svd(A_1);
    end
    A_1 = [];
else
    for i = 1:I(3)
        M(:,i)      = mean(X(:,:,i),2);
        M_e(:,:,i)  = repmat(M(:,i),[1 I(2)])
        A_1(:,:,i)  = X(:,:,i)-M_e(:,:,i);
        if ~isempty(R)
            [U{i},D{i},V{i}] = svds(A_1(:,:,i),R);
        else
            [U{i},D{i},V{i}] = svd(A_1(:,:,i));
        end
        A_1 = [];
    end
end

end