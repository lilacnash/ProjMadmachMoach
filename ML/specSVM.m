function cfg = specSVM()

    cfg.beep_events = 'data/beep_events.txt';    
    cfg.relevantMatFile = '*.mat';    
    cfg.dataFolderPath = 'data/real_data';
    
    cfg.relevantEvents = {'ANNOTATE_AUDITORY', 'ANNOTATE'};
    
    cfg.bippoffset = 0.05;
    
    cfg.binBeforeCue = 1000000;%1000;
    cfg.binAfterCue = 200000;%200;
    
    cfg.maxNumOfClusters = 5;
    
    cfg.FiringRateCalculation = 'meanFiringRate';
    
    cfg.trainingPercent = 0.75;
    
    cfg.drewHyperPlane = true;
    
    cfg.numberOfFeture = 2;


end
