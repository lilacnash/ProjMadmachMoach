function logArray = getLogs()
    
    global cfg;
    
    %% request logFile from paradigm computer
    fwrite(cfg.client_data_socket, '1');
    
    %% read response
    response = fread(cfg.server_data_socket);
    
    if(strcmp(response, '0'))
        logArray = 0;
        return;
    end
    
    %% convert response to cell array
    logArray = convertResponseToCellArray(response);

end
