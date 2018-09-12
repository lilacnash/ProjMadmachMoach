function createExpLogFile()

    global cfg;
    
    temp_fname = [propertiesFile.LOG_PREFIX,'_', datestr(now, 'yyyy-mm-dd_HH-MM-SS')];
    fname = ['logs/',temp_fname,'.txt'];
    cfg.logfile = fopen(fname,'w');
    if cfg.logfile == -1
        fprintf(cfg.logfile, '>>>>>>>>>>> %f in createExpLogFile: error opening log file, exiting..\n', GetSecs);
        disp('error opening log file, exiting...');
        close all;
    else
        fprintf(cfg.logfile, '>>>>>>>>>>> %f in createExpLogFile: new log file was created\n', GetSecs);
    end
    
end