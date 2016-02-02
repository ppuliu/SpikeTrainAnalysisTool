function [cor,norms,ranks,simX]=simInteractiveExpBatchWithHidden(U,hidm,dt,minlag,maxlag,num)
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

validm=m-hidm;
compareU=U(1:validm,1);
for i=1:(mh-1)/m
    compareU=[compareU U(1:validm,m*(i-1)+2:m*(i-1)+1+validm)];
end

gU=U;
U=compareU;

simX=genSimulatedDataWithHiddenNode(gU, ones(mh,1), 60000,[],hidm);
data={};
data{1,1}=simX;
data{1,2}=[];
[U1, S1, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
firstCor=corr(U(:),U1(:));
%firstNorm=norm(U-U1,'fro');
firstNorm=norm(U(:,2:end)-U1(:,2:end),'fro');

cachedData=cell(m,1);

cor=[];
norms=[];
ranks=[];

%% extend recording
tcor=[firstCor];
tnorm=[firstNorm]
trank=zeros(num,1);
for i=1:num
    data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[],hidm);
    data{i+1,2}=[];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
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
tnorm=[firstNorm];
trank=ranking(1:num);
for i=1:num
    if isempty(cachedData{ranking(i)})     
        data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[ranking(i)],hidm);
        cachedData{ranking(i)}=data{i+1,1};
    else
        data{i+1,1}=cachedData{ranking(i)};
    end
    %data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[ranking(i)],hidm);
    data{i+1,2}=[ranking(i)];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
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
    if isempty(cachedData{intervI})     
        data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
        cachedData{intervI}=data{i+1,1};
    else
        data{i+1,1}=cachedData{intervI};
    end
    %data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
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
    if isempty(cachedData{intervI})     
        data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
        cachedData{intervI}=data{i+1,1};
    else
        data{i+1,1}=cachedData{intervI};
    end    
    %data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tC=getCovarianceMatrixForEachNeuron(tS, [intervI], tU,tC);
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
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
    if isempty(cachedData{intervI})     
        data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
        cachedData{intervI}=data{i+1,1};
    else
        data{i+1,1}=cachedData{intervI};
    end    
    %data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tC=getCovarianceMatrixForEachNeuron(tS, [intervI], tU,tC);
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];


%% mix: new var + validation

ver_rank=ranks(:,3);
var_rank=ranks(:,5);

data={};
data{1,1}=simX;
data{1,2}=[];
tcor=[firstCor];
tnorm=[firstNorm]
trank=[];
used=[];
model_choosed=1;
for i=1:num
    
    if model_choosed==1
        model_choosed=2;
        ranking=ver_rank;
    else
        model_choosed=1;
        ranking=var_rank;
    end
        
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
    if isempty(cachedData{intervI})     
        data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
        cachedData{intervI}=data{i+1,1};
    else
        data{i+1,1}=cachedData{intervI};
    end    
    %data{i+1,1}=genSimulatedDataWithHiddenNode(gU, ones(mh,1), dt,[intervI],hidm);
    data{i+1,2}=[intervI];
    [tU, tS, ~, ~]=getMeanParameters(data, minlag, maxlag,1,'L2');
    tcor=[tcor; corr(U(:),tU(:))];
    %tnorm=[tnorm;norm(U-tU,'fro')];
    tnorm=[tnorm;norm(U(:,2:end)-tU(:,2:end),'fro')];
end
cor=[cor tcor];
norms=[norms tnorm];
ranks=[ranks trank];

end