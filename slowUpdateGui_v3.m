function varargout = slowUpdateGui_v3(varargin)
    % SLOWUPDATEGUI_V3 MATLAB code for slowUpdateGui_v3.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @slowUpdateGui_v3_OpeningFcn, ...
                       'gui_OutputFcn',  @slowUpdateGui_v3_OutputFcn, ...
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


% --- Executes just before slowUpdateGui_v3 is made visible.
function slowUpdateGui_v3_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for slowUpdateGui_v3
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes slowUpdateGui_v3 wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = slowUpdateGui_v3_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end



% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_Callback');
    currChoise = round(get(hObject, 'Value')/10,1)*10+1;
    set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
    for inti = 1:10
        currText = findobj('Tag',['slowPlotLabel',num2str(inti)]);
        set(currText, 'string', ((currChoise-1)*10)+inti);
    end
end
% --- Executes during object creation, after setting all properties.
function sliderForSlowUpdate_CreateFcn(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_CreateFcn');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    set(hObject, 'Max', 9, 'Min', 0);
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

% --- Executes on button press in closeButtonSlow.
function closeButtonSlow_Callback(hObject, eventdata, handles)
    disp('closeButtonSlow_Callback');
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    disp('figure1_CloseRequestFcn');
    handles.figure1.UserData.closeFlag = true;
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
    disp('checkbox1_Callback');
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
    disp('checkbox2_Callback');
end

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    disp('checkbox3_Callback');
end

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    disp('checkbox4_Callback');
end

% --- Executes on button press in viewSelectedButton.
function viewSelectedButton_Callback(hObject, eventdata, handles)
    disp('viewSelectedButton_Callback');
end

% --- Executes on button press in closeAllFilteredViewsButton.
function closeAllFilteredViewsButton_Callback(hObject, eventdata, handles)
    disp('closeAllFilteredViewsButton_Callback');
end
