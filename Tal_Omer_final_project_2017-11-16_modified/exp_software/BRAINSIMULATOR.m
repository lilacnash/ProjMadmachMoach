% Clear console and workspace
close all;
clear all;
clc;
KbName('UnifyKeyNames');
keysOfInterest=zeros(f1,256);
keysOfInterest(KbName({'r','d','f','g','a','e','u','o','i','s'}))=1;
KbQueueCreate(-1, keysOfInterest);

% Configuration and connection
disp ('Receiver started');
t=tcpip('localhost', 4013,'NetworkRole','server');

% Wait for connection
disp('Waiting for connection');
fopen(t);
disp('Connection OK');
KbQueueStart;
% write data to the socket
while true
    [pressed, firstPress]=KbQueueCheck;
    if pressed
        pressedCode=find(firstPress);
        if pressedCode == 's' | pressedCode == 'S'
            return;
        end
        fwrite(t,char(pressedCode));
        disp(['sent to socket:',pressedCode]);
        
    end
        
    
end
