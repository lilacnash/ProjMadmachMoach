function read_cmnds_from_file()
    
    global cfg;
    
    
    fid = fopen(cfg.TASKS_FILE_PATH,'r');
    
    
    i = 1;
    
    while true
        curLine = fgetl(fid);
        
        if curLine == -1                        %% add 'DONE!' at the end of the list
            cfg.tasks_array{i} = 'DONE!';
            cfg.cur_task = 1;
            cfg.num_of_tasks = i;
            return;
        end
        
        cfg.tasks_array{i} = curLine;
        i = i+1;
    end
    
    



end