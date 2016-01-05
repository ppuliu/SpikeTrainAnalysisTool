function C=getCovarianceWithSelfInitialization(S, maskedNeurons, U_t)
%do not need to input C_tm1
%
% SYNOPSIS: getCovarianceWithSelfInitialization(S, maskedNeurons, U_t)
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
% DATE: 17-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,mh]=size(U_t);

C=cell(m,2);
for i=1:m
    disp(i);
    if ismember(i,maskedNeurons)
        fprintf('neuron %d masked \n',i);
        C{i,1}=eye(mh,mh);
        C{i,2}=eye(mh,mh);
        continue;
    else
        fprintf('updating covariance matrix for neuron %d \n',i);
    end
    ipC=eye(mh,mh);   % the inversion of the covariance matrix
    lambda=exp(U_t(i,:)*S);    % 1 x T
    
    % one solution
    %lambda=diag(lambda(:)); % T x T
    %F=S*lambda*S';  % mh x mh
    
    % another solution
    lambda=ones(mh,1)*lambda;
    tic
    F=(lambda.*S)*S';
    toc
    
    norm(F,'fro')

    C{i,2}=ipC+F; % update
    tic
    C{i,1}=inv(C{i,2}); % get the covariance matrix
    toc
end

end