function [connection, instrument] = ConnectToNeuroport(interface, recordingsFileName, comments)

[connection, instrument] = cbmex('open', interface); %Try default, return assigned connection type

% Start recording the specified file with the comment
cbmex('fileconfig', recordingsFileName, comments, 1);

% Activate all the channels
cbmex('mask', 0, 1);

%print connection details
sprintf('>>>>>>>>>>> in ConnectToNeuroport: connection: %d, instrument: %d\n', connection, instrument);