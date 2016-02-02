function [net,rate]=genRandomNetWithHidden(m, p_conn, p_neg, minlag, maxlag)
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

rndm=ceil(m*0.1);
m=m-rndm;

done=0;

while ~done

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
    
    rate=-9+6*rand(m,1);


%     %direction j-->i
%     net=zeros(m,m);
% 
%     neg_signs=binornd(ones(m,1),p_neg);
%     conn=binornd(ones(m,m),p_conn);
%     for j=1:m
%         for i=1:m
%             if i==j
%                 net(i,j)=-1;
%             else
%                 if conn(i,j)==1
%                     if neg_signs(j)==1
%                         net(i,j)=-1;
%                     else
%                         lag=randi([1,2],1,1);
%                         net(i,j)=lag;
%                     end
%                 end
%             end
%         end
%     end
% 
%     rate=-9+6*rand(m,1);
    % for i=1:m
    %     if neg_signs(i)==1
    %         rate(i)=-3;
    %     end
    %     if sum(net(:,i))==-1
    %         rate(i)=-3;
    %     end
    % end
    
    done=1;
    
    t=net+eye(m,m);
    if abs(sum(sum(abs(t)>0,1))/(m*(m-1))-p_conn)>0.1
        done=0;
    end
    if abs((sum(sum(t<0,1))/sum(sum(abs(t)>0,1)))-p_neg)>0.1
        done=0;
    end
   
%     for i=1:m
%         for j=1:m
%             if i~=j && net(i,j)<0 && sum(net(i,:))>=-1
%                 done=0;
%             end
%             if i~=j && net(i,j)<0 && rate(j)<rate(i)
%                 done=0;
%             end
%         end
%     end
   
%     for i=m-1:m
%         if sum(net(:,i))<0
%             done=0;
%         end
% 
%     end


%     if abs((sum(neg_signs>0)/m)-p_neg)>0.1
%         done=0;
%     end
end

% add random firing neurons

for i=1:rndm
    m=size(net,1);
    net=[zeros(m,1) net];
    m=size(net,2);
    net=[zeros(1,m);net];
    rate=[-3;rate;];
end


end
            