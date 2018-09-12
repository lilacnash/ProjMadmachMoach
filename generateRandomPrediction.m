function pred = generateRandomPrediction()
    
   labels = propertiesFile.labelsForRandomPrediction;
   pred = labels{randi([1 length(labels)])};

end