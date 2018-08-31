function [logArray] = convertResponseToCellArray(response)
    
    logArray = cell(200,3);
    beepsAndsyllables = find(response == 36 | response == 42);
    
    index = 1;
    for i = 1:4:length(beepsAndsyllables)
       
        tempTimesVector = response((beepsAndsyllables(i) + 1):(beepsAndsyllables(i + 1) - 1)); 
        tempSylVector = response((beepsAndsyllables(i + 2) + 1):(beepsAndsyllables(i + 3) - 1));
        
        logArray{index,1} = tempSylVector;
        logArray{index,2} = str2double(native2unicode(tempTimesVector));
        index = index+1;
    end
  
end