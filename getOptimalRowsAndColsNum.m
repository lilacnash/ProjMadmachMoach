function [ numOfRows, numOfCols ] = getOptimalRowsAndColsNum( numOfHists )
%GETOPTIMALROWANDCOLNUM Summary of this function goes here
%   Detailed explanation goes here
    numOfRows = round(sqrt(numOfHists));
    numOfCols = ceil(numOfHists/numOfRows);
end

