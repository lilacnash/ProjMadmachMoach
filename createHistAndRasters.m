function createHistAndRasters(minVal, maxVal, slowUpdateFlag, newTrialsPerLabel, numOfTrialsPerLabel, dataToSaveForHistAndRaster, histograms, currGui)
     elecToPresent = getappdata(currGui,'currPageElecs');
     %nBins = propertiesFile.numOfBins;
     sizeOfBins = (maxVal-minVal)/10;
     xBins = [minVal:sizeOfBins:maxVal];
     % Get the number of electrodes to present for the update loop of the
     % histograms and rasters
     if find(elecToPresent == 0) > 0
         numOfElecsToPresent = find(elecToPresent == 0) - 1;
     else
         numOfElecsToPresent = length(elecToPresent);
     end
     if(slowUpdateFlag)
         for ll = 1:propertiesFile.numOfLabelTypes
             if newTrialsPerLabel(ll) > 0
                 for aa = 1:numOfElecsToPresent
                     currFig = findall(currGui, 'Tag', ['rasterPlot',num2str(aa),'_',num2str(ll)]);
                     for rr = 1:numOfTrialsPerLabel(ll)
                         hold(currFig, 'on');
                         currVector = dataToSaveForHistAndRaster{elecToPresent(aa),(ll-1)*propertiesFile.numOfTrials + rr};
                         if ~isempty(currVector)
                             yVec = rr + zeros(length(currVector),1);
                             scatter(currFig, currVector, yVec, 1, 'k');
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
                     maxYForLim = max(nSlow);
                     %format = 'nSlow(:,%d)';
                     %barParam = sprintf(format, elecToPresent(jj));
%                      currFig = findobj('Tag',['slowPlot',num2str(aa),'_',num2str(ll)]);
                     currFig = histograms{aa,ll};
                     %bar(currFig,xoutSlow,nSlow(:,jj),'YDataSource',barParam, 'XDataSource', 'xoutSlow');
                     bar(currFig,xoutSlow,nSlow); %nSlow(:,1)?
%                      ttle = sprintf('Online electrode:');
%                      title(currFig, ttle);
%                      currText = findobj('Tag',['slowPlotLabel',num2str(aa),'_',num2str(ll)]);
%                      set(currText, 'string', elecToPresent(aa));
%                      if aa == propertiesFile.numOfElectrodesPerPage
%                         xlabel(currFig, 'time bins (sec) ');
%                      end
%                      if ll == 1
%                         ylabel(currFig, 'count ');
%                      end
                     ylim(currFig, [0 20]);
                     currFig.XAxis.Visible = 'off';
                     if ll > 1
                         currFig.YAxis.Visible = 'off';
                     else
                         currFig.YAxis.Color = [0.94 0.94 0.94];
                     end
                 end
             end
         end
     end
end