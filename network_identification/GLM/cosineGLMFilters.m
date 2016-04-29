function filters=cosineGLMFilters(w, m, minlag, maxlag, p)
%get cosine bump filters 
%
% SYNOPSIS: filters=cosineFilters(w, minlag, maxlag, p)
%
% INPUT w: flatten array of parameters
%		minlag:
%		maxlag:
%		p: number of cosine functions  
%       m: number of neurons
%
% OUTPUT filters: 3 dimensional array  [m,m,t]; t: time lag m: number of neurons
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 21-Apr-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ihprs.ncols=p;
ihprs.hpeaks=[minlag maxlag];
ihprs.b=5;
ihprs.absref=1;
[iht,ihbas,ihbasis]=makeBasis_PostSpike(ihprs,1);

h=size(ihbasis,1);
W=cell(p,1);

for i=1:p
    startPoint=(i-1)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W{i}=reshape(w(startPoint:endPoint),[m m]);
end

filters=zeros(m,m,h);

for i=1:m
    for j=1:m
        filter=zeros(h,1);
        for k=1:p
            filter=filter+ihbasis(:,k)*W{k}(i,j);
        end
        filters(i,j,:)=filter;
    end
end

end