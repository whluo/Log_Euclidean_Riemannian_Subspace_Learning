function drawResult(fno,frame,param,tmpl)
%--------------------------------------------------
%Draw the current result
%--------------------------------------------------
figure(1)
imshow(frame);

sz      = size(tmpl.mean);
w       = sz(1);
h       = sz(2);
M       = [param.est(1) param.est(3) param.est(4); param.est(2) param.est(5) param.est(6)];
corners = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';
corners = M * corners;
text(25,25, num2str(fno), 'Color','y', 'FontWeight','bold', 'FontSize',18);
line(corners(1,:), corners(2,:), 'Color','r', 'LineWidth',2.5);



