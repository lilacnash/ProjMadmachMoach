
function [numOfElecToPres, neuronMap] = getNumOfElecToPres()
    
    electrodsMap = cell(propertiesFile.numOfElec, 3); % (1)index, (2)label (3)original index
    
    % Start recording the specified file with the comment
    cbmex('fileconfig', propertiesFile.maskRecordingsFileName, 'spontaneous', 1);
    
    % Activate all the channels
    cbmex('mask', 0, 1);
    
    %check spontaneous activity
    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double'); 
    
    pause(propertiesFile.spontenuasTime);
    
    [tempTimeStamps, t, continuous_data] = cbmex('trialdata');
    
    if (propertiesFile.numOfChannels == 0)
        numOfChannels = getChannelNumber(tempTimeStamps);
    else
        numOfChannels = propertiesFile.numOfChannels;
    end
    
    if(~propertiesFile.useSpikeSorting)
        
        index = 0;
        
        for ii = 1:numOfChannels
            if isempty(tempTimeStamps{ii,2}) 
                cbmex('mask', ii, 0);
            else
                index = index + 1;
                chan_label = cbmex('chanlabel', ii);
                label = chan_label{1,1};
                electrodsMap{index,1} = index;
                electrodsMap{index,2} = label;
                electrodsMap{index,3} = ii;
            end
        end
    else
        %TODO: add spike sorting labeling and masking        
    end
      
    % Stop recording
    %cbmex('fileconfig', propertiesFile.maskRecordingsFileName, '', 0);
    
    numOfElecToPres = index;
    neuronMap = electrodsMap;
end
