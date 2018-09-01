%%
%===============INIT-GUI===============
%======================================
function varargout = RTExp_v3(varargin)
% RTEXP_V3 MATLAB code for RTExp_v3.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RTExp_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @RTExp_v3_OutputFcn, ...
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

% Executes just before RTExp_v3 is made visible.
function RTExp_v3_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for RTExp_v3
handles.output = hObject;
% Sets the GUIs position to be almost the maximum of the screen
set(hObject, 'Position', [ 0.005, 0.09, 0.95, 0.87]);

% Update handles structure
guidata(hObject, handles);

% set up data
load('labelsList.mat')
labelsAndBipsTime = zeros(length(labelsList),2);
setappdata(handles.figure1, 'labelsList', labelsList);
setappdata(handles.figure1, 'labelsIndex', 1);
%TODO::add next line
%setappdata(handles.nextLabel, 'trialIndex', 1);
setappdata(handles.figure1, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.figure1, 'labelsAndBipsTimeIndex', 1);
setappdata(handles.figure1,'slowUpdateFlag',false);
setappdata(handles.figure1, 'useCBMEX', false);
setappdata(handles.figure1, 'closeFlagOn', false);
setappdata(handles.figure1, 'stopButtonPressed', false);
setappdata(handles.figure1, 'startExpButtonPressed', false);
setappdata(handles.figure1, 'elecToPresent', []);
setappdata(handles.figure1, 'listboxString', {''});

% UIWAIT makes RTExp_v3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end


% Outputs from this function are returned to the command line.
function varargout = RTExp_v3_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
end


%%
%===========GUI-CREATE-FUNCTIONS========
%=======================================




%%
%===============GUI-CALLBACKS===========
%=======================================

function popupmanueData_Callback (hObject, eventdata)
    disp('popupmanueData_Callback');
    RTExpObject = hObject.Parent;
    elecToPresent = getappdata(RTExpObject, 'elecToPresent');
    elecNumRegex = regexp(get(hObject, 'Tag'), '\d+', 'match');
    elecNum = str2num(elecNumRegex{1});
    newChoise = get(hObject, 'Value');
    listboxString = getappdata(RTExpObject, 'listboxString');
    elecToPresent(elecNum) = str2num(listboxString{newChoise});
    setappdata(RTExpObject, 'elecToPresent', elecToPresent);
    titleObj = findobj('Tag', ['fastPlotTitle', num2str(elecNum)]);
    set(titleObj, 'String', [propertiesFile.fastHistogramsTitle, num2str(newChoise)]);
end


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
    
    if getappdata(handles.figure1, 'useCBMEX') == true
        startRecording(); 
    end
    %TODO: add "recording" on screen
    
    labelsAndBipsTime = getappdata(handles.figure1, 'labelsAndBipsTime');
    labelsAndBipsTimeIndex = getappdata(handles.figure1, 'labelsAndBipsTimeIndex');
    if labelsAndBipsTimeIndex ~= 1 && labelsAndBipsTime(labelsAndBipsTimeIndex-1,1) == propertiesFile.LABEL_SHOWING
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.BEEP_SOUND, GetSecs];
        Beeper(propertiesFile.beepFrequency, propertiesFile.beepVolume, propertiesFile.beepDurationSec);
        setappdata(handles.figure1,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.figure1,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
    end
end


function slowUpdateButton_Callback(hObject, eventdata, handles)
    disp('slowUpdateButton_Callback');
    % slowUpdateGui;
    if get(handles.startExpButton, 'Value') == 1
%         setappdata(handles.figure1,'slowUpdateFlag',true);
        setappdata(handles.figure1,'slowUpdateFlag',true);
    else
        errordlg('Please choose the "Start Exp" button before pressing the "Slow Update" option!','Unpermitted Operation');
    end
end


function startExpButton_Callback(hObject, eventdata, handles)
    %%
    %===============PRE-PROCESING===============
    %===========================================
    disp('startExpButton_Callback');
    
    global cfg;
    
    stamIndex = 1; %delete after connecting to Guy
    connection = -1;
    instrument = -1;
    
    % propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
    if getappdata(handles.figure1, 'useCBMEX') == true
        % open neuroport
        cbmex('close');
        [connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    end
    MAX_LEGENT_FONT_SIZE = 12;
    setappdata(handles.figure1, 'startExpButtonPressed', true);
    
    %% Initilize the GUI plots according to the properties
    % Initilize all GUI objects
    % If rows and columns did not come from the properties file  get
    % optiman number
    if propertiesFile.numOfCols <= 0 || propertiesFile.numOfRows <= 0
        [numOfRows, numOfCols] = getOptimalRowsAndColsNum(propertiesFile.numOfHistogramsToPresent);
    end
    fastPlotsPanel = findobj('Tag', 'fastPlotsPanel');
    containerPosition = [0.0079    0.0078    0.8540    0.8717];
    GUI_object = findobj('Name', 'RTExp_v3');
    generatePlots(GUI_object, propertiesFile.numOfHistogramsToPresent, numOfRows, numOfCols, containerPosition);
  
    
    % Insert data into Listboxes and titles
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, matrix] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
    end
    listboxString = arrayfun(@num2str, (1:numOfActiveElectrodes), 'UniformOutput', false);
    for inti = 1:propertiesFile.numOfHistogramsToPresent
        % Insert data to listboxes
        currHandler = findobj('Tag',['fastPlotPopupmenu', num2str(inti)]);
        set(currHandler, 'Value', inti);
        set(currHandler, 'String', listboxString);
        set(currHandler, 'Callback', @popupmanueData_Callback);
        % Insert data into titles
        currHandler = findobj('Tag',['fastPlotTitle', num2str(inti)]);
        if propertiesFile.numOfHistogramsToPresent <= 16
            set(currHandler, 'String', [propertiesFile.fastHistogramsTitle, num2str(inti)]);
        else
            set(currHandler, 'String', ['Electrode: ', num2str(inti)], 'FontSize', 7);
        end
        
        setappdata(handles.figure1, 'listboxString', listboxString);
        elecToPresent(inti) = inti;
    end
    % Saves elecToPresent in a shared variable
    setappdata(handles.figure1, 'elecToPresent', elecToPresent);

    %%
    %===============TRAINING====================
    %===========================================
    collect_time = 0; %propertiesFile.collectTime;
    index = ones(propertiesFile.numOfElec, 1);
    neuronTimeStamps = NaN(propertiesFile.numOfStamps, propertiesFile.numOfElec);
    dataToSave = NaN(1, propertiesFile.numOfElec);
    fastUpdateFlag = propertiesFile.fastUpdateFlag;
    slowUpdateFlag = propertiesFile.slowUpdateFlag;
    firstUpdate = true;

    fprintf('>>>>>>>>>>> in RT_Exp:TRAINING started\n');

    %%
    %init clocks
    t_col0 = tic; %collection time
    bCollect = true; %do we need to collect
    firstGetTimestamps = true;
    lastSample = 0;

    set(handles.labelText, 'String', 'Started, press next to continue');

    labelsDataIndex = 0;
    dataToSaveForHistAndRaster = cell(propertiesFile.numOfElec, (propertiesFile.numOfLabelTypes * propertiesFile.numOfTrials));
    numOfTrialsPerLabel = zeros(1,propertiesFile.numOfLabelTypes);
    
    %%
    %while slow and fast figures are open
    while(ishandle(handles.figure1) && getappdata(handles.figure1, 'closeFlagOn') == false && getappdata(handles.figure1, 'stopButtonPressed') == false)
        if(bCollect)
            et_col = toc(t_col0); %elapsed time of collection
            if(et_col >= collect_time)
                
                if getappdata(handles.figure1, 'useCBMEX') == true
                    [neuronTimeStamps, tempDataToSave] = getAllTimestamps(neuronTimeStamps, index); %read some data - the data should retern in cyclic arrays
                    dataToSave = [dataToSave; tempDataToSave];

                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', GetSecs); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end
                    elecToPresent = getElecToPresentFastUpdate_tmp(); %ask which neurons to present in fast update
                    
                else
                    [neuronTimeStamps, index, lastSample, tempDataToSave] = getAllTimestampsSim(et_col, neuronTimeStamps, index, lastSample); %TODO: delete this
                    dataToSave = [dataToSave; tempDataToSave];

                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', 0); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end
%                     elecToPresent = getElecToPresentFastUpdate(get(handles.listboxFastPlot1,'Value'), length(listBox1), get(handles.listboxFastPlot2,'Value'), length(listBox2), get(handles.listboxFastPlot3,'Value'), length(listBox3), get(handles.listboxFastPlot4,'Value'), length(listBox4)); %ask which neurons to present in fast update
                    elecToPresent = getappdata(handles.figure1, 'elecToPresent');
                end
                
                %if the gui is open
                if(ishandle(handles.figure1))
                    % update fast
                    nGraphs = size(elecToPresent, 2); %number of electrodes to present
%                     listOfFastHandles = findobj('Type', 'Axes');
%                     listOfFastHandles = flip(listOfFastHandles);
                    nBins = propertiesFile.numOfBins;  
                    data = neuronTimeStamps(:, elecToPresent);
                    if(fastUpdateFlag)
                        [n,xout] = hist(data,nBins);
                        for jj = 1:nGraphs
                            currFig = findobj('Tag',['fastPlot',num2str(jj)]);
                            format = 'n(:,%d)';
                            barParam = sprintf(format, jj);
                            bar(currFig,xout,n(:,jj),'YDataSource',barParam, 'XDataSource', 'xout');
                            if nGraphs <= 16
                                xlabel(currFig, 'time bins (sec) ', 'FontSize', min([MAX_LEGENT_FONT_SIZE,round((1/nGraphs)*80)]));
                                ylabel(currFig, 'count ', 'FontSize', min([MAX_LEGENT_FONT_SIZE,round((1/nGraphs)*80)]));
                            end
                            ylim(currFig, [0 20]);
                        end
                        fastUpdateFlag = 0;
                    
                    else
                        %turn on datalinking
                        if ishandle(handles.figure1)
                            linkdata(handles.figure1, 'on');
                            [n,xout] = hist(data,nBins);
                            refreshdata(handles.figure1,'caller');
                            collect_time = et_col + propertiesFile.collectTime;
                        else
                            linkdata off
                        end     
                    end
                end
            end
        end  
        myOffset = getappdata(handles.figure1,'offsetFirstGetTimestamps');
        if propertiesFile.connectToParadigm == false
            newLabelAndBipTimeMatrix = {'a', 0.001;
                                        'e', 0.002;
                                        'u', 0.003;
                                        'o', 0.04;
                                        'i', 0.05}; %TODO::call Guy's func instead:
            %newLabelAndBipTimeMatrix = callGuy'sFunc();
            %if newLabelAndBipTimeMatrix == 0
            %    continue;
            %end
        else
            newLabelAndBipTimeMatrix = getLogs();
            if newLabelAndBipTimeMatrix == 0
                continue;
            end
        end
        labelsData(labelsDataIndex+1:labelsDataIndex+length(newLabelAndBipTimeMatrix(:,1)), 1:length(newLabelAndBipTimeMatrix(1,:))) = newLabelAndBipTimeMatrix;
        labelsDataIndex = length(labelsData(:, 1));
        
        newTrialsPerLabel = zeros(1, propertiesFile.numOfLabelTypes);
        for ii = 1:size(newLabelAndBipTimeMatrix,1)
            letterOfCurrLabel = newLabelAndBipTimeMatrix{ii,1};
            currentBipTime = (newLabelAndBipTimeMatrix{ii,2}+stamIndex) - myOffset;
            switch (letterOfCurrLabel)
                case 'a'
                    currentLabel = 1;
                case 'e'
                    currentLabel = 2;
                case 'i'
                    currentLabel = 3;
                case 'o'
                    currentLabel = 4;
                case 'u'
                    currentLabel = 5;
            end
            numOfTrialsPerLabel(currentLabel) = numOfTrialsPerLabel(currentLabel) + 1;
            newTrialsPerLabel(currentLabel) = newTrialsPerLabel(currentLabel) + 1;
            
            %save relevant timestamps from new trials
            for ee = 1:propertiesFile.numOfElec % 4 for now
%                 currentElecTimestampsVector = dataToSave(:,ee);
%                 relevantTimestamps = dataToSave((dataToSave(:,ee) >= (currentBipTime-propertiesFile.preBipTime) & (dataToSave(:,ee) <= (currentBipTime+propertiesFile.postBipTime))),ee) - currentBipTime; %normalized for histogram x axis
%                 relevantTimestamps = currentElecTimestampsVector(currentElecTimestampsVector>(currentBipTime-1) & currentElecTimestampsVector<(currentBipTime+1));
%                 relevantTimestamps = relevantTimestamps - currentBipTime; %normalized for histogram x axis
%                 if min(relevantTimestamps) < minVal
%                     minVal = min(relevantTimestamps);
%                 end
%                 if max(relevantTimestamps) > maxVal
%                     maxVal = max(relevantTimestamps);
%                 end
                dataToSaveForHistAndRaster{ee,(currentLabel-1)*propertiesFile.numOfTrials + numOfTrialsPerLabel(currentLabel)} = dataToSave((dataToSave(:,ee) >= (currentBipTime-propertiesFile.preBipTime) & (dataToSave(:,ee) <= (currentBipTime+propertiesFile.postBipTime))),ee) - currentBipTime; %normalized for histogram x axis
            end
        end
        stamIndex = stamIndex + randn(1);
        if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
            %slowUpdateGuiFig = slowUpdateGui;
            slowUpdateGuiFig = slowUpdateGui_v3;
            slowUpdateGuiFig.UserData.closeFlag = false;
            setappdata(handles.figure1, 'slowUpdateGuiFig',slowUpdateGuiFig);
            firstUpdate = false;
            slowUpdateFlag = true;
        end
        if ~firstUpdate && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig')) && slowUpdateGuiFig.UserData.closeFlag == false
            slowGuiObject = getappdata(handles.figure1, 'slowUpdateGuiFig');
            slowUpdateGuiFig.UserData.preBipTime = propertiesFile.preBipTime;
            slowUpdateGuiFig.UserData.postBipTime = propertiesFile.postBipTime;
            slowUpdateGuiFig.UserData.slowUpdateFlag = slowUpdateFlag;
            slowUpdateGuiFig.UserData.newTrialsPerLabel = newTrialsPerLabel;
            slowUpdateGuiFig.UserData.numOfTrialsPerLabel = numOfTrialsPerLabel;
            slowUpdateGuiFig.UserData.dataToSaveForHistAndRaster = dataToSaveForHistAndRaster;
            createPlotsFunc = findall(slowGuiObject,'Tag', 'createPlots');
            createPlotsFunc.Callback(createPlotsFunc, eventdata);
%             createHistAndRasters(-propertiesFile.preBipTime, propertiesFile.postBipTime, slowUpdateFlag, newTrialsPerLabel, numOfTrialsPerLabel, dataToSaveForHistAndRaster);
        end
        % If slowUpdateGui is close setup all slow variables and delete the Gui fig
        if getappdata(handles.figure1, 'slowUpdateFlag') == true && ishandle(slowUpdateGuiFig) && slowUpdateGuiFig.UserData.closeFlag == true
            %linkdata off;
            slowUpdateFlag = true;
            firstUpdate = true;
            setappdata(handles.figure1, 'slowUpdateFlag', false);
            delete(slowUpdateGuiFig);
        end
    end
    
    %% stoping the recording and saving the data
    if getappdata(handles.figure1, 'useCBMEX') == true 
        cbmex('close');
    end
    
    %TODO::save labelsData as well
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
     
     % close sockets
     if cfg.useParadigm
         CloseSockets();
     end
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
    
    if getappdata(handles.figure1, 'useCBMEX') == true
        stopRec();
    end
    
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
