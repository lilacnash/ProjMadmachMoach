function [ ] = slowUpdateForGui_tmp( timerObj, event )
%SLOWUPDATEFORGUI Summary of this function goes here
%   Detailed explanation goes here
    timerData = get(timerObj, 'UserData');
    [n,xout] = hist(timeData.data, timerData.nBins);
    refreshdata(timeData.slowGuiObject,'caller');
    timerData.n = n;
    timerData.xout = xout;
    set(timerObj, 'UserData', timerData);
end

