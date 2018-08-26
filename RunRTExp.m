function [] = RunRTExp()
    
    clear all;
    close all;
    global cfg;
    
    cfg = exp_specs();
    connectToParadigmComputer();
    RTExp();
   

end
