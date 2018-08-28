function [] = write_to_ard(is_up)
% write_to_ard    

% Author: Ariel Tankus.
% Created: 07.03.2018.


a = serial('/dev/ttyACM0', 'BaudRate', 115200);
fopen(a)
if (is_up)
    fprintf(a, '1\n');
else
    fprintf(a, '0\n');
end
fclose(a)
clear a
