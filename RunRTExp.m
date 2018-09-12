function [] = RunRTExp()
    
    clear all;
    close all;
    global cfg;
   
    cfg = exp_specs();
    createExpLogFile();
    
    if propertiesFile.connectToParadigm
        connectToParadigmComputer();
    end
   
    RealTimeSpikes();
   

end
