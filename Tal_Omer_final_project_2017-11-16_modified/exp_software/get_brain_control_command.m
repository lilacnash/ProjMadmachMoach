function [x,y] = get_brain_control_command(cfg,x,y)
    global audio;
    %% read char from socket
    recvd = fread(cfg.barin_socket,1);
    
    if ~isempty(recvd)
       input = char(recvd);
       fprintf(cfg.logfile,'%f SOCKET: received %s\n',GetSecs,input);
       switch input
           case cfg.BRAIN_CONTROL_UP
                y = y - cfg.BRAIN_CONTROL_DELTA_XY;
           case cfg.BRAIN_CONTROL_DOWN
                y = y + cfg.BRAIN_CONTROL_DELTA_XY;
           case cfg.BRAIN_CONTROL_RIGHT
                x = x + cfg.BRAIN_CONTROL_DELTA_XY;
           case cfg.BRAIN_CONTROL_LEFT
                x = x - cfg.BRAIN_CONTROL_DELTA_XY;
           case cfg.BRAIN_CONTROL_A
                playSOund(audio.A.data);
           case cfg.BRAIN_CONTROL_E   
                playSOund(audio.E.data);
           case cfg.BRAIN_CONTROL_U
                playSOund(audio.U.data);
           case cfg.BRAIN_CONTROL_I
                playSOund(audio.I.data);
           case cfg.BRAIN_CONTROL_O
                playSOund(audio.O.data);
       end
       
    end

    
end

function playSOund(data)
    global cfg;
    
    PsychPortAudio('FillBuffer', cfg.pahandle, data'); 
    PsychPortAudio('Start', cfg.pahandle);
end