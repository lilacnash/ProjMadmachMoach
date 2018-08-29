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
        setappdata(handles.figure1,'slowUpdateFlag',false);
    else
        errordlg('Please choose the "Start Exp" button before pressing the "Slow Update" option!','Unpermitted Operation');
    end
end


function startExpButton_Callback(hObject, eventdata, handles)
    %%
    %===============PRE-PROCESING===============
    %===========================================

    % propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
    
    MAX_LEGENT_FONT_SIZE = 12;
    setappdata(handles.figure1, 'startExpButtonPressed', true);
    if getappdata(handles.figure1, 'useCBMEX') == true
        % open neuroport
        cbmex('close');
        [connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
    end
    
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
    disp('startExpButton_Callback');
    connection = 1; %TODO: delete
    instrument = 1; %TODO: delete
    %print connection details
    fprintf('>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);

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
    Syllables = []; % ADD propertiesFile.Syllables;
    allTimestampsMatrix = NaN(propertiesFile.numOfElec,200);
    index = ones(propertiesFile.numOfElec, 1);
    fastUpdateFlag = propertiesFile.fastUpdateFlag;
    slowUpdateFlag = propertiesFile.slowUpdateFlag;
    firstUpdate = true;

    %cyclic arrays for time stamps - one for each neuron
    spikesTimeStamps = cell(numOfElecToPres, 1);
    for ii = 1:numOfElecToPres
        spikesTimeStamps{ii, 1} = NaN(1, propertiesFile.numOfStamps);
    end

    fprintf('>>>>>>>>>>> in RT_Exp:TRAINING started\n');

    %%
    %init clocks
    t_Fdisp0 = tic; %fast display time
    t_Sdisp0 = tic; %slow display time
    t_SYLdisp = tic; %Syllables change time
    t_col0 = tic; %collection time
    bCollect = true; %do we need to collect
    firstGetTimestamps = true;
    time = 0; %TODO: delete this
    neuronTimeStamps = NaN(200, 80);
    lastSample = 0;
    last_col = 0;
    last_updated_slow = 0;

    %%
    syl_index = 0;
    % Syl_fig = figure; %used to move between syllables
    % title('A - close this window to move to the next Syllable')


    set(handles.labelText, 'String', 'Started, press next to continue');

    dataToSaveIndex = 0;
    trialNum = 0;
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
%                     elecToPresent = getElecToPresentFastUpdate(get(handles.listboxFastPlot1,'Value'), length(listBox1), get(handles.listboxFastPlot2,'Value'), length(listBox2), get(handles.listboxFastPlot3,'Value'), length(listBox3), get(handles.listboxFastPlot4,'Value'), length(listBox4)); %ask which neurons to present in fast update
                    elecToPresent = getappdata(handles.figure1, 'elecToPresent');
                end
                %if the gui is open
                if(ishandle(handles.figure1))
                    % update fast
                    nGraphs = size(elecToPresent, 2); %number of electrodes to present
%                     listOfFastHandles = findobj('Type', 'Axes');
%                     listOfFastHandles = flip(listOfFastHandles);
                    nBins = propertiesFile.numOfBins; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram   
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
        if(et_col >= slow_update_time)
            if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
                slowUpdateGuiFig = slowUpdateGui2;
                slowUpdateGuiFig.UserData.closeFlag = false;
                setappdata(handles.figure1, 'slowUpdateGuiFig',slowUpdateGuiFig);
                firstUpdate = false;
                slowUpdateFlag = true;
            end
            if ~firstUpdate && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig')) && slowUpdateGuiFig.UserData.closeFlag == false
                slowGuiObject = getappdata(handles.figure1, 'slowUpdateGuiFig');
                elecToPresent = getElecToPresentSlowUpdate(round(get(findobj('Tag','sliderForSlowUpdate'),'Value')/10,1)*10+1); %ask which neurons to present in fast update
                nGraphs = numberOfHistograms; %number of electrodes to present
                nBins = 10; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram
                data = neuronTimeStamps;
                updateNum = 1;
                if(slowUpdateFlag)
                    [nSlow,xoutSlow] = hist(data,nBins);
                    for jj = 1:10 
                        format = 'nSlow(:,%d)';
                        barParam = sprintf(format, elecToPresent(jj));
                        currFig = findobj('Tag',['slowUpdatePlot',num2str(jj)]);
                        bar(currFig,xoutSlow,nSlow(:,jj),'YDataSource',barParam, 'XDataSource', 'xoutSlow');
                        ttle = sprintf('Online electrode:');
                        title(currFig, ttle);
                        currText = findobj('Tag',['slowPlotLabel',num2str(jj)]);
                        set(currText, 'string', elecToPresent(jj));
    %                     xlabel(currFig, 'time bins (sec) ');
    %                     ylabel(currFig, 'count ');
                        ylim(currFig, [0 20]);
                    end
                    % Creates the raster plots
                    myOffset = getappdata(handles.figure1,'offsetFirstGetTimestamps');
                    labelsAndBipsTime = getappdata(handles.figure1, 'labelsAndBipsTime');
                    labelsAndBipsTimeIndex = getappdata(handles.figure1, 'labelsAndBipsTimeIndex');
                    trialNum = trialNum + 1;
                    for rr = 1:10
                        currFig = findobj('Tag', ['rasterPlot', num2str(rr)]);
                        %hold on;
                        currElecSpikes = data(:, rr);
                        for tt = 1:size(currElecSpikes,1)
                            %don't plot (break) if timestamp value is after END_OF_LABEL (trial finished)
                            %check that labelsAndBipsTime(labelsAndBipsTimeIndex-2, 1) == propertiesFile.END_OF_LABEL
                            labelsAndBipsTime(labelsAndBipsTimeIndex, 2) = (13.02 + myOffset); %TODO::remove after testing
                            if (currElecSpikes(tt) > (labelsAndBipsTime(labelsAndBipsTimeIndex, 2) - myOffset))
                                break;
                            else
                                hold(currFig, 'on');
                                %plot([currElecSpikes(tt) currElecSpikes(tt)], [trialNum-0.1 trialNum+0.1], 'Color', 'k');
                                plot(currFig, [currElecSpikes(tt) currElecSpikes(tt)], [trialNum-0.1 trialNum+0.1], 'Color', 'k');
                            end
                        end
                        ttle = sprintf('Raster Plot: %d', rr);
                        title(currFig, ttle);
                        %ylim([0 propertiesFile.numOfRasterRows+1]); %change to numOfTrials
                        xlim(currFig, [0 3]);
                        ylim(currFig, [0 3]);
                        %xticks([(labelsAndBipsTime(labelsAndBipsTimeIndex-4, 2) - myOffset) (labelsAndBipsTime(labelsAndBipsTimeIndex-3, 2) - myOffset) (labelsAndBipsTime(labelsAndBipsTimeIndex-2, 2) - myOffset)]);
                        %xt = get(gca, 'XTickLabel');
                        %set(gca, 'XTickLabel', xt, 'FontSize', 6);
                        xticks([0 1.5 3]);
                        xticklabels(currFig, {'LABEL_SHOWING', 'BEEP_SOUND', 'END_OF_LABEL'});
                        labelName = getappdata(handles.nextLabel, 'currLabel');
                        labelName = 'a'; %TODO::remove after testing
                        format = '%s trials';
                        txtForY = sprintf(format, labelName);
                        %ylabel(currFig, txtForY);
                        yticks(currFig, [2]);
                        yticklabels(currFig, {txtForY});
                        slowUpdateFlag = 0;
                    end
                end
                %turn on datalinking (in order to update slow_fig)
                if ishandle(handles.figure1) && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig')) && slowUpdateGuiFig.UserData.closeFlag == false
                    linkdata on
                    [nSlow,xoutSlow] = hist(data,nBins);
                    refreshdata(slowGuiObject,'caller');
                    slow_update_time = et_col + 2;
                    updateNum = updateNum + 1;
                else
                    linkdata off
                end
            end
            % If slowUpdateGui is close setup all slow variables and delete the Gui fig
            if getappdata(handles.figure1, 'slowUpdateFlag') == true && slowUpdateGuiFig.UserData.closeFlag == true
                linkdata off;
                slowUpdateFlag = true;
                firstUpdate = true;
                setappdata(handles.figure1, 'slowUpdateFlag', false);
                delete(slowUpdateGuiFig);
                %delete(rasterGuiFig); %TODO:: add
            end
        end
        %%
        %if trial is finished && slowUpdateGui is still open
        if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && slowUpdateGuiFig.UserData.closeFlag == false
            
            %create a raster per electrode
            for rr = 1:12
            end
        end
        %%
        dataToSave(dataToSaveIndex+1:dataToSaveIndex+length(neuronTimeStamps(:,1)),1:length(neuronTimeStamps(1,:))) = neuronTimeStamps;
        dataToSaveIndex = length(dataToSave(:,1));
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
    % time = time + 0.5; %TODO: delete this
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
