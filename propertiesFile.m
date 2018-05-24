classdef propertiesFile
   %permanent properties (set before the experiment and do not change)
   %properties (SetAccess = private)
   properties (Constant)
      NumOfElec
      numOfTrials
      numOfBins
      binSize = 100/300 %how do we convert to milliseconds?
      recordingsFileName = 'D:\Neuroport\BMI\DataFromCbmex'
      FiringRate %not sure we need this
      slowUpdateTime
      fastUpdateTime
   end
   %properties that we change according to the experiment data
   properties
      numOfElecToPres
      %neuronTimeStamps - do we want the timestamps matrix in here too?
   end
end