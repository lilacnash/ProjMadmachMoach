function cfg = specSVM()

    cfg.beep_events = 'data/beep_events.txt';    
    cfg.relevantMatFile = '*.mat';    
    cfg.dataFolderPath = 'data/real_data';
    
    cfg.relevantEvents = {'ANNOTATE_AUDITORY', 'ANNOTATE'};
    
    cfg.bippoffset = 0.05;
    
    cfg.binBeforeCue = 1;
    cfg.binAfterCue = 0.2;
    
    cfg.maxNumOfClusters = 5;
    cfg.labels = ['A', 'E', 'I', 'O', 'U'];
    
    cfg.FiringRateCalculation = 'meanFiringRate';
    
    cfg.trainingPercent = 0.75;
    
    cfg.drewHyperPlane = true;
    
    cfg.numberOfFeture = 2; %use 0 for using all fetures
    
    cfg.predictorFileName = 'predictors.mat';


end
