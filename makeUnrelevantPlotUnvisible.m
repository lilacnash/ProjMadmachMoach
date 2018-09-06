function makeUnrelevantPlotUnvisible(selectedLength, currPage, currGui, handles)
    for inti = 1:(propertiesFile.numOfElectrodesPerPage-selectedLength)
        histograms = getappdata(currGui, 'histograms');
        rasters = getappdata(currGui, 'rasters');
        set(handles.(['elec',num2str(selectedLength+inti),'Label']), 'string','');
        currPage(selectedLength+inti) = 0;
%         for indexForLabel = 1:propertiesFile.numOfLabelTypes
%             currRaster = findall(currGui, 'Tag', ['rasterPlot',num2str(selectedLength+inti),'_',num2str(indexForLabel)]);
%             currHist = findall(currGui, 'Tag', ['slowUpdatePlot',num2str(selectedLength+inti),'_',num2str(indexForLabel)]);
%             if isempty(currHist) || isempty(currRaster)
%                 currRaster = rasters{selectedLength+inti, indexForLabel};
%                 currHist = histograms{selectedLength+inti, indexForLabel};
%             end
%             currRaster.Visible = 'off';
%             currHist.Visible = 'off';
%         end
    end
    setappdata(currGui, 'currPageElecs', currPage);
end
