function StartRecord()
    global rec;
    global H_RECORD;
    
    set(H_RECORD(2),'Enable','on');
    set(H_RECORD(1),'Enable','off');
    set(H_RECORD(3),'Enable','off');
    
    Log_String = {'Recording';'in process...'};
    set(H_RECORD(5),'String',Log_String);
    
    InitializePsychSound;
    rec.SampleRate = 44100;
    rec.pahandle = PsychPortAudio('Open', [], 2, 0, rec.SampleRate, 2);
    rec.start_time = GetSecs;
    PsychPortAudio('GetAudioData', rec.pahandle, 2*rec.BackUpIntervalSec);
    PsychPortAudio('Start', rec.pahandle, 0, 0, 1);
    t2 =  GetSecs;
    create_log_and_audio_files();
    fprintf(rec.logfile,'%f %f RECORD STARTED\n',...
                        rec.start_time,t2);
    rec.isON = true;
    rec.fileNum = 1;
    rec.TotalSamples = 0;
    
    
    rec.audioTimer = tic;
    while(rec.isON)
        if toc(rec.audioTimer) > rec.BackUpIntervalSec
            rec.audioTimer = tic;
            SaveAudioToDisk();
        end
        pause(0.2);
        ToggleRecSign();
    end
    
    
    

end


    
function ToggleRecSign()
    global H_RECORD;
    persistent state;
    
    if isempty(state)
        state = 1;
    end
    
    if state == 1
        set(H_RECORD(6),'Visible','off');
    else 
        set(H_RECORD(6),'Visible','on');
    end
    state= 1 - state;
end