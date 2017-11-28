function [active_state, config_vector_out] = DissconnectFromNeuroport(recordingsFileName, comments)

[active_state, config_vector_out] = cbmex('trialconfig', 0);
cbmex('fileConfig', recordingsFileName, comments, 0);
cbmex('close');