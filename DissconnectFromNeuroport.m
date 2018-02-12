function [active_state, config_vector_out] = DissconnectFromNeuroport(recordingsFileName, comments)

[active_state, config_vector_out] = cbmex('trialconfig', 0,'double');
cbmex('fileconfig', recordingsFileName, comments, 0);
cbmex('close');