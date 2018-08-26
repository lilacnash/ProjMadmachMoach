function [logArray] = convertResponseToCellArray(response)
    
    logArray = cell(200,3);
    beepsAndsyllables = find(response == 36 | response == 42);
    
    for i = 1:beepsAndsyllables/4
       
        tempTimesVector = response((beepsAndsyllables(i) + 1):(beepsAndsyllables(i + 2) + 1)); 
        tempSylVector = response((beepsAndsyllables(i + 3) + 1):(beepsAndsyllables(i + 4) + 1));
        
        logArray(i,1) = str2double(native2unicode(tempSylVector));
        logArray(i,2) = str2double(native2unicode(tempTimesVector));
        
    end
  
end