function [connection, instrument] = openNeuroport(interface, recordingsFileName, comments)

[connection, instrument] = cbmex('open', interface); %Try default, return assigned connection type

%print connection details
sprintf('>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);