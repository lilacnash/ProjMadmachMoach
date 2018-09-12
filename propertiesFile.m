classdef propertiesFile
   %% 
   % permanent properties (set before the experiment and do not change)
   % properties (SetAccess = private)
   
   properties (Constant)
       
      %% log file
      LOG_PREFIX = 'experiment_log'
      
      %% data storing
      outputDir = 'output'
      allDataName = 'allDataFrom_'
      trialsDataName = 'TrialsDataFrom_'
      
      %% comunication
      % DATA COMPUTER
      DATA_COMPUTER_IP = '127.0.0.1'
      DATA_COMPUTER_PORT = 4015
      DATA_COMPUTER_TIMEOUT = 0      % dont wait, just read from queue.
      
      % PARADIGM COMPUTER
      PARADIGM_COMPUTER_IP = '127.0.0.1'
      PARADIGM_COMPUTER_PORT = 3015

      %% general
      numOfElec = 128
      numOfChannels = 128
      numOfTrials = 200
      numOfBins = 10
      numOfStamps = 200 %number of time stamps to save from electrode (size of cyclic array)
      
      %% Histograms and rasters
      binSize = (100/300)
      fastHistogramsTitle = 'Neuron number: '
      postBipTime = 0.001
      preBipTime = 0.05
      
      %% Labels
      numOfLabelTypes = 5 %a=1,e=2,u=3,o=4,i=5
      
      %% flags
      useSpikeSorting = 0
      fastUpdateFlag = true
      slowUpdateFlag = true
      connectToParadigm = false
      usingUpdateButton = true

      %% GUI
      numOfElectrodesPerPage = 4
      numOfHistogramsToPresent = 4
      numOfRows = 0
      numOfCols = 0
      
      %% CBMEX
      cbmexRecordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      maskRecordingsFileName = 'D:\Neuroport\BMI\MaskDataFromCbmex'
      spontenuasTime = 2 %time to decide which channels to mask
      
      %% data presentation
      fastHistNum = 4
      
      %% save data
      saveInterval = 2; % In minutes
      
      %% prediction
      predictionOnline = true
      predictionPostBipTime = 0.2
      predictionPreBipTime = 0.001
      labelsForRandomPrediction = {'A','E','I','O','U'}
      predictorPath = 'ML/predictors.mat'
      predictorType = 'SVM'

      %% Data store configurations
	  fileType = '.mat'
      
      %% CONFIGURATIONS enum to num
      LABEL_SHOWING = 1
      BEEP_SOUND = 2
      END_OF_LABEL = 3
      
      %% Timings
      slowUpdateTime = 1
      fastUpdateTime = 0.1
      collectTime = 0.1
      
      %% Beep configurations
      beepFrequency = 'high' 
      % 'low', 'med', 'high'
      beepVolume = 0.4 
      % Between 0 to 1
      beepDurationSec = 0.4
      
   end
end