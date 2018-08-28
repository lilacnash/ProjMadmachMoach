function [] = PlayBeeps(cfg,beepIndex)
    
    beepsNum = cfg.BEEP(beepIndex).REPETITIONS;
    numOfFreqs = length(cfg.BEEP(beepIndex).FREQ);
    %% set rand beeps array
    for i=1:beepsNum
        freqArray(i) = cfg.BEEP(beepIndex).FREQ(mod(i,numOfFreqs)+1);
        PauseTimesArray(i) = GetRandNum(cfg.BEEP_PAUSE_MIN_S,cfg.BEEP_PAUSE_MAX_S);
        LengthArray(i) = GetRandNum(cfg.BEEP_LENGTH_MIN_S,cfg.BEEP_LENGHTH_MAX_S);
    end
    
    %% for series of beeps add 3 beeps mark in the end
    if beepsNum > 1
        for i = 1:3
            freqArray(i + beepsNum) = 500;
            PauseTimesArray(i + beepsNum) = 0.3;
            LengthArray(i + beepsNum) = 0.3;
        end
        beepsNum = beepsNum + 3;
    end

    % Start immediately (0 = immediately)
    startCue = 0;

    % Should we wait for the device to really start (1 = yes)
    % INFO: See help PsychPortAudio
    waitForDeviceStart = 0;
    
    %% play beeps
    for i = 1:beepsNum
        curBeep = MakeBeep(freqArray(i),LengthArray(i),cfg.BEEP_SAMPLE_RATE);
        % Fill the audio playback buffer with the audio data, doubled for stereo
        % presentation
        InitializePsychSound(1)
        pahandle = PsychPortAudio('open',[],[],2,44100,1,0); %TODO: change freq to 
        %PsychPortAudio('FillBuffer', pahandle, './beep-07.wav');
        % Start audio playback
        %StartTime = PsychPortAudio('Start', cfg.pahandle,1, startCue, 1);
        StartTime = 7;
        fprintf(cfg.logfile,'$%f$ EVENT: AUDIO_BEEP %d\n',StartTime,i);
        if beepsNum > 1 && i < beepsNum     % wait only between 2 beeps
            %mouse_recorder_and_wait(cfg,PauseTimesArray(i)+LengthArray(i));
        end
    end
        
    fprintf(cfg.logfile,'%f EVENT: AUDIO_FINISHED\n',GetSecs);
    PsychPortAudio('Stop', cfg.pahandle, 1, 1);

% Close the audio device
% PsychPortAudio('Close', cfg.pahandle);
    
end