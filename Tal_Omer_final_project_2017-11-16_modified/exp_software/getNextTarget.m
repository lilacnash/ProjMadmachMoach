function [newTarget,restTime] = getNextTarget(cur_pos)
    
    global cfg;
    if cfg.gonogoMode
        [newTarget,restTime] = NextTargetGNG(cur_pos);
    else
        [newTarget,restTime] = NextTargetBasic(cur_pos);
    end
    
end

function [nextpos,restTime] = NextTargetBasic(curPos)
    global cfg;
    if curPos == 9
        index = floor(cfg.NUM_TARGETS*rand) + 1;
        nextpos = cfg.TARGETS(index); 
        restTime = GetRandNum(cfg.TARGET_REST_MIN,cfg.TARGET_REST_MAX);
    else 
        restTime = GetRandNum(cfg.CENTER_REST_MIN,cfg.CENTER_REST_MAX);
        nextpos = 9;
    end
end

function [newTarget,restTime] = NextTargetGNG(cur_pos)

    persistent phase;       %% 0-pre-cue   1-cue   2-post-cue  3-normal target
    persistent cueEvent;
    global cfg;
    newTarget = cur_pos;
    if isempty(phase)       %% first visit at the function->initial params
        phase = 3;
        cfg.gonogoColor = [cfg.GO_COLOR' cfg.NOGO_COLOR'];
        cueEvent = [string('%f Event: GO_CUE %d %d %d\n') ,string('%f Event: NOGO_CUE %d %d %d\n')];
        restTime = cfg.PRE_GONOGO_HOLD_S;
    end


    if phase == 0           %%pre cue - set the next phase (change the color of the center taget)
        restTime = cfg.GONOGO_DURATION_S;
        go = round(rand) + 1;               %%draw go or no go   (reminder: 1-go    2-nogo)
        cfg.currentTargetColor = cfg.gonogoColor(:,go);
        fprintf(cfg.logfile,cueEvent(go),GetSecs,cfg.currentTargetColor);

    end

    if phase == 1           %%cur - set the next phase-change  (change color back to default)
       restTime = GetRandNum(cfg.CENTER_REST_MIN,cfg.CENTER_REST_MAX);
       cfg.currentTargetColor = cfg.TARGET_COLOR;
       fprintf(cfg.logfile,'%f Event: HOLD_PERIOD_START %d %d %d\n',GetSecs, cfg.currentTargetColor);
    end

    if phase == 2
       restTime = GetRandNum(cfg.TARGET_REST_MIN,cfg.TARGET_REST_MAX);
       newTarget = NextTargetBasic(cur_pos);
    end

    if phase == 3
       restTime = cfg.PRE_GONOGO_HOLD_S;
       newTarget = 9;
       phase = -1;
    end

    phase = phase + 1;
end