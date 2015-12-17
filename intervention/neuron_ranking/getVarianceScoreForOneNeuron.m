function score=getVarianceScoreForOneNeuron(s, u_i, c_i)
%get intervention score w.r.t. one neuron
%
% SYNOPSIS: score=getVarianceScoreForOneNeuron(s, u_i, c_i)
%
% INPUT s: input	mh x 1
%		u_i: estimated parameters for neuron i	1 x mh
%		ci: covariance matrix for neuron i's parameters	mh x mh  
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 10-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

score=exp(u_i*s+0.5*s'*c_i*s)*(s'*c_i*s);

end