function [R,U]=simWithRealData(w, X, minlag,maxlag, t, fixValues)
%gen simulated data with model train by real data
%
% SYNOPSIS: R=simWithRealData(trainX, t, fixValues)
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
% DATE: 15-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intervention=true;
if ~exist('fixValues','var')
    intervention=false;
end

[m,T]=size(X);

% getting input matrix
S=[];
for i=minlag:maxlag
    S=[S;sum(X,2)/T];
end
S=[1; S];

% fill S with average firing rate

% getting parameters
b=reshape(w(1:m),[m 1]);
U=b;
for i=minlag:maxlag
    startPoint=(i-minlag)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W=reshape(w(startPoint:endPoint),[m m]);
    U=[U W];
end

if intervention
    [R,P]=genSimulatedDataWithIntervention(U, S, t, fixValues);
else
    [R,~]=genSimulatedDataWithIntervention(U, S, t,[]);
end


end