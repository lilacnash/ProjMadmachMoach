function cfg = exp_specs()

    cfg.LOG_PREFIX = 'experiment_log';
    
    %% DATA COMPUTER
    cfg.DATA_COMPUTER_IP = '0.0.0.0';
    cfg.DATA_COMPUTER_PORT = 4013;
    cfg.DATA_COMPUTER_TIMEOUT = 0;   %% dont wait, just read from queue
    
    %% PARADIGM COMPUTER
    cfg.PARADIGM_COMPUTER_IP = 'localhost';
    cfg.PARADIGM_COMPUTER_PORT = 3000;

    %% for speech
    cfg.BRAIN_CONTROL_A = 'A';
    cfg.BRAIN_CONTROL_E = 'E';
    cfg.BRAIN_CONTROL_U = 'U';
    cfg.BRAIN_CONTROL_I = 'I';
    cfg.BRAIN_CONTROL_O = 'O';


end