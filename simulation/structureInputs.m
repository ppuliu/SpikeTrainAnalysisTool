function S=structureInputs(X, minlag, maxlag)
%structure input to big matrix
%
% SYNOPSIS: S=structureInputs(X, minlag, maxlag)
%
% INPUT X: input matrix	m x T
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 17-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dyX=GLMPrepareData(X,minlag,maxlag);

S=[];
for i=minlag:maxlag
    S=[S;dyX{i+1}];
end
bOne=ones(1,size(S,2));
S=[bOne; S];

end