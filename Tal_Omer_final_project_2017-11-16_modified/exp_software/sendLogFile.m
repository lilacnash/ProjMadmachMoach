function sendLogFile()

    global cfg;
    
    logFileAsChar = fileread(cfg.LOG_PREFIX);
    tempLogFileLength = length(logFileAsChar);
    logFileAsCharMessage = logFileAsChar(:,cfg.logFileLength:tempLogFileLength);
    fwrite(cfg.client_data_socket, logFileAsCharMessage);
    cfg.logFileLength = tempLogFileLength;
    fprintf(cfg.logfile,'%f DATA COMPUTER- CLIENT_SOCKET_SENT PORT:%d\n',GetSecs,cfg.DATA_COMPUTER_PORT);
   
end
