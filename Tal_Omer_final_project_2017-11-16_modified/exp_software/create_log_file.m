function create_log_file()

    global cfg;
    temp_fname = [cfg.LOG_PREFIX,'_', datestr(now, 'yyyy-mm-dd_HH-MM-SS')];
    fname = ['logs/',temp_fname,'.txt']
    cfg.logfile = fopen(fname,'w');
    if cfg.logfile == -1
        disp('error opening log file, exiting...');
        close all;
    end
    
   
end