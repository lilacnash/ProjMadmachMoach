%return timestamps matrix(cell array for Guy's RT_Exp) after spike sorting
%caller should pass allTimestampsMatrix = NaN(propertiesFile.numOfElec,200);
%caller should pass index = ones(propertiesFile.numOfElec, 1);

function neuronTimeStamps = getAllTimestamps(allTimestampsMatrix, index)
    %%
    close all;
    clear variables;
    %%
    allTimestampsMatrix = NaN(propertiesFile.numOfElec,200);
    index = ones(propertiesFile.numOfElec, 1);
    connection = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    %Try default, return assigned connection type
    % Start recording the specified file with the comment
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'label', 1); %from labels: A E I O U

    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
    
    cbmex('fileconfig', propertiesFile.recordingsFileName, 'start trial ii for label', 1); %from labels: A E I O U
    %flush buffer + read new data
    pause(1);
    [tempTimeStamps, t, continuous_data] = cbmex('trialdata',1); %tempTimeStamps is a matrix where every row represents a different channel
    %[returnedNumOfElec, returnedbooleanVector] = getNumOfElecToPres();
    %if returnedbooleanVector(ii)~= 0 %if this channel is not masked (don't need this, since mask already removes irrelevant channels from matrix)
    %neuronTimestampsMatrix{ii,1} = tempTimeStamps{ii,2};
        
    numOfChanel = size(tempTimeStamps);
    numOfChanel = numOfChanel(1);
        
    for jj = 1:numOfChanel
        if(~(isempty(tempTimeStamps{jj, 2})))
            for indexFromTempVector = 1:size(tempTimeStamps{jj, 2})
                index(jj) = mod(index(jj)-1,propertiesFile.numOfStamps)+1;
                allTimestampsMatrix(index(jj),jj)= tempTimeStamps{jj, 2}(indexFromTempVector); 
                index(jj) = index(jj)+1;
            end
        end
    end
% Stop recording
%cbmex('fileconfig', propertiesFile.recordingsFileName, '', 0);
%cbmex('close');
neuronTimeStamps = allTimestampsMatrix;
end