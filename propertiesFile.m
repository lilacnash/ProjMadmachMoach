classdef propertiesFile
   %all but the last one are permanent properties (set before the experiment and do not change)
   %properties (SetAccess = private)
   properties (Constant)
      numOfElec = 128
      numOfTrials = 200
      numOfBins = 10
      numOfStamps = 200 %number of time stamps to save from electrode
      binSize = (100/300) %how do we convert to milliseconds?
      cbmexRecordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      maskRecordingsFileName = 'D:\Neuroport\BMI\MaskDataFromCbmex'
      spontenuasTime = 2
      useSpikeSorting = 0
      numOfChannels = 128
      FiringRate = 0 %not sure we need this
      slowUpdateTime = 1
      fastUpdateTime = 0.1
      collectTime = 0.1
      fastUpdateFlag = true
      slowUpdateFlag = true
      numOfLabelTypes = 5 %a=1,e=2,u=3,o=4,i=5
      numOfElectrodesPerPage = 4
      numOfHistogramsToPresent = 4
      fastHistogramsTitle = 'Neuron number: '
      numOfRows = 0
      numOfCols = 0
      postBipTime = 0.05
      preBipTime = 0.05
      connectToParadigm = false
      usingUpdateButton = true
      fastHistNum = 4
      predictionOnline = false
      saveInterval = 2; % In minutes

      
      %Data store configurations
	  fileType = '.mat'
      
      % CONFIGURATIONS enum to num
      LABEL_SHOWING = 1
      BEEP_SOUND = 2
      END_OF_LABEL = 3
      
      % Beep configurations
      beepFrequency = 'high' 
      % 'low', 'med', 'high'
      beepVolume = 0.4 
      % Between 0 to 1
      beepDurationSec = 0.4
   end
end