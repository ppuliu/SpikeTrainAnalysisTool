% this file implements the derivatives calculation of GLM

function [obj,grad]=cosineGLMGrad(w,dynamicX,p,lamda,reg)
% w : parameters flat array
% dynamicX : column cell array  maxlag+1
% p : number of basis functions
% lamda : regulazation term
% reg : regularization method L1 / L2
X0=dynamicX{1};
[m,T]=size(X0);
W=cell(p,1);
b=reshape(w(1:m),[m 1]);
bOne=ones(1,T);
mainM=zeros(m,T);
for i=1:p
    startPoint=(i-1)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W{i}=reshape(w(startPoint:endPoint),[m m]);
    mainM=mainM+W{i}*dynamicX{i+1};
end
mainM=mainM++b*bOne;
mainMExp=exp(mainM);
obj=X0.*mainM-mainMExp;
if strcmp(reg,'L2')
    obj=-sum(obj(:))+lamda*(w(m+1:end)'*w(m+1:end))/2;  %L2
else
    obj=-sum(obj(:))+lamda*(sum(abs(w(m+1:end))));  %L1
end

tempDiff=X0-mainMExp;
grad=-tempDiff*bOne';
for i=1:p
    if strcmp(reg,'L2')
        wGrad=-tempDiff*dynamicX{i+1}'+lamda*W{i}; % L2
    else
        wGrad=-tempDiff*dynamicX{i+1}'+lamda*((W{i}>0)*2-1); % L1
    end
    %wGrad=-tempDiff*dynamicX{i+1}';
    grad=cat(1,grad,wGrad(:));
end

end
    
    