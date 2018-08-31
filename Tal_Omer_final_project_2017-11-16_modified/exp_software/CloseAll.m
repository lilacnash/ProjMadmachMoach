function CloseAll(time)
    global cfg;
    
    if nargin < 1
        time = GetSecs;
    end
    Screen('CloseAll');
    fprintf(cfg.logfile,'%f EVENT: ADMIN_KEY_PRESS q\n',time);
    
    KbQueueRelease;
    fclose(cfg.logfile);
    
    if(cfg.CONNECT_TO_DATA_COMPUTER)
        fclose(cfg.client_data_socket);
        fclose(cfg.server_data_socket);
    end
    close all;
    clear all;
end