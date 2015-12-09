function [cnn]=GLMInfluenceMatrix(w,trainX, dynamicX, minlag, maxlag)
%get network from GLM
%
% SYNOPSIS: [cnn]=GLMInfluenceMatrix(w,trainX, dynamicX)
%
% INPUT w : parameter flat array
%		trainX : training data for normalization m x T
%		dynamicX : column cell array  maxlag+1          
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
disp('Calculating influence matrix');
X0=dynamicX{1};
[m,T]=size(X0);
W=cell(maxlag,1);
%b=reshape(w(1:m),[m 1]);
%bOne=ones(1,T);
norm=ones(m,1)*sum(trainX'); % m x m
cnn=zeros(m,m);
for chN=1:m
    fprintf('getting influence vector for channel: %d \n',chN);
    mainM=zeros(m,T);
    for i=minlag:maxlag
        startPoint=(i-minlag)*m*m+1+m;
        endPoint=startPoint+m*m-1;
        W{i}=reshape(w(startPoint:endPoint),[m m]);
        mainM=mainM+W{i}(chN,:)'*ones(1,T).*dynamicX{i+1};
    end
    cnn(chN,:)=cnn(chN,:)+sum(mainM');
end

cnn=cnn./norm;

end