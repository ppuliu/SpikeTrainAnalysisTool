function U=structureParas(w,m,minlag,maxlag)
%convert a flat array of parameters to structured matrix
%
% SYNOPSIS: W=structureParas(w,minlag,maxlag)
%
% INPUT w: flat array of parameters
%       m: number of rows in matrix
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
b=reshape(w(1:m),[m 1]);
U=b;
for i=minlag:maxlag
    startPoint=(i-minlag)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W=reshape(w(startPoint:endPoint),[m m]);
    U=[U W];
end

end