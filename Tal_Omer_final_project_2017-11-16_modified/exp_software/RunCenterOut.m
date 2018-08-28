

function RunCenterOut()
    global cfg;
    global Target;
     
    %% initilize params 
    if cfg.TTL_PORT == 1
   %     openArduinoPort();
    end 
    create_log_file();
    set_screen();
    cfg.currentTargetColor = cfg.TARGET_COLOR;
    [pos,restTime] = getNextTarget(1);
    [x, y] = GetMouse(cfg.window);

    %% initilize keyboard queue
    keysOfInterest=zeros(1,256);
	keysOfInterest(KbName({'q'}))=1;
	KbQueueCreate(-1, keysOfInterest);
	KbQueueStart;
    
    
    %%
    while true
        
        if pos ~= 9
            TimeoutTimer = tic;
        end
        
        Target = CenterRectOnPointd(cfg.baseRect, cfg.TargetsArray(1,pos), cfg.TargetsArray(2,pos));
        fprintf(cfg.logfile,'%f EVENT: DRAW_TARGET %d\n',GetSecs(),pos);
        
        firstInside = 0;
        finished = 0;
        while (~finished)
            
            
            %% check if Admin Pressed on 'q' button
            [pressed, firstPress]=KbQueueCheck;
            if pressed
                pressedTime = firstPress(firstPress~=0);
                CloseAll(pressedTime);
                return;
            end
            
            %% sending pulses
            if cfg.TTL_PORT == 1
               arduino_control();
            end
            
            %% check if the cursor is inside the target
            if cfg.BRAIN_CONTROL
                [x,y] = get_brain_control_command(cfg,x,y);
            else
                [x, y] = GetMouse(cfg.window);
            end
            
            %% print cursor position and update screen
            fprintf(cfg.logfile,'%f %d %d \n',GetSecs,x,y);
            if (mod(cfg.eventCounter,5) == 0)
                UpdateScreen(cfg,x,y);
            end
            cfg.eventCounter = cfg.eventCounter+1;
            
            %% check if the cursor is inside the target
            inside = IsInRect(x, y, Target);
            if inside
                %% first inside 'sample'
                if ~firstInside
                    insideTimer = tic;
                    firstInside=1;   
                end
                %% finished rest time inside 
                if toc(insideTimer) > restTime
                    finished = 1;
                    fprintf(cfg.logfile,'%f EVENT: TARGET_DONE %d\n',GetSecs,pos);
                end
            end

            %% not inside
            if ~inside
                if firstInside         %% the first sample that not inside the target where the last one was inside
                    firstInside = 0;
                end
                
                if pos ~= 9             %% no timeout for center taret
                    if (toc(TimeoutTimer) > cfg.TARGET_TIMEOUT)
                        fprintf(cfg.logfile,'%f EVENT: TIMEOUT_REACHED %d\n',GetSecs,pos);
                        finished = 1;
                    end
                end
                
            end
        end
    [pos,restTime] = getNextTarget(pos);
    end
    
end
    
