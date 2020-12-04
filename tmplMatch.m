function param = tmplMatch(frm, tmpl, param, opt)
%--------------------------------------------------
%To find the most confident candidate according to template match
%--------------------------------------------------
n   = opt.numsample;
sz  = size(tmpl.mean);
N   = sz(1)*sz(2);

if ~isfield(param,'param')
    param.param = repmat(affparam2geom(param.est(:)), [1,n]);
else
    cumconf         = cumsum(param.conf);
    idx             = floor(sum(repmat(rand(1,n),[n,1]) > repmat(cumconf,[1,n])))+1;
    param.param     = param.param(:,idx);
end

param.param         = param.param + randn(6,n).*repmat(opt.affsig(:),[1,n]);
wimgs               = warpimg(frm, affparam2mat(param.param), sz);
diff                = repmat(tmpl.mean(:),[1,n]) - reshape(wimgs,[N,n]);
param.conf          = exp(-sum(diff.^2)./opt.condenssig)';
param.conf          = param.conf ./ sum(param.conf);
[~,maxidx]          = max(param.conf);
param.est           = affparam2mat(param.param(:,maxidx));
param.wimg          = wimgs(:,:,maxidx);
