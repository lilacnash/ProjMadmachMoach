%compute the number of relevant electrodes to present (numOfElecToPres),
%and return a neuronMap: a 2-column matrix, the 1st column is a boolean vector (1 if the electrode is active, 0 otherwise), 
%every cell in the 2nd column is an array(holds at most 5 neuronIDs - not necessarily in order, i.e. [6,0,0,4,5])
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

    % Deactivate (mask) irrelevant channels + create neuron mapping
    for ii = 1:propertiesFile.numOfElec
        unclassified_timestamps_vector = neuronTimeStamps{ii,2}; %we do not need spike sorting yet, since this func only masks irrelevant channels
        if length(unclassified_timestamps_vector) ~= 0
            for jj = 1:length(unclassified_timestamps_vector)
                if unclassified_timestamps_vector(jj) ~= 0 %TODO: 0 or NAN??
                    %there are active neurons in this channel (it is relevant)
                    for kk = 3:7
                        currNeuronTimestamps = neuronTimeStamps{ii,kk};
                        if length(currNeuronTimestamps) ~= 0
                            for tt = 1:length(currNeuronTimestamps)
                                if currNeuronTimestamps(tt) ~= 0 %TODO: 0 or NAN??
                                    currNeuronID = currNeuronID + 1;
                                    if mod(currNeuronID,5) == 0
                                        tempMap{ii,2}(5) = currNeuronID; %add active neuronID to the mapping
                                    else
                                        tempMap{ii,2}(mod(currNeuronID,5)) = currNeuronID; %add active neuronID to the mapping
                                        break;
                                    end
                                end
                            end
                        end
                    end
                    break; %break(this electrode is active, now check next electrode)=break out of forloop in line 34
                end
            end
            if jj == length(unclassified_timestamps_vector) %if entire vector is 0 (irrelevant electrode)
                cbmex('mask', ii, 0); %mask removes the irrelevant channels from future trialdatas
                tempNum = tempNum - 1; %decrement number of electrodes to present
                tempMap{ii,1} = 0; %the channel ii is irrelevant
            end
        else %length of the vector is 0 = no activity on electrode (irrelevant electrode)
            cbmex('mask', ii, 0);
            tempNum = tempNum - 1;
            tempMap{ii,1} = 0;
        end
    end
      
    % Stop recording
    cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
    
    %open/close cbmex in RT_Exp
    %cbmex('close');
    numOfElecToPres = tempNum;
    neuronMap = tempMap;
end