% get network from GLM

function [cnn]=cosineGLMInfluenceMatrix(w,trainX, dynamicX,p)
% w : parameter flat array
% trainX : training data for normalization m x T
% dynamicX : column cell array  p+1
% p : number of basis functions

X0=dynamicX{1};
[m,T]=size(X0);
W=cell(p,1);
%b=reshape(w(1:m),[m 1]);
%bOne=ones(1,T);
norm=ones(m,1)*sum(trainX'); % m x m
cnn=zeros(m,m);
for chN=1:m
    fprintf('getting influence vector for channel: %d',chN);
    mainM=zeros(m,T);
    for i=1:p
        startPoint=(i-1)*m*m+1+m;
        endPoint=startPoint+m*m-1;
        W{i}=reshape(w(startPoint:endPoint),[m m]);
        mainM=mainM+W{i}(chN,:)'*ones(1,T).*dynamicX{i+1};
    end
    cnn(chN,:)=cnn(chN,:)+sum(mainM');
end

cnn=cnn./norm;

end
    
    