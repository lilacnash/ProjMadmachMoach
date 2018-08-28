function fliptime = UpdateScreen(cfg,x,y)
    global Target;
    
    if cfg.imageBG
        Screen('DrawTexture', cfg.window, cfg.imageTexture, [], [], 0);
    end
    
    if ~cfg.centeroutMode && ~cfg.gonogoMode
        if cfg.CURSOR_ON
            Cursor = CenterRectOnPointd(cfg.cursorShape, x, y);
            Screen('FillOval', cfg.window ,cfg.CURSOR_COLOR',Cursor',4);
        end

        if cfg.VISUAL_MODE
            Screen(cfg.VISUAL_CUE_SHAPE, cfg.window ,cfg.current_cue_color',cfg.Cue',4);
        end
        Screen('DrawText', cfg.window, char(cfg.tasks_array(cfg.cur_task)), 0, 0 , [1 1 1]);
    elseif cfg.centeroutMode
        Screen('FrameOval', cfg.window ,cfg.currentTargetColor',Target',4);
        Cursor = CenterRectOnPointd(cfg.cursorShape, x, y);
        Screen('FillOval', cfg.window ,cfg.CURSOR_COLOR',Cursor',4);
    end
     
    
    fliptime = Screen('flip',cfg.window);
    
    
end