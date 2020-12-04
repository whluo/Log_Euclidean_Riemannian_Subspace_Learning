
OutputDir   = 'F:\work\res\';  %% to save the result images
num_frames  = size(data,2);
I0          = data(:,:,1);
frame       = double(I0)/256;
tmpl.mean   = warpimg(frame, param0, opt.tmplsize);
sz          = size(tmpl.mean);  
N           = sz(1)*sz(2);
param       = [];
param.est   = param0;
param.wimg  = tmpl.mean;
frame_show  = repmat(frame,[1 1 3]);

%%% draw initial track window
drawResult(1, frame_show, param, tmpl);

GridCovArray   = cell(opt.GridNum);
Pa             = param;

for f = 1:opt.num_learning_frames
    if f == 1
        GridCovArray = ImageGrid(256*param.wimg,opt.GridNum,GridCovArray);  
    else
        I0          = data(:,:,f);
        frame       = double(I0)/256;
        frame_show  = repmat(frame,[1 1 3]);
        Pa          = tmplMatch(frame, tmpl, Pa, opt);
        drawResult(f, frame_show, Pa,tmpl);
        imwrite(frame2im(getframe(gca)),sprintf('%s_%04d.bmp',[OutputDir 'TrackResult'],f));
        GridCovArray = ImageGrid(256*Pa.wimg,opt.GridNum,GridCovArray); 
    end
end


U = cell(opt.GridNum);  
D = cell(opt.GridNum);
M = cell(opt.GridNum);

for i = 1:opt.GridNum(1)
    for j = 1:opt.GridNum(2)
        [U{i,j},D{i,j},M{i,j}] = OfflineGridPCA(GridCovArray{i,j},opt.R);
    end
end

wimgs   = [];
Buffer  = cell(opt.GridNum);
BufferI = 0;

L = opt.num_learning_frames;
n = opt.num_runtime_particle;  % number of particles at run time

%%% track the sequence from the (opt.num_learning_frames+1) frame onward
for f = opt.num_learning_frames+1:num_frames
    I0          = data(:,:,f); 
    frame       = double(I0)/256;
    frame_show  = repmat(frame,[1 1 3]); 
    sz          = size(tmpl.mean);
    PredParam   = repmat(affparam2geom(param.est(:)), [1,n]);
    a           = randn(6,n);
    PredParam   = PredParam + a.*repmat(opt.affsig(:),[1,n]);  
    wimgs       = warpimg(frame, affparam2mat(PredParam), sz);
    Liki        = [];  %likelihood 
    for II = 1:n
        buf             = 0.0;
        bufA            = 0.0;
        GridCovArray    = OnlineImageGrid(256*wimgs(:,:,II),opt.GridNum); 
        LikiMap         = [];
        for i = 1:opt.GridNum(1)
            for j = 1:opt.GridNum(2)
                buf     = buf + (((2*i-1)*(16/opt.GridNum(1))-16)^2+((2*j-1)*(16/opt.GridNum(2))-16)^2)/30; 
                tmp     = opt.scale*sum((GridCovArray{i,j}-M{i,j}-U{i,j}*U{i,j}'*(GridCovArray{i,j}-M{i,j})).^2);  % restruction 
                bufA    = bufA + tmp; 
                LikiMap = [LikiMap exp(-2000*tmp)];
            end
        end
        Prob = GridGraphLaplacian(LikiMap,opt.GridNum);
        Liki = [Liki exp(-buf)*mvnpdf(a(:,II),zeros(6,1),eye(6))*(0.9*exp(-bufA)+0.1*Prob)];
    end
   
    [V,No]      = max(Liki);
    Param       = PredParam(:,No);
    param.est   = affparam2mat(Param);
    
    drawResult(f, frame_show, param,tmpl);
     
    BufferI     = BufferI+1;
    Buffer      = BufOnlineImageGrid(256*wimgs(:,:,No),opt.GridNum,Buffer);
    
    if rem(BufferI,opt.num_update_frame) == 0
        for i = 1:opt.GridNum(1)
            for j = 1:opt.GridNum(2)
                [U{i,j},D{i,j},M{i,j}] = OnlineGridPCA(Buffer{i,j},opt.R,U{i,j},D{i,j},M{i,j},opt.lamda,L);
                Buffer{i,j} = [];
            end
        end        
        L       = f;
        BufferI = 0;
    end   
    imwrite(frame2im(getframe(gca)),sprintf('%s_%04d.png',[OutputDir 'TrackResult'],f));
end
