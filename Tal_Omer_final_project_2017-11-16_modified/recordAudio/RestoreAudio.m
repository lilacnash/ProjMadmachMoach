function RestoreAudio()
    
    global H_RECORD;
    
    Log_String = {'Audio Restore';'started'};
    set(H_RECORD(5),'String',Log_String);
    
    mainPath = uigetdir('.\Output','Please choose Date And Time To resore');
    audiofile = [mainPath,'\\RESTORED_AUDIO.wav'];
    
    %% read temp mat files
    
    i = 1;
    mainPath = [mainPath,'\temp'];
    disp(mainPath);
    data =[];
    while true
        filename = sprintf('\\audio-BACKUP-%d.mat',i);
        filename = [mainPath,filename];
        if exist(filename) == 0
            break
        end
        curData = load(filename);
        data = [data ; transpose(curData.audiodata)];
        i = i +1;
    end
    
    audiowrite(audiofile,data,44100);
    Log_String = {'Audio Restored';'successfully';'Please check audio file';'and delete temp files';'manually'};
    set(H_RECORD(5),'String',Log_String);
end
    
    