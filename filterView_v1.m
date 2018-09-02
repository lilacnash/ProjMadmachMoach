function varargout = filterView_v1(varargin)
    % FILTERVIEW_V1 MATLAB code for filterView_v1.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @filterView_v1_OpeningFcn, ...
                       'gui_OutputFcn',  @filterView_v1_OutputFcn, ...
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


% --- Executes just before filterView_v1 is made visible.
function filterView_v1_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for filterView_v1
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes filterView_v1 wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % Global Variables
    UserData = get(hObject, 'UserData');
    selected = UserData.numOfElecs;
    setappdata(hObject, 'selected', selected);
    for inti = 1:length(selected)
        set(handles.(['elec',num2str(inti),'Label']), 'string', ['Elec: ',num2str(selected(inti))]);
        currPage(inti) = selected(inti);
    end
    if length(selected) < propertiesFile.numOfElectrodesPerPage
        for inti = 1:(propertiesFile.numOfElectrodesPerPage-length(selected))
            set(handles.(['elec',num2str(length(selected)+inti),'Label']), 'string','');
            currPage(length(selected)+inti) = 0;
            for indexForLabel = 1:propertiesFile.numOfLabelTypes
                currRaster = findall(hObject, 'Tag', ['rasterPlot',num2str(length(selected)+inti),'_',num2str(indexForLabel)]);
                currHist = findall(hObject, 'Tag', ['slowUpdatePlot',num2str(length(selected)+inti),'_',num2str(indexForLabel)]);
                currRaster.Visible = 'off';
                currHist.Visible = 'off';
            end
        end
    end
    setappdata(hObject, 'currPageElecs', currPage);
    numOfFilteredElec = length(selected);
    set(handles.sliderForSlowUpdate, 'Max', ceil(numOfFilteredElec/propertiesFile.numOfElectrodesPerPage), 'Min', 0);
    set(handles.sliderForSlowUpdate, 'SliderStep', [1/get(handles.sliderForSlowUpdate, 'Max'), 1/get(handles.sliderForSlowUpdate, 'Max')*5])
    setappdata(hObject.Parent, 'histograms', []);
    createPlotsFunc = findall(hObject,'Tag', 'createPlots');
    createPlotsFunc.Callback(createPlotsFunc, eventdata);
end


% --- Outputs from this function are returned to the command line.
function varargout = filterView_v1_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end



% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_Callback');
    currChoise = get(hObject, 'Value')+1;
    selected = getappdata(hObject.Parent, 'selected');
    if currChoise > ceil(length(selected)/propertiesFile.numOfElectrodesPerPage)
        currChoise = ceil(length(selected)/propertiesFile.numOfElectrodesPerPage);
    end
    set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
    currGui = hObject.Parent;
    for inti = 1:min(length(selected),propertiesFile.numOfElectrodesPerPage)
        currText = findobj('Tag',['elec',num2str(inti),'Label']);
        newElecNum = ((currChoise-1)*4)+inti;
        set(currText, 'string', ['Elec: ',num2str(newElecNum)]);
        currPage(inti) = newElecNum;
    end
    setappdata(currGui, 'currPageElecs', currPage);
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
    if isempty(histograms) 
        for electrodeIndex = 1:propertiesFile.numOfElectrodesPerPage
            for labelsIndex = 1:propertiesFile.numOfLabelTypes
                histograms{electrodeIndex, labelsIndex} = findall(hObject.Parent, 'Tag',['slowUpdatePlot',num2str(electrodeIndex),'_',num2str(labelsIndex)]);
            end
        end
        setappdata(hObject.Parent, 'histograms', histograms);
    end
    createHistAndRasters(-parameters.preBipTime, parameters.postBipTime, parameters.slowUpdateFlag, parameters.newTrialsPerLabel, parameters.numOfTrialsPerLabel, parameters.dataToSaveForHistAndRaster, histograms, hObject.Parent);
end
