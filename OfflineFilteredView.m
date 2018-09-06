function varargout = OfflineFilteredView(varargin)
    % OFFLINEFILTEREDVIEW MATLAB code for OfflineFilteredView.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @OfflineFilteredView_OpeningFcn, ...
                       'gui_OutputFcn',  @OfflineFilteredView_OutputFcn, ...
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


% --- Executes just before OfflineFilteredView is made visible.
function OfflineFilteredView_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for OfflineFilteredView
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes OfflineFilteredView wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % Global Variables
    UserData = get(hObject, 'UserData');
    selected = UserData.numOfElecs;
    setappdata(hObject, 'selected', selected);
    setappdata(hObject, 'histograms', []);
    setappdata(hObject, 'rasters', []);
    neuronMap = getappdata(findall(0,'Name', 'RealTimeSpikes'), 'neuronMap');
    setappdata(hObject, 'neuronMap', neuronMap);

    for inti = 1:min(length(selected), propertiesFile.numOfElectrodesPerPage)
        set(handles.(['elec',num2str(inti),'Label']), 'string', ['Elec: ',num2str(selected(inti)),'-',neuronMap{selected(inti),2}]);
        currPage(inti) = selected(inti);
    end
    if length(selected) < propertiesFile.numOfElectrodesPerPage
        makeUnrelevantPlotUnvisible(length(selected), currPage, hObject, handles);
    else
        setappdata(hObject, 'currPageElecs', currPage);
    end
    numOfFilteredElec = length(selected);
    set(handles.sliderForSlowUpdate, 'Max', ceil(numOfFilteredElec/propertiesFile.numOfElectrodesPerPage), 'Min', 0);
    set(handles.sliderForSlowUpdate, 'SliderStep', [1/get(handles.sliderForSlowUpdate, 'Max'), 1/get(handles.sliderForSlowUpdate, 'Max')*5])
    createPlotsFunc = findall(hObject,'Tag', 'createPlots');
    createPlotsFunc.Callback(createPlotsFunc, eventdata);
end

% --- Outputs from this function are returned to the command line.
function varargout = OfflineFilteredView_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_Callback');
    currChoise = get(hObject, 'Value')+1;
    selected = getappdata(hObject.Parent, 'selected');
    neuronMap = getappdata(hObject.Parent, 'neuronMap');
    if currChoise > ceil(length(selected)/propertiesFile.numOfElectrodesPerPage)
        currChoise = ceil(length(selected)/propertiesFile.numOfElectrodesPerPage);
    end
    set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
    currGui = hObject.Parent;
    for inti = 1:min((length(selected)-((currChoise-1)*propertiesFile.numOfElectrodesPerPage)),propertiesFile.numOfElectrodesPerPage)
        currText = findobj('Tag',['elec',num2str(inti),'Label']);
        newElecNum = selected(((currChoise-1)*4)+inti);
        set(currText, 'string', ['Elec: ',num2str(newElecNum),'-',neuronMap{selected(inti),2}]);
        currPage(inti) = newElecNum;
    end
    if inti<propertiesFile.numOfElectrodesPerPage
        makeUnrelevantPlotUnvisible(inti, currPage, hObject.Parent, handles);
    else
        setappdata(currGui, 'currPageElecs', currPage);
    end  
    currUpdateButton = findall(hObject.Parent, 'Tag', 'updateButton');
    currUpdateButton.Callback(currUpdateButton, eventdata);
end

% --- Executes during object creation, after setting all properties.
function sliderForSlowUpdate_CreateFcn(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_CreateFcn');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


function slowPlotsSliderResultLabel_Callback(hObject, eventdata, handles)
    disp('slowPlotsSliderResultLabel_Callback');
end

% --- Executes during object creation, after setting all properties.
function slowPlotsSliderResultLabel_CreateFcn(hObject, eventdata, handles)
    disp('slowPlotsSliderResultLabel_CreateFcn');
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', '1');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    disp('figure1_CloseRequestFcn');
    hObject.UserData.open = false;
    delete(hObject);
end

% --- Executes on button press in viewSelectedButton.
function viewSelectedButton_Callback(hObject, eventdata, handles)
    disp('viewSelectedButton_Callback');
    elec = (getappdata(hObject.Parent, 'selected'));
    find(elec == 1)
end


% --- Executes on button press in createPlots.
function createPlots_Callback(hObject, eventdata, handles)
    % hObject    handle to createPlots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    %Plots the histograms and rasters for the relevant view
    parameters = hObject.Parent.UserData;
    histograms = getappdata(hObject.Parent, 'histograms');
    rasters = getappdata(hObject.Parent, 'rasters');
    firstCreationFlag = false;
    if isempty(histograms) 
        for electrodeIndex = 1:propertiesFile.numOfElectrodesPerPage
            for labelsIndex = 1:propertiesFile.numOfLabelTypes
                histograms{electrodeIndex, labelsIndex} = findall(hObject.Parent, 'Tag',['slowUpdatePlot',num2str(electrodeIndex),'_',num2str(labelsIndex)]);
                rasters{electrodeIndex, labelsIndex} = findall(hObject.Parent, 'Tag', ['rasterPlot',num2str(electrodeIndex),'_',num2str(labelsIndex)]);
            end
        end
        firstCreationFlag = true;
        setappdata(hObject.Parent, 'histograms', histograms);
        setappdata(hObject.Parent, 'rasters', rasters);
    end
    Priority(2);
    createHistAndRasters(-parameters.preBipTime, parameters.postBipTime, parameters.slowUpdateFlag, parameters.numOfTrialsPerLabel, parameters.dataToSaveForHistAndRaster, histograms, hObject.Parent, rasters, firstCreationFlag);
end


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
    bigFather = findall(0,'Name', 'RealTimeSpikes');
    if ~isempty(bigFather)
        bigFather.UserData.update = true;
    end
end
