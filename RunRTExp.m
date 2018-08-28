function [] = RunRTExp()
    
    clear all;
    close all;
    global cfg;
    
    cfg = exp_specs();
    createExpLogFile();
    connectToParadigmComputer();
    RTExp();
   

end
