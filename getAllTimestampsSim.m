function [neuronTimeStamps, index, lastSample] = getAllTimestampsSim(fakeTime, neuronTimeStamps, index, lastSample)

    numOfElec = 80;
        
    min = lastSample;
    max = fakeTime;
    
    for i = 1:numOfElec
        numberOfTimeStamps = randi([0 100],1,1);
        neuronTimeStampsVector = (max-min).*rand(numberOfTimeStamps,1) + min;
        
        for j = 1:size(neuronTimeStampsVector)
            index(i) = mod(index(i)-1, 200) + 1;
            neuronTimeStamps(index(i), i) = neuronTimeStampsVector(j);
            index(i) = index(i)+1;
            
        end
    end   
    lastSample = fakeTime;
end

    
    
    
    
