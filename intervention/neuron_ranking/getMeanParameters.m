function [U, S, maskedNeurons,w]=getMeanParameters(trainX, minlag, maxlag,lambda,reg)
%get optimized parameter using all the data
%
% SYNOPSIS: [U, S]=getMeanParameters(trainX, minlag, maxlag,lambda,reg)
%
% INPUT cell array  {[recording1 (m x T1), [perturbed neuron1,perturbed neuron2]]}
%		minlag: minimum time lag
%		maxlag: maximum time lag
%		lambda: regularization term
%		reg: L1/L2/None                                                             
%
% OUTPUT U: parameter matrix	m x mh
%			S: the input matrix corresponding to the last cell of trainX	mh x T      
%           maskedNeurons: masked neurons in this input matrix
%           w: flat array of the parameters
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 14-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[w, ~, inputs] = batchGLMTrain(trainX, minlag, maxlag,lambda,reg);
batchN=size(trainX,1);
m=size(trainX{1,1},1);

% getting last input matrix
dyX=inputs{batchN,1};
maskedNeurons=inputs{batchN,2};

S=[];
for i=minlag:maxlag
    S=[S;dyX{i+1}];
end
bOne=ones(1,size(S,2));
S=[bOne; S];

% getting parameters
U=[];
b=reshape(w(1:m),[m 1]);
U=b;
for i=minlag:maxlag
    startPoint=(i-minlag)*m*m+1+m;
    endPoint=startPoint+m*m-1;
    W=reshape(w(startPoint:endPoint),[m m]);
    U=[U W];
end

end

    
    