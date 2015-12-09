function [para, cnn, W, AUC]=GLMRun(X, trainRatio, minlag, maxlag,lambda,reg, plotfig)
%run glm
%
% SYNOPSIS: [para, cnn, W, AUC]=GLMRun(X, trainRatio, minlag, maxlag,lambda,reg, plotfig)
%
% INPUT X:  m x T
%		trainRatio: percentage of data used for training  
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
if ~exist('plotfig','var')
    plotfig=false;
end

if ~exist('lambda','var')
    lambda=1;
end

if ~exist('reg','var')
    reg='None';
end

[m,T]=size(X);
trainT=int32(T*trainRatio);
trainX=X(:,1:trainT);
testX=X(:,trainT+1:end);

% train the model
[para, ~, dynamicX] = GLMTrain(trainX, minlag, maxlag, lambda, reg);

% get connection matrix
[cnn]=GLMInfluenceMatrix(para,trainX, dynamicX, minlag, maxlag);

% calculate predicts
[~,W,~,AUC]=GLMPredict(para,testX,minlag,maxlag, plotfig);


end