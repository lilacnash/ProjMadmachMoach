function [ fds ] = createDataStoreFromDir( dirPath )
% This finction created a new dataStore of .mat files.
% You can use this dataStore by using the output argument like this:
% Usage:
% >> fds = createDataStoreFromFolder(dirPath);
% In order to read from this fds:
% >> dataX = read(fds);
% The designed read function iterated through the .mat files
% in this folder and reads it one by one.
    fds = fileDatastore(dirPath, 'ReadFcn', @readFnc, 'FileExtensions', '.mat');
end

