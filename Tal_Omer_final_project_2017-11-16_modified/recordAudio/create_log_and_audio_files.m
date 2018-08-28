function create_log_and_audio_files()
    
    global rec;
    dateAndTime = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    mainFolder = ['Output/',dateAndTime];
    mkdir(mainFolder);
    log = [mainFolder,'/AudioLog',dateAndTime,'.txt'];
    rec.logfile = fopen(log,'w+');
    
    rec.backUpPath = [mainFolder,'/Temp'];
    rec.backUpFileName = [rec.backUpPath,'/audio-BACKUP-%d.mat'];
    mkdir(rec.backUpPath);
    
    rec.AudioOutputFileName = [mainFolder,'/AduioOutput',dateAndTime,'.flac'];
end