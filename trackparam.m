% script: trackparam.m
% loads data and initializes variables

clc
clear

% initialise the random number generator 
rand('state',sum(100*clock));  randn('state',sum(100*clock));


title = 'trellis70';

switch (title)   
case 'dudek';  
    p = [192,195,110,130,-0.11];
    opt = struct('numsample',400, 'condenssig',0.25, ...  % use your initialization here, the initialization provided here is not promised to be the best one.
                 'affsig',[12,12,.05,.05,.005,.001]);
             load dudek;                  
             
case 'trellis70'; 
    p = [208 116 62 68 0]; 
    opt = struct('numsample',400, 'condenssig',0.2, ...  % use your initialization here, the initialization provided here is not promised to be the best one.
                 'affsig',[6,6,.03,.02,.005,.001]);
    load trellis70.mat;

case 'fish';  
    p = [165 102 62 80 0];
    opt = struct('numsample',400, 'condenssig',0.2, ... % use your initialization here, the initialization provided here is not promised to be the best one.
                 'affsig',[7,7,.01,.01,.002,.001]);
    load fish       
    
case 'car11'; 
    p = [89 140 30 25 0];
    opt = struct('numsample',400, 'condenssig',0.2, ... % use your initialization here, the initialization provided here is not promised to be the best one.
                 'affsig',[5,5,.01,.01,.001,.001]);
    load car11
    
otherwise;  
    error(['unknown title ' title]);
    
end

if ~isfield(opt,'tmplsize')   opt.tmplsize      = [28 28];  end  % size of the normalized template 
if ~isfield(opt,'errfunc')    opt.errfunc       = 'L2';  end
if ~isfield(opt,'GridNum')    opt.GridNum       = [4 4];  end   % number of blocks, typically it should be 4 by 4
if ~isfield(opt,'scale')      opt.scale         = 1/1;  end   
if ~isfield(opt,'lamda')      opt.lamda         = 1;  end   
if ~isfield(opt,'R')          opt.R             = 8;  end   


if ~isfield(opt,'num_runtime_particle')   
    opt.num_runtime_particle = 20;
end

if ~isfield(opt,'num_learning_frames')  % this parameter sets the number of frames required to learn the appearance model before runtime  
    opt.num_learning_frames = 4;
end

if ~isfield(opt,'num_update_frame')  % every this number of frames, the appearance model is updated
    opt.num_update_frame = 3;
end

param0 = [p(1), p(2), p(3)/28, p(5), p(4)/p(3), 0]; 
param0 = affparam2mat(param0);
