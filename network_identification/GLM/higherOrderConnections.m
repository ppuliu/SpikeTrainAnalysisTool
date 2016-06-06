function higherOrderConnections(filters, source, target, n)
%find and plot higher order connections from source to target
%
% SYNOPSIS: higherOrderConnections(filters, source, target)
%
% INPUT filters: 3-dimensional marti, m x m x h
%		source: source channel
%		target: target channel
%       n: only plot top n filters
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 06-Jun-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abSum=sum(abs(filters),3);

fromSource=abSum(:,source);
toTarget=abSum(target,:);
middleStrength=fromSource.*toTarget';
[~,r]=sort(middleStrength,'descend');
linecolors = jet(n);
% from source
figure
hold on
for i=1:n
    t=r(i);
    plot(squeeze(filters(t,source,:)),'Color',linecolors(i,:),'LineWidth',2);
    legendInfo{i}=[num2str(source),'->',num2str(t)];
end
legend(legendInfo)
xlabel('time lags')
ylabel('weights')
hold off

% to target
figure
hold on
for i=1:n
    s=r(i);
    plot(squeeze(filters(target,s,:)),'Color',linecolors(i,:),'LineWidth',2);
    legendInfo{i}=[num2str(s),'->',num2str(target)];
end
legend(legendInfo)
xlabel('time lags')
ylabel('weights')
hold off
