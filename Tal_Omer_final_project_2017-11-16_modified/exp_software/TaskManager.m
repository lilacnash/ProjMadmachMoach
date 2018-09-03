function TaskManager(pressedCode,time)
    global cfg;
    KbName('UnifyKeyNames');
    
    
    
    if strcmp(pressedCode,'q') | strcmp(pressedCode,'Q')     %%Press on q
        CloseAll(time);
        cfg.cur_task = -1;
        return;
    end
    
      
    
    
    if strcmp(pressedCode,'space')            %% Space - go one task next
        
        %% tasks are over
        if  cfg.cur_task == cfg.num_of_tasks
            fprintf(cfg.logfile,'%f EVENT: DONE!T\n',GetSecs);
            fprintf('DONE!\n');
            return;
        end
            
       %% end the current
       fprintf(cfg.logfile,'%f EVENT: %s END\n',GetSecs,char(cfg.tasks_array(cfg.cur_task)));
       fprintf('%s END\n',char(cfg.tasks_array(cfg.cur_task)));
       
       %% start the next
       cfg.cur_task = cfg.cur_task + 1;
       fprintf(cfg.logfile,'%f EVENT: %s START\n',GetSecs,char(cfg.tasks_array(cfg.cur_task)));
       %UpdateScreen(cfg,0,0);
       return;
        
    end
    
    if strcmp(pressedCode,'BackSpace')            %% Backspace - go one task back
        
       
        %% end the current
        fprintf(cfg.logfile,'%f EVENT: %s END\n',GetSecs,char(cfg.tasks_array(cfg.cur_task)));
        fprintf('%s END\n',char(cfg.tasks_array(cfg.cur_task)));
       
        %% start the previous
        if cfg.cur_task ~= 1
            cfg.cur_task = cfg.cur_task - 1;
        end
        fprintf(cfg.logfile,'%f EVENT: %s START\n',GetSecs,char(cfg.tasks_array(cfg.cur_task)));
        UpdateScreen(cfg,0,0);
        return;
        
    end
    
    if (sum(strcmp(cfg.syllables, pressedCode)))
        cfg.currentSyllable = pressedCode;
        return;
    end
    
    pressedCode = str2num(pressedCode(1));      %% convert pressed code to number
    if ~cfg.VISUAL_MODE
        if pressedCode > 0 & pressedCode < 10   %%key pressed: 1,2,3,4,5,6,7,8,9 for beeps configutations
%            pressedCode = pressedCode - 48;
           fprintf(cfg.logfile,'%f Event: KEY_PRESS %d Go\n',time);
           PlayBeeps(cfg,pressedCode);
           cfg.currentSyllable = '0';
           return;
        end
        
    elseif cfg.VISUAL_MODE
        if pressedCode > 0 & pressedCode < 3   %%key pressed: 1 or 2
%            pressedCode = pressedCode - 48;
           fprintf(cfg.logfile,'%f Event: KEY_PRESS %d Go\n',time,pressedCode);
           playVisualCue(cfg,pressedCode);
           return;
        end
    end



end