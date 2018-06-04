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

% Last Modified by GUIDE v2.5 04-Jun-2018 22:09:55

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
load('labelsList.mat')
% set up data
setappdata(handles.nextLabel,'labelsList',labelsList);
setappdata(handles.nextLabel,'labelsIndex',1);

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
labelsList = getappdata(handles.nextLabel,'labelsList');
labelsIndex = getappdata(handles.nextLabel,'labelsIndex');
if labelsIndex <= length(labelsList)
    set(handles.labelText, 'String', labelsList(labelsIndex));
    setappdata(handles.nextLabel,'labelsIndex',labelsIndex+1);
end


% --- Executes on button press in pushbutton2.
function startRecording_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
