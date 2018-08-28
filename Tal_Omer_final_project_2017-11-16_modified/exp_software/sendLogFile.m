function sendLogFile()

    global cfg;
    
    logFileAsChar = fileread(cfg.LOG_PREFIX);
    fwrite(cfg.client_data_socket, logFileAsChar);
    fprintf(cfg.logfile,'%f DATA COMPUTER- CLIENT_SOCKET_SENT PORT:%d\n',GetSecs,cfg.DATA_COMPUTER_PORT);
   
end
