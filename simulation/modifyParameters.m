function newU=modifyParameters(U)
%modify the inferred parameters to make them more like real ones
%
% SYNOPSIS: newU=modifyParameters(U)
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
% DATE: 05-Jan-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,mh]=size(U);
newU=U;
U=U(:,2:end);
totalN=m*(mh)-1;
sortedU=sort(abs(U(:)),'descend');
threshold=sortedU(floor(totalN/10));

for i=1:m
    for j=2:mh
        ch=rem(j-2,m)+1;
        if(i~=ch&&abs(newU(i,j)>threshold))
            for k=1:floor(mh/m)
                newU(ch,m*(k-1)+i+1)=0;
            end
        end
    end
end

end