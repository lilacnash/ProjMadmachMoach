function save_audio_file()
    global rec;
    
    
    
    rec.isON = false;
    data = [];
    for i=1:(rec.fileNum-1)
        filename = sprintf(rec.backUpFileName,i);
        curData = load(filename);
        data = [data ; transpose(curData.audiodata)];
    end
    fclose(rec.logfile);
    audiowrite(rec.AudioOutputFileName,data,rec.SampleRate);
    rmdir('Temp');
    
end