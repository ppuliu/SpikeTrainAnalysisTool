function [R,P]=genSimulatedDataWithIntervention(W, initialS, t, fixValues)
%generate simulated data with intervention
%
% SYNOPSIS: R=genSimulatedDataWithIntervention(W, initialS, t, fixValues)
%
% INPUT W: parameter matrix	m x mh
%		initialS: initial input matrix	mh x 1
%		t: length of simulation
%		fixValues: fix values for neurons, matrix	 [neuron number, value]  
%
% OUTPUT 
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
initial_p=1-exp(-exp(W*S));
%sigma=intial_p/10;
cliping_norm=2*norm(initial_p,'fro');
for i=1:t
    p=1-exp(-exp(W*S));
    
    % clipping
    %pnorm=norm(p,'fro');
    %if pnorm>cliping_norm
    %    p=(cliping_norm/pnorm).*p;
    %end
    
    % add noise
    
    %delta=normrnd(0, sigma);
    %p=p+delta;
    %p(p<0)=0;
    %p(p>1)=1;    
    r=binornd(ones(m,1),p);
    r(fixValues)=0;
    R(:,i)=r;
    S=[S(1); S(m+2:end); r];
    P=[P p];
end

end