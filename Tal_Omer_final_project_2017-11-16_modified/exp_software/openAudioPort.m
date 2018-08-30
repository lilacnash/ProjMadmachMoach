function openAudioPort()
    
global cfg;

InitializePsychSound(1); 
cfg.pahandle = PsychPortAudio('Open', [], 1, 1, cfg.BEEP_SAMPLE_RATE, cfg.BEEP_NUM_CHANNELS);
PsychPortAudio('Volume', cfg.pahandle, 0.5);

end