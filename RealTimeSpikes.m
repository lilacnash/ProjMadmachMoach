
%===============INIT-GUI===============
%======================================
function varargout = RealTimeSpikes(varargin)
% REALTIMESPIKES MATLAB code for RealTimeSpikes.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RealTimeSpikes_OpeningFcn, ...
                   'gui_OutputFcn',  @RealTimeSpikes_OutputFcn, ...
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


% Executes just before RealTimeSpikes is made visible.
function RealTimeSpikes_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for RealTimeSpikes
handles.output = hObject;
% Sets the GUIs position to be almost the maximum of the screen
set(hObject, 'Position', [ 0.005, 0.09, 0.95, 0.87]);

% Update handles structure
guidata(hObject, handles);

% set up data
setappdata(handles.figure1,'slowUpdateFlag',false);
setappdata(handles.figure1, 'useCBMEX', false);
setappdata(handles.figure1, 'usePrediction', false);
setappdata(handles.figure1, 'closeFlagOn', false);
setappdata(handles.figure1, 'stopButtonPressed', false);
setappdata(handles.figure1, 'startExpButtonPressed', false);
setappdata(handles.figure1, 'elecToPresent', []);
setappdata(handles.figure1, 'listboxString', {''});
set(handles.fastUpdatePlotsStaticLabel, 'String', 'Real Time Spikes');

end


% Outputs from this function are returned to the command line.
function varargout = RealTimeSpikes_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    hObject.UserData.update = true;
end

%%
%===============GUI-CALLBACKS===========
%=======================================
% Callbak to all popupmenu
function popupmanueData_Callback (hObject, eventdata)
    disp('popupmanueData_Callback');
    neuronMap = getappdata(hObject.Parent, 'neuronMap');
    elecToPresent = getappdata(hObject.Parent, 'elecToPresent');
    elecNumRegex = regexp(get(hObject, 'Tag'), '\d+', 'match');
    elecNum = str2num(elecNumRegex{1});
    newChoise = get(hObject, 'Value');
    listboxString = getappdata(hObject.Parent, 'listboxString');
    elecToPresent(elecNum) = str2num(listboxString{newChoise});
    setappdata(hObject.Parent, 'elecToPresent', elecToPresent);
    titleObj = findobj('Tag', ['fastPlotTitle', num2str(elecNum)]);
    set(titleObj, 'String', [propertiesFile.fastHistogramsTitle, num2str(newChoise), ' - ',neuronMap{newChoise,2}]);
end


function slowUpdateButton_Callback(hObject, eventdata, handles)
    disp('slowUpdateButton_Callback');
    if getappdata(handles.figure1,'startExpButtonPressed') == 1
        setappdata(handles.figure1,'slowUpdateFlag',true);
    else
        errordlg('Please choose the "Start Exp" button before pressing the "Slow Update" option!','Unpermitted Operation');
    end
end


function startExpButton_Callback(hObject, eventdata, handles)

    %%
    %===============PRE-PROCESING===============
    %===========================================
    disp('startExpButton_Callback');
    
    if getappdata(handles.figure1, 'startExpButtonPressed') == true
        return;
    end
    
    global cfg;
    
    if getappdata(handles.figure1, 'useCBMEX') == true
        % open neuroport
        cbmex('close');
        [connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
        if propertiesFile.connectToParadigm
            fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes: neuroport is open. connection: %d instrument: %d\n', GetSecs, connection, instrument);
        end
        startRecording();
    end
    
    MAX_LEGENT_FONT_SIZE = 12;
    setappdata(handles.figure1, 'startExpButtonPressed', true);
    
    %% Initilize the GUI plots according to the properties
    % Initilize all GUI objects
    % If rows and columns did not come from the properties file get
    % optimal number
    
    if getappdata(handles.figure1, 'useCBMEX') == true
        [numOfActiveElectrodes, neuronMap] = getNumOfElecToPres();
    else
        [numOfActiveElectrodes, neuronMap] = getNumOfElecToPresent_Temp(); 
        if neuronMap == 0
            neuronMap = load('neuronMap.mat');
            neuronMap = neuronMap.neuronMap;
            neuronMap = neuronMap(1:numOfActiveElectrodes, :);
            
        end
    end
    
    numOfActiveElectrodesToPresent = min(numOfActiveElectrodes,propertiesFile.numOfHistogramsToPresent);
    
    if propertiesFile.numOfCols <= 0 || propertiesFile.numOfRows <= 0
        [numOfRows, numOfCols] = getOptimalRowsAndColsNum(numOfActiveElectrodesToPresent);
    end
    containerPosition = [0.0079    0.0078    0.8540    0.8717];
    GUI_object = hObject.Parent;
    
    generatePlots(GUI_object, numOfActiveElectrodesToPresent, numOfRows, numOfCols, containerPosition);
  
    % Insert data into Listboxes and titles
    
    
    if(numOfActiveElectrodes == 0)
        % TODO: add close here.
    end

    setappdata(hObject.Parent, 'numOfActiveElectrodes', numOfActiveElectrodes);
    setappdata(hObject.Parent, 'neuronMap', neuronMap);
        
    listboxString = arrayfun(@num2str, (1:numOfActiveElectrodes), 'UniformOutput', false);
    
    for inti = 1:numOfActiveElectrodesToPresent
        % Insert data to listboxes
        currHandler = findobj('Tag',['fastPlotPopupmenu', num2str(inti)]);
        set(currHandler, 'Value', inti);
        set(currHandler, 'String', listboxString);
        set(currHandler, 'Callback', @popupmanueData_Callback);
        % Insert data into titles
        currHandler = findobj('Tag',['fastPlotTitle', num2str(inti)]);
        if numOfActiveElectrodesToPresent <= 16
            set(currHandler, 'String', [propertiesFile.fastHistogramsTitle, num2str(inti), ' - ',neuronMap{inti,2}]);
        else
            set(currHandler, 'String', ['Electrode: ', num2str(inti)], 'FontSize', 7);
        end
        
        setappdata(handles.figure1, 'listboxString', listboxString);
        elecToPresent(inti) = inti;
    end
    % Saves elecToPresent in a shared variable
    setappdata(handles.figure1, 'elecToPresent', elecToPresent);

    %%
    %===============TRAINING====================
    %===========================================
    collect_time = 0; %propertiesFile.collectTime;
    index = ones(numOfActiveElectrodes, 1);
    neuronTimeStamps = NaN(propertiesFile.numOfStamps, numOfActiveElectrodes);
    dataToSave = NaN(1, size(neuronMap,1));
    fastUpdateFlag = propertiesFile.fastUpdateFlag;
    slowUpdateFlag = propertiesFile.slowUpdateFlag;
    firstUpdate = true;
    
    fakeTrailNum = 1; %for simulation time sync
    if propertiesFile.connectToParadigm
        fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes: TRAINING started\n', GetSecs);
    end

    %%
    %init clocks
    t_col0 = tic; %collection time
    bCollect = true; %do we need to collect
    firstGetTimestamps = true;
    lastSample = 0;
    barAxes = cell(length(elecToPresent), 1);

    set(handles.labelText, 'String', '');

    labelsDataIndex = 0;
    dataToSaveForHistAndRaster = cell(numOfActiveElectrodes, (propertiesFile.numOfLabelTypes * propertiesFile.numOfTrials));
    indexFetchDataToSave = cell(1, size(neuronMap,1));
    indexFetchDataToSave(1,:) = {1};
    lastLabelTime = 0;
    dataForPrediction = cell(1, numOfActiveElectrodes*2); 
    numOfTrialsPerLabel = zeros(1,propertiesFile.numOfLabelTypes);
    
    % This time - For saving scheduling
    lastUpdate = now;
    %%
    %while slow and fast figures are open
    while(ishandle(handles.figure1) && getappdata(handles.figure1, 'closeFlagOn') == false && getappdata(handles.figure1, 'stopButtonPressed') == false)
        if(bCollect)
            et_col = toc(t_col0); %elapsed time of collection
            if(et_col >= collect_time)
                
                if getappdata(handles.figure1, 'useCBMEX') == true
                    [neuronTimeStamps, tempDataToSave] = getAllTimestamps(neuronTimeStamps, index, numOfActiveElectrodes, neuronMap); %read some data - the data should retern in cyclic arrays
                    dataToSave = [dataToSave; tempDataToSave];

                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', 0); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end

                else
                    [neuronTimeStamps, index, lastSample, tempDataToSave] = getAllTimestampsSim(et_col, neuronTimeStamps, index, lastSample); %for simulation only
                    dataToSave = [dataToSave; tempDataToSave];

                    if firstGetTimestamps == true
                        setappdata(handles.figure1,'offsetFirstGetTimestamps', 0); %saves time(of first call to getAllTimestamps) as offset
                        firstGetTimestamps = false;
                    end
                    
                    elecToPresent = getappdata(handles.figure1, 'elecToPresent');
                end
                
                %if the gui is open
                if(ishandle(handles.figure1))
                    % update fast
                    nGraphs = length(elecToPresent); %number of electrodes to present
                    nBins = propertiesFile.numOfBins;  
                    data = neuronTimeStamps(:, elecToPresent);
                    if(fastUpdateFlag)
                        [n,xout] = hist(data,nBins);
                        for jj = 1:nGraphs
                            barAxes{jj} = findobj('Tag',['fastPlot',num2str(jj)]);
                            format = 'n(:,%d)';
                            barParam = sprintf(format, jj);
                            bar(barAxes{jj},xout,n(:,jj),'YDataSource',barParam, 'XDataSource', 'xout');
                            if nGraphs <= 16
                                xlabel(barAxes{jj}, 'time bins (sec) ', 'FontSize', min([MAX_LEGENT_FONT_SIZE,round((1/nGraphs)*80)]));
                                ylabel(barAxes{jj}, 'count ', 'FontSize', min([MAX_LEGENT_FONT_SIZE,round((1/nGraphs)*80)]));
                            end
                            ylim(barAxes{jj}, [0 30]);
                        end
                        fastUpdateFlag = 0;
                        linkaxes([barAxes{:,1}], 'xy');
                    else
                        %turn on datalinking
                        if ishandle(handles.figure1)
                            linkdata(handles.figure1, 'on');
                            [n,xout] = hist(data,nBins);
                            xlim(barAxes{1}, [min(xout) max(xout)]);
                            ylim(barAxes{1}, [0 MatMax(n)+1]);
                            refreshdata(handles.figure1,'caller');
                            collect_time = et_col + propertiesFile.collectTime;
                        else
                            linkdata off
                        end     
                    end
                end
            end
        end
        
        if (getappdata(handles.figure1, 'slowUpdateFlag') == true) && firstUpdate
            slowUpdateGuiFig = OfflineAnalyse;
            slowUpdateGuiFig.UserData.closeFlag = false;
            setappdata(handles.figure1, 'slowUpdateGuiFig',slowUpdateGuiFig);
            firstUpdate = false;
            slowUpdateFlag = true;
        end
        
        myOffset = getappdata(handles.figure1,'offsetFirstGetTimestamps');
        
        %% need to update now even if we dont have new trials (page switch)
        needToUpdate =  (~firstUpdate && ishandle(getappdata(handles.figure1, 'slowUpdateGuiFig')) && slowUpdateGuiFig.UserData.closeFlag == false && ...
                (propertiesFile.usingUpdateButton == false || (propertiesFile.usingUpdateButton == true && hObject.Parent.UserData.update == true)));
        
        %% For testing Only, bips simulation - when not using paradigm
        if propertiesFile.connectToParadigm == false
           labels = {'a','e','i','o','u'};
           if second(now-lastUpdate) > 15 || needToUpdate
               newLabelAndBipTimeMatrix = {labels{randi([1 length(labels)])}, rand(1, 1, 'double')*(MatMax(neuronTimeStamps)-MatMin(neuronTimeStamps))};
           else
               continue;
           end
        else
            
        %% When using paradigm    
            if (cfg.server_data_socket.BytesAvailable > 0) || needToUpdate
                [newLabelAndBipTimeMatrix, empty] = getLogs();
                if empty && ~needToUpdate
                    continue;
                else
                    hObject.Parent.UserData.update = true;
                end
            else
                continue;
            end
        end
        
        labelsData(labelsDataIndex+1:labelsDataIndex+length(newLabelAndBipTimeMatrix(:,1)), 1:length(newLabelAndBipTimeMatrix(1,:))) = newLabelAndBipTimeMatrix;
        labelsDataIndex = length(labelsData(:, 1));
        
        if ~isempty(newLabelAndBipTimeMatrix{1,1})
            for ii = 1:size(newLabelAndBipTimeMatrix,1)
                letterOfCurrLabel = newLabelAndBipTimeMatrix{ii,1};
                currentBipTime = (newLabelAndBipTimeMatrix{ii,2}) - myOffset;
                switch (letterOfCurrLabel)
                    case 'a'
                        currentLabel = 1;
                    case 'e'
                        currentLabel = 2;
                    case 'i'
                        currentLabel = 3;
                    case 'o'
                        currentLabel = 4;
                    case 'u'
                        currentLabel = 5;
                end

                numOfTrialsPerLabel(currentLabel) = numOfTrialsPerLabel(currentLabel) + 1;

                %% For testing only
                if propertiesFile.connectToParadigm == true
                    currentBipTime = NaN;
                    kk = 1;
                    while(isnan(currentBipTime))
                        currentBipTime = dataToSave(30*fakeTrailNum, kk);
                        kk = kk+1;
                        if kk > propertiesFile.numOfElec
                            currentBipTime = 30*fakeTrailNum/10;
                            break;
                        end
                    end
                    fakeTrailNum = fakeTrailNum + 1;
                end
                
                predictionMinTime = currentBipTime - propertiesFile.predictionPreBipTime;
                predictionMaxTime = currentBipTime + propertiesFile.predictionPostBipTime;
                minTime = currentBipTime - propertiesFile.preBipTime;
                maxTime = currentBipTime + propertiesFile.postBipTime;
                labelIndex = (currentLabel-1)*propertiesFile.numOfTrials + numOfTrialsPerLabel(currentLabel);
                
                %% save relevant timestamps from new trials
                for ee = 1:numOfActiveElectrodes
                    if(lastLabelTime <= currentBipTime - propertiesFile.preBipTime)
                        ind = indexFetchDataToSave{1, ee};
                    else
                        ind = 1;
                    end
                    dataToSaveForHistAndRaster{ee, labelIndex} = dataToSave((dataToSave(ind:end, ee) >= minTime) & (dataToSave(ind:end, ee) <= maxTime), ee) - currentBipTime; %normalized for histogram x axis
                    
                    %% get data for prediction
                    if(propertiesFile.predictionOnline)
                        if(lastLabelTime <= currentBipTime - propertiesFile.predictionPreBipTime)
                            ind = indexFetchDataToSave{1, ee};
                        else
                            ind = 1;
                        end
                        dataForPrediction{(ee*2)-1} = getFiringRate(dataToSave((dataToSave(ind:end,ee) >= predictionMinTime) & (dataToSave(ind:end,ee) <= currentBipTime), ee), propertiesFile.preBipTime);
                        dataForPrediction{ee*2} = getFiringRate(dataToSave((dataToSave(ind:end,ee) >= currentBipTime) & (dataToSave(ind:end,ee) <= predictionMaxTime), ee), propertiesFile.postBipTime);
                        givePrediction = true;
                        handles.predictButton.UserData = dataForPrediction;
                    end
                    indexFetchDataToSave{1, ee} = length(dataToSave(:, ee));
                end
                lastLabelTime = currentBipTime;
            end
        end
        
        % Updates all relevant infomration to the Offline Analyzed View
        if needToUpdate
            slowGuiObject = getappdata(handles.figure1, 'slowUpdateGuiFig');
            slowUpdateGuiFig.UserData.preBipTime = propertiesFile.preBipTime;
            slowUpdateGuiFig.UserData.postBipTime = propertiesFile.postBipTime;
            slowUpdateGuiFig.UserData.slowUpdateFlag = slowUpdateFlag;
            slowUpdateGuiFig.UserData.numOfTrialsPerLabel = numOfTrialsPerLabel;
            slowUpdateGuiFig.UserData.dataToSaveForHistAndRaster = dataToSaveForHistAndRaster;
            createPlotsFunc = findall(slowGuiObject,'Tag', 'createPlots');
            createPlotsFunc.Callback(createPlotsFunc, eventdata);
            hObject.Parent.UserData.update = false;
        end
        
        % If slowUpdateGui is close setup all slow variables and delete the Gui fig
        if getappdata(handles.figure1, 'slowUpdateFlag') == true && ishandle(slowUpdateGuiFig) && slowUpdateGuiFig.UserData.closeFlag == true
            %linkdata off;
            slowUpdateFlag = true;
            firstUpdate = true;
            setappdata(handles.figure1, 'slowUpdateFlag', false);
            delete(slowUpdateGuiFig);
        end
        
        % When prediction flag is false, prediction works only with button
        % when there is new data to predict from (trail)
        if (propertiesFile.predictionOnline && getappdata(handles.figure1, 'usePrediction') == true && givePrediction)
            predictButton_Callback(handles.predictButton, eventdata, handles);
            givePrediction = false;
        end
        
        %% Saving data
        if (~isempty(dataToSave) && minute(now-lastUpdate) > propertiesFile.saveInterval)
            currentDateAndTime = replace(replace(datestr(datetime('Now')),' ','_'),':','-');
            if ~(exist(propertiesFile.outputDir, 'Dir') > 0)
                 mkdir(propertiesFile.outputDir);
            end
            allDataName = [propertiesFile.outputDir,'/',propertiesFile.allDataName,'.mat'];
            trailDataName = [propertiesFile.outputDir,'/',propertiesFile.trialsDataName,'.mat'];
            
            save([allDataName,currentDateAndTime,'.mat'],'dataToSave');
            save([trailDataName,currentDateAndTime,'.mat'],'dataToSaveForHistAndRaster');
            
            if propertiesFile.connectToParadigm
                fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes:data saved\n', GetSecs);
            end
            
            dataToSave = NaN(1, size(neuronMap,1));
            indexFetchDataToSave = cell(1, size(neuronMap,1));
            indexFetchDataToSave(1,:) = {1};
            %dataToSaveForHistAndRaster = cell(numOfActiveElectrodes, (propertiesFile.numOfLabelTypes * propertiesFile.numOfTrials));
            lastUpdate = now;
        end
    end
    
    %% stoping the recording and saving the data
    if getappdata(handles.figure1, 'useCBMEX') == true 
        cbmex('close');
        if propertiesFile.connectToParadigm
            fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes: cbmex closed\n', GetSecs);
        end
    end
    
    %% save data on exit
    if ~(isempty(dataToSave))
        currentDateAndTime = replace(replace(datestr(datetime('Now')),' ','_'),':','-');
        if ~(exist(propertiesFile.outputDir, 'Dir') > 0)
             mkdir(propertiesFile.outputDir);
        end
        allDataName = [propertiesFile.outputDir,'/',propertiesFile.allDataName,'.mat'];
        trailDataName = [propertiesFile.outputDir,'/',propertiesFile.trialsDataName,'.mat'];
            
        save([allDataName,currentDateAndTime,'.mat'],'dataToSave');    
        save([trailDataName,currentDateAndTime,'.mat'],'dataToSaveForHistAndRaster');
        if propertiesFile.connectToParadigm
            fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes: data saved\n', GetSecs);
        end
    end
    
     % close sockets
     if propertiesFile.connectToParadigm
         CloseSockets();
     end
    
     linkdata off;
     setappdata(handles.figure1, 'stopButtonPressed', false);
     setappdata(handles.figure1, 'startExpButtonPressed', false);
     
     if getappdata(handles.figure1, 'slowUpdateFlag') == true && ishandle(slowUpdateGuiFig) && slowUpdateGuiFig.UserData.closeFlag == false
        slowUpdateGuiFig.CloseRequestFcn(slowUpdateGuiFig, eventdata);
        setappdata(handles.figure1, 'slowUpdateFlag', 0);
     end
     
     % deleting all dynamic UI objects if close gui was not pressed
     if getappdata(handles.figure1, 'closeFlagOn') == false
         for inti = 1:numOfActiveElectrodesToPresent
            % Insert data to listboxes
            currHandler = findobj('Tag',['fastPlotPopupmenu', num2str(inti)]);
            delete(currHandler);
            currHandler = findobj('Tag',['fastPlotTitle', num2str(inti)]);
            delete(currHandler);
            delete(barAxes{inti});
         end
     end
    
     % When closing the main GUI exit nicely
     if getappdata(handles.figure1, 'closeFlagOn') == true
        delete(handles.figure1);
     end
     
end


function useCBMEX_Callback(hObject, eventdata, handles)
    disp('useCBMEX_Callback');
    setappdata(handles.figure1, 'useCBMEX', xor(getappdata(handles.figure1, 'useCBMEX'),true));
end


function closeButton_Callback(hObject, eventdata, handles)
    disp('closeButton_Callback');
    setappdata(handles.figure1, 'closeFlagOn', true);
end


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
    disp('stopButton_Callback');
    
%     if getappdata(handles.figure1, 'useCBMEX') == true
%         stopRec();
%     end
    
    setappdata(handles.figure1, 'stopButtonPressed', true);
end


% --- Executes on button press in forceCloseButton.
function forceCloseButton_Callback(hObject, eventdata, handles)
    % hObject    handle to forceCloseButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if getappdata(handles.figure1, 'slowUpdateFlag') == 1
        slowUpdateGuiFig = getappdata(handles.figure1, 'slowUpdateGuiFig');
        delete(slowUpdateGuiFig);
    end
    delete(handles.figure1);
end

% --- Executes on button press in predictionCheckbox.
function predictionCheckbox_Callback(hObject, eventdata, handles)
    disp('predictionCheckbox_Callback');
    setappdata(handles.figure1, 'usePrediction', xor(getappdata(handles.figure1, 'usePrediction'),true));
end


% --- Executes on button press in predictButton.
function predictButton_Callback(hObject, eventdata, handles)
   
    global cfg;

    persistent predictor;
    prediction = '0';
    
    if(getappdata(handles.figure1, 'startExpButtonPressed') == true)
        
        if(~isempty(handles.predictButton.UserData))
        
            if(isempty(predictor))   

                if(~strcmp(propertiesFile.predictorType, 'SIMULATION'))          
                   try
                       predictor = load(propertiesFile.predictorPath);
                   catch
                       errordlg('Could not find a predictor in specified path, will use random prediction','File does not exist');
                       prediction = generateRandomPrediction();
                   end              
                else
                    prediction = generateRandomPrediction();
                end          
            end

            if(strcmp(prediction, '0'))
                switch (propertiesFile.predictorType)
                    case 'SVM'
                        prediction = svmPrediction(predictor.predictors, handles.predictButton.UserData);
                    case 'NEURAL_NETWORK'
                        % add more options here 
                end  
            end

            playPrediction(prediction); 
            fprintf(cfg.logfile, '>>>>>>>>>>> %f in RealTimeSpikes: Prediction: %s\n', GetSecs, prediction);
        else
            errordlg('No data to predict yet, please wait for trail','Unpermitted Operation');
        end
    else
        errordlg('Please mark "with prediction" checkbox and start the expiriment first','Unpermitted Operation');
    end
    
end


function getLogs_Callback(hObject, eventdata, handles)
    getLogs();
end


%%
%===============GUI-OTHER===========
%===================================
function slowUpdateButton_ButtonDownFcn(hObject, eventdata, handles)
    disp('slowUpdateButton_ButtonDownFcn');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    disp('figure1_CloseRequestFcn');
    setappdata(handles.figure1, 'closeFlagOn', true);
    if getappdata(handles.figure1, 'startExpButtonPressed') == false
        delete(handles.figure1);
    end
end

