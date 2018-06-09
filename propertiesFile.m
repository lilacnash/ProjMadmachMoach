classdef propertiesFile
   %all but the last one are permanent properties (set before the experiment and do not change)
   %properties (SetAccess = private)
   properties (Constant)
      numOfElec = 200
      numOfTrials = 200
      numOfBins
      numOfStamps = 100 %number of time stamps to save from electrode
      binSize = 100/300 %how do we convert to milliseconds?
      recordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      FiringRate %not sure we need this
      slowUpdateTime
      fastUpdateTime
   end
end