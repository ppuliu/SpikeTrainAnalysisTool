function [absS, posS, negS]=cosineGLMStrengthMatrix(w, m, minlag, maxlag, p)
%collapse filters into one value to represent connection strength
%
% SYNOPSIS: [absS, posS, negS]cosineGLMStrengthMatrix(w, m, minlag, maxlag, p)
%
% INPUT w: flatten array of parameters
%		minlag:
%		maxlag:
%		p: number of cosine functions
%		m: number of neurons            
%
% OUTPUT absS: absolute value sum as strength
%			posS: positive value sum as strength
%			negS: negative value sum as strength   
%
% REMARKS
%
% created with MATLAB ver.: 8.0.0.783 (R2012b) on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% created by: Honglei Liu
% DATE: 21-Apr-2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filters=cosineGLMFilters(w, m, minlag, maxlag, p);  % [m, m, h]

absS=sum(abs(filters), 3);
posS=sum(filters.*(filters>0),3);
negS=sum(filters.*(filters<0),3);

end
