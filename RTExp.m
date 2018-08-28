%%
%global cfg;

%%
%===============INIT-GUI===============
%======================================
function varargout = RTExp(varargin)
% RTEXP MATLAB code for RTExp.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RTExp_OpeningFcn, ...
                   'gui_OutputFcn',  @RTExp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% Executes just before RTExp is made visible.
function RTExp_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for RTExp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set up data
load('labelsList.mat')
labelsAndBipsTime = zeros(length(labelsList),2);
setappdata(handles.figure1, 'labelsList', labelsList);
setappdata(handles.figure1, 'labelsIndex', 1);
setappdata(handles.figure1, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.figure1, 'labelsAndBipsTimeIndex', 1);
setappdata(handles.figure1,'slowUpdateFlag',false);
setappdata(handles.figure1, 'useCBMEX', false);
setappdata(handles.figure1, 'closeFlagOn', false);
setappdata(handles.figure1, 'stopButtonPressed', false);
setappdata(handles.figure1, 'startExpButtonPressed', false);

% UIWAIT makes RTExp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end


% Outputs from this function are returned to the command line.
function varargout = RTExp_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
end


%%
%===========GUI-CREATE-FUNCTIONS========
%=======================================
function fastPlotsSlider1_CreateFcn(hObject, eventdata, handles)
    disp('fastPlotsSlider1_CreateFcn');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


function fastPlotsSlider2_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    disp('fastPlotsSlider2_CreateFcn');
end


function fastPlotsSlider3_CreateFcn(hObject, eventdata, handles)
    disp('fastPlotsSlider3_CreateFcn');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


function fastPlotsSlider4_CreateFcn(hObject, eventdata, handles)
    disp('fastPlotsSlider4_CreateFcn');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


function listboxFastPlot1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    disp('listboxFastPlot1_CreateFcn');
    indexesList = {'1'};
    set(hObject , 'string' , indexesList);
end


function listboxFastPlot2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    disp('listboxFastPlot2_CreateFcn');
    indexesList = {'2'};
    set(hObject , 'string' ,indexesList);
end


function listboxFastPlot3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    disp('listboxFastPlot3_CreateFcn');
    indexesList = {'3'};
    set(hObject , 'string' ,indexesList);
end


function listboxFastPlot4_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    disp('listboxFastPlot4_CreateFcn');
    indexesList = {'4'};
    set(hObject , 'string' ,indexesList);
end


%%
%===============GUI-CALLBACKS===========
%=======================================
function nextLabel_Callback(hObject, eventdata, handles)
    disp('nextLabel_Callback');
    labelsList = getappdata(handles.figure1, 'labelsList');
    labelsIndex = getappdata(handles.figure1, 'labelsIndex');
    %TODO:: add next line
    %trialIndex = getappdata(handles.nextLabel, 'trialIndex');
    labelsAndBipsTime = getappdata(handles.figure1, 'labelsAndBipsTime');
    labelsAndBipsTimeIndex = getappdata(handles.figure1, 'labelsAndBipsTimeIndex');
    if labelsIndex == 1
        set(handles.labelText, 'String', labelsList(labelsIndex));
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.LABEL_SHOWING, GetSecs];
        setappdata(handles.figure1,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.figure1,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
        setappdata(handles.figure1,'currLabel',labelsList(labelsIndex));
        setappdata(handles.figure1,'labelsIndex',labelsIndex+1);
    elseif labelsIndex <= length(labelsList)
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.END_OF_LABEL, GetSecs];    
        set(handles.labelText, 'String', labelsList(labelsIndex));
        labelsAndBipsTime(labelsAndBipsTimeIndex+1, 1:2) = [propertiesFile.LABEL_SHOWING, GetSecs];
        setappdata(handles.figure1,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.figure1,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+2);
        setappdata(handles.figure1,'currLabel',labelsList(labelsIndex));
        setappdata(handles.figure1,'labelsIndex',labelsIndex+1);
        %TODO:: add next line
        %setappdata(handles.nextLabel,'trialIndex',trialIndex+3); %TODO:1,3,1,3(no2=bip) in labelAndBipsTime
    else
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.END_OF_LABEL, GetSecs];    
        setappdata(handles.figure1,'labelsAndBipsTime',labelsAndBipsTime);
        %TODO:: add next line
        %setappdata(handles.nextLabel,'trialIndex',trialIndex+3);
        save('labelsAndBipsTime.mat', 'labelsAndBipsTime');
    end
end


function startRecording_Callback(hObject, eventdata, handles)
    disp('startRecording_Callback');
    labelsAndBipsTime = getappdata(handles.figure1, 'labelsAndBipsTime');
    labelsAndBipsTimeIndex = getappdata(handles.figure1, 'labelsAndBipsTimeIndex');
    if labelsAndBipsTimeIndex ~= 1 && labelsAndBipsTime(labelsAndBipsTimeIndex-1,1) == propertiesFile.LABEL_SHOWING
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.BEEP_SOUND, GetSecs];
        Beeper(propertiesFile.beepFrequency, propertiesFile.beepVolume, propertiesFile.beepDurationSec);
        setappdata(handles.figure1,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.figure1,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
    end
end

function fastPlotsSlider1_Callback(hObject, eventdata, handles)
    disp('fastPlotsSlider1_Callback');
end

      
function fastPlotsSlider2_Callback(hObject, eventdata, handles)
    disp('fastPlotsSlider2_Callback');
end


function fastPlotsSlider3_Callback(hObject, eventdata, handles)
    disp('fastPlotsSlider3_Callback');
end

   
function fastPlotsSlider4_Callback(hObject, eventdata, handles)
    disp('fastPlotsSlider4_Callback');
end


function slowUpdateButton_Callback(hObject, eventdata, handles)
    disp('slowUpdateButton_Callback');
    % slowUpdateGui;
    if get(handles.startExpButton, 'Value') == 1
        setappdata(handles.figure1,'slowUpdateFlag',true);
    else
        errordlg('Please choose the "Start Exp" button before pressing the "Slow Update" option!','Unpermitted Operation');
    end
end


function startExpButton_Callback(hObject, eventdata, handles)
    %%
    %===============PRE-PROCESING===============
    %===========================================
    
    connection = -1;
    instrument = -1;
    % propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
    if getappdata(handles.figure1, 'useCBMEX') == true
        % open neuroport
        cbmex('close');
        [connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    end
    setappdata(handles.figure1, 'startExpButtonPressed', true);
    %%
    disp('startExpButton_Callback');
    %print connection details
%    fprintf(cfg.logfile, '>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);

    %get number of electrode to present  
    %TODO: this should return a map of active neurons (not channels) and their index.
    %[numOfElecToPres, neuronMap] = getNumOfElecToPres(); % TODO: this should create a mapping
    numOfElecToPres = 4; %TODO: delete
    %%
    %===============TRAINING====================
    %===========================================
    numberOfHistograms = 80; %TODO: get this from function
    collect_time = 0; %propertiesFile.collectTime;
    fast_update_time = propertiesFile.fastUpdateTime;
    slow_update_time = propertiesFile.slowUpdateTime;
    nGraphs = propertiesFile.numOfElec;
    index = ones(propertiesFile.numOfElec, 1);
    neuronTimeStamps = NaN(200, 80);
    fastUpdateFlag = propertiesFile.fastUpdateFlag;
    slowUpdateFlag = propertiesFile.slowUpdateFlag;
    firstUpdate = true;

%    fprintf(cfg.logfile, '>>>>>>>>>>> in RT_Exp:TRAINING started\n');

    %%
    %init clocks
    t_col0 = tic; %collection time
    bCollect = true; %do we need to collect
    firstGetTimestamps = true;
    lastSample = 0;

    %%
    %set the listboxes with relevant values
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    [listBox3, listBox4, listBox1, listBox2] = getListBoxes(numOfActiveElectrodes);
    set(handles.listboxFastPlot1, 'string', listBox1);
    set(handles.listboxFastPlot2, 'string', listBox2);
    set(handles.listboxFastPlot3, 'string', listBox3);
    set(handles.listboxFastPlot4, 'string', listBox4);
    set(handles.listboxFastPlot1, 'Value', 1);
    set(handles.listboxFastPlot2, 'Value', 1);
    set(handles.listboxFastPlot3, 'Value', 1);
    set(handles.listboxFastPlot4, 'Value', 1);
    set(handles.numOfElecForPlot3, 'String', listBox3(1), 'Visible', 'off');
    set(handles.numOfElecForPlot4, 'String', listBox4(1), 'Visible', 'off');
    set(handles.numOfElecForPlot2, 'String', listBox2(1), 'Visible', 'off');
    set(handles.numOfElecForPlot1, 'String', listBox1(1), 'Visible', 'off');
    
    set(handles.labelText, 'String', 'Started, press next to continue');
    
    dataToSaveForHistAndRaster = cell(propertiesFile.numOfElec, (propertiesFile.numOfLabelTypes * propertiesFile.numOfTrials));
    dataToSaveIndex = 0;
    trialNum = 0;
    numOfTrialsPerLabel = zeros(1,propertiesFile.numOfLabelTypes);
    %%
    %while slow and fast figures are open
    while(ishandle(handles.figure1) && getappdata(handles.figure1, 'closeFlagOn') == false && getappdata(handles.figure1, 'stopButtonPressed') == false)
        if(bCollect)
            et_col = toc(t_col0); %elapsed time of collection
            if(et_col >= collect_time)
                if getappdata(handles.figure1, 'useCBMEX') == true
                    neuronTimeStamps = getAllTimestamps(neuronTimeStamps, index); %read some data - the data should retern in cyclic arrays
                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', GetSecs); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end
                    elecToPresent = getElecToPresentFastUpdate_tmp(); %ask which neurons to present in fast update
                else
                    [neuronTimeStamps, index, lastSample] = getAllTimestampsSim(et_col, neuronTimeStamps, index, lastSample); %TODO: delete this
                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', GetSecs); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end
                    elecToPresent = getElecToPresentFastUpdate(get(handles.listboxFastPlot1,'Value'), length(listBox1), get(handles.listboxFastPlot2,'Value'), length(listBox2), get(handles.listboxFastPlot3,'Value'), length(listBox3), get(handles.listboxFastPlot4,'Value'), length(listBox4)); %ask which neurons to present in fast update
                end
                %if the gui is open
                if(ishandle(handles.figure1))
                    % update fast
                    nGraphs = size(elecToPresent, 2); %number of electrodes to present
                    listOfFastHandles = findobj('Type', 'Axes');
                    listOfFastHandles = flip(listOfFastHandles);
                    nBins = propertiesFile.numOfBins; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram
                    data = neuronTimeStamps(:, [elecToPresent(1) elecToPresent(2) elecToPresent(3) elecToPresent(4)]);
                    if(fastUpdateFlag)
                        [n,xout] = hist(data,nBins);
                        indexForTitles = 1;
                        for jj = 1:nGraphs
                            format = 'n(:,%d)';
                            barParam = sprintf(format, jj);
                            bar(listOfFastHandles(jj),xout,n(:,jj),'YDataSource',barParam, 'XDataSource', 'xout');
                            title(listOfFastHandles(jj), 'Fast update electrode number:');
                            set(handles.(['numOfElecForPlot',num2str(indexForTitles)]), 'Visible', 'on');
                            xlabel(listOfFastHandles(jj), 'time bins (sec) ');
                            ylabel(listOfFastHandles(jj), 'count ');
                            ylim(listOfFastHandles(jj), [0 20]);
                            indexForTitles = indexForTitles + 1;
                        end
                        fastUpdateFlag = 0;
                    end
                    %turn on datalinking
                    if ishandle(handles.figure1)
                        linkdata on
                        [n,xout] = hist(data,nBins);
                        refreshdata(handles.figure1,'caller');
                        collect_time = et_col + propertiesFile.collectTime;
                    else
                        linkdata off
                    end                
                end
            end
        end
        dataToSave(dataToSaveIndex+1:dataToSaveIndex+length(neuronTimeStamps(:,1)),1:length(neuronTimeStamps(1,:))) = neuronTimeStamps;
        dataToSaveIndex = length(dataToSave(:,1));
        myOffset = getappdata(handles.figure1,'offsetFirstGetTimestamps');
        newLabelAndBipTimeMatrix = {'a', 0.01;
                                    'e', 1.02;
                                    'u', 2.03;
                                    'o', 3.04;
                                    'i', 4.50}; %TODO::call Guy's func instead:
        %newLabelAndBipTimeMatrix = callGuy'sFunc();
        %if newLabelAndBipTimeMatrix == 0
        %    continue;
        %end
        for ii = 1:size(newLabelAndBipTimeMatrix,1)
            letterOfCurrLabel = newLabelAndBipTimeMatrix{ii,1};
            currentBipTime = newLabelAndBipTimeMatrix{ii,2} - myOffset;
            switch (letterOfCurrLabel)
                case 'a'
                    currentLabel = 1;
                case 'e'
                    currentLabel = 2;
                case 'u' %TODO:: a e i o u (change order i=3,u=5)
                    currentLabel = 3;
                case 'o'
                    currentLabel = 4;
                case 'i'
                    currentLabel = 5;
            end
            numOfTrialsPerLabel(currentLabel) = numOfTrialsPerLabel(currentLabel) + 1;
            %save relevant timestamps from current trial
            for ee = 1:propertiesFile.numOfElectrodesPerPage % 4 for now
                %currentElecTimestampsVector = dataToSave(:,ee) - myOffset; %in order to compare to normalized currentBipTime
                currentElecTimestampsVector = dataToSave(:,ee);
                relevantTimestamps = currentElecTimestampsVector(currentElecTimestampsVector>(currentBipTime-1) & currentElecTimestampsVector<(currentBipTime+1));
                relevantTimestamps = relevantTimestamps - currentBipTime; %normalized for histogram x axis
                numOfRelevant = length(relevantTimestamps);
                padding = ((propertiesFile.numOfTrials - numOfRelevant)/2);
                tmpToSave = padarray(relevantTimestamps,floor(padding),'pre');
                finalToSave = padarray(tmpToSave,ceil(padding),'post');
                dataToSaveForHistAndRaster{ee,(currentLabel-1)*propertiesFile.numOfTrials + numOfTrialsPerLabel(currentLabel)} = finalToSave;
            end
            if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
                %slowUpdateGuiFig = slowUpdateGui;
                slowUpdateGuiFig = slowUpdateGui2;
                slowUpdateGuiFig.UserData.closeFlag = false;
                setappdata(handles.figure1, 'slowUpdateGuiFig',slowUpdateGuiFig);
                firstUpdate = false;
                slowUpdateFlag = true;
            end
            if ~firstUpdate && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig')) && slowUpdateGuiFig.UserData.closeFlag == false
                slowGuiObject = getappdata(handles.figure1, 'slowUpdateGuiFig');
                %elecToPresent = getElecToPresentSlowUpdate(round(get(findobj('Tag','sliderForSlowUpdate'),'Value')/10,1)*10+1); %ask which neurons to present in fast update
                elecToPresent = getElecToPresentSlowUpdate(round(get(findobj('Tag','sliderForSlowUpdate'),'Value')/4,1)*4+1); %4 per page for now
                %nGraphs = numberOfHistograms; %number of electrodes to present
                nBins = propertiesFile.numOfBins; %number of bins for histogram
                %data = neuronTimeStamps;
                if(slowUpdateFlag)
                    for aa = 1:propertiesFile.numOfElectrodesPerPage % 4 for now
                        %NaN(size(dataToSaveForHistAndRaster{1,1}),1); %200 instead of size(dataToSaveForHistAndRaster{1,1})
                        %create raster for electrode aa
                        currFig = findobj('Tag', ['rasterPlot',num2str(aa),'_',num2str(currentLabel)]);
                        for tt = 1:numOfTrialsPerLabel(currentLabel)
                            currVector = dataToSaveForHistAndRaster{aa,(currentLabel-1)*propertiesFile.numOfTrials + tt};
                            if tt == 1
                                summedVector = currVector;
                            else
                                summedVector = summedVector + currVector;
                            end
                            %plot a row for every 'a' trial until now (be4 or after summing?)
                            for nn = 1:length(currVector)
                                %hold(currFig, 'on');
                                plot(currFig, [currVector(nn) currVector(nn)], [tt-0.1 tt+0.1], 'Color', 'k');
                                hold on;
                            end
                        end
                        %ttle = sprintf('Raster Plot: %d', rr);
                        ttle = sprintf('Raster Plot: %d_%d', aa, currentLabel);
                        title(currFig, ttle);
                        %ylim(currFig, [0 3]);
                        xlim(currFig, [-5 5]);
                        xticks([0]);
                        xticklabels(currFig, {'BEEP_SOUND'});
                        format = '%s trials';
                        txtForY = sprintf(format, letterOfCurrLabel);
                        %ylabel(currFig, txtForY);
                        yticks(currFig, [2]);
                        yticklabels(currFig, {txtForY});
                        slowUpdateFlag = 0;
                    
                        %create histogram  for electrode aa (averaged hist of all trials until now)
                        [nSlow,xoutSlow] = hist(summedVector,nBins);
                        %[nSlow,xoutSlow] = hist(data,nBins);
                        nSlow = nSlow/numOfTrialsPerLabel(currentLabel); %divide - to get average
                        %format = 'nSlow(:,%d)';
                        %barParam = sprintf(format, elecToPresent(jj));
                        currFig = findobj('Tag',['slowUpdatePlot',num2str(aa),'_',num2str(currentLabel)]);
                        %bar(currFig,xoutSlow,nSlow(:,jj),'YDataSource',barParam, 'XDataSource', 'xoutSlow');
                        bar(currFig,xoutSlow,nSlow); %nSlow(:,1)?
                        ttle = sprintf('Online electrode:');
                        title(currFig, ttle);
                        currText = findobj('Tag',['slowPlotLabel',num2str(aa),'_',num2str(currentLabel)]);
                        set(currText, 'string', elecToPresent(aa));
                        %xlabel(currFig, 'time bins (sec) ');
                        %ylabel(currFig, 'count ');
                        ylim(currFig, [0 20]);
                    end
                end
            end
        end
        % If slowUpdateGui is close setup all slow variables and delete the Gui fig
        if getappdata(handles.figure1, 'slowUpdateFlag') == true && slowUpdateGuiFig.UserData.closeFlag == true
            %linkdata off;
            slowUpdateFlag = true;
            firstUpdate = true;
            setappdata(handles.figure1, 'slowUpdateFlag', false);
            delete(slowUpdateGuiFig);
            %delete(rasterGuiFig); %TODO:: add
        end
    end
    % stoping the recording and save the data
    if getappdata(handles.figure1, 'useCBMEX') == true 
        cbmex('close');
    end
    if ~(isempty(dataToSave))
        currentDateAndTime = replace(replace(datestr(datetime('Now')),' ','_'),':','-');
        if ~(exist('output', 'Dir') > 0)
             mkdir('output');
        end
        save(['output\dataFrom_',currentDateAndTime,'.mat'],'dataToSave');    
    end
     linkdata off;
     setappdata(handles.figure1, 'stopButtonPressed', false);
     setappdata(handles.figure1, 'startExpButtonPressed', false);
     % When closing the main GUI exit nicely
     if getappdata(handles.figure1, 'closeFlagOn') == true
         if getappdata(handles.figure1, 'slowUpdateFlag') == 1
            delete(slowUpdateGuiFig);
         end
        delete(handles.figure1);
     end
     closeSockets();
%     fclose(cfg.logfile);
end

% --- Executes on selection change in listboxFastPlot1.
function listboxFastPlot1_Callback(hObject, eventdata, handles)
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    [listBox3, listBox4, listBox1, listBox2] = getListBoxes(numOfActiveElectrodes);
    set(handles.numOfElecForPlot1, 'String', listBox1(get(hObject, 'Value')));
end

function listboxFastPlot2_Callback(hObject, eventdata, handles)
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    [listBox3, listBox4, listBox1, listBox2] = getListBoxes(numOfActiveElectrodes);
    set(handles.numOfElecForPlot2, 'String', listBox2(get(hObject, 'Value')));
end

function listboxFastPlot3_Callback(hObject, eventdata, handles)
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    [listBox3, listBox4, listBox1, listBox2] = getListBoxes(numOfActiveElectrodes);
    set(handles.numOfElecForPlot3, 'String', listBox3(get(hObject, 'Value')));
end

function listboxFastPlot4_Callback(hObject, eventdata, handles)
    disp('listboxFastPlot4_Callback');
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    [listBox3, listBox4, listBox1, listBox2] = getListBoxes(numOfActiveElectrodes);
    set(handles.numOfElecForPlot4, 'String', listBox4(get(hObject, 'Value')));
end

function useCBMEX_Callback(hObject, eventdata, handles)
    disp('useCBMEX_Callback');
    setappdata(handles.figure1, 'useCBMEX', true);
end


function closeButton_Callback(hObject, eventdata, handles)
    disp('closeButton_Callback');
    setappdata(handles.figure1, 'closeFlagOn', true);
end


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
    disp('stopButton_Callback');
    setappdata(handles.figure1, 'stopButtonPressed', true);
end


% --- Executes on button press in forceCloseButton.
function forceCloseButton_Callback(hObject, eventdata, handles)
    % hObject    handle to forceCloseButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if getappdata(handles.figure1, 'slowUpdateFlag') == 1
        slowUpdateGuiFig = getappdata(handles.figure1, 'slowUpdateGuiFig');
        delete(slowUpdateGuiFig);
    end
    delete(handles.figure1);
end


%%
%===============GUI-OTHER===========
%===================================
function slowUpdateButton_ButtonDownFcn(hObject, eventdata, handles)
    disp('slowUpdateButton_ButtonDownFcn');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    disp('figure1_CloseRequestFcn');
    setappdata(handles.figure1, 'closeFlagOn', true);
    if getappdata(handles.figure1, 'startExpButtonPressed') == false
        delete(handles.figure1);
    end
end
