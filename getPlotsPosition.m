function [ result ] = getPlotsPosition( numOfHistToPresent )
%GETPLOTSPOSITION Summary of this function goes here
%   Detailed explanation goes here
    BUTTONS_WIDTH = 20;
    BUTTONS_HIGHT = 20;
    MIN_WIDTH_FOR_HISTOGRAM = 40;
    MIN_HIGHT_FOR_HISTOGRAM = 10;
    WIDTH_OFFSET = 4;
    HIGHT_OFFSET = 2;
    GUI = findall(groot, 'Name', 'RTExp_v2');
    if ~isempty(GUI)
        GUIPos = get(GUI, 'Position');
        histWidthRatio = (GUIPos(3)-BUTTONS_WIDTH)/numOfHistToPresent;
        numOfHistInARow = histWidthRatio/MIN_WIDTH_FOR_HISTOGRAM;
        histHightRatio = (GUIPos(4)-BUTTONS_HIGHT)/numOfHistToPresent;
        numOfHistInAColumn = histHightRatio/MIN_HIGHT_FOR_HISTOGRAM;
        if numOfHistInARow >= 1 && numOfHistInAColumn >= 1
            histWidth = GUIPos(3)/floor(sqrt(numOfHistToPresent)) - WIDTH_OFFSET;
            histHightRatio = GUIPos(4)/floor(sqrt(numOfHistToPresent)) - HIGHT_OFFSET;
        elseif numOfHistInARow >= 1 && numOfHistInAColumn < 1
            
        histHight
        if numOfHistInARow >= 1
            for inti = 1:numOfHistToPresent
                result{inti} = [GUIPos(1) + WIDTH_OFFSET, 

    end
end
end

