function varargout = labelAndBipApp(varargin)
% LABELANDBIPAPP MATLAB code for labelAndBipApp.fig
%      LABELANDBIPAPP, by itself, creates a new LABELANDBIPAPP or raises the existing
%      singleton*.
%
%      H = LABELANDBIPAPP returns the handle to a new LABELANDBIPAPP or the handle to
%      the existing singleton*.
%
%      LABELANDBIPAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELANDBIPAPP.M with the given input arguments.
%
%      LABELANDBIPAPP('Property','Value',...) creates a new LABELANDBIPAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labelAndBipApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labelAndBipApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labelAndBipApp

% Last Modified by GUIDE v2.5 24-Jul-2018 15:53:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labelAndBipApp_OpeningFcn, ...
                   'gui_OutputFcn',  @labelAndBipApp_OutputFcn, ...
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


% --- Executes just before labelAndBipApp is made visible.
function labelAndBipApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labelAndBipApp (see VARARGIN)

% Choose default command line output for labelAndBipApp
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



% UIWAIT makes labelAndBipApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = labelAndBipApp_OutputFcn(hObject, eventdata, handles) 
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

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slowUpdateButton.
function slowUpdateButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slowUpdateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('slowUpdateButton_ButtonDownFcn');
