function CloseAll(time)
    global cfg;
    
    if nargin < 1
        time = GetSecs;
    end
    Screen('CloseAll');
    fprintf(cfg.logfile,'%f EVENT: ADMIN_KEY_PRESS q\n',time);
    
    KbQueueRelease;
    fclose(cfg.logfile);
    fclose(cfg.client_data_socket);
    fclose(cfg.server_data_socket);
    close all;
    clear all;
end