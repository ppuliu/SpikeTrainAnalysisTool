function s=generateStimulation(aver_firerate, stimuli, mh)
%generate input vector with stimulation
%
% SYNOPSIS: s=generateStimulation(aver_firerate, stimuli, mh)
%
% INPUT aver_firerate: average firing rate	m  x 1
%		stimuli: vector, stimulated neurons
%		mh: m*h+1                                  
%
% OUTPUT s: input vector with stimulation	mh x 1
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 14-Dec-2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=length(aver_firerate);

s=ones(mh,1);
for i=1:m
    j=0;
    while j*m+i+1<=mh
        if ismember(i,stimuli)
            s(j*m+i+1)=0;
        else
            s(j*m+i+1)=aver_firerate(i);
        end
        j=j+1;
    end
end


        
    