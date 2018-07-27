function neuronTimeStamps = getAllTimestampsSim(fakeTime) %(allTimestampsMatrix, index)
   
    samplePeriod = 0.5;
    numOfElec = 80;
    index = ones(numOfElec, 1);
    
    tempNeuronTimeStamps = NaN(200, numOfElec);
    %for ii = 1:numOfElec
    %    tempNeuronTimeStamps{ii, 1} = NaN(1, 200);
    %end
    
    min = 0.001;
    max = samplePeriod;
    
    for i = 1:numOfElec
        numberOfTimeStamps = randi([0 100],1,1);
        neuronTimeStampsVector = (max-min).*rand(numberOfTimeStamps,1) + min + fakeTime;
        
        for j = 1:size(neuronTimeStampsVector)
            index(i) = mod(index(i)-1, 200) + 1;
            tempNeuronTimeStamps(j, i) = neuronTimeStampsVector(j);
            index(i) = index(i)+1;
            
        end
    end
    
    neuronTimeStamps = tempNeuronTimeStamps;
    

    
    
    
    
