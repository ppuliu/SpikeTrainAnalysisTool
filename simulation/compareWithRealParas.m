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
    eu=W{i}()
    if(type==0)
        diff(i)=norm(W{i}-realU,'fro');
    else if(type==1)
            diff(i)=norm(W{i}(realU>0)-realU(realU>0),'fro');
        else
            diff(i)=norm(W{i}(realU<0)-realU(realU<0),'fro');
        end
    end
end

plot(diff);

end