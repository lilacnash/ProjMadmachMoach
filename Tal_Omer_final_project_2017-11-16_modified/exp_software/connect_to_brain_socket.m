function connect_to_brain_socket()
    
    warning('off','instrument:fread:unsuccessfulRead');
    global cfg;
    global audio;           %%for brain control commands
    cfg.barin_socket = tcpip(cfg.BRAIN_CONTROL_IP,cfg.BRAIN_CONTROL_PORT);
    fopen(cfg.barin_socket);
    cfg.barin_socket.Timeout = cfg.BRAIN_CONTROL_TIMEOUT;
    fprintf(cfg.logfile,'%f BRAIN CONTROL- SOCKET_CONNECTED PORT:%d\n',GetSecs,cfg.BRAIN_CONTROL_PORT);
    
    %% load audio files for speech
    [audio.A.data,audio.A.freq] = audioread('audio/A.wav');
    [audio.E.data,audio.E.freq] = audioread('audio/E.wav');
    [audio.I.data,audio.I.freq] = audioread('audio/I.wav');
    [audio.O.data,audio.o.freq] = audioread('audio/O.wav');
    [audio.U.data,audio.U.freq] = audioread('audio/U.wav');
end