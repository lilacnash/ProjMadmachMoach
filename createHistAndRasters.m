function createHistAndRasters(minVal, maxVal, slowUpdateFlag, newTrialsPerLabel, numOfTrialsPerLabel, dataToSaveForHistAndRaster, histograms, currGui, rasters)
     elecToPresent = getappdata(currGui,'currPageElecs');
     %nBins = propertiesFile.numOfBins;
     sizeOfBins = (maxVal-minVal)/10;
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
     if(slowUpdateFlag)
         for ll = 1:propertiesFile.numOfLabelTypes
             if newTrialsPerLabel(ll) > 0
                 for aa = 1:numOfElecsToPresent
                     currFig = rasters{aa,ll};
                     for rr = 1:numOfTrialsPerLabel(ll)
                         currVector = dataToSaveForHistAndRaster{elecToPresent(aa),(ll-1)*propertiesFile.numOfTrials + rr};
                         if ~isempty(currVector)
                             yVec = rr + zeros(length(currVector),1);
                             scatter(currFig, currVector, yVec, 1, 'k');
                             hold(currFig, 'on');
                         end
                     end
                     xlim(currFig, [minVal maxVal]);
                     ylim(currFig, [0 (rr+1)]);
                     currFig.YAxis.Visible = 'off';
                     if aa < numOfElecsToPresent
                         currFig.XAxis.Visible = 'off';
                     else
                         currFig.XAxis.Visible = 'on';
                         currFig.XAxis.FontSize = 8;
                         currFig.XAxis.Color = [0.94 0.94 0.94];
                     end
                     hold(currFig, 'off');
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
%                          if (strcmp(currRaster.Visible, 'on'))
%                             hold(currRaster, 'off');
%                          end
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
     end
end