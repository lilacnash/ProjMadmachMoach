function nrsamples = SaveAudioToDisk()
    global rec;
    t = GetSecs;
    [audiodata absrecposition overflow cstarttime] = PsychPortAudio('GetAudioData', rec.pahandle);
    t2 = GetSecs;
    nrsamples = size(audiodata, 2);
    rec.TotalSamples = rec.TotalSamples + nrsamples;
    fprintf(rec.logfile,'%f %f File#%d: %d samples (%f seconds) TOTAL: %d (%f)\n',...
                        t,t2, rec.fileNum,...
                        nrsamples,nrsamples/rec.SampleRate,...
                        rec.TotalSamples,rec.TotalSamples/rec.SampleRate);
    filename = sprintf(rec.backUpFileName,rec.fileNum);
    save(filename,'audiodata');
    
    rec.fileNum = rec.fileNum +1;   
end