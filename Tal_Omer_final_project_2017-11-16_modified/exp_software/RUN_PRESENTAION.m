function [] = RUN_PRESENTAION()
    
    clear all;
    close all;
    global cfg;
    %%
    cfg = specs();          %% basic center out
    
    if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
    else
        RunBasic();
    end
    %%
    cfg = specs2();         %% go no go
    
    if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
    else
        RunBasic();
    end
    
    %%
    cfg = specs4();         %% visual cue
    if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
    else
        RunBasic();
    end
    %%
    cfg = specs6();         %% image mode && beeps
    
    if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
    else
        RunBasic();
    end
    %%
    
    cfg = specs8();         %% brain control
    
    if cfg.centeroutMode || cfg.gonogoMode
        RunCenterOut();
    else
        RunBasic();
    end
end
