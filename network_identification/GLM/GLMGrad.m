function [obj,grad]=GLMGrad(w,dynamicX,minlag,maxlag,lamda,reg)
%get gradients for GLM parameters
%
% SYNOPSIS: [obj,grad]=GLMGrad(w,dynamicX,minlag,maxlag,lamda,reg)
%
% INPUT w : parameters flat array
%		dynamicX : column cell array  maxlag+1
%		minlag : e.g. 2
%		maxlag : e.g. 20
%		lamda : regulazation term
%		reg : regularization method L1 / L2 / None, if not specified, no regularization  
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 08-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('lamda','var')
    lamda=1;
end

if ~exist('reg','var')
    reg='None';
end


X0=dynamicX{1};
[m,T]=size(X0);
W=cell(maxlag,1);
b=reshape(w(1:m),[m 1]);
bOne=ones(1,T);
mainM=zeros(m,T);
for i=minlag:maxlag
    startPoint=(i-minlag)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W{i}=reshape(w(startPoint:endPoint),[m m]);
    mainM=mainM+W{i}*dynamicX{i+1};
end
mainM=mainM+b*bOne;
mainMExp=exp(mainM);
obj=X0.*mainM-mainMExp;

obj=-sum(obj(:));

if strcmp(reg,'L2')
    obj=obj+lamda*(w(m+1:end)'*w(m+1:end))/2; % L2 regularization
else if strcmp(reg,'L1')
        obj=obj+lamda*(sum(abs(w(m+1:end)))); % L1 regularization
    end
end

tempDiff=X0-mainMExp;
grad=-tempDiff*bOne';
for i=minlag:maxlag
    wGrad=-tempDiff*dynamicX{i+1}';
    if strcmp(reg,'L2')
        wGrad=wGrad+lamda*W{i}; % L2
    else if strcmp(reg,'L1')
            wGrad=wGrad+lamda*((W{i}>0)*2-1); % L1
        end
    end
    grad=cat(1,grad,wGrad(:));
end

end