function [ elecsToPresent ] = getElecToPresentSlowUpdate( page )
%GETELECTOPRESENTSLOWUPDATE Summary of this function goes here
%   Detailed explanation goes here
     %elecsToPresent = [(page-1)*10+1:(page*10)];
     elecsToPresent = [(page-1)*4+1:(page*4)];
     %elecsToPresent = [1:4];
%     elecsToPresent = [97:106];
end

