%Conect to the neurolink system and plot grapph for each electorde
%connected in real time. replot every k seconds.
%password **Cervello1**
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

inputSystem = 0; 

Electrodes.numOfBins = 10;
Electrodes.numOfElec = 10; 
Electrodes.updateTime = 5;
Electrodes.elecArray = cell(Electrodes.numOfElec, 1);
Electrodes.n = cell(Electrodes.numOfElec,1); %creates a cell array of the n parameter for each electrodes
Electrodes.xout = cell(Electrodes.numOfElec,1); %creates a cell array of the xout parameter for each electrodes

%init cell array to read data in from buffer -> input for histograms
spikesTimeStamps = cell(Electrodes.numOfElec, 1);
numOfStamps = 10; %number of time stamps to save from electrodes 
for ii = 1:Electrodes.numOfElec
    spikesTimeStamps{ii, 1} = NaN(1, numOfStamps);
end 

%create cyclic time stemps vectors for each electrode
index = ones(Electrodes.numOfElec, 1);

%create array of histograms - one for each active electrod.
for ii = 1:Electrodes.numOfElec
   
    Electrodes.elecArray{ii, 1} = figure;
    histogram(spikesTimeStamps{ii, 1}, Electrodes.numOfBins);
    xlabel('Time', 'FontSize', 12);
    ylabel('number of spikes', 'FontSize', 12);
    title('spikes per 100 ms', 'FontSize', 18);
end

%%
%conect to nueroport
if(inputSystem == 0)
    recordingsFileName = 'D:\Neuroport\BMI\test3'; %TODO: where to record to
    comments = 'third'; %TODO what is this for?
    interface = 2; %TODO: what value should it get?
    [connection, instrument] = ConnectToNeuroport(interface, recordingsFileName, comments);
    %TODO: check if connection and instrument are as expected
end

%%
%read and display

%read from neuroport
if(inputSystem == 0)
    
    [activeState, configVectorOut] = cbmex('trialconfig', 1, 'double');
    
    for ii = 1:5 %TODO: change to true while(TRUE)
        
        pause(Electrodes.updateTime);%TODO: change to other thread?
        eventData = cbmex('trialdata', 1);
        
        for jj = 1:Electrodes.numOfElec 
           for indexFromTempVector = 1:length(eventData{jj, 1})
                
                index(jj) = mod(index(jj)-1,numOfStamps)+1;
                spikesTimeStamps{jj,1}(index(jj)) = eventData{jj, 1}(indexFromTempVector); 
                index(jj) = index(jj)+1;
                    
           end
        end
        
        for indexForHist = 1:Electrodes.numOfElec
            
            [Electrodes.n{indexForHist},Electrodes.xout{indexForHist}] = hist(spikesTimeStamps{indexForHist, 1}, Electrodes.numOfBins); %takes n and xout parameters for each electrode
            figure(Electrodes.elecArray{indexForHist, 1})
            bar(Electrodes.xout{indexForHist},Electrodes.n{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            linkdata on
            xlabel('Time', 'FontSize', 12);
            ylabel('number of spikes', 'FontSize', 12);
            title('spikes per 100 ms', 'FontSize', 18);
        
        end
    end
end

%%
%read from trail
% 
% s = 'Ready to conect?';
% output = input(s, 's');
% if strcmp(output,'y') 
%     t = tcpip('10.0.0.2', 55000, 'NetworkRole', 'client');
%     set(t, 'InputBufferSize', 7688);
%     set(t, 'Timeout', 30);
%     fopen(t);
% 
%     if(inputSystem == 1)
%         for ii = 1:5 %TODO: change to true while(TRUE)
%             pause(Electrodes.updateTime);%TODO: change to other thread?
%             for jj = 1:Electrodes.numOfElec
%                 tempVectorFromElectrode = fread(t , 961, 'double');
%                 for indexFromTempVector = 1:length(tempVectorFromElectrode)
%                     index(jj) = mod(index(jj)-1,numOfStamps)+1;
%                     spikesTimeStamps{jj,1}(index(jj)) = tempVectorFromElectrode(indexFromTempVector); 
%                         index(jj) = index(jj)+1;
%                 end
%             end
% 
%             for indexForHist = 1:Electrodes.numOfElec
%                 [Electrodes.n{indexForHist},Electrodes.xout{indexForHist}] = hist(spikesTimeStamps{indexForHist, 1}, Electrodes.numOfBins); %takes n and xout parameters for each electrode
%                 figure(Electrodes.elecArray{indexForHist, 1})
%                 bar(Electrodes.xout{indexForHist},Electrodes.n{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
%                 linkdata on
%                 xlabel('Time', 'FontSize', 12);
%                 ylabel('number of spikes', 'FontSize', 12);
%                 title('spikes per 100 ms', 'FontSize', 18);
%             end
%         end
%     end
%     fclose(t);
% end

%%
%read from server
if(inputSystem == 2)
    t = tcpip('localhost', 30000, 'NetworkRole', 'client');
    fopen(t);
    while(data(1) ~= -1) %read from server until server end connection by sending -1
        pause(Electrodes.updateTime);%TODO: change to other thread?
        data = read(t,100, 'double'); %reads 100 doubles vector from server
        figure(Electrodes.elecArray{his, 1})
        histogram(spikesTimeStamps{his, 1}, Electrodes.numOfBins);
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