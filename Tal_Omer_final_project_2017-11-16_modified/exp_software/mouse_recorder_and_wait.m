function [] = mouse_recorder_and_wait(cfg,time)
    %% wait [time] seconds while keeping mouse record
    timer = tic;
    i=0;
    while (true)
        elapsed = toc(timer);
        if elapsed > time
            return
        end
        
        if cfg.CURSOR_ON
            [x, y] = GetMouse(cfg.window);

            fprintf(cfg.logfile,'%f %d %d \n',GetSecs,x,y);

            if (mod(i,5) == 0)
                UpdateScreen(cfg,x,y);
            end
            i = i+1 ;
        end
    end
end
    
