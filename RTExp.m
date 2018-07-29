function varargout = RTExp(varargin)
% RTEXP MATLAB code for RTExp.fig
%      RTEXP, by itself, creates a new RTEXP or raises the existing
%      singleton*.
%
%      H = RTEXP returns the handle to a new RTEXP or the handle to
%      the existing singleton*.
%
%      RTEXP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RTEXP.M with the given input arguments.
%
%      RTEXP('Property','Value',...) creates a new RTEXP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RTExp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RTExp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RTExp

% Last Modified by GUIDE v2.5 25-Jul-2018 18:23:19

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


% --- Executes just before RTExp is made visible.
function RTExp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RTExp (see VARARGIN)

% Choose default command line output for RTExp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set up data
load('labelsList.mat')
labelsAndBipsTime = zeros(length(labelsList),2);
setappdata(handles.nextLabel, 'labelsList', labelsList);
setappdata(handles.nextLabel, 'labelsIndex', 1);
setappdata(handles.nextLabel, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.nextLabel, 'labelsAndBipsTimeIndex', 1);
setappdata(handles.startRecording, 'labelsAndBipsTime', labelsAndBipsTime);
setappdata(handles.startRecording, 'labelsAndBipsTimeIndex', 1);
setappdata(handles.figure1,'slowUpdateFlag',false);


% UIWAIT makes RTExp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RTExp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in nextLabel.
function nextLabel_Callback(hObject, eventdata, handles)
% hObject    handle to nextLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('nextLabel_Callback');
labelsList = getappdata(handles.nextLabel, 'labelsList');
labelsIndex = getappdata(handles.nextLabel, 'labelsIndex');
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
else
    labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.END_OF_LABEL, GetSecs];    
    setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
    save('labelsAndBipsTime.mat', 'labelsAndBipsTime');
end


% --- Executes on button press in startRecording.
function startRecording_Callback(hObject, eventdata, handles)
% hObject    handle to startRecording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('startRecording_Callback');
labelsAndBipsTime = getappdata(handles.startRecording, 'labelsAndBipsTime');
labelsAndBipsTimeIndex = getappdata(handles.startRecording, 'labelsAndBipsTimeIndex');
if labelsAndBipsTime(labelsAndBipsTimeIndex-1,1) == propertiesFile.LABEL_SHOWING
    labelsAndBipsTime(labelsAndBipsTimeIndex, 1:2) = [propertiesFile.BEEP_SOUND, GetSecs];
    Beeper(propertiesFile.beepFrequency, propertiesFile.beepVolume, propertiesFile.beepDurationSec);
    setappdata(handles.startRecording,'labelsAndBipsTime',labelsAndBipsTime);
    setappdata(handles.startRecording,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);
    setappdata(handles.nextLabel,'labelsAndBipsTime',labelsAndBipsTime);
    setappdata(handles.nextLabel,'labelsAndBipsTimeIndex',labelsAndBipsTimeIndex+1);    
end

% --- Executes on slider movement.
function fastPlotsSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('fastPlotsSlider1_Callback');

% --- Executes during object creation, after setting all properties.
function fastPlotsSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
disp('fastPlotsSlider1_CreateFcn');

% --- Executes on slider movement.
function fastPlotsSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('fastPlotsSlider2_Callback');

% --- Executes during object creation, after setting all properties.
function fastPlotsSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
disp('fastPlotsSlider2_CreateFcn');

% --- Executes on slider movement.
function fastPlotsSlider4_Callback(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('fastPlotsSlider4_Callback');

% --- Executes during object creation, after setting all properties.
function fastPlotsSlider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
disp('fastPlotsSlider4_CreateFcn');

% --- Executes on slider movement.
function fastPlotsSlider3_Callback(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('fastPlotsSlider3_Callback');

% --- Executes during object creation, after setting all properties.
function fastPlotsSlider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastPlotsSlider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
disp('fastPlotsSlider3_CreateFcn');

% --- Executes on button press in slowUpdateButton.
function slowUpdateButton_Callback(hObject, eventdata, handles)
% hObject    handle to slowUpdateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('slowUpdateButton_Callback');
% slowUpdateGui;
if get(handles.startExpButton, 'Value') == 1
    setappdata(handles.figure1,'slowUpdateFlag',true);
else
    errordlg('Please choose the "Start Exp" button before pressing the "Slow Update" option!','Unpermitted Operation');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slowUpdateButton.
function slowUpdateButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slowUpdateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('slowUpdateButton_ButtonDownFcn');


% --- Executes on button press in startExpButton.
function startExpButton_Callback(hObject, eventdata, handles)
% hObject    handle to startExpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
%===============PRE-PROCESING===============
%===========================================

% propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
%open neuroport
cbmex('close');
[connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
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
collect_time = propertiesFile.collectTime; %propertiesFile.collectTime;
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
% 
% prompt = 'press ENTRR to start training\n';
% input(prompt);
fprintf('>>>>>>>>>>> in RT_Exp:TRAINING started\n');

%%
%init clocks
t_Fdisp0 = tic; %fast display time
t_Sdisp0 = tic; %slow display time
t_SYLdisp = tic; %Syllables change time
t_col0 = tic; %collection time
bCollect = true; %do we need to collect
time = 0; %TODO: delete this
neuronTimeStamps = NaN(200, 80);
lastSample = 0;
last_col = 0;
last_updated_slow = 0;

%%
%init figures
% figure1 = figure; %fast update display

% slow_fig = figure; %slow update display

syl_index = 0;
% Syl_fig = figure; %used to move between syllables
% title('A - close this window to move to the next Syllable')

%%
%set the listboxes with relevant values
[numOfActiveElectrodes, matrix] = getNumOfElecToPresent_Temp(); % change to the real function
[listBox1, listBox2, listBox3, listBox4] = getListBoxes(numOfActiveElectrodes);
set(handles.listboxFastPlot1, 'string', listBox1);
set(handles.listboxFastPlot2, 'string', listBox2);
set(handles.listboxFastPlot3, 'string', listBox3);
set(handles.listboxFastPlot4, 'string', listBox4);

%%
%while slow and fast figures are open
while(ishandle(handles.figure1))
    if(bCollect)
        et_col = toc(t_col0); %elapsed time of collection
        if(et_col >= collect_time)
%             neuronTimeStamps = getAllTimestampsSim(time); %TODO: delete this
            neuronTimeStamps = getAllTimestamps(neuronTimeStamps, index); %read some data - the data should retern in cyclic arrays
%             [neuronTimeStamps, index, lastSample] = getAllTimestampsSim(et_col, neuronTimeStamps, index, lastSample); %TODO: delete this
            elecToPresent = getElecToPresentFastUpdate(get(handles.listboxFastPlot1,'Value'), length(listBox1), get(handles.listboxFastPlot2,'Value'), length(listBox2), get(handles.listboxFastPlot3,'Value'), length(listBox3), get(handles.listboxFastPlot4,'Value'), length(listBox4)); %ask which neurons to present in fast update
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
%                     set(0,'CurrentFigure',handles.fastPlot1); % make hFig thecurrent figure 
                    for jj = 1:nGraphs
%                    figure1 = subplot(nGraphs/2,2,jj);
                        format = 'n(:,%d)';
                        barParam = sprintf(format, jj);
                        bar(listOfFastHandles(jj),xout,n(:,jj),'YDataSource',barParam);
                        title(listOfFastHandles(jj), 'Fast update electrode number:');
                        set(findobj('Tag',['numOfElecForPlot',num2str(jj)]), 'String', elecToPresent(jj));
                        xlabel(listOfFastHandles(jj), 'time bins (sec) ');
                        ylabel(listOfFastHandles(jj), 'count ');
                        ylim(listOfFastHandles(jj), [0 20]);
                    end
                    fastUpdateFlag = 0;
                end
                %turn on datalinking
                if ishandle(handles.figure1)
                    linkdata on
                    [n,xout] = hist(data,nBins);
                    refreshdata(handles.figure1,'caller');
                    collect_time = et_col + 0.5;
                else
                    linkdata off
                end
%                 set(0,'CurrentFigure',handles.fastPlot1); % make hFig thecurrent figure 
                
                %et_disp = toc(t_disp0);  % elapsed time since last display
                %if(et_disp >= display_period)
                %    t_col0 = tic; % collection time
                %    t_disp0 = tic; % restart the period
                %    bCollect = true; % start collection
            end
        end
        et_disp = toc(t_Fdisp0);  % elapsed time since last display    
        %if(et_disp >= display_period)
        %    t_col0 = tic; % collection time
        %    t_disp0 = tic; % restart the period
        %    bCollect = true; % start collection
        %end
    end
    if(et_col >= slow_update_time)
        if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
            slowUpdateGuiFig = slowUpdateGui;
            setappdata(handles.figure1, 'slowUpdateGuiFig',slowUpdateGuiFig);
            firstUpdate = false;
            slowUpdateFlag = true;
        end
        if ~firstUpdate && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig'))
%             round(get(hObject, 'Value')/10,1)*10+1);
            %             slowUpdateFlag = slowUpdate(numberOfHistograms, slow_fig, neuronTimeStamps, slowUpdateFlag); %plot all active histograms and rasterplots 
            slowGuiObject = getappdata(handles.figure1, 'slowUpdateGuiFig');
            elecToPresent = getElecToPresentSlowUpdate(round(get(findobj('Tag','sliderForSlowUpdate'),'Value')/10,1)*10+1); %ask which neurons to present in fast update
            nGraphs = numberOfHistograms; %number of electrodes to present
            nBins = 10; %TODO: change to - propertiesFile.numOfBins; %number of bins for histogram
            data = neuronTimeStamps;
            updateNum = 1;
            if(slowUpdateFlag)
                [nSlow,xoutSlow] = hist(data,nBins);
%               set(0,'CurrentFigure',slow_fig) % make slow_fig thecurrent figure
                for jj = 1:10 
%         slow_fig = scrollsubplot(nGraphs/4, 4, jj);
                    format = 'nSlow(:,%d)';
                    barParam = sprintf(format, elecToPresent(jj));
                    currFig = findobj('Tag',['slowUpdatePlot',num2str(jj)]);
                    bar(currFig,xoutSlow,nSlow(:,jj),'YDataSource',barParam);
                    ttle = sprintf('Online electrode:');
                    title(currFig, ttle);
                    currText = findobj('Tag',['slowPlotLabel',num2str(jj)]);
                    set(currText, 'string', elecToPresent(jj));
%                     xlabel(currFig, 'time bins (sec) ');
%                     ylabel(currFig, 'count ');
                    ylim(currFig, [0 20]);
                end
                    % Creates the raster plot
%                 for jj = 1:10
%                     currFig = findobj('Tag',['rasterPlot',num2str(jj)]);
%                     y = updateNum;
%                     hold on;
%                     numOfSpikes = data(:, jj);
%                     for tt = 1:size(numOfSpikes,1)
%                         %format = 'numOfSpikes(%d)';
%                         %format = 'data(:, %d)(%d)'; %%changee
%                         %x = sprintf(format, jj, tt);
%                         format = 'numOfSpikes(:,%d)';
%                         sourceX = sprintf(format, tt);
%                         x = numOfSpikes(tt);
%                         h = plot(currFig, [x x], [y-0.1 y+0.1], 'Color', 'k');
%                         %set(h, 'XDataSource', 'numOfSpikes(tt)')
%                         set(h, 'XDataSource', 'x')
%                         set(h, 'YDataSource', 'y')
%                     end
%                     ylim(currFig, [0 propertiesFile.numOfRasterRows+1]);
%                     xlabel(currFig, 'time bins (sec) ');
%                     ylabel(currFig, '0.5sec-long time periods ');
%                 end
                slowUpdateFlag = 0;
            end
%             updateNum = updateNum + 1;
            %turn on datalinking (in order to update slow_fig)
            if ishandle(handles.figure1) && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig'))
                linkdata on
% %                 timerData.slow_update_time = slow_update_time;
% %                 timerData.et_col = et_col;
% %                 timerData.handles = handles;
%                 timerData.data = data;
%                 timerData.nBins = nBins;
%                 timer.slowGuiObject = slowGuiObject;
% %                 timerData.firstUpdate = firstUpdate;
% %                 timerData.slowUpdateFlag = slowUpdateFlag;
%                 timerData.neuronTimeStamps = neuronTimeStamps;
%                 timerObj = timer('TimerFcn', @slowUpdateForGui_tmp, 'ExecutionMode','fixedRate', 'Period',1, 'UserData', timerData);
                 [nSlow,xoutSlow] = hist(data,nBins);
                 refreshdata(slowGuiObject,'caller');
%                 n = timerObj.n;
%                 xout = timerObj.xout;
                slow_update_time = et_col + 2;
                updateNum = updateNum + 1;
            else
                linkdata off
            end
            %update raster plot for relevant slow_fig
            % linkdata on
            % set(0,'CurrentFigure',raster_fig); % make raster_fig the current figure
            % refreshdata(raster_fig,'caller'); 
            %et_disp = toc(t_disp0);  % elapsed time since last display
            %if(et_disp >= display_period)
            %    t_col0 = tic; % collection time
            %    t_disp0 = tic; % restart the period
            %    bCollect = true; % start collection
        end
    end
end

linkdata off;
% time = time + 0.5; %TODO: delete this


% --- Executes on selection change in listboxFastPlot1.
function listboxFastPlot1_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFastPlot1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFastPlot1
listElecToPresent = getElecToPresentFastUpdate(get(handles.listboxFastPlot1,'Value'), length(get(handles.listboxFastPlot1, 'string')), ...
    get(handles.listboxFastPlot2,'Value'), length(get(handles.listboxFastPlot2, 'string')), ...
    get(handles.listboxFastPlot3,'Value'), length(get(handles.listboxFastPlot3,'string')), ...
    get(handles.listboxFastPlot4,'Value'), length(get(handles.listboxFastPlot4,'string')));
set(handles.numOfElecForPlot1, 'String', listElecToPresent(1));

% --- Executes during object creation, after setting all properties.
function listboxFastPlot1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
disp('listboxFastPlot1_CreateFcn');
indexesList = {'1'};
set(hObject , 'string' , indexesList);

% --- Executes on selection change in listboxFastPlot2.
function listboxFastPlot2_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFastPlot2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFastPlot2
listElecToPresent = getElecToPresent(get(handles.listboxFastPlot1,'Value'), length(get(handles.listboxFastPlot1, 'string')), ...
    get(handles.listboxFastPlot2,'Value'), length(get(handles.listboxFastPlot2, 'string')), ...
    get(handles.listboxFastPlot3,'Value'), length(get(handles.listboxFastPlot3,'string')), ...
    get(handles.listboxFastPlot4,'Value'), length(get(handles.listboxFastPlot4,'string')));
set(handles.numOfElecForPlot2, 'String', listElecToPresent(2));

% --- Executes during object creation, after setting all properties.
function listboxFastPlot2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
disp('listboxFastPlot2_CreateFcn');
indexesList = {'2'};
set(hObject , 'string' ,indexesList);

% --- Executes on selection change in listboxFastPlot3.
function listboxFastPlot3_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFastPlot3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFastPlot3
listElecToPresent = getElecToPresent(get(handles.listboxFastPlot1,'Value'), length(get(handles.listboxFastPlot1, 'string')), ...
    get(handles.listboxFastPlot2,'Value'), length(get(handles.listboxFastPlot2, 'string')), ...
    get(handles.listboxFastPlot3,'Value'), length(get(handles.listboxFastPlot3,'string')), ...
    get(handles.listboxFastPlot4,'Value'), length(get(handles.listboxFastPlot4,'string')));
set(handles.numOfElecForPlot3, 'String', listElecToPresent(3));

% --- Executes during object creation, after setting all properties.
function listboxFastPlot3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
disp('listboxFastPlot3_CreateFcn');
indexesList = {'3'};
set(hObject , 'string' ,indexesList);

% --- Executes on selection change in listboxFastPlot4.
function listboxFastPlot4_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFastPlot4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFastPlot4
% stainingList = getappdata(handles.imagesListBox, 'stainingList');
% currStaining = stainingList(selectedIndex);
% setappdata(handles.imagesListBox, 'currStaining', currStaining);
% currSection = getappdata(handles.imagesListBox, 'currSection');
% currMag = getappdata(handles.imagesListBox, 'currMag');
% currDate = getappdata(handles.imagesListBox, 'currDate');
% currRatNum = getappdata(handles.imagesListBox, 'currRatNum');
% names = getImageList(images, currSection, currRatNum, currDate, currMag, currStaining);
% set(handles.imagesListBox , 'string' ,names);
% set(handles.numOfElecForPlot4
disp('stam');
listElecToPresent = getElecToPresent(get(handles.listboxFastPlot1,'Value'), length(get(handles.listboxFastPlot1, 'string')), ...
    get(handles.listboxFastPlot2,'Value'), length(get(handles.listboxFastPlot2, 'string')), ...
    get(handles.listboxFastPlot3,'Value'), length(get(handles.listboxFastPlot3,'string')), ...
    get(handles.listboxFastPlot4,'Value'), length(get(handles.listboxFastPlot4,'string')));
set(handles.numOfElecForPlot4, 'String', listElecToPresent(4));

% --- Executes during object creation, after setting all properties.
function listboxFastPlot4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFastPlot4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
disp('listboxFastPlot4_CreateFcn');
indexesList = {'4'};
set(hObject , 'string' ,indexesList);
