function [obj,grad]=batchGLMGrad(w,inputs,minlag,maxlag,lamda,reg)
%get gradients for a set of recordings, leave out those neurons that are masked in each recording 
%
% SYNOPSIS: [obj,grad]=batchGLMGrad(w,inputs,minlag,maxlag,lamda,reg)
%
% INPUT w: parameters flat array
%		inputs: cell array {[dyX,[masked1,masked2..]]}  
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 11-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('lamda','var')
    lamda=1;
end

if ~exist('reg','var')
    reg='None';
end

batchN=size(inputs,1);
dynamicX=inputs{1,1};
X0=dynamicX{1};
[m,~]=size(X0);

W=cell(maxlag,1);
b=reshape(w(1:m),[m 1]);

for i=minlag:maxlag
    startPoint=(i-minlag)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W{i}=reshape(w(startPoint:endPoint),[m m]);
end

obj=0;
grad=zeros(size(w));
for bn=1:batchN
    dynamicX=inputs{bn,1};
    maskedNeurons=inputs{bn,2};
    X0=dynamicX{1};
    [~,T]=size(X0);
    bOne=ones(1,T);

    mainM=zeros(m,T);
    for i=minlag:maxlag
        mainM=mainM+W{i}*dynamicX{i+1};
    end
    mainM=mainM++b*bOne;
    mainMExp=exp(mainM);
    obj_bn=X0.*mainM-mainMExp;
    obj_bn(maskedNeurons,:)=0;     % update obj according to masked neurons
    
    tempDiff=X0-mainMExp;
    grad_bn=-tempDiff*bOne';
    grad_bn(maskedNeurons,:)=0;
    for i=minlag:maxlag
        wGrad=-tempDiff*dynamicX{i+1}';
        wGrad(maskedNeurons,:)=0;  % update obj according to masked neurons

        grad_bn=cat(1,grad_bn,wGrad(:));
    end
    obj=obj-sum(obj_bn(:));
    grad=grad+grad_bn;
end

if strcmp(reg,'L2')
    obj=obj+lamda*(w(m+1:end)'*w(m+1:end))/2; % L2 regularization
    grad(m+1:end)=grad(m+1:end)+lamda*w(m+1:end); % L2
    disp('2');
else if strcmp(reg,'L1')
        obj=obj+lamda*(sum(abs(w(m+1:end)))); % L1 regularization
        grad(m+1:end)=grad(m+1:end)+lamda*((w(m+1:end)>0)*2-1); % L1
        disp('1');
    end
end
disp('0');


end