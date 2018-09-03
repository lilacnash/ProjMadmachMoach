function sendLogFile()

    global cfg;
    
    logFileAsChar = fileread(cfg.logFileName);
    tempLogFileLength = length(logFileAsChar);
    
    if(cfg.logFileLength == tempLogFileLength)
       fwrite(cfg.client_data_socket, '0');
       fprintf(cfg.logfile,'%f DATA COMPUTER- CLIENT_SOCKET_SENT - NO NEW DATA. PORT: %d\n',GetSecs,cfg.DATA_COMPUTER_PORT);
       return;
    end
    
    logFileAsCharMessage = logFileAsChar(:, cfg.logFileLength+1:tempLogFileLength);
    fwrite(cfg.client_data_socket, logFileAsCharMessage);
    cfg.logFileLength = tempLogFileLength;
    fprintf(cfg.logfile,'%f DATA COMPUTER- CLIENT_SOCKET_SENT PORT: %d\n',GetSecs,cfg.DATA_COMPUTER_PORT);
   
end
