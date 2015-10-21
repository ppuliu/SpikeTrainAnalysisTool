function visualSeries(X)

[CHN SMP TRL] = size(X);
nvar = CHN;

%figure
% plot raw time series
for i=1:nvar,
    Y(i,:) = X(i,:)*1+(1*(i-1));
end
plot(Y');%,'Color','black');
%set(gca,'YTick',[]);
xlim([0 SMP]);
xlabel('time');
set(gca,'Box','off');
title('Raw time series');