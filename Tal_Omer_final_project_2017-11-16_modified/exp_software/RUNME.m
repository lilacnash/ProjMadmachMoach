function [] = RUNME()
    
    clear all;
    close all;
    global cfg;
    
    cfg = specs6();          %% basic center out
    
   % if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
   % else
        RunBasic();
   % end

end
