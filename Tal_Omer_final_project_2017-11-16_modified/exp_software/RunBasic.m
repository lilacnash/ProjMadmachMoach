

function RunBasic()
    global cfg;
    
    %% initilize params 
    if cfg.TTL_PORT == 1
        openArduinoPort();
    end 
    
    create_log_file();
    
    if cfg.CONNECT_TO_DATA_COMPUTER == 1
        ConnectToDataComputerSocket() %open connection with data presentation computer
    end
    
    %set_screen();
    %cfg.currentTargetColor = cfg.TARGET_COLOR;
    read_cmnds_from_file();
    [pos,restTime] = getNextTarget(1);
    %[x, y] = GetMouse(cfg.window);
    
    %% initilize keyboard queue
    KbName('UnifyKeyNames');
    keysOfInterest=zeros(1,256);
	keysOfInterest(KbName({'q', 'space', 'backspace','1!','2@','3#','4$','5%','6^','7&','8*','9(','a','e','i','o','u'}))=1;
	KbQueueCreate(-1, keysOfInterest);
	KbQueueStart;
    
    %%
    fprintf(cfg.logfile,'%f EVENT: %s START\n',GetSecs,char(cfg.tasks_array(1)));
    %UpdateScreen(cfg,0,0);
    while true
        
        [pressed, firstPress]=KbQueueCheck;
        %% pressed a button
        if pressed
           
           pressedCode=find(firstPress);
           time = firstPress(pressedCode);
           pressedCode = KbName(pressedCode);
           TaskManager(pressedCode,time);
           if cfg.cur_task == -1        % q pressed
               return;
           end
        end
        
        
         %% sending pulses
        if cfg.TTL_PORT == 1
           arduino_control();
        end
        
        
        if cfg.BRAIN_CONTROL
                [x,y] = get_brain_control_command(cfg,x,y);
        else 
                %[x, y] = GetMouse(cfg.window);
        end
            
%         if (cfg.CURSOR_ON)
%             fprintf(cfg.logfile,'%f %d %d \n',GetSecs,x,y);
%             
%             if (mod(cfg.eventCounter,5) == 0)
%                 UpdateScreen(cfg,x,y);
%             end
% 
%             cfg.eventCounter = cfg.eventCounter+1;
%         end

        %% logFile requested
        if cfg.CONNECT_TO_DATA_COMPUTER
            
            logFileRequest = fread(cfg.server_data_socket);
            
            if strcmp(logFileRequest,'1')
                sendLogFile();
            end
            
        end

            
    
    end
end
    
