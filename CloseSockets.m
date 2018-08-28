function CloseSockets()
    
    global cfg;
    
    if(~strcmp(cfg.client_data_socket.status(), 'closed'))
        fclose(cfg.client_data_socket);
        fprintf(cfg.logfile, '>>>>>>>>>>> in CloseSockets: client socket closed\n');
    end
    
    if(~strcmp(cfg.server_data_socket.status(), 'closed'))
        fclose(cfg.server_data_socket);
        fprintf(cfg.logfile, '>>>>>>>>>>> in CloseSockets: server socket closed\n');
    end

end