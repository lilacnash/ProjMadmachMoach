function varargout = GUIgood(varargin)
% GUIGOOD MATLAB code for GUIgood.fig
%      GUIGOOD, by itself, creates a new GUIGOOD or raises the existing
%      singleton*.
%
%      H = GUIGOOD returns the handle to a new GUIGOOD or the handle to
%      the existing singleton*.
%
%      GUIGOOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIGOOD.M with the given input arguments.
%
%      GUIGOOD('Property','Value',...) creates a new GUIGOOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIgood_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIgood_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIgood

% Last Modified by GUIDE v2.5 24-Feb-2018 15:14:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIgood_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIgood_OutputFcn, ...
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

% --- Executes just before GUIgood is made visible.
function GUIgood_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIgood (see VARARGIN)

% Choose default command line output for GUIgood
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%
%initialize system

%inputSystem = 1; 
Electrodes.numOfBins = 10;
Electrodes.numOfElec = 4; 
Electrodes.updateTime = 5;
Electrodes.elecArray = cell(Electrodes.numOfElec, 1);
Electrodes.n = cell(Electrodes.numOfElec,1); %creates a cell array of the n parameter for each electrodes
Electrodes.xout = cell(Electrodes.numOfElec,1); %creates a cell array of the xout parameter for each electrodes

%init cell array to read data in from buffer -> input for histograms
spikesTimeStamps = cell(Electrodes.numOfElec, 1);
numOfStamps = 10; %number of time stamps to save from electrodes 
for ii = 1:Electrodes.numOfElec
    spikesTimeStamps{ii, 1} = NaN(1, numOfStamps);
end 

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
setappdata(handles.pushbutton1,'Electrodes',Electrodes);
setappdata(handles.pushbutton1,'index',index);
setappdata(handles.pushbutton1,'spikesTimeStamps',spikesTimeStamps);
setappdata(handles.pushbutton2,'Electrodes',Electrodes);
setappdata(handles.pushbutton2,'index',index);
setappdata(handles.pushbutton2,'spikesTimeStamps',spikesTimeStamps);
setappdata(handles.pushbutton3,'Electrodes',Electrodes);
setappdata(handles.pushbutton3,'index',index);
setappdata(handles.pushbutton3,'spikesTimeStamps',spikesTimeStamps);
% UIWAIT makes GUIgood wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIgood_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [Electrodes, index, spikesTimeStamps] = getappdata(handles.pushbutton1,'Electrodes','index','spikesTimeStamps');
    recordingsFileName = 'D:\Neuroport\BMI\test3'; %TODO: where to record to
    comments = 'third'; %TODO what is this for?
    interface = 2; %TODO: what value should it get?
    [connection, instrument] = ConnectToNeuroport(interface, recordingsFileName, comments);
    %TODO: check if connection and instrument are as expected

    [activeState, configVectorOut] = cbmex('trialconfig', 1, 'double');
    
    for ii = 1:5 %TODO: change to true while(TRUE)
        
        pause(Electrodes.updateTime);%TODO: change to other thread?
        eventData = cbmex('trialdata', 1);
        
        for jj = 1:Electrodes.numOfElec 
           for indexFromTempVector = 1:length(eventData{jj, 1})
                
                index(jj) = mod(index(jj)-1,numOfStamps)+1;
                spikesTimeStamps{jj,1}(index(jj)) = eventData{jj, 1}(indexFromTempVector); 
                index(jj) = index(jj)+1;
                    
           end
        end
        
        %creating cell from struct
        cellOfStruct = struct2cell(Electrodes);
        cellOfStructNOB = cellOfStruct{1};
        cellOfStructNOE = cellOfStruct{2};
        cellOfStructUT = cellOfStruct{3};
        cellOfStructEA = cellOfStruct{4};
        cellOfStructN = cellOfStruct{5};
        cellOfStructX = cellOfStruct{6};

        %multi threads to the hist section
        parfor indexForHist = 1:Electrodes.numOfElec
            [ElectrodesN{indexForHist},ElectrodesX{indexForHist}] = hist(spikesTimeStamps{indexForHist, 1}, ElectrodesNOB); %takes n and xout parameters for each electrode
            %axes(handles.(['axes',num2str(indexForHist)]));
            bar(handles.(['axes',num2str(indexForHist)]), cellOfStructX{indexForHist},cellOfStructN{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            %bar(cellOfStructX{indexForHist},cellOfStructN{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            refreshdata(handles.(['axes',num2str(indexForHist)]));
%             xlabel('Time', 'FontSize', 12);
%             ylabel('number of spikes', 'FontSize', 12);
%             title('spikes per 100 ms', 'FontSize', 18);
        end
    end





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [Electrodes, index, spikesTimeStamps] = getappdata(handles.pushbutton2,'Electrodes','index','spikesTimeStamps');
    t = tcpip('10.0.0.2', 55000, 'NetworkRole', 'client');
    set(t, 'InputBufferSize', 7688);
    set(t, 'Timeout', 30);
    fopen(t);
    for ii = 1:5 %TODO: change to true while(TRUE)
        pause(Electrodes.updateTime);%TODO: change to other thread?
        for jj = 1:Electrodes.numOfElec
            tempVectorFromElectrode = fread(t , 961, 'double');
            for indexFromTempVector = 1:length(tempVectorFromElectrode)
                index(jj) = mod(index(jj)-1,numOfStamps)+1;
                spikesTimeStamps{jj,1}(index(jj)) = tempVectorFromElectrode(indexFromTempVector); 
                    index(jj) = index(jj)+1;
            end
        end

        %creating cell from struct
        cellOfStruct = struct2cell(Electrodes);
        cellOfStructNOB = cellOfStruct{1};
        cellOfStructNOE = cellOfStruct{2};
        cellOfStructUT = cellOfStruct{3};
        cellOfStructEA = cellOfStruct{4};
        cellOfStructN = cellOfStruct{5};
        cellOfStructX = cellOfStruct{6};

        %multi threads to the hist section
        parfor indexForHist = 1:cellOfStruct{2}
            [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(spikesTimeStamps{indexForHist, 1}, cellOfStructNOB); %takes n and xout parameters for each electrode
            %axes(handles.(['axes',num2str(indexForHist)]));
            bar(handles.(['axes',num2str(indexForHist)]), cellOfStructX{indexForHist},cellOfStructN{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            %bar(cellOfStructX{indexForHist},cellOfStructN{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            refreshdata(handles.(['axes',num2str(indexForHist)]));
%             xlabel('Time', 'FontSize', 12);
%             ylabel('number of spikes', 'FontSize', 12);
%             title('spikes per 100 ms', 'FontSize', 18);
        end
    end

    



% %read from server
% if(inputSystem == 2)
%     t = tcpip('localhost', 30000, 'NetworkRole', 'client');
%     fopen(t);
%     while(data(1) ~= -1) %read from server until server end connection by sending -1
%         pause(Electrodes.updateTime);%TODO: change to other thread?
%         data = read(t,100, 'double'); %reads 100 doubles vector from server
%         figure(Electrodes.elecArray{his, 1})
%         histogram(spikesTimeStamps{his, 1}, Electrodes.numOfBins);
%         xlabel('Time', 'FontSize', 12);
%         ylabel('number of spikes', 'FontSize', 12);
%         title('spikes per 100 ms', 'FontSize', 18);
%     end
% end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Electrodes = getappdata(handles.pushbutton3,'Electrodes');
    index = getappdata(handles.pushbutton3,'index');
    spikesTimeStamps = getappdata(handles.pushbutton3,'spikesTimeStamps');
    %getting the random input
    while true
        pause(Electrodes.updateTime);%TODO: change to other thread?
        for jj = 1:Electrodes.numOfElec
            tempVectorFromElectrode = rand(10,1)*1000;
            for indexFromTempVector = 1:length(tempVectorFromElectrode)
                spikesTimeStamps{jj,2}(index(jj)) = tempVectorFromElectrode(indexFromTempVector);
                if index(jj) == length(spikesTimeStamps{jj,2})
                    index(jj) = 1;
                else
                    index(jj) = index(jj)+1;
                end
            end
        end

        %creating cell from struct
        cellOfStruct = struct2cell(Electrodes);
        cellOfStructNOB = cellOfStruct{1};
        cellOfStructNOE = cellOfStruct{2};
        cellOfStructUT = cellOfStruct{3};
        cellOfStructEA = cellOfStruct{4};
        cellOfStructN = cellOfStruct{5};
        cellOfStructX = cellOfStruct{6};

        %multi threads to the hist section
        for indexForHist = 1:cellOfStructNOE
            [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(spikesTimeStamps{indexForHist, 1}, cellOfStructNOB); %takes n and xout parameters for each electrode
            %axes(handles.(['axes',num2str(indexForHist)]));
            bar(cellOfStructX{indexForHist},cellOfStructN{indexForHist},'YDataSource','Electrodes.n(indexForHist)');
            refreshdata(handles.(['axes',num2str(indexForHist)]));
    %             xlabel('Time', 'FontSize', 12);
    %             ylabel('number of spikes', 'FontSize', 12);
    %             title('spikes per 100 ms', 'FontSize', 18);
        end
    end