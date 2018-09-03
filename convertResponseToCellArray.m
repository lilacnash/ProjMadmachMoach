function [logArray, empty] = convertResponseToCellArray(response)

    empty = 0;
    
    logArray = cell(200,3);
    beepsAndsyllables = find(response == 36 | response == 42);
    logArray = cell(length(beepsAndsyllables)/4, 3);
    
    index = 1;
    len = length(beepsAndsyllables);
    
    for i = 1:4:len
       
        tempTimesVector = response((beepsAndsyllables(i) + 1):(beepsAndsyllables(i + 1) - 1)); 
        tempSylVector = response((beepsAndsyllables(i + 2) + 1):(beepsAndsyllables(i + 3) - 1));
        
        logArray{index,1} = char(tempSylVector);
        logArray{index,2} = str2double(native2unicode(tempTimesVector));
        index = index+1;
    end
    
    if(len == 0)
        empty = 1;
    end
  
end