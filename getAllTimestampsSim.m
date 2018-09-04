function [neuronTimeStamps, index, lastSample, tempDataToSave] = getAllTimestampsSim(fakeTime, neuronTimeStamps, index, lastSample)

    numOfElec = getappdata(findall(0,'Name', 'RealTimeSpikes'), 'numOfActiveElectrodes');
    tempDataToSave = NaN(propertiesFile.numOfStamps, numOfElec);
        
    min = lastSample;
    max = fakeTime;
    maxLength = 0;
    
    for i = 1:numOfElec
        numberOfTimeStamps = randi([0 100],1,1);
        neuronTimeStampsVector = (max-min).*rand(numberOfTimeStamps,1) + min;
        
        if(numberOfTimeStamps > maxLength)
            maxLength = numberOfTimeStamps;
        end
        
        tempDataToSave(1:length(neuronTimeStampsVector), i) = neuronTimeStampsVector;
        
        for j = 1:size(neuronTimeStampsVector)
            index(i) = mod(index(i)-1, 200) + 1;
            neuronTimeStamps(index(i), i) = neuronTimeStampsVector(j);
            index(i) = index(i)+1;
            
        end
    end   
    lastSample = fakeTime;
    tempDataToSave = tempDataToSave(1:maxLength,:);
end

    
    
    
    
