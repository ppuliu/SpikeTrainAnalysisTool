function visualSeries2(X)
%New function to visualize spike trains by drawing lines
%
% SYNOPSIS: visualSeries2(X)
%
% INPUT X: N x T matrix
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 23-Sep-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[CHN SMP] = size(X);

% plot target spikes

[tyPoints,txPoint] = find(X==1);
line([txPoint';txPoint'],[tyPoints' - 1;tyPoints' - 1 + 0.8],'Color','black');

xlim([0 SMP]);
ylim([0 CHN]);
set(gca,'Box','on');
% shift the ytick labels
ax = gca;
YTick = get(ax, 'YTick');
YTickLabel = get(ax, 'YTickLabel');
set(ax,'YTick',YTick-0.6);
set(ax,'YTickLabel',YTickLabel);