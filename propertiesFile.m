classdef propertiesFile
   %all but the last one are permanent properties (set before the experiment and do not change)
   %properties (SetAccess = private)
   properties (Constant)
      numOfElec = 80
      numOfTrials
      numOfBins
      binSize = 100/300 %how do we convert to milliseconds?
      recordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      FiringRate %not sure we need this
      slowUpdateTime
      fastUpdateTime
   end
end