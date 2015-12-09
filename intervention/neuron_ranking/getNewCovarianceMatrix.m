function C_t=getNewCovarianceMatrix(S,R,U_t,C_tm1)
%get new covariance matrix from mean and previous covariance matrix
%
% SYNOPSIS: C_t=getNewCovarianceMatrix(S,R,U_t,C_tm1)
%
% INPUT S: input matrix	(mh+1) x  T
%		R: output matrix	m x T
%		U_t: estimated parameter matrix with peak probability
%		C_tm1: covariance matrix at time tm-1                  
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
