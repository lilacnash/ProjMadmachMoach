%Conect to the neurolink system and plot grapph for each electorde
%connected in real time. replot every k seconds.

%%
%constant
%NEUROPORT = 0;
%TRIAL = 1;
%SERVER = 2;

%%
clear all;
clear variables;

%%
%initialize system

inputSystem = 1; %TODO: read from gui

Electrodes.numOfBins = 10;
Electrodes.numOfElec = 10; %TODO: init from gui
Electrodes.updateTime = 5;%TODO: update by all histogram or every 100ms?
Electrodes.elecArray = cell(Electrodes.numOfElec, 4);

%init cell array to read data in from buffer -> input for histograms
spikesTimeStamps = cell(Electrodes.numOfElec, 3);

%create array of histograms - one for each active electrod.
for ii = 1:Electrodes.numOfElec
   
    Electrodes.elecArray{ii, 1} = figure;
    histogram(spikesTimeStamps{ii, 2}, Electrodes.numOfBins);
    xlabel('Time', 'FontSize', 12);
    ylabel('number of spikes', 'FontSize', 12);
    title('spikes per 100 ms', 'FontSize', 18);
end

%%
%conect to nueroport
if(inputSystem == 0)
    recordingsFileName = ''; %TODO: where to record to
    comments = ''; %TODO what is this for?
    interface = 0; %TODO: what value should it get?
%    [connection, instrument] = ConnectToNeuroport(interface, recordingsFileName, comments);
    %TODO: check if connection and instrument are as expected
end

%%
%read and display (read by function)(main loop)

%read from neuroport
if(inputSystem == 0)
    cbmex('trialconfig', 1);
    for ii = 1:5 %TODO: change to true while(TRUE)
        pause(Electrodes.updateTime);%TODO: change to other thread?
        spikesTimeStamps = cbmex('trialdata', 1);%TODO: what returns for non active channels?
        for his = 1:Electrodes.numOfElec
            figure(Electrodes.elecArray{his, 1})
            histogram(spikesTimeStamps{his, 2}, Electrodes.numOfBins);
            xlabel('Time', 'FontSize', 12);
            ylabel('number of spikes', 'FontSize', 12);
            title('spikes per 100 ms', 'FontSize', 18);
        end
        %TODO: should be stoped by gui
        %if()
        %    break;
    end
end

%read from trail
if(inputSystem == 1)
    for ii = 1:5 %TODO: change to true while(TRUE)
        pause(Electrodes.updateTime);%TODO: change to other thread?
        for jj = 1:Electrodes.numOfElec
            spikesTimeStamps{jj,2} = rand(10,1)*1000;
        end
        for his = 1:Electrodes.numOfElec
            figure(Electrodes.elecArray{his, 1})
            histogram(spikesTimeStamps{his, 2}, Electrodes.numOfBins);
            xlabel('Time', 'FontSize', 12);
            ylabel('number of spikes', 'FontSize', 12);
            title('spikes per 100 ms', 'FontSize', 18);
        end
    end
end

%read from server
if(inputSystem == 2)
    t = tcpip('localhost', 30000, 'NetworkRole', 'client');
    fopen(t);
    while(data(1) ~= -1) %read from server until server end connection by sending -1
        pause(Electrodes.updateTime);%TODO: change to other thread?
        data = read(t,100, 'double'); %reads 100 doubles vector from server
        figure(Electrodes.elecArray{his, 1})
        histogram(spikesTimeStamps{his, 2}, Electrodes.numOfBins);
        xlabel('Time', 'FontSize', 12);
        ylabel('number of spikes', 'FontSize', 12);
        title('spikes per 100 ms', 'FontSize', 18);
    end
end
    
%%
%close operation
if(inputSystem == 0)
    DissconnectFromNeuroport(recordingsFileName, comments);
end

if(inputSystem == 2)
    fclose(t);
end
    

%%
%GUI
