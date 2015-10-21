function overlayPredicts(targetX, predictX)
%overlay spike predictions on top of target spikes
%
% SYNOPSIS: overlayPredicts(targetX, predictX)
%
% INPUT targetX: target spikes  m x T
%		predictX: predicted spikes m x T   
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.3.0.532 (R2014a) on Mac OS X  Version: 10.9.5 Build: 13F34 
%
% created by: Honglei Liu
% DATE: 20-Oct-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[CHN SMP] = size(targetX);
nvar = CHN;

% scale
predictX=predictX./(max(predictX(:)));

for i=1:nvar,
    predictY(i,:) = predictX(i,:)*1+(1*i);
end

% plot target spikes

[tyPoints,txPoint] = find(targetX==1);
line([txPoint';txPoint'],[tyPoints';tyPoints'+1],'Color','red');

hold on;
% plot predicted time series

plot(predictY','Color','black');
%set(gca,'YTick',[]);
xlim([0 SMP]);
xlabel('time');
set(gca,'Box','off');
%title('Raw time series');