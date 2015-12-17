function C_t=getNewCovarianceMatrix(S,R,U_t,C_tm1)
%get new covariance matrix from mean and previous covariance matrix
%
% SYNOPSIS: C_t=getNewCovarianceMatrix(S,R,U_t,C_tm1)
%
% INPUT S: input matrix     mh x  T    mh=m*h+1
%		R: output matrix	m x T
%		U_t: estimated parameter matrix with peak probability  m x mh
%		C_tm1: covariance matrix at time tm-1                  m^2h x m^2h
%
% OUTPUT C_t: new covariance matrix  m^2h x m^2h
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 08-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mh,T]=size(S);
[m,T]=size(R);
I=eye(m);
SK=kron(S,I);   % Kronecker tensor product
SKT=kron(S',I);
L=exp(U_t*S);   % predicted firing rate
DIL=diag(L(:)); % diagonalized firing rate

C_t=C_tm1-C_t*SK*inv(inv(DIL)+SKT*C_tm1*SK)*SKT*C_tm1;

end
