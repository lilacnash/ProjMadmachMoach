function [] = RunInteract()
    
    clear all;
    close all;
    global cfg;
    
    cfg = specs9();          %% madmoach project
    openAudioPort();
    RunBasic();
   

end
