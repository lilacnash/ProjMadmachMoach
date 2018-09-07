function createHistAndRasters(minVal, maxVal, slowUpdateFlag, numOfTrialsPerLabel, dataToSaveForHistAndRaster, histograms, currGui, rasters, firstFlag)
     elecToPresent = getappdata(currGui,'currPageElecs');
     histogramsAxes = getappdata(currGui, 'histogramsAxes');
     sizeOfBins = (maxVal-minVal)/10;
     numOfLabels = propertiesFile.numOfLabelTypes;
     xBins = [minVal:sizeOfBins:maxVal];
     yLimMax = zeros(propertiesFile.numOfElectrodesPerPage,1);
     % Get the number of electrodes to present for the update loop of the
     % histograms and rasters
     if find(elecToPresent == 0) > 0
         findResult = find(elecToPresent == 0);
         if length(findResult) > 1
            numOfElecsToPresent = findResult(1)-1;
         else
             numOfElecsToPresent = findResult-1;
         end
     else
         numOfElecsToPresent = length(elecToPresent);
     end
     indexForRasters = 1;
     indexForHists = 1;
     nSlow = zeros(length(xBins), propertiesFile.numOfElectrodesPerPage*propertiesFile.numOfLabelTypes);
     xoutSlow = zeros(length(xBins), propertiesFile.numOfElectrodesPerPage*propertiesFile.numOfLabelTypes);
     if(slowUpdateFlag)
         for aa = 1:numOfElecsToPresent
            for ll = 1:numOfLabels 
                 allTimes = vertcat(dataToSaveForHistAndRaster{elecToPresent(aa),((ll-1)*propertiesFile.numOfTrials+1):((ll-1)*propertiesFile.numOfTrials+1+numOfTrialsPerLabel(ll))});
                 xAxis(indexForRasters:indexForRasters+1, [1:length(allTimes)]) = [allTimes allTimes]';
                 currTrialsLength = [cellfun(@length, dataToSaveForHistAndRaster(elecToPresent(aa),((ll-1)*propertiesFile.numOfTrials+1):((ll-1)*propertiesFile.numOfTrials+1+numOfTrialsPerLabel(ll))))];
                 lengthMatWithZeros = [currTrialsLength; [1:length(currTrialsLength)]];
                 lengthMat = lengthMatWithZeros(:, lengthMatWithZeros(1,:) ~= 0);
                 yAxisForCurrUpdate = ones(2, length(allTimes));
                 yAxisIndex = 1;
                 for activeTrial = 1:size(lengthMat,2)
                     yAxisForCurrUpdate(1, yAxisIndex:(yAxisIndex+lengthMat(1,activeTrial)-1)) = lengthMat(2,activeTrial);
                     yAxisForCurrUpdate(2, yAxisIndex:(yAxisIndex+lengthMat(1,activeTrial)-1)) = lengthMat(2,activeTrial)+0.5;
                     yAxisIndex = yAxisIndex+lengthMat(1,activeTrial);
                 end
                 yAxis([indexForRasters:indexForRasters+1], [1:length(allTimes)]) = yAxisForCurrUpdate;
                 if firstFlag == true
                     xFormat = 'xAxis([%d:%d],:)';
                     yFormat = 'yAxis([%d:%d],:)';
                     xParam = sprintf(xFormat, indexForRasters, indexForRasters+1);
                     yParam = sprintf(yFormat, indexForRasters, indexForRasters+1);
                     plot(rasters{aa,ll}, xAxis([indexForRasters,indexForRasters+1],:), yAxis([indexForRasters:indexForRasters+1],:), ...
                         'LineStyle', '-', 'Color', 'black', 'YDataSource', yParam, 'XDataSource', xParam);
                 else
                      plot(rasters{aa,ll}, xAxis{ll, aa}, yAxis{ll, aa}, 'LineStyle', '-', 'Color', 'black');
%                       refreshdata(rasters{aa,ll}, 'caller');
                 end
                 xlim(rasters{aa,ll}, [minVal maxVal]);
                 ylim(rasters{aa,ll}, [0 (numOfTrialsPerLabel(ll)+1)]);
                 rasters{aa,ll}.YAxis.Visible = 'off';
                 if aa < numOfElecsToPresent
                     rasters{aa,ll}.XAxis.Visible = 'off';
                 else
                     rasters{aa,ll}.XAxis.Visible = 'on';
                     rasters{aa,ll}.XAxis.FontSize = 8;
                     rasters{aa,ll}.XAxis.Color = [0.94 0.94 0.94];
                 end
                 %create histogram  for electrode aa (averaged hist of all 'll' trials until now)
                 [nSlowTemp,xoutSlow(:, indexForHists)] = hist(allTimes,xBins);
                 nSlow(:,indexForHists) = nSlowTemp/numOfTrialsPerLabel(ll); %divide - to get average
                 if firstFlag == true
                     xOutFormat = 'xoutSlow(:,%d)';
                     nSlowFormat = 'nSlow(:,%d)';
                     xOutParam = sprintf(xOutFormat, indexForHists);
                     nSlowParam = sprintf(nSlowFormat, indexForHists);
                     histogramsAxes{indexForHists} = bar(histograms{aa,ll},xoutSlow(:,indexForHists),nSlow(:,indexForHists), 'XDataSource', xOutParam, 'YDataSource', nSlowParam);
                 else
%                      bar(histograms{aa,ll},xoutSlow(:,indexForHists),nSlow(:,indexForHists));
%                      refreshdata(histograms{aa,ll}, 'caller');
                        set(histogramsAxes{indexForHists}, 'xdata', xoutSlow(:,indexForHists), 'ydata', nSlow(:,indexForHists));
                 end
                 yLimMax(aa) = max(yLimMax(aa), max(nSlowTemp));
                 xlim(histograms{aa,ll}, [minVal maxVal]);
                 histograms{aa,ll}.XAxis.Visible = 'off';
                 
                 if ll > 1
                     histograms{aa,ll}.YAxis.Visible = 'off';
                 else
                     histograms{aa,ll}.YAxis.Color = [0.94 0.94 0.94];
                 end
                 ylim(histograms{aa,ll}, [0 yLimMax(aa)+1]);
                 indexForRasters = indexForRasters + 2;
                 indexForHists = indexForHists + 1;
            end
         end
         if numOfElecsToPresent < propertiesFile.numOfElectrodesPerPage
             for ll = 1:numOfLabels 
                 for inti = 1:(propertiesFile.numOfElectrodesPerPage-numOfElecsToPresent)
                     emptyBar = bar(histograms{numOfElecsToPresent+inti, ll}, 0);
                     emptyBar.Visible = 'Off';
                     emptyRaster = scatter(rasters{numOfElecsToPresent+inti, ll}, 1, 1);
                     emptyRaster.Visible = 'off';
                     rasters{numOfElecsToPresent+inti, ll}.Visible = 'off';
                     histograms{numOfElecsToPresent+inti, ll}.Visible = 'off';
                     rasters{numOfElecsToPresent+inti, ll}.XAxis.Visible = 'off';
                     histograms{numOfElecsToPresent+inti, ll}.XAxis.Visible = 'off';
                     rasters{numOfElecsToPresent+inti, ll}.YAxis.Visible = 'off';
                     histograms{numOfElecsToPresent+inti, ll}.YAxis.Visible = 'off';
                 end
             end
         end
     end
     if firstFlag
        setappdata(currGui, 'histogramsAxes', histogramsAxes);
     else
         drawnow;
     end
%      refreshdata(currGui, 'caller');
end


     