function [Coor_x,Coor_y,Intensity,Der_1x,Der_1y,GradMod] = GRCG(I,M,N)

tlt_1 = [-1 0 1];
I = double(I);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Der_1x = abs(conv2(I,tlt_1,'same'));
Der_1x = Der_1x(1:end-2,2:end-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Der_1y = abs(conv2(I,tlt_1','same'));
Der_1y = Der_1y(2:end-1,1:end-2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Coor_x = repmat([1:M-2]',1,N-2);
Coor_y = repmat([1:N-2],M-2,1);
GradMod = sqrt(Der_1x.^2+Der_1y.^2);
Intensity = I(1:M-2,1:N-2);