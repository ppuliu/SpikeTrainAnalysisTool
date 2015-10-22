

function [para, cnn, W, AUC]=cosineGLMRun(X, trainRatio, minlag, maxlag, ncosines,lambda,reg, plotfig)
% X m x T
% trainRatio


[m,T]=size(X);
trainT=int32(T*trainRatio);
trainX=X(:,1:trainT);
testX=X(:,trainT+1:end);

% train the model
[para, ~, dynamicX] = cosineGLMTrain(trainX, minlag, maxlag, ncosines,lambda,reg);

% get connection matrix
[cnn]=cosineGLMInfluenceMatrix(para,trainX, dynamicX,ncosines);

% calculate predicts
[~,W,~,AUC]=cosineGLMPredict(para,testX,minlag,maxlag, ncosines, plotfig);


end
