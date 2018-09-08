function [labels, fetures, feturesNames] = prepareDataset(label)
        
    global cfg;
        
    [labels, feturesSource] = extractLabelsFromFile(label);
    if(isempty(labels))
        return;
    end
    
    sizeOflabels = size(labels);
    sizeOflabels = sizeOflabels(1);
    
    [fetures, feturesNames] = getFeatures(feturesSource, sizeOflabels);
    
     
    function [labels, fetures] = extractLabelsFromFile(label)
       
        fd =  fopen(cfg.beep_events);
        
        if(fd == -1)
            printf('error opening file %s\n', cfg.beep_events);
            return;
        end
        
        numOfLines = getNumOfLines(fd);
        labels = cell(numOfLines, 1);
        fetures = cell(numOfLines, 2);
        
        numOfRelevantEvents = length(cfg.relevantEvents);
        
        for jj = 1:numOfLines
           
           line = fgets(fd);
           
           for ii = 1:numOfRelevantEvents       
               if(contains(line, cfg.relevantEvents{1, ii}))     
                    lb = line(length(line) - 1);
                    if(strcmp(label, lb))
                        lb = 1;
                    else
                        lb = 2;
                    end
                    
                    labels{jj, 1} = lb;
                    fetures{jj, 1} = lb;
                    fetures{jj, 2} = (str2double(line(1:strfind(line, ' '))))/1000000;
                    break;                  
               end
           end 
        end
        
    end

    function numOfLines = getNumOfLines(fd)
        
        numOfLines = 0;
        line = fgets(fd);
        
        while ischar(line)
            numOfLines = numOfLines + 1;
            line = fgets(fd);
        end  
        frewind(fd);
    end

    
    function [fetures, feturesNames] = getFeatures(feturesSource, numOflabels)
        
        [rawFetures, feturesNames] = getRawFetures();
        
        numOfFetures = size(feturesNames);
        numOfFetures = numOfFetures(1,2);
        
        fetures = cell(numOflabels, numOfFetures);
                
        for ii = 1:numOflabels
            
           beepTime = feturesSource{ii, 2};
           maxTime = beepTime + cfg.binAfterCue;
           minTime = beepTime - cfg.binBeforeCue;
           
           for jj = 1:2:numOfFetures
              
              tempFetures = rawFetures{1, (jj + 1)/2};
              relavantPeriodSpikesBefore = tempFetures((tempFetures(:,1) >= minTime) & (tempFetures(:,1) <= beepTime));
              relavantPeriodSpikesAfter = tempFetures((tempFetures(:,1) >= beepTime) & (tempFetures(:,1) <= maxTime));
              fetures{ii, jj} = getFiringRate(relavantPeriodSpikesBefore, cfg.binBeforeCue);
              fetures{ii, jj+1} = getFiringRate(relavantPeriodSpikesAfter, cfg.binAfterCue);
               
           end
           
        end
             
    end

    
    function [rawFetures, feturesNames] = getRawFetures()
       
       
       fp = fullfile(cfg.dataFolderPath, cfg.relevantMatFile);
       matFiles = dir(fp);
       
       len = length(matFiles);
       rawFetures = cell(1, len*cfg.maxNumOfClusters);
       feturesNames = cell(1, len*cfg.maxNumOfClusters*2);
       numOfUsedColumns = 0;
       
       for ii = 1:len
           matFilename = fullfile(cfg.dataFolderPath, matFiles(ii).name);
           matData = load(matFilename); 
           cluster_class = matData.cluster_class;
           
           for k = 1:cfg.maxNumOfClusters %number of clusters per electrode              
              relevantIndexes = find(cluster_class(:,1) == k);
              
              if ~isempty(relevantIndexes)
                numOfUsedColumns = numOfUsedColumns + 1;
                tempVec = cluster_class(relevantIndexes, 2);
                rawFetures{1, numOfUsedColumns} = tempVec/1000;
                feturesNames{1, (numOfUsedColumns*2)} = sprintf('%s_%d_%s', matFiles(ii).name, k, 'A');
                feturesNames{1, (numOfUsedColumns*2)-1} = sprintf('%s_%d_%s', matFiles(ii).name, k, 'B');
              end                
           end
       end
       rawFetures = rawFetures(:, 1:numOfUsedColumns);
       feturesNames = feturesNames(:, 1:numOfUsedColumns*2);
    end

    function firingRate = getFiringRate(periodSpikes, binTime)
       
        if(strcmp(cfg.FiringRateCalculation, 'meanFiringRate'))
            if isempty(periodSpikes)
                firingRate = 0;
                return;
            end
            firingRate = length(periodSpikes(1,:))*(1/(binTime/1000));
        end   
    end
    
    
end

