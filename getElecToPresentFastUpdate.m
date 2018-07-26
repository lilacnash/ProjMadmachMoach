function elecToPresent = getElecToPresentFastUpdate(indexOfPlot1, plot1Length, indexOfPlot2, plot2Length, indexOfPlot3, plot3Length, indexOfPlot4, plot4Length)
%TODO: ask user which electrodes he would like to present in fast update
    elecToPresent = [indexOfPlot1, plot1Length+indexOfPlot2, plot1Length+plot2Length+indexOfPlot3, plot1Length+plot2Length+plot3Length+indexOfPlot4];
end