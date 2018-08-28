function set_screen()
    global cfg;
    Screen('Preference', 'SkipSyncTests', 1);

    % Clear the workspace and the screen
    Screen('Preference', 'SkipSyncTests', 1);
    sca;
    close all;
    OpenAudioPort(); 
    % clearvars;
    if cfg.BRAIN_CONTROL
        connect_to_brain_socket();
%         OpenAudioPort(); 
    end
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);

    % Get the screen numbers
    screens = Screen('Screens');

    % Draw to the external screen if avaliable
    screenNumber = max(screens);

    % Define black and white
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);

    % Open an on screen window
    [cfg.window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

    % Get the size of the on screen window
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', cfg.window);
    
    fprintf(cfg.logfile,'SCREEN_SIZE %d x %d\n',screenXpixels, screenYpixels);
    
    %% set background
    cfg.imageBG = false;
    if ~strcmp(cfg.BACKGROUND,'black')
        theImage = imread(cfg.BACKGROUND);
        cfg.imageTexture = Screen('MakeTexture', cfg.window, theImage);
        cfg.imageBG = true;
    end
    
    
    [cfg.xCenter, cfg.yCenter] = RectCenter(windowRect);    % Get the centre coordinate of the window
    cfg.cursorShape = [0 0 cfg.CURSOR_RADIUS cfg.CURSOR_RADIUS];
    SetMouse(cfg.xCenter + 300,cfg.yCenter,cfg.window);
%     HideCursor();

    
    %% deaw targets
    if cfg.centeroutMode || cfg.gonogoMode
       cfg.baseRect = [0 0 cfg.TARGET_RADIUS cfg.TARGET_RADIUS];
       cfg.TargetsArray = Get_Target_Locations(cfg);
       return;
    end
        
    
    %% only for non-centerout modes
    if cfg.CURSOR_ON
        SetMouse(cfg.xCenter + 300,cfg.yCenter,cfg.window);
    end

    if cfg.VISUAL_MODE
       cfg.cueBaseRect = [0 0 cfg.VISUAL_CUE_SIZE cfg.VISUAL_CUE_SIZE];
       cfg.Cue = CenterRectOnPointd(cfg.cueBaseRect, cfg.xCenter, cfg.yCenter);
       Screen(cfg.VISUAL_CUE_SHAPE, cfg.window ,cfg.VISUAL_CUE_REST_COLOR',cfg.Cue',4);
       cfg.current_cue_color = cfg.VISUAL_CUE_REST_COLOR;
       Screen('flip',cfg.window);
    elseif cfg.BRAIN_CONTROL    %%if brain control is on Audio port is already open
%        OpenAudioPort(); 
    end
    
     
    

end

function OpenAudioPort()
    global cfg;
    InitializePsychSound(1);    
    cfg.pahandle = PsychPortAudio('Open', [], 1, 1, cfg.BEEP_SAMPLE_RATE, cfg.BEEP_NUM_CHANNELS);
    PsychPortAudio('Volume', cfg.pahandle, 0.5);
end