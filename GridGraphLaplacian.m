function Prob = GridGraphLaplacian(Liki,GridNum)
%--------------------------------------------------
%   Liki -- likelihood of each block
%   GridNum -- number of blocks 
%   Prob --  
%--------------------------------------------------

Prob = 0.0;
num  = 0;
for i = 1:GridNum(1)
    for j = 1:GridNum(2)     
        if j>1
           Prob = Prob + (Liki((i-1)*GridNum(2)+j)-Liki((i-1)*GridNum(2)+j-1))^2;
           num  = num + 1;
           if j < GridNum(2)
              Prob  = Prob + (Liki((i-1)*GridNum(2)+j)-Liki((i-1)*GridNum(2)+j+1))^2;
              num   = num+1;
           end
        end
        if i>1
           Prob = Prob + (Liki((i-1)*GridNum(2)+j)-Liki((i-2)*GridNum(2)+j))^2;
           num  = num + 1;
           if i < GridNum(1)
              Prob  = Prob + (Liki((i-1)*GridNum(2)+j)-Liki(i*GridNum(2)+j))^2;
              num   = num+1;
           end
        end
    end
end
Prob = Prob/num;