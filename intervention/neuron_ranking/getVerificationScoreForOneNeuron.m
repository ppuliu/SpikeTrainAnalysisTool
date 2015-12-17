function score=getVerificationScoreForOneNeuron(s,u_i)
%get score from verification model for one neuron
%
% SYNOPSIS: score=getVerificationScoreForOneNeuron(s,u_i)
%
% INPUT s: input vector 	mh x 1
%		u_i: estimated parameters for neuron i	1 x mh  
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
lambda=exp(u_i*s);
disp(lambda);

score=lambda*exp(-lambda)*(log(lambda)-lambda-1);

end