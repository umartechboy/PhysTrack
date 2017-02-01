function varargout = convertToBin(varargin)
% CONVERTTOBIN MATLAB code for convertToBin.fig
%      CONVERTTOBIN, by itself, creates a new CONVERTTOBIN or raises the existing
%      singleton*.
%
%      H = CONVERTTOBIN returns the handle to a new CONVERTTOBIN or the handle to
%      the existing singleton*.
%
%      CONVERTTOBIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERTTOBIN.M with the given input arguments.
%
%      CONVERTTOBIN('Property','Value',...) creates a new CONVERTTOBIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before convertToBin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to convertToBin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help convertToBin

% Last Modified by GUIDE v2.5 28-Oct-2016 12:50:49

% Begin initialization code - DO NOT EDIT
addpath(fileparts(pwd));
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @convertToBin_OpeningFcn, ...
                   'gui_OutputFcn',  @convertToBin_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

warning off;
if nargout
    gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
warning on;
% End initialization code - DO NOT EDIT

% --- Executes just before convertToBin is made visible.
function convertToBin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to convertToBin (see VARARGIN)

% Choose default command line output for convertToBin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~exist('handles') 
    return; 
end
% movegui(handles.vtt, 'northwest');
if PhysTrack.vr2oExists;   
    evalin('base', 'global vtt_thresh_00');
    global vtt_thresh_00
    vtt_vr2o_00 = evalin('base', 'vtt_vr2o_00');
    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', vtt_vr2o_00.TotalFrames);
    set(handles.slider1, 'Value', 1);
    
    [histImg, hist, thresh] = PhysTrack.imhistSmooth(PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.ifi, true), 0, true);
    vtt_thresh_00 = uint16([0, thresh]);
    showImsOnConToBinGUI
end

% UIWAIT makes convertToBin wait for user response (see UIRESUME)
uiwait(handles.vtt);

% --- Outputs from this function are returned to the command line.
function varargout = convertToBin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
watchon;
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00 vtt_thresh_00
    showImsOnConToBinGUI
end
watchoff;
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in prevkf.
function prevkf_Callback(hObject, eventdata, handles)
% hObject    handle to prevkf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00 vtt_thresh_00
    inds = vtt_thresh_00(find(vtt_thresh_00(:,1) < round(get(handles.slider1, 'Value'))),:);
    inds = inds(:,1);
    if length(max(inds)) == 1
        inds = max(inds);
        if inds <= 0
            inds = 1;
        elseif inds >= vtt_vr2o_00.TotalFrames
            inds = vtt_vr2o_00.TotalFrames;
        end
        set(handles.slider1, 'Value', inds);
        showImsOnConToBinGUI        
    end
end
% --- Executes on button press in nextkf.
function nextkf_Callback(hObject, eventdata, handles)
% hObject    handle to nextkf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_thresh_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    inds = vtt_thresh_00(find(vtt_thresh_00(:,1) > round(get(handles.slider1, 'Value'))),:);
    inds = inds(:,1);
    if length(max(inds)) == 1
        inds = min(inds);
        if inds <= 0
            inds = 1;
        elseif inds >= vtt_vr2o_00.TotalFrames
            inds = vtt_vr2o_00.TotalFrames;
        end
        set(handles.slider1, 'Value', inds);
        showImsOnConToBinGUI        
    end
end

% --- Executes on button press in closeB.
function closeB_Callback(hObject, eventdata, handles)
% hObject    handle to closeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handes.vtt);

% --- Executes on button press in firstf.
function firstf_Callback(hObject, eventdata, handles)
% hObject    handle to firstf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    set(handles.slider1, 'Value', 1);
    showImsOnConToBinGUI        
end

% --- Executes on button press in prevf.
function prevf_Callback(hObject, eventdata, handles)
% hObject    handle to prevf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    v = get(handles.slider1, 'Value');
    v = v - 1;
    if v < 1
        v = 1;
    end
    set(handles.slider1, 'Value', v);
    showImsOnConToBinGUI        
end

% --- Executes on button press in lastf.
function lastf_Callback(hObject, eventdata, handles)
% hObject    handle to lastf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00
    set(handles.slider1, 'Value', vtt_vr2o_00.TotalFrames);
    showImsOnConToBinGUI        
end

% --- Executes on button press in nextf.
function nextf_Callback(hObject, eventdata, handles)
% hObject    handle to nextf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00
    v = get(handles.slider1, 'Value');
    v = v + 1;
    if v > vtt_vr2o_00.TotalFrames
        v = vtt_vr2o_00;
    end
    set(handles.slider1, 'Value', v);
    showImsOnConToBinGUI        
end

% --- Executes on button press in playf.
function playf_Callback(hObject, eventdata, handles)
% hObject    handle to playf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00
    if strcmp(get(handles.playf, 'String'), 'Preview') % is stopped
        set(handles.playf, 'String', 'Stop');
    else
        set(handles.playf, 'String', 'Preview');
        return;
    end
    for ii = round(get(handles.slider1, 'Value')):1:vtt_vr2o_00.TotalFrames
        if ~strcmp(get(handles.playf, 'String'), 'Stop') % is playing
            break;
        end
        set(handles.slider1, 'Value', ii);
        showImsOnConToBinGUI        
    end
    set(handles.playf, 'String', 'Preview');
end
% --- Executes on button press in gotoxB.
function gotoxB_Callback(hObject, eventdata, handles)
% hObject    handle to gotoxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00
    try    
        toFrame = str2double(char(get(handles.framex, 'String')));
        if toFrame > 0 && toFrame <= vtt_vr2o_00.TotalFrames    
            set(handles.slider1, 'Value', toFrame);
            showImsOnConToBinGUI        
        end
    catch
    end
end

watchoff;
function framex_Callback(hObject, eventdata, handles)
% hObject    handle to framex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framex as text
%        str2double(get(hObject,'String')) returns contents of framex as a double
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
try
    toFrame = str2double(char(get(hObject, 'String')));
    set(handles.gotoxB, 'TooltipString', ['Goto Frame: ', num2str(toFrame)]); 
    showImsOnConToBinGUI
catch ex
end

% --- Executes during object creation, after setting all properties.
function framex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to framex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close vtt.
function vtt_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to vtt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);


% --- Executes on button press in insKF.
function insKF_Callback(hObject, eventdata, handles)
% hObject    handle to insKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_thresh_00
    ind = round(get(handles.slider1, 'Value'));
    if length(find(vtt_thresh_00(:,1) == ind) > 0)
        vtt_thresh_00(find(vtt_thresh_00(:,1) == ind), :) = [];
    end
    % copy the temp buffer to new location.
    vtt_thresh_00(end + 1, :) = vtt_thresh_00(end, :);
    % make the previous buf permament
    vtt_thresh_00(end - 1, 1) = ind;
    showImsOnConToBinGUI
end

% --- Executes on button press in remKF.
function remKF_Callback(hObject, eventdata, handles)
% hObject    handle to remKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00 vtt_thresh_00
    ind = round(get(handles.slider1, 'Value'));
    vtt_thresh_00(find(vtt_thresh_00(:,1) == ind),:) = [];
    showImsOnConToBinGUI
end

% --- Executes on button press in cancelB.
function cancelB_Callback(hObject, eventdata, handles)
% hObject    handle to cancelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.vtt);

% --- Executes on button press in resetThresh.
function resetThresh_Callback(hObject, eventdata, handles)
% hObject    handle to resetThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00 vtt_thresh_00
    ind = round(get(handles.slider1, 'Value'));
    tThresh = ginput(1);
    if length(find(vtt_thresh_00(:, 1) ==  ind)) > 0 % already contains        
        vtt_thresh_00(find(vtt_thresh_00(:, 1), ind), 2) = tThresh(1);
        showImsOnConToBinGUI
    else    
        vtt_thresh_00(end + 1, :) = vtt_thresh_00(end, :);
        vtt_thresh_00(end - 1, 1:2) = [ind,  tThresh(1)];
        showImsOnConToBinGUI
        vtt_thresh_00(end - 1, 1) = 0;
        vtt_thresh_00(end, :) = [];
    end
    
end

% --- Executes on button press in bkIsLight.
function bkIsLight_Callback(hObject, eventdata, handles)
% hObject    handle to bkIsLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    showImsOnConToBinGUI
end
% Hint: get(hObject,'Value') returns toggle state of bkIsLight


% --- Executes on button press in showRGB.
function showRGB_Callback(hObject, eventdata, handles)
% hObject    handle to showRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showRGB
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    showImsOnConToBinGUI
end
