function [cor,norms,ranks,simX]=simInteractiveExpBatch(U,dt,minlag,maxlag,num)
%simulate interactive intervention experiment
%
% SYNOPSIS: cor=simInteractiveExpBatch(U,dt,minlag,maxlag)
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
[m,mh]=size(U);
simX=genSimulatedData(U, ones(mh,1), 60000,[]);
data={};
data{1,1}=simX;
data{1,2}=[];
[U1, S1, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
firstCor=corr(U(:),U1(:));
firstNorm=norm(U-U1,'fro');

cor=[];
norms=[];
ranks=[];

%% extend recording
tcor=[firstCor];
tnorm=[firstNorm]
trank=zeros(num,1);
for i=1:num
    data{i+1,1}=genSimulatedData(U, ones(mh,1), dt,[]);
    data{i+1,2}=[];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    tnorm=[tnorm;norm(U-tU,'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

%% rate ranking
data={};
data{1,1}=simX;
data{1,2}=[];
[~,ranking]=sort(sum(simX,2),'descend');
tcor=[firstCor];
tnorm=[firstNorm]
trank=ranking(1:num);
for i=1:num
    data{i+1,1}=genSimulatedData(U, ones(mh,1), dt,[ranking(i)]);
    data{i+1,2}=[ranking(i)];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    tnorm=[tnorm;norm(U-tU,'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

%% verification ranking
data={};
data{1,1}=simX;
data{1,2}=[];
tcor=[firstCor];
tnorm=[firstNorm]
trank=[];
tU=U1;
used=[];
for i=1:num
    scores=getScores(tU,[],1,ones(m,1),1);
    [~, ranking] = sort(scores,'descend');
    
    intervI=ranking(1);
    for j=1:length(ranking)
        if ismember(ranking(j),used)
            continue
        else
            intervI=ranking(j);
            used=[used intervI];
            trank=[trank;intervI];
            break;
        end
    end
    
    data{i+1,1}=genSimulatedData(U, ones(mh,1), dt,[intervI]);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    tnorm=[tnorm;norm(U-tU,'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

%%
C1=getCovarianceWithSelfInitialization(S1, [], U1);

%% old var ranking
data={};
data{1,1}=simX;
data{1,2}=[];
tcor=[firstCor];
tnorm=[firstNorm]
trank=[];
tU=U1;
tS=S1;
tC=C1;
used=[];
for i=1:num
    scores=getScores(tU,tC,0,ones(m,1),0); % old
    [~, ranking] = sort(scores,'descend');
    
    intervI=ranking(1);
    for j=1:length(ranking)
        if ismember(ranking(j),used)
            continue
        else
            intervI=ranking(j);
            used=[used intervI];
            trank=[trank;intervI];
            break;
        end
    end
    
    data{i+1,1}=genSimulatedData(U, ones(mh,1), dt,[intervI]);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tC=getCovarianceMatrixForEachNeuron(tS, [intervI], tU,tC);
    tcor=[tcor; corr(U(:),tU(:))];
    tnorm=[tnorm;norm(U-tU,'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

%% new var ranking
data={};
data{1,1}=simX;
data{1,2}=[];
tcor=[firstCor];
tnorm=[firstNorm]
trank=[];
tU=U1;
tS=S1;
tC=C1;
used=[];
for i=1:num
    scores=getScores(tU,tC,0,ones(m,1),1); % new
    [~, ranking] = sort(scores,'descend');
    
    intervI=ranking(1);
    for j=1:length(ranking)
        if ismember(ranking(j),used)
            continue
        else
            intervI=ranking(j);
            used=[used intervI];
            trank=[trank;intervI];
            break;
        end
    end
    
    data{i+1,1}=genSimulatedData(U, ones(mh,1), dt,[intervI]);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tC=getCovarianceMatrixForEachNeuron(tS, [intervI], tU,tC);
    tcor=[tcor; corr(U(:),tU(:))];
    tnorm=[tnorm;norm(U-tU,'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

end