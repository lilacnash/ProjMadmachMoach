function cfg = exp_specs()

    %% CBMEX
    cfg.interface = 0;      %0 (Automatic), 1 (Central), 2 (UDP) 
    cfg.connection = -1;
    cfg.instrument = -1;

    %% GENERAL VARIABLES
    cfg.numOfElec = 200;
    cfg.numOfTrials = 200;
    
    %% HISTOGRAM VARIABLES
    cfg.numOfBins = 10;     %number of bins for histograms.
    cfg.numOfStamps = 100;      %number of time stamps to save from electrode for fast update histograms.
    cfg.binSize = (100/300);
    cfg.fastUpdateFlag = true;
    cfg.slowUpdateFlag = true;      %TODO: remove this
    cfg.fastHistNum = 4;
    cfg.fastHistogramsTitle = 'Fast update electrode number: ';
    
    %% TIMES
    cfg.fastUpdateTime = 0.5;
    cfg.slowUpdateTime = 1;
    cfg.collectTime = 0.5;
    
    %% RASTER PLOT VARIABLES
    cfg.numOfRasterRows = 5;
    cfg.numOfRasterRows = 10;
    
    %% LOG FILE
    cfg.LOG_PREFIX = 'experiment_log';
    
    %% RECORDINGS FILE NAME
    cfg.recordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex';
    cfg.fileType = '.mat';
    
    %% CONFIG ENUM TO NUM
    cfg.LABEL_SHOWING = 1;
    cfg.BEEP_SOUND = 2;
    cfg.END_OF_LABEL = 3;
    
    %% BEEP CONFIG
    cfg.beepFrequency = 'high';     % 'low', 'med', 'high'
    cfg.beepVolume = 0.4;       % Between 0 to 1
    cfg.beepDurationSec = 0.4;
    
    %% DATA COMPUTER
    cfg.DATA_COMPUTER_IP = '0.0.0.0';
    cfg.DATA_COMPUTER_PORT = 4013;
    cfg.DATA_COMPUTER_TIMEOUT = 0;      %% dont wait, just read from queue.
    
    %% PARADIGM COMPUTER
    cfg.useParadigm = 0;
    cfg.PARADIGM_COMPUTER_IP = 'localhost';
    cfg.PARADIGM_COMPUTER_PORT = 3000;

    %% FOR SPEECH
    cfg.BRAIN_CONTROL_A = 'A';
    cfg.BRAIN_CONTROL_E = 'E';
    cfg.BRAIN_CONTROL_U = 'U';
    cfg.BRAIN_CONTROL_I = 'I';
    cfg.BRAIN_CONTROL_O = 'O';


end