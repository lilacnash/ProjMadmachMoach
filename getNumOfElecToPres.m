%compute the number of relevant electrodes to present (numOfElecToPres),
%and return a boolean vector specifying which channels are relevant(1)
function [numOfElecToPres, booleanMaskedChannelsVector] = getNumOfElecToPres()
    %
    close all;
    clear variables;
    
    tempNum = propertiesFile.numOfElec;
    tempVector = ones(propertiesFile.numOfElec,1);
    
    connection = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    % Start recording the specified file with the comment
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'spontaneous', 1);
    % Activate all the channels
    cbmex('mask', 0, 1);
    
    %check spontaneous activity
    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
    %flush by calling cbmex('trialconfig', 1) every how many seconds??? 
    [neuronTimeStamps, t, continuous_data] = cbmex('trialdata',1); %read data

    % Deactivate (mask) irrelevant channels
    for ii = 1:propertiesFile.numOfElec
        unclassified_timestamps_vector = neuronTimeStamps{ii,2};
        for jj = 1:length(unclassified_timestamps_vector)
            if unclassified_timestamps_vector(jj) ~= 0
                break;
            end
            if jj == length(unclassified_timestamps_vector) %if entire vector is 0
                cmbex('mask', ii, 0); %mask removes the irrelevant channels from the matrix
                tempNum = tempNum - 1; %decrement number of electrodes to present
                tempVector(ii) = 0; %the channel ii is irrelevant (all 0 - no spikes)
            end
        end
    end
    % Stop recording
    cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
    cbmex('close');
    numOfElecToPres = tempNum;
    booleanMaskedChannelsVector = tempVector;
end