function createHistAndRasters(minVal, maxVal, slowUpdateFlag, numOfTrialsPerLabel, dataToSaveForHistAndRaster, histograms, currGui, rasters, firstFlag)
     elecToPresent = getappdata(currGui,'currPageElecs');
     %nBins = propertiesFile.numOfBins;
     sizeOfBins = (maxVal-minVal)/10;
     numOfLabels = propertiesFile.numOfLabelTypes;
     xBins = [minVal:sizeOfBins:maxVal];
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
     xAxis = cell(numOfLabels, numOfElecsToPresent);
     yAxis = cell(numOfLabels, numOfElecsToPresent);
     if(slowUpdateFlag)
         for ll = 1:numOfLabels
             for aa = 1:numOfElecsToPresent
                 currFig = rasters{aa,ll};
                 allTimes = vertcat(dataToSaveForHistAndRaster{elecToPresent(aa),((ll-1)*propertiesFile.numOfTrials+1):((ll-1)*propertiesFile.numOfTrials+1+numOfTrialsPerLabel)});
                 xAxis{ll, aa} = [allTimes allTimes]';
                 currTrialsLength = [cellfun(@length, dataToSaveForHistAndRaster(elecToPresent(aa),((ll-1)*propertiesFile.numOfTrials+1):((ll-1)*propertiesFile.numOfTrials+1+numOfTrialsPerLabel)))];
                 lengthMatWithZeros = [currTrialsLength; [1:length(currTrialsLength)]];
                 lengthMat = lengthMatWithZeros(:, lengthMatWithZeros(1,:) ~= 0);
                 yAxisForCurrUpdate = ones(2, length(allTimes));
                 yAxisIndex = 1;
                 for activeTrial = 1:size(lengthMat,2)
                     yAxisForCurrUpdate(1, yAxisIndex:(yAxisIndex+lengthMat(1,activeTrial)-1)) = lengthMat(2,activeTrial);
                     yAxisForCurrUpdate(2, yAxisIndex:(yAxisIndex+lengthMat(1,activeTrial)-1)) = lengthMat(2,activeTrial)+0.5;
                     yAxisIndex = yAxisIndex+lengthMat(1,activeTrial);
                 end
                 yAxis{ll, aa} = yAxisForCurrUpdate;
                 if firstFlag == true
                     xFormat = 'xAxis{%d,%d}';
                     yFormat = 'yAxis{%d,%d}';
                     xParam = sprintf(xFormat, ll, aa);
                     yParam = sprintf(yFormat, ll, aa);
                     plot(currFig, xAxis{ll, aa}, yAxis{ll, aa}, ...
                         'LineStyle', '-', 'Color', 'black', 'YDataSource', yParam, 'XDataSource', xParam);
                 else
                     plot(currFig, xAxis{ll, aa}, yAxis{ll, aa}, 'LineStyle', '-', 'Color', 'black');
%                              refreshdata(currFig, 'caller');
                 end
                 xlim(currFig, [minVal maxVal]);
                 ylim(currFig, [0 (numOfTrialsPerLabel(ll)+1)]);
                 currFig.YAxis.Visible = 'off';
                 if aa < numOfElecsToPresent
                     currFig.XAxis.Visible = 'off';
                 else
                     currFig.XAxis.Visible = 'on';
                     currFig.XAxis.FontSize = 8;
                     currFig.XAxis.Color = [0.94 0.94 0.94];
                 end
                 %create histogram  for electrode aa (averaged hist of all 'll' trials until now)
                 for hh = 1:numOfTrialsPerLabel(ll)
                     vectorToAdd = dataToSaveForHistAndRaster{elecToPresent(aa),(ll-1)*propertiesFile.numOfTrials + hh};
                     if hh == 1
                         allVectors = vectorToAdd;
                     else
                         allVectors = [allVectors; vectorToAdd];
                     end
                 end
                 [nSlow,xoutSlow] = hist(allVectors,xBins);
                 nSlow = nSlow/numOfTrialsPerLabel(ll); %divide - to get average
                 currFig = histograms{aa,ll};
                 bar(currFig,xoutSlow,nSlow); %nSlow(:,1)?
                 ylim(currFig, [0 20]);
                 currFig.XAxis.Visible = 'off';
                 if ll > 1
                     currFig.YAxis.Visible = 'off';
                 else
                     currFig.YAxis.Color = [0.94 0.94 0.94];
                 end
             end
             if numOfElecsToPresent < propertiesFile.numOfElectrodesPerPage
                 for inti = 1:(propertiesFile.numOfElectrodesPerPage-numOfElecsToPresent)
                     currRaster = rasters{numOfElecsToPresent+inti, ll};
                     currHist = histograms{numOfElecsToPresent+inti, ll};
                     emptyBar = bar(currHist, 0);
                     emptyBar.Visible = 'Off';
                     emptyRaster = scatter(currRaster, 1, 1);
                     emptyRaster.Visible = 'off';
                     currRaster.Visible = 'off';
                     currHist.Visible = 'off';
                     currRaster.XAxis.Visible = 'off';
                     currHist.XAxis.Visible = 'off';
                     currRaster.YAxis.Visible = 'off';
                     currHist.YAxis.Visible = 'off';
                 end
             end
         end
     end
     drawnow;
end


     