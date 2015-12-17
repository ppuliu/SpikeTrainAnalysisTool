function [optpara, cost, dynamicX] = GLMTrain(trainX, minlag, maxlag,lambda,reg)
%glm training process
%
% SYNOPSIS: [optpara, cost, dynamicX] = GLMTrain(trainX, minlag, maxlag,lambda,reg)
%
% INPUT trainX : m x T
%		minlag
%		maxlag
%		lambda : regularization parameter
%		reg : L1 / L2 / None               
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

if ~exist('lambda','var')
    lambda=1;
end

if ~exist('reg','var')
    reg='None';
end

disp('Traing GLM model');

options.Method = 'lbfgs'; 
options.maxIter =200;  
options.maxFunEvals = 100000;
options.display = 'on';
options.DerivativeCheck = 'off';

dynamicX=GLMPrepareData(trainX,minlag,maxlag);
m=size(trainX,1);

para=rand(m + m*m*(maxlag-minlag+1),1)-0.5;
[optpara, cost] = minFunc( @(p) GLMGrad(p,dynamicX,minlag,maxlag,lambda,reg), para, options);
 
% tic
% numgrad=computeNumericalGradient( @(p) GLMGrad(p,dynamicX,minlag,maxlag,lamda,reg), para);
% [~, grad]=GLMGrad(para,dynamicX,minlag,maxlag,lamda,reg);
% disp([numgrad grad]); 
% diff = norm(numgrad-grad)/norm(numgrad+grad);
% disp(diff);  % Should be small. In our implementation, these values are
%              % usually less than 1e-9.
%              % When you got this working, Congratulations!!! 
% 
% disp('Verification Complete!');
% toc