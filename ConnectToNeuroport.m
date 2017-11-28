function [connection, instrument] = ConnectToNeuroport(interface, recordingsFileName, comments)

[connection, instrument] = cbmex('open', interface);
cbmex('fileconfig', recordingsFileName, comments, 1); 
%TODO: add digital out test if working with NSP