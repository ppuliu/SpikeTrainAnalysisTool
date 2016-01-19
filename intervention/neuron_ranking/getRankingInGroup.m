function [ranks, groups]=getRankingInGroup(X, NSTchID, minlag, maxlag)
%get rankings in group
%
% SYNOPSIS: ranks=getRankingInGroup(X, NSTchID)
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
% DATE: 18-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=size(X,1);
data={};
data{1,1}=X;
data{1,2}=[];
[U1, S1, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');

groups={};
ui=1;
groups{1,1}=[1];
groups{1,2}=NSTchID(1);
for i=2:size(NSTchID,1)
    if NSTchID(i)==NSTchID(i-1)
        groups{ui,1}=[groups{ui,1}; i];
    else
        ui=ui+1;
        groups{ui,1}=[i];
        groups{ui,2}=NSTchID(i);
    end
end

ranks=[];

% verification ranking
scores=getScoresInGroup(U1,[],1,ones(m,1),1,groups);
[~, trank] = sort(scores,'descend');
ranks=[ranks trank];

% var ranking
C1=getCovarianceWithSelfInitialization(S1, [], U1);
scores=getScoresInGroup(U1,C1,0,ones(m,1),1,groups);
[~, trank] = sort(scores,'descend');
ranks=[ranks trank];

% print

disp('verification ranking');
for i=1:size(ranks,1)
    g=sprintf('%d ', groups{ranks(i,1),1});
    fprintf('%d:    %s\n',groups{ranks(i,1),2},g);
end


disp('variance ranking');
for i=1:size(ranks,1)
    g=sprintf('%d ', groups{ranks(i,2),1});
    fprintf('%d:    %s\n',groups{ranks(i,2),2},g);
end


end
