%
close all;
clear variables;

properties = propertiesFile;
properties.numOfElecToPres = properties.numOfElec;

connection = cbmex('open'); %Try default, return assigned connection type

%%
%check spontaneous activity, return booleanVector (or just mask the irrelevant channels)
%if we use mask, we don't need booleanVector!!!
function booleanVector = UpdateBooleanVector()
booleanVector = ones(properties.NumOfElec,1);
%connection = cbmex('open'); %Try default, return assigned connection type

% Start recording the specified file with the comment
cbmex('fileconfig', properties.recordingsFileName, 'spontaneous', 1);
% Activate all the channels
cbmex('mask', 0, 1);

[active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
%flush by calling cbmex('trialconfig', 1) every how many seconds??? 
[neuronTimeStamps, t, continuous_data] = cbmex('trialdata',1); %read data

% Deactivate irrelevant channels
for ii = 1:properties.NumOfElec
    unclassified_timestamps_vector = neuronTimeStamps{ii,2};
    for jj = 1:length(unclassified_timestamps_vector)
        if unclassified_timestamps_vector(jj) ~= 0
            break;
        end
        if jj == length(unclassified_timestamps_vector)
			cmbex('mask', jj, 0);
			booleanVector(jj) = 0; %mask removes the irrelevant channels from the matrix (we don't need booleanVector)
            properties.numOfElecToPres --; %update 
        end
    end
end
end

%%
%return timestamps matrix(cell array for Guy's RT_Exp) after spike sorting
function neuronTimeStamps = getAllTimestamps()
% Start recording the specified file with the comment
cbmex('fileconfig', properties.recordingsFileName, 'label', 1); %from labels: A E I O U

[active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
%flush by calling cbmex('trialconfig', 1) every how many seconds???
for ii = 1:properties.numOfTrials
    cbmex('fileconfig', properties.recordingsFileName, 'start trial ii for label', 1); %from labels: A E I O U
    while active_state == 1 % ??
        startReadTime = tic; %start reading time
        [neuronTimeStamps, t, continuous_data] = cbmex('trialdata',1); %flush buffer + read new data
        while toc(startReadTime) < 3
            continue;
        end
    end
end

% Stop recording
cbmex('fileconfig', properties.recordingsFileName, '', 0)

cbmex('close');
