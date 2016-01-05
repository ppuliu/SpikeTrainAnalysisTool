function C=getCovarianceMatrixForEachNeuron(S, maskedNeurons, U_t,C_tm1)
%get the covariance matrix for each neuron, given ut
%
% SYNOPSIS: C=getCovarianceMatrixForEachNeuron(S,R,U_t,C_tm1)
%
% INPUT S: input matrix     mh x  T    mh=m*h+1
%       maskedNeurons: the neurons that are masked
%		U_t: estimated parameter matrix with peak probability  m x mh
%		C_tm1: cell array storing the covariance matrix and its inversion for each cell  
%
% OUTPUT C: cell array storing the covariance matrix and its inversion for each cell
%           {[covariance matrix, inversion]}
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 10-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,mh]=size(U_t);

C=cell(m,2);
for i=1:m
    if ismember(i,maskedNeurons)
        fprintf('neuron %d masked \n',i);
        C{i,1}=C_tm1{i,1};
        C{i,2}=C_tm1{i,2};
        continue;
    else
        fprintf('updating covariance matrix for neuron %d \n',i);
    end
    ipC=C_tm1{i,2};   % the inversion of the covariance matrix
    lambda=exp(U_t(i,:)*S);    % 1 x T
    
    % one solution
    %lambda=diag(lambda(:)); % T x T
    %F=S*lambda*S';  % mh x mh
    
    % another solution
    lambda=ones(mh,1)*lambda;
    tic
    F=(lambda.*S)*S';
    toc
    
    C{i,2}=ipC+F; % update
    tic
    C{i,1}=inv(C{i,2}); % get the covariance matrix
    toc
end

end

