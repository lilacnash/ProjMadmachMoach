function syllable = getSyllableFromTask()

    global cfg;

    syllable = '*';
    
    task = cfg.tasks_array(cfg.cur_task);
    length = cellfun('length',task);
    
    if(length == 10)
        syllable = task{1,1}(1,length);
    end

end