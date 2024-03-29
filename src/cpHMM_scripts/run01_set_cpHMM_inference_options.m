% Script to call primary cpHMM wrapper function

clear
close all
warning('off','all') %Shut off Warnings
addpath(genpath('utilities'))


inferenceInfo = struct;

% set project identifiers (only applicable if running this on savio)
inferenceInfo.projectNameCell = {'Bcd-GFP-McpMcherry-hbP2P-d6'}; % {'2xDl-Ven_hbP2P-mCh'};

% set inference options
inferenceInfo.ProteinBinFlag = 0; % Group by input protein concentration?
inferenceInfo.FluoBinFlag = 0; % Group according to MS2 trace intensity?
inferenceInfo.timeBins = {[0 40*60]}; % cell array containing 1x2 vectors with max and min time in seconds
inferenceInfo.apBins = [];% array of ap bins to use for inference

% set core model specs
inferenceInfo.modelSpecs.nStates = 2; % number of states in system
inferenceInfo.modelSpecs.nSteps = 4; % number of steps required to traverse gene
inferenceInfo.modelSpecs.alphaFrac =  1302/6444; % fraction of total gene length taken upo by MS2 casset

% other info
inferenceInfo.AdditionalGroupingVariable = '';%'Stripe'
inferenceInfo.SampleSize = 3000; % target number of data points per inference
inferenceInfo.useQCFlag = true;
inferenceInfo.n_localEM = 25; % number of independent EM runs per inference (keep at 25)

% Get basic project info and determing file paths
liveProject = LiveEnrichmentProject(inferenceInfo.projectNameCell{1});

% save
slashes = regexp(liveProject.dataPath,'/|\');
dataDir = liveProject.dataPath(1:slashes(end-1));
inferenceDir = [dataDir 'inferenceDirectory' filesep];
mkdir(inferenceDir)
save([inferenceDir 'inferenceInfo.mat'],'inferenceInfo')

% copy bash file to inference directory
copyfile('run_cpHMM.sh',[inferenceDir 'run_cpHMM.sh'])