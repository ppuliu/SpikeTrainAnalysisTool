function score=getScoreForStimulation(s, deltaC, stimuli, U,C, vRatio)
%calculate scores for neurons and rank them
%
% SYNOPSIS: score=getScoreForStimulation(s,U,C, vRatio)
%
% INPUT s: input vectore  	mh x 1
%       stimuli: masked neurons by the stimulation
%		U: estimated parameters		m x mh
%		C: cell array containing covariance matrices	{[covariance matrix for neuron i, its inversion]}
%		vRatio: weight given to verification model                                                      
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 10-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,mh]=size(U);
score=0;
for i=1:m
    if ~ismember(i,stimuli)
        if vRatio==1
            varianceScore=0;
            verificationScore=getVerificationScoreForOneNeuron(s,U(i,:));
        else if vRatio==0
                varianceScore=getVarianceScoreForOneNeuron(s, deltaC(i,:),U(i,:), C{i,1});
                verificationScore=0;
            else
                varianceScore=getVarianceScoreForOneNeuron(s, deltaC(i,:), U(i,:), C{i,1});
                verificationScore=getVerificationScoreForOneNeuron(s,U(i,:));
            end
        end
    else
        varianceScore=0;
        verificationScore=0;
    end
    %disp(verificationScore);
    score=score+(1-vRatio)*varianceScore+vRatio*verificationScore;
end

end