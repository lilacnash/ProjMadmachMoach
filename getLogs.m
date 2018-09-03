function [logArray, empty] = getLogs()
    
    global cfg;
    
    empty = 0;
    
    %% request logFile from paradigm computer
    fwrite(cfg.server_data_socket, '1');
    
    %% read response
    response = fread(cfg.server_data_socket);
    
    if(strcmp(response, '0') || isempty(response))
        empty = 1;
        return;
    end
    
    %% convert response to cell array
    logArray = convertResponseToCellArray(response);

end