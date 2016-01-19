function X=readCell(NST)
%read from cell array
%
% SYNOPSIS: X=readCell(NST)
%
% INPUT 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 18-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neuronN = length(NST);
maxT=0;
for i=1:neuronN
    if maxT < max(NST{i})
        maxT=max(NST{i});
    end
end

bitsN = ceil(maxT*1000);   % time bin=1ms
X = zeros(neuronN,bitsN);
for i = 1:neuronN
    t=NST{i};
    for j = 1:length(t)
        X(i,ceil(t(j)*1000))=1;
    end
end