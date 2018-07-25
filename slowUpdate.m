function [slowUpdateFlag] = slowUpdate(numberOfHistograms, slow_fig, raster_fig, neuronTimeStamps, slowUpdateFlag)


nGraphs = numberOfHistograms; %number of electrodes to present
nBins = 10; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram

data = neuronTimeStamps;

if(slowUpdateFlag)
    [n,xout] = hist(data,nBins);
    set(0,'CurrentFigure',slow_fig) % make slow_fig thecurrent figure
    
    for jj = 1:12 
        slow_fig = scrollsubplot(nGraphs/4, 4, jj);
        format = 'n(:,%d)';
        barParam = sprintf(format, jj);
        bar(xout,n(:,jj),'YDataSource',barParam);
        
        ttle = sprintf('Online electrode: %d', jj);
        title(ttle);
        xlabel('time bins (sec) ');
        ylabel('count ');
        ylim([0 20]);
        
        %create a raster plot for every slow histogram
        set(0,'CurrentFigure',raster_fig) % make raster_fig the current figure
        %for kk = 1:propertiesFile.numOfTrials %there should be one row for every 0.5sec(or for every update of slow_fig?)
        for kk = 1:propertiesFile.numOfRasterRows %TODO: ask Tankus
            %numOfSpikes = propertiesFile.numOfStamps; %# of timestamps for every electrode
            numOfSpikes = data(:, jj);
            %x axis should be 0.5sec before the beep and 0.5sec after the beep
            for tt = 1:size(numOfSpikes,1)
                %don't plot (break to next row in raster) if timestamp value is greater than rasterRowStartTime+0.5sec
                %creates a scatter plot (dot per spike)
                plot([numOfSpikes(tt) numOfSpikes(tt)], [kk-0.5 kk+0.5], 'Color', 'k');
            end
        end
        ttle = sprintf('Raster Plot: %d', jj);
        title(ttle);
        ylim([0 propertiesFile.numOfRasterRows+1]);
        xlabel('time bins (sec) ');
        ylabel('0.5sec-long time periods ');
    end
    slowUpdateFlag = 0;
    return;
end
    
%turn on datalinking (in order to update slow_fig)
linkdata on
set(0,'CurrentFigure',slow_fig); % make slow_fig the current figure 
[n,xout] = hist(data,nBins);
refreshdata(slow_fig,'caller');

%update raster plot for relevant slow_fig
linkdata on
set(0,'CurrentFigure',raster_fig); % make raster_fig the current figure
refreshdata(raster_fig,'caller');
 
%et_disp = toc(t_disp0);  % elapsed time since last display
%if(et_disp >= display_period)
%    t_col0 = tic; % collection time
%    t_disp0 = tic; % restart the period
%    bCollect = true; % start collection
end


