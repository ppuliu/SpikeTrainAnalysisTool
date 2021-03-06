% use inferred parameters to do predictions

function [predictX,W,obj,AUC]=cosineGLMPredict(w,targetX,minlag,maxlag, p, plotfig)
% w : m + m x m x (maxlag-minlag+1) flat array
% dynamicX : column cell array  p+1
% p : number of basis functions

if ~exist('plotfig','var')
    plotfig=false;
end

dynamicX=cosineGLMPrepareData(targetX,minlag,maxlag,p);

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
mainM=mainM+b*bOne;
%predictX=exp(-exp(mainM)).*exp(mainM);
obj=X0.*mainM-exp(mainM);
obj=sum(obj(:));
%predictX=exp(mainM);
predictX=1-exp(-exp(mainM)); % P(x(k)>0)=1-exp(-lambda) 

% calculate AUC
labels=logical(X0(:));
scores=predictX(:);
[AUC,fpr,tpr] = fastAUC(labels,scores,plotfig);
if plotfig
    % plot overlay figure
    figure
    overlayPredicts(X0,predictX);
end

end
    
    