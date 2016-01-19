function scores=getScoresInGroup(U,C,vRatio,aver_firerate,new,groups)
%group stimulation
%
% SYNOPSIS: scores=getScoresInGroup(U,C,vRatio,aver_firerate,new)
%
% INPUT 
%       groups: {[uid1, uid2, uid3] channel_id}
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
[m,mh]=size(U);
meanS=generateStimulation(aver_firerate, [], mh);
meanLambda=exp(U*meanS);
meanLambda(meanLambda==0)=1e-9;
meanS(meanS==0)=1e-9;

% another initialization method
deltaC=(1./(meanLambda*meanS'));

nchannel=size(groups,1);
scores=zeros(nchannel,1);
for i=1:nchannel
    disp(i);

    s=generateStimulation(aver_firerate, groups{i,1}, mh);
    %s=generateStimulation(ones(m,1), i, mh);
    tic
    scores(i)=getScoreForStimulation(s,deltaC,i,U,C, vRatio,new);
    toc
end

end
