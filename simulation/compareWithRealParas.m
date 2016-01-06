function diff=compareWithRealParas(W, realU, type)
%compare with real parameters
%
% SYNOPSIS: compareWithRealParas(W, realU)
%
% INPUT W: cell array of U m x mh
%		realU: realU     
%       type: -1 (inhibitory) / 1(excitatory) / 0 (all)
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 05-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('type','var')
    type=0;
end
n=length(W);
diff=zeros(n,1);

for i=1:n
    eu=W{i}(:,2:end);
    ru=realU(:,2:end);
    if(type==0)
        diff(i)=norm(eu-ru,'fro');
    else if(type==1)
            diff(i)=norm(eu(ru>0)-ru(ru>0),'fro');
        else
            diff(i)=norm(eu(ru<0)-ru(ru<0),'fro');
        end
    end
end

plot(diff);

end