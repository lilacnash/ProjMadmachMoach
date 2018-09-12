function [fastUpdateFlag] = fastUpdate(numOfElecToPresent, fast_fig, neuronTimeStamps, fastUpdateFlag)

nGraphs = size(numOfElecToPresent, 2); %number of electrodes to present
nBins = 10; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram

data = neuronTimeStamps(:, [numOfElecToPresent(1) numOfElecToPresent(2) numOfElecToPresent(3) numOfElecToPresent(4)]);

if(fastUpdateFlag)
    [n,xout] = hist(data,nBins);
    set(0,'CurrentFigure',fast_fig) % make hFig thecurrent figure 
    for jj=1:nGraphs
        fast_fig = subplot(nGraphs/2,2,jj);
        format = 'n(:,%d)';
        barParam = sprintf(format, jj);
        bar(xout,n(:,jj),'YDataSource',barParam);
        
        ttle = sprintf('Fast update electrode number: %d', numOfElecToPresent(jj));
        title(ttle);
        xlabel('time bins (sec) ');
        ylabel('count ');
        ylim([0 20]);
    end
    fastUpdateFlag = 0;
    return;
end
    
    
%turn on datalinking
linkdata on
set(0,'CurrentFigure',fast_fig); % make hFig thecurrent figure 
[n,xout] = hist(data,nBins);
refreshdata(fast_fig,'caller');

 
%et_disp = toc(t_disp0);  % elapsed time since last display
%if(et_disp >= display_period)
%    t_col0 = tic; % collection time
%    t_disp0 = tic; % restart the period
%    bCollect = true; % start collection
end


