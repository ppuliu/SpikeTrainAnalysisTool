function visualSeries(X)

[CHN SMP TRL] = size(X);
nvar = CHN;

%figure
% plot raw time series
for i=1:nvar,
    Y(i,:) = X(i,:)*0.8+(1*(i-1));
end
plot(Y');%,'Color','black');
%set(gca,'YTick',[]);
xlim([0 SMP]);
%xlabel('time');
ylim([0 CHN]);
set(gca,'Box','on');
%title('Raw time series');

% shift the ytick labels
ax = gca;
YTick = get(ax, 'YTick');
YTickLabel = get(ax, 'YTickLabel');
set(ax,'YTick',YTick-0.6);
set(ax,'YTickLabel',YTickLabel);
