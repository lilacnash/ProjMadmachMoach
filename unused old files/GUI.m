function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 15-Mar-2018 19:37:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
Electrodes.numOfBins = 10;
Electrodes.numOfElec = 10; 
Electrodes.updateTime = 5;
Electrodes.elecArray = cell(Electrodes.numOfElec, 1);
Electrodes.n = cell(Electrodes.numOfElec,1); %creates a cell array of the n parameter for each electrodes
Electrodes.xout = cell(Electrodes.numOfElec,1); %creates a cell array of the xout parameter for each electrodes

%init cell array to read data in from buffer -> input for histograms
numOfStamps = 10; %number of time stamps to save from electrodes 
spikesTimeStamps = cell(Electrodes.numOfElec, numOfStamps);

%create cyclic time stemps vectors for each electrode
index = ones(Electrodes.numOfElec, 1);

%create array of histograms - one for each active electrod.
% for ii = 1:Electrodes.numOfElec
%    
%     Electrodes.elecArray{ii, 1} = figure;
%     histogram(spikesTimeStamps{ii, 1}, Electrodes.numOfBins);
%     xlabel('Time', 'FontSize', 12);
%     ylabel('number of spikes', 'FontSize', 12);
%     title('spikes per 100 ms', 'FontSize', 18);
% end

%%
% set up data
setappdata(handles.Random,'Electrodes',Electrodes);
setappdata(handles.Random,'index',index);
setappdata(handles.Random,'spikesTimeStamps',spikesTimeStamps);
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Random.
function Random_Callback(hObject, eventdata, handles)
% hObject    handle to Random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Electrodes = getappdata(handles.Random,'Electrodes');
    index = getappdata(handles.Random,'index');
    spikesTimeStamps = getappdata(handles.Random,'spikesTimeStamps');
    %getting the random input
    while true
        pause(Electrodes.updateTime);%TODO: change to other thread?
        for jj = 1:Electrodes.numOfElec
            tempVectorFromElectrode = rand(10,1)*1000;
            for indexFromTempVector = 1:length(tempVectorFromElectrode)
                spikesTimeStamps{jj,index(jj)} = tempVectorFromElectrode(indexFromTempVector);
                if index(jj) == size(spikesTimeStamps,2)
                    index(jj) = 1;
                else
                    index(jj) = index(jj)+1;
                end
            end
        end
        
        %creating cell from struct
        cellOfStruct = struct2cell(Electrodes);
        handlesCell = struct2cell(handles);
        cellOfStructNOB = cellOfStruct{1};
        cellOfStructNOE = cellOfStruct{2};
        cellOfStructUT = cellOfStruct{3};
        cellOfStructEA = cellOfStruct{4};
        cellOfStructN = cellOfStruct{5};
        cellOfStructX = cellOfStruct{6};

        %multi threads to the hist section
        for indexForHist = 1:cellOfStructNOE
            myIndex = strcmp(fieldnames(handles), ['axes',num2str(indexForHist)]); % retrieving the name of the axes
            axes(handlesCell{myIndex});
            myData = cell2mat(spikesTimeStamps(indexForHist, :)); %turning the cell to matrix
            [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(myData, cellOfStructNOB); %takes n and xout parameters for each electrode
            MyXsource = cellOfStructX{indexForHist};
            MyYsource = cellOfStructN{indexForHist};
            cla; %clear the axes to improve performance
            drawnow;
            bar(MyXsource,MyYsource, 'YDataSource','myData');
        end
    end

% --- Executes on button press in pushbutton2.
function Neuroport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TCPIP.
function TCPIP_Callback(hObject, eventdata, handles)
% hObject    handle to TCPIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
