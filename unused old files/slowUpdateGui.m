function varargout = slowUpdateGui(varargin)
% SLOWUPDATEGUI MATLAB code for slowUpdateGui.fig
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
% Choose default command line output for slowUpdateGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slowUpdateGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slowUpdateGui_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
disp('sliderForSlowUpdate_Callback');
currChoise = round(get(hObject, 'Value')/10,1)*10+1;
set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
for inti = 1:10
    currText = findobj('Tag',['slowPlotLabel',num2str(inti)]);
    set(currText, 'string', ((currChoise-1)*10)+inti);
end

% --- Executes during object creation, after setting all properties.
function sliderForSlowUpdate_CreateFcn(hObject, eventdata, handles)
disp('sliderForSlowUpdate_CreateFcn');
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 9, 'Min', 0);



function slowPlotsSliderResultLabel_Callback(hObject, eventdata, handles)
disp('slowPlotsSliderResultLabel_Callback');


% --- Executes during object creation, after setting all properties.
function slowPlotsSliderResultLabel_CreateFcn(hObject, eventdata, handles)
disp('slowPlotsSliderResultLabel_CreateFcn');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '1');


% --- Executes on button press in closeButtonSlow.
function closeButtonSlow_Callback(hObject, eventdata, handles)
disp('closeButtonSlow_Callback');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
disp('figure1_CloseRequestFcn');
handles.figure1.UserData.closeFlag = true;
