function [optpara, cost, inputs] = batchCosineGLMTrain(trainX, minlag, maxlag,ncosines,lambda,reg)
%train GLM on a set of recordings instead of one, and allows masking neurons in each recording
%
% SYNOPSIS: [optpara, cost, inputs] = batchGLMTrain(trainX, minlag, maxlag,lambda,reg)
%
% INPUT trainX: cell array  {[recording1 (m x T1), [perturbed neuron1,perturbed neuron2]]}
%		minlag: minimum time lag
%		maxlag: maximum time lag
%		lambda: regularization term
%		reg: L1/L2/None                                                                     
%
% OUTPUT inputs: cell array with each cell containg the input cell array
% dynamicX
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 11-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('lambda','var')
    lambda=1;
end

if ~exist('reg','var')
    reg='None';
end

batchN=size(trainX,1);
m=size(trainX{1,1},1);

disp('Batch traing GLM model');
fprintf('Number of recordings: %d \n',batchN);
inputs=cell(batchN,2);
for i=1:batchN
    disp(i);
    inputs{i,1}=cosineGLMPrepareData(trainX{i,1},minlag,maxlag,ncosines);
    inputs{i,2}=trainX{i,2};
end

options.Method = 'lbfgs'; 
options.maxIter =500;  
options.maxFunEvals = 100000;
options.display = 'on';
options.DerivativeCheck = 'off';

para=rand(m + m*m*ncosines,1)-0.5;
[optpara, cost] = minFunc( @(p) batchCosineGLMGrad(p,inputs,ncosines,lambda,reg), para, options);


% tic
% numgrad=computeNumericalGradient( @(p) batchGLMGrad(p,inputs,minlag,maxlag,lambda,reg), para);
% [~, grad]=batchGLMGrad(para,inputs,minlag,maxlag,lambda,reg);
% disp([numgrad grad]); 
% diff = norm(numgrad-grad)/norm(numgrad+grad);
% disp(diff);  % Should be small. In our implementation, these values are
%              % usually less than 1e-9.
%              % When you got this working, Congratulations!!! 
% 
% disp('Verification Complete!');
% toc
% optpara=0;
% cost=0;

end