%compute the number of relevant electrodes to present (numOfElecToPres),
%and return a boolean vector specifying which channels are relevant(1)
function [numOfElecToPres, neuronMap] = getNumOfElecToPres()
    %
    close all;
    clear variables;
    
    tempNum = propertiesFile.numOfElec;
    %tempMap = ones(propertiesFile.numOfElec,2);
    tempMap = cell(propertiesFile.numOfElec,2);
    currNeuronID = 0;
    for nn = 1:propertiesFile.numOfElec
        tempMap{nn,1} = 1;
        tempMap{nn,2} = [0 0 0 0 0]; %at most 5 active neurons on every channel
    end
    
    %open/close cbmex in RT_Exp
    %connection = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    
    % Start recording the specified file with the comment
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'spontaneous', 1);
    % Activate all the channels
    cbmex('mask', 0, 1);
    
    %check spontaneous activity
    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double'); 
    [neuronTimeStamps, t, continuous_data] = cbmex('trialdata',1); %read data into buffer

    % Deactivate (mask) irrelevant channels
    for ii = 1:propertiesFile.numOfElec
        unclassified_timestamps_vector = neuronTimeStamps{ii,2};
        if length(unclassified_timestamps_vector) ~= 0
            for jj = 1:length(unclassified_timestamps_vector)
                if unclassified_timestamps_vector(jj) ~= 0 %there are active neurons in this channel
                    for kk = 3:7
                        currNeuronID = currNeuronID + 1;
                        currNeuronTimestamps = neuronTimeStamps{ii,kk};
                        for tt = 1:length(currNeuronTimestamps)
                            if currNeuronTimestamps(tt) ~= 0
                                tempMap{ii,2}(mod(currNeuronID,5)) = currNeuronID; %add active neuronID to the mapping
                                break;
                            end
                        end
                    end
                    break; %break and move on to next electrode(break out of forloop in line 29)
                end
                if jj == length(unclassified_timestamps_vector) %if entire vector is 0
                    cbmex('mask', ii, 0); %mask removes the irrelevant channels from the matrix
                    tempNum = tempNum - 1; %decrement number of electrodes to present
                    %tempVector(ii,1) = 0; %the channel ii is irrelevant (all 0 - no spikes)
                    %tempVector(ii,2) = 0; %the channel ii is irrelevant
                end
            end
        else
            cbmex('mask', ii, 0); %mask removes the irrelevant channels from the matrix
            tempNum = tempNum - 1; %decrement number of electrodes to present
        end
      
    % Stop recording
    cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
    
    %open/close cbmex in RT_Exp
    %cbmex('close');
    numOfElecToPres = tempNum;
    neuronMap = tempMap;
end