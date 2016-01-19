function [W, data]=simInterventionExpBatch(w, X, simX, U_t, ranking, num)
%simulate intervention experiment
%
% SYNOPSIS: W=simInterventionExp(U, trainX, U_t, ranking)
%
% INPUT w: flat array of real paramters
%		X: some real data 
%		U_t: inferred parameters so far
%		ranking: ranking to do interventions  
%
% OUTPUT W: cell array of parameter matrices
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 17-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data={};
data{1,1}=simX;
data{1,2}=[];

W={};
W{1}=U_t;

for i=1:num
    stimuli=ranking(i);
    [newdata,~]=simWithRealData(w, X, 1,20, 10000, [stimuli]);
    %visualSeries([simX newdata]);
    
    data{i+1,1}=newdata;
    data{i+1,2}=[stimuli];
    [W{i+1}, ~, ~, ~]=getMeanParameters(data, 1, 20,1,'None');
end

end
    