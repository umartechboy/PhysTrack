function varargout = objectSelecter(varargin)
% OBJECTSELECTER MATLAB code for objectSelecter.fig
%      OBJECTSELECTER, by itself, creates a new OBJECTSELECTER or raises the existing
%      singleton*.
%
%      H = OBJECTSELECTER returns the handle to a new OBJECTSELECTER or the handle to
%      the existing singleton*.
%
%      OBJECTSELECTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJECTSELECTER.M with the given input arguments.
%
%      OBJECTSELECTER('Property','Value',...) creates a new OBJECTSELECTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before objectSelecter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to objectSelecter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help objectSelecter

% Last Modified by GUIDE v2.5 27-Aug-2019 14:08:11

% Begin initialization code - DO NOT EDIT

addpath(fileparts(pwd));
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @objectSelecter_OpeningFcn, ...
                   'gui_OutputFcn',  @objectSelecter_OutputFcn, ...
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


% --- Executes just before objectSelecter is made visible.
function objectSelecter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to objectSelecter (see VARARGIN)

% Choose default command line output for objectSelecter
handles.output = hObject;

axis(handles.mainAxis);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes objectSelecter wait for user response (see UIRESUME)
% uiwait(handles.vtt);

if ~exist('handles') 
    return; 
end
% movegui(handles.vtt, 'northwest');
if PhysTrack.vr2oExists;   
    vtt_vr2o_00 = evalin('base', 'vtt_vr2o_00');
    evalin('base', 'global  vtt_obs_00');
    assignin('base', 'vtt_obs_00', []);
    % preset values if the video is binary
    isBinary = false;
    if isnumeric(vtt_vr2o_00.BinaryThreshold)
        if vtt_vr2o_00.BinaryThreshold > 0
            isBinary = true;
        end
    end
    if isa(vtt_vr2o_00.BinaryThreshold, 'cfit') || isBinary
        isBinary = true;
        set(handles.binThreshSlider, 'Value', vtt_vr2o_00.BinaryThreshold(1));
        set(handles.cb1, 'Value', vtt_vr2o_00.BinaryBackgroundIsLight);
    else % get an apropriate initial theshold
        [It, histT, th, bkIsBright] = PhysTrack.imhistSmooth(PhysTrack.read2(vtt_vr2o_00, 1, false, true), 0, true);
        set(handles.cb1, 'Value', bkIsBright);
        set(handles.binThreshSlider, 'Value', th);
    end
    axis(handles.mainAxis);
    global vtt_resumeFromInd_00 
    if vtt_resumeFromInd_00 > 1
        set(handles.showLastCB, 'Visible', 'On');
        set(handles.showLastCB, 'Value', 1);
    else
        set(handles.showLastCB, 'Visible', 'Off');
        set(handles.showLastCB, 'Value', 0);
    end
    refreshBinObsWindow;
end
uiwait(handles.vtt);

% --- Outputs from this function are returned to the command line.
function varargout = objectSelecter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure



% --- Executes on button press in dBinObs.
function dBinObs_Callback(hObject, eventdata, handles)
% hObject    handle to dBinObs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00
    I = PhysTrack.read2(vtt_vr2o_00, 1, false);
    if size(I, 3) == 3 % is RGB
        I = rgb2gray(PhysTrack.read2(vtt_vr2o_00, 1, false));
        if get(handles.cb1, 'Value')
            I = I <= uint16(round(get(handles.binThreshSlider, 'Value')));
        else
            I = I > uint16(round(get(handles.binThreshSlider, 'Value')));
        end
        se = strel('disk', 10);
        I = bwareaopen(imclose(I, se), 10);
    end
    obs = regionprops(I, 'BoundingBox');
    
    %add objects     
    for ii = 1:size(obs, 1)
        vtt_obs_00(end + 1, :) = obs(ii).BoundingBox;
    end
    % remove duplicates
    remThese = [];    
    for jj = 1:size(vtt_obs_00, 1)
        for ii = (jj + 1):1:size(vtt_obs_00, 1)
            if rectint(vtt_obs_00(jj, :), vtt_obs_00(ii, :)) > 0
                remThese(end + 1) = ii;
            end
        end
    end
    
    vtt_obs_00(remThese, :) = [];
    refreshBinObsWindow;
end

% --- Executes on button press in addObj.
function addObj_Callback(hObject, eventdata, handles)
% hObject    handle to addObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00
    rect = round(getrect(handles.mainAxis));
    remThese = [];
    for ii = 1:size(vtt_obs_00, 1)
        if rectint(rect, vtt_obs_00(ii, :)) > 0
            remThese(end + 1) = ii;
        end
    end
    vtt_obs_00(remThese, :) = [];
    vtt_obs_00(end + 1, :) = rect;
    refreshBinObsWindow;
end


% --- Executes on button press in remObj.
function remObj_Callback(hObject, eventdata, handles)
% hObject    handle to remObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00
    rect = round(getrect(handles.mainAxis));
    remThese = [];
    for ii = 1:size(vtt_obs_00, 1)
        if rectint(rect, vtt_obs_00(ii, :)) >= rectint(vtt_obs_00(ii, :), vtt_obs_00(ii, :))
            remThese(end + 1) = ii;
        end
    end
    vtt_obs_00(remThese, :) = [];
    refreshBinObsWindow;
end

% --- Executes on button press in closeB.
function closeB_Callback(hObject, eventdata, handles)
% hObject    handle to closeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.vtt);

% --- Executes on button press in okB.
function okB_Callback(hObject, eventdata, handles)
% hObject    handle to okB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in dMovObs.
function dMovObs_Callback(hObject, eventdata, handles)
% hObject    handle to dMovObs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00
    if vtt_vr2o_00.TotalFrames < 10
        return;
    end
    mObs = []; % moving obs
    I1 = rgb2gray(PhysTrack.read2(vtt_vr2o_00, 1, false, true));
    samples = 20.0;
    h = waitbar(0, 'Analyzing Video...');
    for ii = 1:samples
        ind = uint16((vtt_vr2o_00.TotalFrames - 1) / samples * ii) + 1;
        I2 = rgb2gray(PhysTrack.read2(vtt_vr2o_00, ind, false, true));
        I2 = uint8(abs(int16(I2) - int16(I1)));
        I2 = I2 > ((min(min(I2)) + max(max(I2))) / 2);
        obs = regionprops(I2, 'BoundingBox');
        for jj = 1:size(obs, 1)
            mObs(end + 1, :) = obs(jj).BoundingBox;
        end
        waitbar(ii / samples, h);
    end
    close(h);
	h = waitbar(0, 'Preparing results');
    dObs = []; % distinct obs
    for jj = 1:size(mObs, 1)  
        alreadyExists = 0;
        for ii = 1:size(dObs, 1)
            if rectint(mObs(jj, :), dObs(ii, :)) /  mObs(jj, 3) / mObs(jj, 4) > 0.5 % diff Obj
                alreadyExists = ii;
            end
        end
        if alreadyExists > 0
            dObs(alreadyExists, 5) = dObs(alreadyExists, 5) + 1;
        else
            dObs(end + 1, :) = [mObs(jj, :), 1];
        end
        waitbar(jj / size(mObs, 1), h);
    end
    close(h);
    
    dObs = dObs(find(dObs(:,5) > 2),:);
    areas = dObs(:, 3) .* dObs(:, 4);
    avgArea = sum(mObs(:, 3) .* mObs(:, 4)) / size(mObs, 1);
    dObs = dObs(find(areas > avgArea), 1:4);
    
    %add objects 
    
    for ii = 1:size(dObs, 1)
        vtt_obs_00(end + 1, :) = dObs(ii, :);
    end
    % remove duplicates
    remThese = [];    
    for jj = 1:size(vtt_obs_00, 1)
        for ii = (jj + 1):1:size(vtt_obs_00, 1)
            if rectint(vtt_obs_00(jj, :), vtt_obs_00(ii, :)) > 0
                remThese(end + 1) = ii;
            end
        end
    end
    
    vtt_obs_00(remThese, :) = [];
    refreshBinObsWindow;
end

% --- Executes on slider movement.
function binThreshSlider_Callback(hObject, eventdata, handles)
% hObject    handle to binThreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function binThreshSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binThreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cb1.
function cb1_Callback(hObject, eventdata, handles)
% hObject    handle to cb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb1


% --- Executes on selection change in obsList.
function obsList_Callback(hObject, eventdata, handles)
% hObject    handle to obsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns obsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from obsList

highlitedObInd = get(hObject, 'Value');
refreshBinObsWindow;

% --- Executes during object creation, after setting all properties.
function obsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function movSlider_Callback(hObject, eventdata, handles)
% hObject    handle to movSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function movSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function vtt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vtt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in removeAll.
function removeAll_Callback(hObject, eventdata, handles)
% hObject    handle to removeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00 vtt_StartF_00
    vtt_obs_00 = [];   
    refreshBinObsWindow;
    drawnow;    
    set(handles.obsList, 'String', '');
end


% --- Executes on button press in forceRGBCB.
function forceRGBCB_Callback(hObject, eventdata, handles)
% hObject    handle to forceRGBCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of forceRGBCB

if PhysTrack.vr2oExists;   
    global vtt_vr2o_00 vtt_obs_00
    refreshBinObsWindow;
end


% --- Executes on button press in showLastCB.
function showLastCB_Callback(hObject, eventdata, handles)
% hObject    handle to showLastCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showLastCB
showLast = get(handles.showLastCB, 'Value');
refreshBinObsWindow;


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
