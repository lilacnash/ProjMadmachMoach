function arduino_control()
    global cfg;
    if ~cfg.Pulse.TimerStarted
        cfg.Pulse.Timer = tic;
        cfg.Pulse.Duration = GetRandNum(cfg.SYNC_INTERVAL_MIN,cfg.SYNC_INTERVAL_MAX);
        cfg.Pulse.TimerStarted = 1;
    end

    %% send pulse
    if (cfg.Pulse.TimerStarted && (toc(cfg.Pulse.Timer) > cfg.Pulse.Duration))
        Send_pulse_to_ard(cfg.Pulse.state,cfg.arduino);
        fprintf(cfg.logfile,'%f EVENT: CHEETAH_SIGNAL %d %d\n',GetSecs,cfg.Pulse.Counter,cfg.Pulse.state);
        cfg.Pulse.Counter = cfg.Pulse.Counter + 1; 
        cfg.Pulse.state = 1 - cfg.Pulse.state;
        cfg.Pulse.TimerStarted = 0;
    end 
end