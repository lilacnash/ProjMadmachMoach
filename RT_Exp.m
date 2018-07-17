%%
clear all;
clear variables;

%%
%===============PRE-PROCESING===============
%===========================================
propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
%open neuroport
%[connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
connection = 1; %TODO: delete
instrument = 1; %TODO: delete
%print connection details
sprintf('>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);

%get number of electrode to present  
%TODO: this should return a map of active neurons (not channels) and their index.
%[numOfElecToPres, neuronMap] = getNumOfElecToPres(); % TODO: this should create a mapping
numOfElecToPres = 4; %TODO: delete
%%
%===============TRAINING====================
%===========================================

collect_time = 1; %propertiesFile.collectTime; %TODO: CHANGE
fast_update_time = 0.1; %propertiesFile.fastUpdateTime; %TODO: CHANGE
slow_update_time = 1; %propertiesFile.slowUpdateTime; %TODO: CHANGE
Syllables = []; %propertiesFile.Syllables; %TODO: CHANGE
allTimestampsMatrix = NaN(80, 200); %TODO: CHANGE first param to propertiesFile.numOfElec
index = ones(80, 1); %TODO: CHANGE first param to propertiesFile.numOfElec
fastUpdateFlag = true; %TODO: change to property and delete
slowUpdateFlag = true; %TODO: change to property and delete
numberOfHistograms = 80; %TODO: get this from function

prompt = 'press ENTRR to start training\n';
input(prompt);

sprintf('>>>>>>>>>>> in RT_Exp:TRAINING started\n');

%%
%init clocks
t_Fdisp0 = tic; %fast display time
t_Sdisp0 = tic; %slow display time
t_SYLdisp = tic; %Syllables change time
t_col0 = tic; %collection time
bCollect = true; %do we need to collect
time = 0; %TODO: delete this

%%
%init figures
fast_fig = figure; %fast update display

slow_fig = figure; %slow update display

syl_index = 0;
Syl_fig = figure; %used to move between syllables
title('A - close this window to move to the next Syllable')

%%
%while slow and fast figures are open
while(or(ishandle(slow_fig), ishandle(fast_fig)))
    if(bCollect)
        et_col = toc(t_col0); %elapsed time of collection
        if(et_col >= collect_time)
            neuronTimeStamps = getAllTimestampsSim(time); %TODO: delete this
            %neuronTimeStamps = getAllTimeStamps(allTimestampsMatrix, index); %read some data - the data should retern in cyclic arrays
            elecToPresent = getElecToPresent();%ask which neurons to present in fast update
            %if the figure is open
            if(ishandle(fast_fig))
                fastUpdateFlag = fastUpdate(elecToPresent, fast_fig, neuronTimeStamps, fastUpdateFlag); %plot the choosen fast histograms 
            end
            et_disp = toc(t_Fdisp0);  % elapsed time since last display
            
            %if(et_disp >= display_period)
            %    t_col0 = tic; % collection time
            %    t_disp0 = tic; % restart the period
            %    bCollect = true; % start collection
            %end
        end
        if(et_col >= slow_update_time)
            if(ishandle(slow_fig))
                slowUpdateFlag = slowUpdate(numberOfHistograms, slow_fig, neuronTimeStamps, slowUpdateFlag); %plot all active histograms and rasterplots 
            end
        end
    end
    time = time + 0.5; %TODO: delete this
end
    
