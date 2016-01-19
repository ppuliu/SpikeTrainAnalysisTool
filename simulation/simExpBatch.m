function [W,data]=simExpBatch(w, X, num)
%simluate experiment withou intervention
%
% SYNOPSIS: [W]=simExpBatch()
%
% INPUT 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.3.0.532 (R2014a) on Mac OS X  Version: 10.9.5 Build: 13F34 
%
% created by: Honglei Liu
% DATE: 06-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W={};
ranking=randperm(size(X,1));
for i=1:num
    
    [newdata,~]=simWithRealData(w, X, 1,20, 20000,[]);
    
    data{i,1}=newdata;
    data{i,2}=[];
    [W{i}, ~, ~, ~]=getMeanParameters(data, 1, 20,1,'None');
end

end