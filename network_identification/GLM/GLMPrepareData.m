function dynamicX=GLMPrepareData(X,minlag,maxlag)
%prepare data for glm input
%
% SYNOPSIS: dynamicX=GLMPrepareData(X,minlag,maxlag)
%
% INPUT X : m x T
%		minlag : mimum time lag e.g. 2
%		maxlag : maxmum time lag e.g. 20  
%
% OUTPUT dynamicX: cell array with maxlag+1 matrices with the same dimensions, cell{1} stores the ouput matrix, m x (T-maxlag)
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 08-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,T]=size(X);
dynamicX=cell(maxlag+1,1);
dynamicX{1}=X(:,maxlag+1:T);

for i=minlag:maxlag
    dynamicX{i+1}=X(:,maxlag+1-i:T-i);
end