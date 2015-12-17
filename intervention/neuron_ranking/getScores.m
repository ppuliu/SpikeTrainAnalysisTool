function scores=getScores(U,C,vRatio,X)
%get scores for all possible interventions
%
% SYNOPSIS: scores=getScores(U,C, X)
%
% INPUT U: parameter matrices	m x mh
%		C: cell array
%		X: input matrix	m x T         
%
% OUTPUT scoes:	m x 1
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 16-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,mh]=size(U);
scores=zeros(m,1);
for i=1:m
    disp(i);
    T=size(X,2);
    aver_firerate=sum(X,2)/T;
    s=generateStimulation(aver_firerate, i, mh);
    tic
    scores(i)=getScoreForStimulation(s,i,U,C, vRatio);
    toc
end



end