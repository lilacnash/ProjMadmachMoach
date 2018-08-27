classdef propertiesFile
   %all but the last one are permanent properties (set before the experiment and do not change)
   %properties (SetAccess = private)
   properties (Constant)
      numOfElec = 200
      numOfTrials = 200
      numOfBins = 10
      numOfStamps = 100 %number of time stamps to save from electrode
      binSize = (100/300) %how do we convert to milliseconds?
      recordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      FiringRate = 0 %not sure we need this
      slowUpdateTime = 1
      fastUpdateTime = 0.1
      collectTime = 0.1
      fastUpdateFlag = true
      slowUpdateFlag = true
      numOfRasterRows = 5
      numOfHistogramsToPresent = 4
      fastHistogramsTitle = 'Fast update electrode number: '
      numOfRows = 0
      numOfCols = 0

      
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