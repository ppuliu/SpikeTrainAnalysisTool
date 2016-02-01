function [R,P]=genSimulatedDataWithHiddenNode(W, initialS, t,fixValues,hidm)
%generate simulated data
%
% SYNOPSIS: R=genSimulatedData(W, initialS, t)
%
% INPUT W: parameter matrix	m x mh
%		initialS: initial input matrix	mh x 1
%		t: length of simulation                
%
% OUTPUT R: output responses	 m x t
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 15-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,mh]=size(W);
R=zeros(m,t);
S=initialS;
P=[];

for i=1:t
    %p=1-exp(-exp(W*S));
    p=(exp(-exp(W*S)).*exp(W*S))*exp(0.999);
    %p=exp(W*S);   
    
    % add noise
    delta=normrnd(0, 0.0005);
    p=p+delta;
    p(p<0)=0;
    p(p>1)=1;    
    
    r=binornd(ones(m,1),p);
%     noise=binornd(ones(m,1),0.001);
%     r(noise>0)=1-r(noise>0);
    r(fixValues)=0;
    R(:,i)=r;
    S=[S(1); r; S(2:mh-m)];
    P=[P p];
end

m=m-hidm;

R=R(1:m,:);

end