function closeArduinoPort()
% closeArduinoPort    

% Author: Ariel Tankus.
% Created: 13.01.2018.


global ard_obj;

fclose(ard_obj);
if ((~strcmp(ard_obj.Status, 'closed')) || ...
    (~strcmp(ard_obj.RecordStatus, 'off')))
    error('Failed to close serial port %s', ard_obj.port); 
end

%fprintf(ard_obj, '0\n');

delete(ard_obj);

clear global ard_obj;
