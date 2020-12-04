function Vec = Matrix2Vector(C,mode)

ord = size(C,1);
Vec = reshape(C,[ord*ord 1]);
