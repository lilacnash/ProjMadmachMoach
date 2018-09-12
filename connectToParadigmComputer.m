function connectToParadigmComputer()
    
    global cfg;
    
    %% CLIENT SOCKET - server needs to go first with fopen then you
    cfg.client_data_socket = tcpip(propertiesFile.PARADIGM_COMPUTER_IP, propertiesFile.PARADIGM_COMPUTER_PORT, 'NetworkRole', 'client');   
    disp('Wait for paradigm computer to connect and then press "Enter"\n ');
    pause;   
    fopen(cfg.client_data_socket);
    fprintf(cfg.logfile, '>>>>>>>>>>> %f in connectToParadigmComputer: CLIENT_SOCKET_CONNECTED PORT:%d\n', GetSecs, propertiesFile.PARADIGM_COMPUTER_PORT);
    
    %% SERVER SOCKET - you need to start the connection then the client does fopen
    cfg.server_data_socket = tcpip(propertiesFile.DATA_COMPUTER_IP, propertiesFile.DATA_COMPUTER_PORT, 'NetworkRole', 'server');
    fopen(cfg.server_data_socket);
    disp('Data computer server socket is now open\n');
    cfg.data_computer.Timeout = propertiesFile.DATA_COMPUTER_TIMEOUT;
    fprintf(cfg.logfile, '>>>>>>>>>>> %f in connectToParadigmComputer: SERVER_SOCKET_CONNECTED PORT:%d\n', GetSecs, propertiesFile.DATA_COMPUTER_PORT);

    end