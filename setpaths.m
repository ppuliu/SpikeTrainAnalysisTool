function setpaths()

basedir = pwd;
addpath([basedir filesep 'utils']);
addpath([basedir filesep 'visualization']);


% set path for GLM
GLMPath=[basedir filesep 'network_identification' filesep 'GLM'];
addpath(GLMPath);

% set path for pillow cosine functions
pillow_path=[GLMPath filesep 'pillow_GLM' filesep 'code_GLM_v1_Feb2010' filesep 'setpaths'];
run(pillow_path);

end


