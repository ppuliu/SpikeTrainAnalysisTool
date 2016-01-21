function [X,P]=genCosineSimulatedData(w,m,minlag, maxlag, p, t, fixValues)
%gen simulated data with cosine GLM
%
% SYNOPSIS: X=genCosineSimulatedData(w,minlag, maxlag, p, dt, fixValues)
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
% DATE: 20-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the parameter matrix
b=reshape(w(1:m),[m 1]);
U=b;
for i=1:p
    startPoint=(i-1)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W=reshape(w(startPoint:endPoint),[m m]);
    U=[U W];
end

% cosine functions
ihprs.ncols=p;
ihprs.hpeaks=[minlag maxlag];
ihprs.b=5;
ihprs.absref=1;
[iht,ihbas,ihbasis]=makeBasis_PostSpike(ihprs,1);

lag=size(ihbasis,1);  % lag and number of basis functions

X=ones(m,lag);
P=[];

for i=1:t
    S=X(:,i:i+lag-1)*ihbasis;
    S=[1;S(:)];
    %p=1-exp(-exp(U*S));
    p=(exp(-exp(U*S)).*exp(U*S));%*exp(0.999);
    r=binornd(ones(m,1),p);

    r(fixValues)=0;
    X=[X r];
    P=[P p];
end

end

