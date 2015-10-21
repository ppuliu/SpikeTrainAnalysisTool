
% this file implements glm training process

function [optpara, cost, dynamicX] = cosineGLMTrain(trainX, minlag, maxlag, ncosines,lambda,reg)
% trainX : m x T
% minlag
% maxlag
% ncosines : numberof basis functions
% lambda : regularization parameter
% reg : L1 / L2

options.Method = 'lbfgs'; 
options.maxIter =1000;  
options.maxFunEvals = 100000;
options.display = 'on';
options.DerivativeCheck = 'off';

dynamicX=cosineGLMPrepareData(trainX,minlag,maxlag,ncosines);
m=size(trainX,1);

para=rand(m + m*m*5,1)-0.5;
[optpara, cost] = minFunc( @(p) cosineGLMGrad(p,dynamicX,ncosines,lambda,reg), para, options);
 

% tic
% numgrad=computeNumericalGradient( @(p) glmGrad(p,dynamicX,5,lamda), para);
% [~, grad]=glmGrad(para,dynamicX,5,lamda);
% disp([numgrad grad]); 
% diff = norm(numgrad-grad)/norm(numgrad+grad);
% disp(diff);  % Should be small. In our implementation, these values are
%              % usually less than 1e-9.
%              % When you got this working, Congratulations!!! 
% 
% disp('Verification Complete!');
% toc

