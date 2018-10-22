function startRecording()

    global cfg;
    
    %% Start recording the specified file with the comment
    fileName = [propertiesFile.cbmexRecordingsFileName,'_', datestr(now, 'yyyy-mm-dd_HH-MM-SS')];
    cbmex('fileconfig', fileName, 'label', 1);
    
    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
    if propertiesFile.connectToParadigm
        fprintf(cfg.logfile, '>>>>>>>>>>> in startRecording: created new data file. data collective state: %d\n', active_state);
    end
    
end
