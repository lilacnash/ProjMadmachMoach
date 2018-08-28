function stop_and_save_video()
    global rec;
    global H_RECORD;
    set(H_RECORD(2),'Enable','off');
    set(H_RECORD(6),'Visible','off');
    set(H_RECORD(3),'Enable','on');
    
        
    numOfSamples = SaveAudioToDisk();
    if numOfSamples ~= 0 
        numOfSamples = SaveAudioToDisk();
    end
    PsychPortAudio('Close', rec.pahandle);
    
    data = [];
    for i=1:(rec.fileNum-1)
        filename = sprintf(rec.backUpFileName,i);
        curData = load(filename);
        delete(filename);
        data = [data ; transpose(curData.audiodata)];
    end
    fclose(rec.logfile);
    audiowrite(rec.AudioOutputFileName,data,rec.SampleRate);
    set(H_RECORD(1),'Enable','on');
    Log_String = {'Audio Saved';'successfuly'};
    set(H_RECORD(5),'String',Log_String);
    rec.isON = false;
end
    