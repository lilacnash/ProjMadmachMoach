function [] = fastUpdate(neuronTimeStamps, numOfElecToPresent, neuronMap, fast_fig)

nGraphs = numOfElecToPresent; %number of electrodes to present
nBins = propertiesFile.numOfBins; %number of bins for histogram

data = getAllTimeStamps(); 

[n,xout] = hist(y,x);
set(0,'CurrentFigure',fast_fig) % you say to Matlab to make hFig thecurrent figure 
fast_fig = subplot(4,1,1);
bar(xout,n(:,1),'YDataSource','n(:,1)')
fast_fig = subplot(4,1,2);
bar(xout,n(:,2),'YDataSource','n(:,2)')
fast_fig = subplot(4,1,3);
bar(xout,n(:,3),'YDataSource','n(:,3)')
fast_fig = subplot(4,1,4);
bar(xout,n(:,4),'YDataSource','n(:,4)')

if(propertiesFile.fastUpdateFlag)
    for jj=1:nGraphs
        set(0,'CurrentFigure',fast_fig)
        fast_fig = subplot(2,1,jj);
        bar(xout{jj},n{jj}(:,1),'YDataSource','n(:,1)')
    end
    propertiesFile.fastUpdateFlag = 0;
end
    
for ii=1:nGraphs
    
    %turn on datalinking
    linkdata on
    
    [n{ii},xout{ii}] = hist(data, nBins);
    
    et_disp = toc(t_disp0);  % elapsed time since last display
    if(et_disp >= display_period)
        t_col0 = tic; % collection time
        t_disp0 = tic; % restart the period
        bCollect = true; % start collection
    end
end


