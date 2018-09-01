function stopRec()
    
    global cfg;
    
    %% Stop recording
    cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
    cbmex('close');
    
    fprintf(cfg.logfile, '>>>>>>>>>>> in stopRec: neuroport is closed\n');

end