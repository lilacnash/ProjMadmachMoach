function openArduinoPort()
    global cfg;
    global ard_obj;
    global use_direct_dev;
    
    priorPorts = instrfind ;% finds any existing Serial Ports in MATLAB
    delete(priorPorts) ;% and deletes them
    hw_info = instrhwinfo ('serial');   % check for available serial ports.
    if (isempty(hw_info.AvailableSerialPorts{1}))
        error('No available serial ports found.');
    end
    cur_port = hw_info.AvailableSerialPorts{1};  % 1st avail. port.
    if (use_direct_dev)
        cfg.arduino = cur_port;    % open device directly, as a file.
    else
        % 115200 is max supported on Arduino:
        ard_obj = serial(cur_port, 'BaudRate', 115200);
%        cfg.arduino = serial('COM3');
%        cfg.arduino = serial('/dev/ttyACM0');
    end
    
    cfg.Pulse.state = 0;
    cfg.Pulse.TimerStarted = 0;
    cfg.Pulse.PeriodStarted = 0 ;
    cfg.Pulse.Counter = 0;
    if (use_direct_dev)
        cfg.arduino = fopen(cur_port, 'w');
        if (cfg.arduino == -1)
            error('Failed to open Arduino serial port %s\n', cur_port);
        end
    else
        fopen(ard_obj);
    end
end
