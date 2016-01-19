function [U]=simWithNetwork(net,minlag,maxlag,backRate)
%gen simulated data with a network structure
%
% SYNOPSIS: X=simWithNetwork(net)
%
% INPUT net: m x m matrix
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.3.0.532 (R2014a) on Mac OS X  Version: 10.9.5 Build: 13F34 
%
% created by: Honglei Liu
% DATE: 10-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=size(net,1);

h=maxlag-minlag+1;
U=zeros(m,m*h);
for i=1:m
    for j=1:m*h
        k=rem(j-1,m)+1;
        delay=floor((j-1)/m)+minlag;
        if net(i,k)>0 && net(i,k)==delay
            U(i,j)=rand();
        else if net(i,k)==-1
                U(i,j)=-5;
            end
        end
    end
end
if length(backRate)==0
    U=[-3*ones(m,1) U];
else
    U=[backRate U];
end
% rescale

for i=1:size(U,1)
    b=-U(i,1);
    excSum=sum(U(i,2:end).*(U(i,2:end)>0));
    %inhSum=-sum(U(i,2:end).*(U(i,2:end)<0));
    for j=2:size(U,2)
        if U(i,j)==0
            continue
        end
        if U(i,j)>0
            U(i,j)=U(i,j)*b/excSum;
        else
            if rem(j-2,m)+1==i && floor((j-2)/m)>=1
                U(i,j)=0;
                continue
            end
            U(i,j)=-b;
%             else if rem(j-2,m)+1==2
%                     U(i,j)=-0.05;
%                 end
%             end
        end
    end
end

%[X,~]=genSimulatedData(U, ones(m*h+1,1), dt,fixValues);

end