function t_sent = Send_pulse_to_ard_cfg()
% Send_pulse_to_ard_cfg    

% Author: Ariel Tankus.
% Created: 13.01.2018.


global cfg;

t_sent = Send_pulse_to_ard(cfg.Pulse.state);
