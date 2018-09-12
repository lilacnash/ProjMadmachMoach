function [slowUpdateFlag] = slowUpdate(numberOfHistograms, slow_fig, raster_fig, neuronTimeStamps, slowUpdateFlag)


nGraphs = numberOfHistograms; %number of electrodes to present
nBins = propertiesFile.numOfBins;

data = neuronTimeStamps;
%data = [1:12; 13:24; 25:36; 37:48; 49:60];
updateNum = 1;

if(slowUpdateFlag)
    [n,xout] = hist(data,nBins);
    set(0,'CurrentFigure',slow_fig) % make slow_fig thecurrent figure
    
    for jj = 1:12
        %create slowUpdate Histograms
        slow_fig = scrollsubplot(nGraphs/4, 4, jj);
        format = 'n(:,%d)';
        barParam = sprintf(format, jj);
        bar(xout,n(:,jj),'YDataSource',barParam);
        
        ttle = sprintf('Online electrode: %d', jj);
        title(ttle);
        xlabel('time bins (sec) ');
        ylabel('count ');
        ylim([0 20]);
    end
    
    set(0,'CurrentFigure',raster_fig)
    for jj = 1:12
        %create raster plots 
        %xlim([0 60+1]); %TODO:what is the xlim?
        %ylim([0 propertiesFile.numOfRasterRows]);
        hold on; %TODO: need this? otherwise raster will only have one row that will be changed over and over again
        numOfSpikes = data(:, jj);
            %x axis should be 0.5sec before the beep and 0.5sec after the beep
            for tt = 1:size(numOfSpikes,1)
                %don't plot (break to next row in raster) if timestamp value is greater than rasterRowStartTime+0.5sec
                %creates a scatter plot (dot per spike)
                plot([numOfSpikes(tt) numOfSpikes(tt)], [updateNum-0.1 updateNum+0.1], 'Color', 'k');
            end %this creates the first raster row for everyyy electrode(creates 12 rasters-each with one row)
            
            %removed previous forinsidefor
        ttle = sprintf('Raster Plot: %d', jj);
        title(ttle);
        ylim([0 propertiesFile.numOfRasterRows+1]);
        xlabel('time bins (sec) ');
        ylabel('0.5sec-long time periods ');
        %hold off;
    end
    slowUpdateFlag = 0;
    return;
end
    
%turn on datalinking (in order to update slow_fig)
linkdata on
set(0,'CurrentFigure',slow_fig); % make slow_fig the current figure 
[n,xout] = hist(data,nBins);
refreshdata(slow_fig,'caller');
%updateNum = updateNum + 1;

%update raster plot for relevant slow_fig
updateNum = updateNum + 1;
linkdata on
set(0,'CurrentFigure',raster_fig); % make raster_fig the current figure
%hold all; %TODO: need this?

%for ii = 1:size(numOfSpikes,1)
%    plot([numOfSpikes(nn) numOfSpikes(nn)], [updateNum-0.1 updateNum+0.1], 'Color', 'k');
%end %this adds another row to everyyy one of the 12 raster plots
refreshdata(raster_fig,'caller');

end


