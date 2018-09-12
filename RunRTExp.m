function [] = RunRTExp()
    
    clear all;
    close all;
    global cfg;
   
    cfg = exp_specs();
    createExpLogFile();
    
    if cfg.useParadigm
        connectToParadigmComputer();
    end
   
    RealTimeSpikes();
   

end
