%return timestamps matrix(cell array for Guy's RT_Exp) after spike sorting
function neuronTimeStamps = getAllTimestamps()
    %
    close all;
    clear variables;

    allTimestampsMatrix = zeros(propertiesFile.numOfTrials,1);
    
    connection = cbmex('open'); %Try default, return assigned connection type
    % Start recording the specified file with the comment
    cbmex('fileconfig', properties.recordingsFileName, 'label', 1); %from labels: A E I O U

    [active_state, config_vector_out] = cbmex('trialconfig', 1,'double');
    %flush by calling cbmex('trialconfig', 1) every how many seconds???
    for ii = 1:properties.numOfTrials
        cbmex('fileconfig', properties.recordingsFileName, 'start trial ii for label', 1); %from labels: A E I O U
        while active_state == 1 % ??
            startReadTime = tic; %start reading time
            %flush buffer + read new data
            [tempTimeStamps, t, continuous_data] = cbmex('trialdata',1); %tempTimeStamps is a matrix where every row represents a different channel
            %[returnedNumOfElec, returnedbooleanVector] = getNumOfElecToPres();
            %if returnedbooleanVector(ii)~= 0 %if this channel is not masked (don't need this, since mask already removes irrelevant channels from matrix)
                %neuronTimestampsMatrix{ii,1} = tempTimeStamps{ii,2};
            allTimestampsMatrix(ii) = tempTimeStamps;
            while toc(startReadTime) < 3
                continue;
            end
        end
    end
    % Stop recording
    cbmex('fileconfig', properties.recordingsFileName, '', 0);
    cbmex('close');
    neuronTimeStamps = allTimestampsMatrix;
end