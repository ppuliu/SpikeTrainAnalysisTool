% This function prepares the data for glm input
% 1. generate basis funcitons
% 2. prepare a matrix for each basis

function dynamicX=cosineGLMPrepareData(X,minlag,maxlag, ncosines)
% X : m x T
% minlag : mimum time lag e.g. 2
% maxlag : maxmum time lag e.g. 20
% number of cosine basis functions

% set parameters for generating basis
ihprs.ncols=ncosines;
ihprs.hpeaks=[minlag maxlag];
ihprs.b=5;
ihprs.absref=1;
[iht,ihbas,ihbasis]=makeBasis_PostSpike(ihprs,1);

fprintf('Prepareing data using cosine basis functions\n');
fprintf('Min lag: %d \n Max lag: %d \n Number of basis functions: %d \n ', minlag, maxlag, ihprs.ncols);

[lag,p]=size(ihbasis);  % lag and number of basis functions

[m,T]=size(X);
dynamicX=cell(p+1,1);
dynamicX{1}=X(:,lag+1:T);

for i=1:p
    dynamicX{i+1}=[];
end

for i=1:m
    %disp(i)
    for j=1:p
        t=conv(X(i,:),ihbasis(:,j),'valid');
        dynamicX{j+1}=[dynamicX{j+1};t(1:end-1)];
    end
end