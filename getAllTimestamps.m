
function [neuronTimeStamps, tempDataToSave] = getAllTimestamps(allTimestampsMatrix, index, numOfElecToPres)
    
    %% flush buffer + read new data
    [tempTimeStamps, t, continuous_data] = cbmex('trialdata');
        
    maxLength = 0;
    
    tempDataToSave = NaN(propertiesFile.numOfStamps, propertiesFile.numOfElec);
    
    %% add new data to cyclic array    
    for jj = 1:propertiesFile.numOfElec
        
        timeStamps = length(tempTimeStamps{jj, 2});
        tempDataToSave(1:timeStamps, jj) = transpose(tempTimeStamps{jj, 2});
        
        if(timeStamps > maxLength)
            maxLength = timeStamps;
        end
        
        if(~(isempty(tempTimeStamps{jj, 2})))
            for indexFromTempVector = 1:size(tempTimeStamps{jj, 2},1)
                index(jj) = mod(index(jj)-1,propertiesFile.numOfStamps)+1;
                allTimestampsMatrix(index(jj),jj)= tempTimeStamps{jj, 2}(indexFromTempVector); 
                index(jj) = index(jj)+1;
            end
        end
    end
    neuronTimeStamps = allTimestampsMatrix;
    tempDataToSave = tempDataToSave(1:maxLength,:);
    
end