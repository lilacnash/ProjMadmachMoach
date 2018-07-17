function [slowUpdateFlag] = slowUpdate(numberOfHistograms, slow_fig, neuronTimeStamps, slowUpdateFlag)

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
        
        ttle = sprintf('Slow update electrode number: %d', jj);
        title(ttle);
        xlabel('time bins (sec) ');
        ylabel('count ');
        ylim([0 20]);
    end
    slowUpdateFlag = 0;
    return;
end
    
    
%turn on datalinking
linkdata on
set(0,'CurrentFigure',slow_fig); % make slow_fig the current figure 
[n,xout] = hist(data,nBins);
refreshdata(slow_fig,'caller');

 
%et_disp = toc(t_disp0);  % elapsed time since last display
%if(et_disp >= display_period)
%    t_col0 = tic; % collection time
%    t_disp0 = tic; % restart the period
%    bCollect = true; % start collection
end


