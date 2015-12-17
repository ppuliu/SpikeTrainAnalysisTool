function [predictX,W,obj,AUC]=GLMPredict(w,targetX,minlag,maxlag, plotfig)
%use inferred parameters to do predictions
%
% SYNOPSIS: [predictX,W,obj,AUC]=GLMPredict(w,targetX,minlag,maxlag, plotfig)
%
% INPUT w : m + m x m x (maxlag-minlag+1) flat array
%		dynamicX : column cell array                  
%
% OUTPUT 
%       obj: log likelihood
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 08-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('plotfig','var')
    plotfig=false;
end

disp('Calculating predictions');

dynamicX=GLMPrepareData(targetX,minlag,maxlag);

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
obj=X0.*mainM-exp(mainM);
obj=sum(obj(:));
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