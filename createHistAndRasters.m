function createHistAndRasters(minVal, maxVal, slowUpdateFlag, newTrialsPerLabel, numOfTrialsPerLabel, dataToSaveForHistAndRaster)
     elecToPresent = getElecToPresentSlowUpdate(round(get(findobj('Tag','sliderForSlowUpdate'),'Value')/4,1)*4+1); %4 per page for now
     %nBins = propertiesFile.numOfBins;
     sizeOfBins = (maxVal-minVal)/10;
     xBins = [minVal:sizeOfBins:maxVal];
     if(slowUpdateFlag)
         for ll = 1:propertiesFile.numOfLabelTypes
             if newTrialsPerLabel(ll) > 0
                 for aa = 1:propertiesFile.numOfElectrodesPerPage
                     currFig = findobj('Tag', ['rasterPlot',num2str(aa),'_',num2str(ll)]); %findobj -> findall
                     for rr = (numOfTrialsPerLabel(ll) - newTrialsPerLabel(ll) + 1):numOfTrialsPerLabel(ll)
                         currVector = dataToSaveForHistAndRaster{aa,(ll-1)*propertiesFile.numOfTrials + rr};
                         for nn = 1:length(currVector)
                             hold(currFig, 'on');
                             plot(currFig, [currVector(nn) currVector(nn)], [rr-0.1 rr+0.1], 'Color', 'k');
                             %hold on;
                         end
                     end
                     %ttle = sprintf('Raster Plot: %d', rr);
%                      ttle = sprintf('Raster Plot: %d_%d', aa, ll);
%                      title(currFig, ttle);
                     %ylim(currFig, [0 3]);
                     xlim(currFig, [-5 5]);
                     xticks([0]);
%                      xticklabels(currFig, {'BEEP_SOUND'});
                     format = '%s trials';
                     switch (ll)
                         case 1
                             vowelToDisp = 'a';
                         case 2
                             vowelToDisp = 'e';
                         case 3
                             vowelToDisp = 'i';
                         case 4
                             vowelToDisp = 'o';
                         case 5
                             vowelToDisp = 'u';
                     end
                     txtForY = sprintf(format, vowelToDisp);
                     %ylabel(currFig, txtForY);
                     yticks(currFig, [2]);
                     yticklabels(currFig, {txtForY});
                     slowUpdateFlag = 0;
                     %create histogram  for electrode aa (averaged hist of all 'll' trials until now)
                     for hh = 1:numOfTrialsPerLabel(ll)
                         vectorToAdd = dataToSaveForHistAndRaster{aa,(ll-1)*propertiesFile.numOfTrials + hh};
                         if hh == 1
                             allVectors = vectorToAdd;
                         else
                             allVectors = [allVectors; vectorToAdd];
                         end
                     end
                     [nSlow,xoutSlow] = hist(allVectors,xBins);
                     nSlow = nSlow/numOfTrialsPerLabel(ll); %divide - to get average
                     %format = 'nSlow(:,%d)';
                     %barParam = sprintf(format, elecToPresent(jj));
                     currFig = findobj('Tag',['slowUpdatePlot',num2str(aa),'_',num2str(ll)]);
                     %bar(currFig,xoutSlow,nSlow(:,jj),'YDataSource',barParam, 'XDataSource', 'xoutSlow');
                     bar(currFig,xoutSlow,nSlow); %nSlow(:,1)?
                     ttle = sprintf('Online electrode:');
                     title(currFig, ttle);
                     currText = findobj('Tag',['slowPlotLabel',num2str(aa),'_',num2str(ll)]);
                     set(currText, 'string', elecToPresent(aa));
                     %xlabel(currFig, 'time bins (sec) ');
                     %ylabel(currFig, 'count ');
                     ylim(currFig, [0 20]);
                 end
             end
         end
     end
end