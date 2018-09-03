
function [neuronTimeStamps, tempDataToSave] = getAllTimestamps(allTimestampsMatrix, index, numOfElecToPres, neuronMap)
    
    %% flush buffer + read new data
    [tempTimeStamps, t, continuous_data] = cbmex('trialdata');
        
    maxLength = 0;
    
    tempDataToSave = NaN(propertiesFile.numOfStamps, length(neuronMap));
    
    %% add new data to cyclic array    
    for jj = 1:length(neuronMap)
        
        filteredIndex = neuronMap{jj, 3};
        
        if isempty(filteredIndex)
            break;
        end
        
        timeStamps = length(tempTimeStamps{filteredIndex, 2});
        tempDataToSave(1:timeStamps, jj) = transpose(tempTimeStamps{filteredIndex, 2});
        
        if(timeStamps > maxLength)
            maxLength = timeStamps;
        end
        
        for indexFromTempVector = 1:size(tempTimeStamps{filteredIndex, 2},1)
            index(jj) = mod(index(jj)-1,propertiesFile.numOfStamps)+1;
            allTimestampsMatrix(index(jj),jj)= tempTimeStamps{filteredIndex, 2}(indexFromTempVector); 
            index(jj) = index(jj)+1;
        end
    end
    neuronTimeStamps = allTimestampsMatrix;
    tempDataToSave = tempDataToSave(1:maxLength,:);
    
end