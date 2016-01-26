function X=mergeNeuron2Channel(NST, NSTchID)

tX=readCell(NST);
[m,T]=size(tX);
X=zeros(120,T);
for i=1:m
    X(NSTchID(i),:)=X(NSTchID(i),:)+tX(i,:);
end

X(X>1)=1;

end
    