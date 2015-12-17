function C=initializeCovarianceMatrix(m,mh)
%initialize the covariance matrix structure
%
% SYNOPSIS: C=initializeCovarianceMatrix(m,mh)
%
% INPUT m: number of neurons
%		mh: m*h+1             
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 14-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=cell(m,2);
for i=1:m
    C{i,1}=eye(mh,mh);
    C{i,2}=inv(C{i,1});
end

end