function [net,rate]=genRandomNet(m, p_conn, p_neg, minlag, maxlag)
%build random network
%
% SYNOPSIS: net=genRandomNet(m, p_conn, p_neg)
%
% INPUT 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 18-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

net=zeros(m,m);

for i=1:m
    for j=1:m
        if i==j
            net(i,j)=-1;
        else
            conn=binornd(1,p_conn);
            if conn==1
                neg=binornd(1,p_neg);
                if neg==1
                    net(i,j)=-1;
                else
                    lag=randi([1,2],1,1);
                    net(i,j)=lag;
                end
            end
        end
    end
end

rate=-10+7*rand(m,1);

%direction j-->i
% neg_signs=zeros(m,1);
% for j=1:m
%     neg=binornd(1,p_neg);
%     neg_signs(j)=neg;
%     for i=1:m
%         if i==j
%             net(i,j)=-1;
%         else
%             conn=binornd(1,p_conn);
%             if conn==1
%                 if neg==1
%                     net(i,j)=-1;
%                 else
%                     lag=randi([1,2],1,1);
%                     net(i,j)=lag;
%                 end
%             end
%         end
%     end
% end
% 
% rate=-9+6*rand(m,1);
% for i=1:m
%     if neg_signs(i)==1
%         rate(i)=-3;
%     end
%     if sum(net(:,i))==-1
%         rate(i)=-3;
%     end
% end
    
end
            