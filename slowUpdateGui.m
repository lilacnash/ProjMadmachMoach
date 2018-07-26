function varargout = slowUpdateGui(varargin)
% SLOWUPDATEGUI MATLAB code for slowUpdateGui.fig
%      SLOWUPDATEGUI, by itself, creates a new SLOWUPDATEGUI or raises the existing
%      singleton*.
%
%      H = SLOWUPDATEGUI returns the handle to a new SLOWUPDATEGUI or the handle to
%      the existing singleton*.
%
%      SLOWUPDATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLOWUPDATEGUI.M with the given input arguments.
%
%      SLOWUPDATEGUI('Property','Value',...) creates a new SLOWUPDATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slowUpdateGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slowUpdateGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slowUpdateGui

% Last Modified by GUIDE v2.5 26-Jul-2018 12:36:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slowUpdateGui_OpeningFcn, ...
                   'gui_OutputFcn',  @slowUpdateGui_OutputFcn, ...
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


% --- Executes just before slowUpdateGui is made visible.
function slowUpdateGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slowUpdateGui (see VARARGIN)

% Choose default command line output for slowUpdateGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slowUpdateGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slowUpdateGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to sliderForSlowUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('sliderForSlowUpdate_Callback');
currChoise = round(get(hObject, 'Value')/10,1)*10+1;
set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
for inti = 1:10
    currText = findobj('Tag',['slowPlotLabel',num2str(inti)]);
    set(currText, 'string', ((currChoise-1)*10)+inti);
end

% --- Executes during object creation, after setting all properties.
function sliderForSlowUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderForSlowUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
disp('sliderForSlowUpdate_CreateFcn');
set(hObject, 'Max', 9, 'Min', 0);



function slowPlotsSliderResultLabel_Callback(hObject, eventdata, handles)
% hObject    handle to slowPlotsSliderResultLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slowPlotsSliderResultLabel as text
%        str2double(get(hObject,'String')) returns contents of slowPlotsSliderResultLabel as a double


% --- Executes during object creation, after setting all properties.
function slowPlotsSliderResultLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slowPlotsSliderResultLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '1');
