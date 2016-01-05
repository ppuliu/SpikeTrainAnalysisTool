function [scores, optpara, U, C]=rankNeurons(vRatio, trainX, minlag, maxlag,lambda,reg, C_tm1)
%calculate scores and rank neurons
%
% SYNOPSIS: [scores, optpara, U, C]=rankNeurons(trainX, minlag, maxlag,lambda,reg)
%
% INPUT 
%       trainX: cell array  {[recording1 (m x T1), [perturbed neuron1,perturbed neuron2]]}
%		minlag: minimum time lag
%		maxlag: maximum time lag
%		lambda: regularization term
%		reg: L1/L2/None       
%       C_tm1: {covariance matrix, its inversion} cell array storing the covariance matrix and its inversion for each cell
%
% OUTPUT scores: array of scores
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 14-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('training GLM model');
[U, S, maskedNeurons, optpara]=getMeanParameters(trainX, minlag, maxlag,lambda,reg);
if ~exist('C_tm1','var')
    disp('updating covariance matrix with C_tm1');
    C=getCovarianceMatrixForEachNeuron(S, maskedNeurons, U,C_tm1);
else
    disp('getting covariance matrix without C_tm1');
    C=getCovarianceWithSelfInitialization(S, maskedNeurons, U);
end

disp('getting scores');
scores=getScores(U,C,vRatio,trainX{1,1});

end
