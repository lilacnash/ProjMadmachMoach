function [] = playVisualCue(cfg,mode)
%%modes: 1-single cue       2-sequence
cfg.current_cue_color = cfg.VISUAL_CUE_GO_COLOR;
if mode == 1
    
   
   flipTIme = UpdateScreen(cfg,0,0);
   fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_ON %d %d %d \n',flipTIme,cfg.VISUAL_CUE_GO_COLOR);
   
   CueTime = GetRandNum(cfg.VISUAL_CUE_LENGTH_MIN_S,cfg.VISUAL_CUE_LENGTH_MAX_S);
   mouse_recorder_and_wait(cfg,CueTime);
   
   cfg.current_cue_color = cfg.VISUAL_CUE_REST_COLOR;
   flipTIme = UpdateScreen(cfg,0,0);
   fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_OFF %d %d %d \n',flipTIme,cfg.VISUAL_CUE_REST_COLOR);
   return;
end


%% sequence mode
for i = 1:cfg.VISUAL_CUE_REPETITIONS
    
    CueTime = GetRandNum(cfg.VISUAL_CUE_LENGTH_MIN_S,cfg.VISUAL_CUE_LENGTH_MAX_S);
    cfg.current_cue_color = cfg.VISUAL_CUE_GO_COLOR;
    flipTIme = UpdateScreen(cfg,0,0);
    fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_ON %d %d %d \n',flipTIme,cfg.VISUAL_CUE_GO_COLOR);
    
    
    mouse_recorder_and_wait(cfg,CueTime);
    RestTime = GetRandNum(cfg.VISUAL_CUE_REST_MIN_S,cfg.VISUAL_CUE_REST_MAX_S);
    cfg.current_cue_color = cfg.VISUAL_CUE_REST_COLOR;
    flipTIme = UpdateScreen(cfg,0,0);
    fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_OFF %d %d %d \n',flipTIme,cfg.VISUAL_CUE_REST_COLOR);
    mouse_recorder_and_wait(cfg,RestTime);
end

%% mark the end of  the sequence
if mode ~= 1
    cfg.current_cue_color = cfg.VISUAL_CUE_END_COLOR;
    flipTIme = UpdateScreen(cfg,0,0);
    fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_END_SEQUENCE %d %d %d \n',flipTIme,cfg.VISUAL_CUE_END_COLOR);
    mouse_recorder_and_wait(cfg,RestTime);
    cfg.current_cue_color = cfg.VISUAL_CUE_REST_COLOR;
    flipTIme = UpdateScreen(cfg,0,0);
    fprintf(cfg.logfile,'%f EVENT: VISUAL_CUE_OFF %d %d %d \n',flipTIme,cfg.VISUAL_CUE_REST_COLOR);
end



