%%
global cfg;

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
setappdata(handles.nextLabel, 'labelsList', labelsList);
setappdata(handles.nextLabel, 'labelsIndex', 1);
%TODO::add next line
%setappdata(handles.nextLabel, 'trialIndex', 1);
setappdata(handles.nextLabel, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.nextLabel, 'labelsAndBipsTimeIndex', 1);
setappdata(handles.startRecording, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.startRecording, 'labelsAndBipsTimeIndex', 1);
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
    labelsList = getappdata(handles.nextLabel, 'labelsList');
    labelsIndex = getappdata(handles.nextLabel, 'labelsIndex');
    %TODO:: add next line
    %trialIndex = getappdata(handles.nextLabel, 'trialIndex');
    labelsAndBipsTime = getappdata(handles.nextLabel, 'labelsAndBipsTime');
    labelsAndBipsTimeIndex = getappdata(handles.nextLabel, 'labelsAndBipsTimeIndex');
    if labelsIndex == 1
        set(handles.labelText, 'String', labelsList(labelsIndex));
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.LABEL_SHOWING, GetSecs];
        setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.nextLabel,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
        setappdata(handles.startRecording,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.startRecording,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
        setappdata(handles.nextLabel,'labelsIndex',labelsIndex+1);
    elseif labelsIndex <= length(labelsList)
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.END_OF_LABEL, GetSecs];    
        set(handles.labelText, 'String', labelsList(labelsIndex));
        labelsAndBipsTime(labelsAndBipsTimeIndex+1, 1:2) = [propertiesFile.LABEL_SHOWING, GetSecs];
        setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.nextLabel,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+2);
        setappdata(handles.startRecording,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.startRecording,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+2);
        setappdata(handles.nextLabel,'labelsIndex',labelsIndex+1);
        %TODO:: add next line
        %setappdata(handles.nextLabel,'trialIndex',trialIndex+3); %TODO:1,3,1,3(no2=bip) in labelAndBipsTime
    else
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.END_OF_LABEL, GetSecs];    
        setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
        %TODO:: add next line
        %setappdata(handles.nextLabel,'trialIndex',trialIndex+3);
        save('labelsAndBipsTime.mat', 'labelsAndBipsTime');
    end
end


function startRecording_Callback(hObject, eventdata, handles)
    disp('startRecording_Callback');
    labelsAndBipsTime = getappdata(handles.startRecording, 'labelsAndBipsTime');
    labelsAndBipsTimeIndex = getappdata(handles.startRecording, 'labelsAndBipsTimeIndex');
    if labelsAndBipsTimeIndex ~= 1 && labelsAndBipsTime(labelsAndBipsTimeIndex-1,1) == propertiesFile.LABEL_SHOWING
        labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.BEEP_SOUND, GetSecs];
        Beeper(propertiesFile.beepFrequency, propertiesFile.beepVolume, propertiesFile.beepDurationSec);
        setappdata(handles.startRecording,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.startRecording,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
        setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
        setappdata(handles.nextLabel,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);    
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
    fprintf(cfg.logfile, '>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);

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

    fprintf(cfg.logfile, '>>>>>>>>>>> in RT_Exp:TRAINING started\n');

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
        if(et_col >= slow_update_time)
            if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
                slowUpdateGuiFig = slowUpdateGui;
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
                        % Creates the raster plot
    %                     currFig = findobj('Tag',['rasterPlot',num2str(jj)]);
                    slowUpdateFlag = 0;
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
            end
        end
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
