function createHistAndRasters(minVal, maxVal, slowUpdateFlag, newTrialsPerLabel, numOfTrialsPerLabel, dataToSaveForHistAndRaster, histograms, currGui)
     elecToPresent = getappdata(findall(0,'Name', 'slowUpdateGui_v3'),'currPageElecs');
     %nBins = propertiesFile.numOfBins;
     sizeOfBins = (maxVal-minVal)/10;
     xBins = [minVal:sizeOfBins:maxVal];
     if(slowUpdateFlag)
         for ll = 1:propertiesFile.numOfLabelTypes
             if newTrialsPerLabel(ll) > 0
                 for aa = 1:propertiesFile.numOfElectrodesPerPage
                     currFig = findall(currGui, 'Tag', ['rasterPlot',num2str(aa),'_',num2str(ll)]);
                     %next for to parfor
                     for rr = (numOfTrialsPerLabel(ll) - newTrialsPerLabel(ll) + 1):numOfTrialsPerLabel(ll)
                         currRasterRow = rr;
                         hold(currFig, 'on');
                         currVector = dataToSaveForHistAndRaster{elecToPresent(aa),(ll-1)*propertiesFile.numOfTrials + rr};
                         if ~isempty(currVector)
                             yVec = rr + zeros(length(currVector),1);
                             scatter(currFig, currVector, yVec, 1, 'k');
                         end
                     end
                     ylim(currFig, [0 (currRasterRow+1)]);
                     xlim(currFig, [minVal maxVal]);
                     xticks([0]);
                     
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
                     ylim(currFig, [0 (maxYForLim+1)]);
                 end
             end
         end
     end
end