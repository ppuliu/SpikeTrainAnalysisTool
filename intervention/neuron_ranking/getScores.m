function scores=getScores(U,C,vRatio,aver_firerate,new)
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
meanS=generateStimulation(aver_firerate, [], mh);
meanLambda=exp(U*meanS);
meanLambda(meanLambda==0)=1e-9;
meanS(meanS==0)=1e-9;

% one initialization method
%%%%meanLambda=(norm(meanLambda,'fro')/norm(1./meanLambda,'fro')).*(1./meanLambda);
% deltaC=(1./(meanLambda.*meanLambda));
% deltaC=generateStimulation(deltaC,[],mh);
% deltaC=(1./meanLambda)*deltaC';

% another initialization method
deltaC=(1./(meanLambda*meanS'));

%deltaC(1:10,:)
%U*meanS

scores=zeros(m,1);
for i=1:m
    disp(i);

    s=generateStimulation(aver_firerate, i, mh);
    %s=generateStimulation(ones(m,1), i, mh);
    tic
    scores(i)=getScoreForStimulation(s,deltaC,i,U,C, vRatio,new);
    toc
end



end