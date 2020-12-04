function C = GPC(I,Pos1,Pos2)

Size = size(I);
[Coor_x,Coor_y,Intensity,Der_1x,Der_1y,GradMod] = GRCG(I,Size(1),Size(2));
C = Covariance(Coor_x,Coor_y,Intensity,Der_1x,Der_1y,GradMod,Pos1,Pos2);




