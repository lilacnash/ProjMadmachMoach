%caller should pass index = ones(propertiesFile.numOfElec, 1);
%use this function once spike sorting is enabled
%returns matrix(neuronTimeStamps), in which every column represents a relevant electrode and contains the array of timestamps from that trial

function neuronTimeStamps = getAllTimestamps_temp_afterSpikeSorting(allTimestampsMatrix, index)
    % Start recording the specified file with the comment
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'label', 1); %from labels: A E I O U

    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
    
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'start trial ii for label', 1); %from labels: A E I O U
    %flush buffer + read new data
    pause(1); %TODO: remove
    [tempTimeStamps, t, continuous_data] = cbmex('trialdata',1);
    numOfRelevantElec = length(tempTimeStamps(:,1)); %this is the number of active electrodes(after masking irrelevant channels)
    index = ones(numOfRelevantElec, 1);
    allTimestampsMatrix = NaN(propertiesFile.numOfStamps, numOfRelevantElec);

    for jj = 1:numOfRelevantElec
        for ii = 3:7
            currNeuronStamps = tempTimeStamps{jj, ii};
            if length(currNeuronStamps) ~= 0
                for kk = 1:length(currNeuronStamps)
                    index(jj) = mod(index(jj)-1,propertiesFile.numOfStamps)+1;
                    allTimestampsMatrix(index(jj),jj)= currNeuronStamps(kk); 
                    index(jj) = index(jj)+1;
                end
            end
        end
    end
    
% Stop recording
%cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
%cbmex('close');
neuronTimeStamps = allTimestampsMatrix;
end