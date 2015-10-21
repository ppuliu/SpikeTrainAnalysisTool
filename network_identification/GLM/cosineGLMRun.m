%%

function cosineGLMRun(X, trainRatio, )

%addpath ~/matlablib/minFunc
%X=read_bian(ST);
paras=fragementGLMTrain(X,50000,3)
save('23_01_with_r','paras');

%%
plot([1],w1self,'black.','MarkerSize',30);
hold on
plot([2],w2self,'b.','MarkerSize',30);
hold on
plot([3],random1w,'r.','MarkerSize',30);
set(gca,'XLim',[0 4])
set(gca,'xtick',[0 1 2 3 4])
set(gca,'xticklabel',{'','23_01','random2','random1',''})

%%
plot([1],trainObj,'black.','MarkerSize',30);
hold on
plot([2],predictObj,'b.','MarkerSize',30);
hold on
plot([3],randomP,'black.','MarkerSize',30);

set(gca,'XLim',[0 4])
set(gca,'xtick',[0 1 2 3 4])
set(gca,'xticklabel',{'','tainning','prediction','random([-20,20]) prediction',''})

%%
dyTestX=prepareGLMData(testX,2,20);
logicalTestX=logical(testX(:,1:49980));
% labels=logical([]);
% scores=[];
for i=1:3
    [predictX,W,obj]=glmPredict(paras{i},dyTestX,2,20);
    labels=[labels logicalTestX(:)];
    scores=[scores predictX(:)];
end
%[auc,fpr,tpr] = fastAUC(labels,scores,true);

%%
[~,W,~]=glmPredict(paras{3},dyTestX,2,20);
parDist=[];
for i=1:67
    for j=1:67
        t=[];
        for k=2:20
            t=[t;W{k}(i,j)];
        end
        parDist=[parDist t];
    end
end
plot(parDist);
xlim([1 20]);
xlabel('Time (ms)');
ylabel('Filters');
   
%%
% using different test data
labels=logical([]);
scores=[];
for i=1:3
    xi=testX(:,50000*i+1:50000*(i+1));
    dyTestX=prepareGLMData(xi,2,20);
    logicalTestX=logical(xi(:,1:49980));
    [predictX,W,obj]=glmPredict(paras{1},dyTestX,2,20);
    labels=[labels logicalTestX(:)];
    scores=[scores predictX(:)];
end
[auc,fpr,tpr] = fastAUC(labels,scores,true);

%%
% different neurons
labels=logical([]);
scores=[];
xi=testX(:,150001:200000);
dyTestX=prepareGLMData(xi,2,20);
[predictX,W,obj]=glmPredict(paras{3},dyTestX,2,20);
logicalTestX=logical(xi(:,1:49980));
for i=1:74
    if(sum(logicalTestX(i,:))<=10)
        continue;
    end
    labels=[labels logicalTestX(i,:)'];
    scores=[scores predictX(i,:)'];
    
end
[auc,fpr,tpr] = fastAUC(labels,scores,true);

%%
% test auc 

dyTestX=prepareGLMData(testX,2,20);
logicalTestX=logical(testX(:,55:50000));
labels=logical([]);
scores=[];
[predictX,W,obj]=glmPredict(optpara,dyTestX,5);
labels=[labels logicalTestX(:)];
scores=[scores predictX(:)];
[test_auc,test_fpr,test_tpr] = fastAUC(labels,scores,true);
%%
a=[];
for lamda=0.4:0.2:1.6
    outpath=['cosine_L2_' sprintf('%0.1f',lamda) '.mat'];
    load(outpath);
    labels=logical([]);
    scores=[];
    [predictX,W,obj]=glmPredict(optpara,dyTestX,5);
    labels=[labels logicalTestX(:)];
    scores=[scores predictX(:)];
    [test_auc,test_fpr,test_tpr] = fastAUC(labels,scores,true);
    a=[a test_auc];
end
aucs=[aucs;a]

%%
dyTestX=prepareGLMData(BeforeTestX,2,20);
logicalTestX=logical(BeforeTestX(:,55:50000));

[predictX,W,obj]=glmPredict(beforeW,dyTestX,5);
%%
labels=logical([]);
scores=[];
labels=[labels logicalTestX(:)];
scores=[scores predictX(:)];
[test_auc1,test_fpr1,test_tpr1] = fastAUC(labels,scores,true);
    

    
    