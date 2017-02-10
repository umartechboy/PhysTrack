function varargout = CoordinateSystemTool(varargin)
% COORDINATESYSTEMTOOL MATLAB code for CoordinateSystemTool.fig
%      COORDINATESYSTEMTOOL, by itself, creates a new COORDINATESYSTEMTOOL or raises the existing
%      singleton*.
%
%      H = COORDINATESYSTEMTOOL returns the handle to a new COORDINATESYSTEMTOOL or the handle to
%      the existing singleton*.
%
%      COORDINATESYSTEMTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COORDINATESYSTEMTOOL.M with the given input arguments.
%
%      COORDINATESYSTEMTOOL('Property','Value',...) creates a new COORDINATESYSTEMTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CoordinateSystemTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CoordinateSystemTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CoordinateSystemTool

% Last Modified by GUIDE v2.5 15-Dec-2016 09:52:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CoordinateSystemTool_OpeningFcn, ...
                   'gui_OutputFcn',  @CoordinateSystemTool_OutputFcn, ...
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


% --- Executes just before CoordinateSystemTool is made visible.
function CoordinateSystemTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CoordinateSystemTool (see VARARGIN)

% Choose default command line output for CoordinateSystemTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~exist('handles') 
    return; 
end
% movegui(handles.vtt, 'northwest');
global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppmPoints_00
vtt_curDir_00 = true;
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', vtt_vr2o_00.TotalFrames);
set(handles.slider1, 'Value', 1);
set(handles.curFrameLabel, 'String', ['Frame 1 of ', num2str(vtt_vr2o_00.TotalFrames)]);
axis(handles.axes1);
if isstruct(vtt_rw_00)
    set(handles.resetUnit, 'Visible', 'off');
    set(handles.unitMarkLen, 'Visible', 'off');
    set(handles.text3, 'Visible', 'off');
    set(handles.resetO, 'Visible', 'off');
    set(handles.resetX, 'Visible', 'off');
    set(handles.toggleDir, 'Visible', 'off');
    set(handles.toggleAxis, 'Visible', 'off');
end
ShowImWithRef(vtt_vr2o_00, 1, vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
drawnow;

% UIWAIT makes CoordinateSystemTool wait for user response (see UIRESUME)
uiwait(handles.vtt);


% --- Outputs from this function are returned to the command line.
function varargout = CoordinateSystemTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

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
global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
set(handles.slider1, 'Value', round(get(handles.slider1, 'Value')));
axes(handles.axes1);
set(handles.curFrameLabel, 'String', ['Frame ', ...
    num2str(round(get(handles.slider1,'Value'))),...
    ' of ',...
    num2str(vtt_vr2o_00.TotalFrames)...
    ]);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
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

% --- Executes on button press in closeB.
function closeB_Callback(hObject, eventdata, handles)
% hObject    handle to closeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.vtt);

% --- Executes on button press in firstf.
function gotoifi_Callback(hObject, eventdata, handles)
% hObject    handle to firstf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
axes(handles.axes1);
set(handles.slider1, 'Value', 1);
set(handles.curFrameLabel, 'String', ['Frame 1 of ',num2str(vtt_vr2o_00.TotalFrames)]);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);

% --- Executes on button press in prevf.
function prevf_Callback(hObject, eventdata, handles)
% hObject    handle to prevf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if round(get(handles.slider1, 'Value')) > 1
    global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
    axes(handles.axes1);
    set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) - 1);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(vtt_vr2o_00.TotalFrames)]);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
end

% --- Executes on button press in lastf.
function gotoofi_Callback(hObject, eventdata, handles)
% hObject    handle to lastf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
axes(handles.axes1);
set(handles.slider1, 'Value', vtt_vr2o_00.TotalFrames);
set(handles.curFrameLabel, 'String', ['Frame ',num2str(vtt_vr2o_00.TotalFrames),' of ',num2str(vtt_vr2o_00.TotalFrames)]);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);

% --- Executes on button press in nextf.
function nextf_Callback(hObject, eventdata, handles)
% hObject    handle to nextf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
axes(handles.axes1);
if round(get(handles.slider1, 'Value')) < vtt_vr2o_00.TotalFrames
    set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) + 1);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(vtt_vr2o_00.TotalFrames)]);
    ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
end

% --- Executes on button press in playf.
function playf_Callback(hObject, eventdata, handles)
% hObject    handle to playf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
axes(handles.axes1);
if strcmp(get(handles.playf, 'String'), 'Preview') % is stopped
    set(handles.playf, 'String', 'Stop');
else
    set(handles.playf, 'String', 'Preview');
    return;
end
if strcmp(get(handles.playf, 'String'), 'Stop') % can play
    for ii = round(get(handles.slider1, 'Value')):1:vtt_vr2o_00.TotalFrames
        if ~strcmp(get(handles.playf, 'String'), 'Stop') % is playing
            break;
        end
            set(handles.slider1, 'Value', ii);
            set(handles.curFrameLabel, 'String', strcat(['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(vtt_vr2o_00.TotalFrames)]));
            ShowImWithRef(vtt_vr2o_00, ii, vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
            drawnow;
            pause(1 / vtt_vr2o_00.FPS);
    end
    set(handles.playf, 'String' , 'Preview');
end
% --- Executes on button press in gotoxB.
function gotoxB_Callback(hObject, eventdata, handles)
% hObject    handle to gotoxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
try    
    toFrame = str2double(char(get(handles.framex, 'String')));
    if toFrame > 0 && toFrame <= vtt_vr2o_00.TotalFrames    
        set(handles.slider1, 'Value', toFrame);
        set(handles.curFrameLabel, 'String', ['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(vtt_vr2o_00.TotalFrames)]);
        ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
    end
catch
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
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
delete(hObject);


% --- Executes on button press in resetO.
function resetO_Callback(hObject, eventdata, handles)
% hObject    handle to resetO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppmPoints_00
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
title('Click to mark the new coordinate system origin.');
vtt_rw_00(1,:) = ginput(1);
a12 = cart2pol(vtt_rw_00(2,1) - vtt_rw_00(1,1), vtt_rw_00(2,2) - vtt_rw_00(1,2));
if vtt_curDir_00
    a3 = a12 + pi / 2;
else
    a3 = a12 - pi / 2;
end
r = sqrt((vtt_rw_00(1,1) - vtt_rw_00(2, 1)).^2 + (vtt_rw_00(1,2) - vtt_rw_00(2, 2)).^2) / 2;
[x, y] = pol2cart(a3, r);
vtt_rw_00 (3,:) = [x, y] + vtt_rw_00(1,:);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);


% --- Executes on button press in resetX.
function resetX_Callback(hObject, eventdata, handles)
% hObject    handle to resetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppmPoints_00
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
title('Click on a point on the desired x axis.');
vtt_rw_00(2,:) = ginput(1);
a12 = cart2pol(vtt_rw_00(2,1) - vtt_rw_00(1,1), vtt_rw_00(2,2) - vtt_rw_00(1,2));
if vtt_curDir_00
    a3 = a12 + pi / 2;
else
    a3 = a12 - pi / 2;
end
r = sqrt((vtt_rw_00(1,1) - vtt_rw_00(2, 1)).^2 + (vtt_rw_00(1,2) - vtt_rw_00(2, 2)).^2) / 2;
[x, y] = pol2cart(a3, r);
vtt_rw_00 (3,:) = [x, y] + vtt_rw_00(1,:);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);

% --- Executes on button press in forceRGB.
function forceRGB_Callback(hObject, eventdata, handles)
% hObject    handle to forceRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of forceRGB
global vtt_vr2o_00 vtt_rw_00 vtt_ppmPoints_00
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);


% --- Executes on button press in toggleDir.
function toggleDir_Callback(hObject, eventdata, handles)
% hObject    handle to toggleDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppmPoints_00
vtt_curDir_00 = ~vtt_curDir_00;
a12 = cart2pol(vtt_rw_00(2,1) - vtt_rw_00(1,1), vtt_rw_00(2,2) - vtt_rw_00(1,2));
if vtt_curDir_00
    a3 = a12 + pi / 2;
else
    a3 = a12 - pi / 2;
end
r = sqrt((vtt_rw_00(1,1) - vtt_rw_00(2, 1)).^2 + (vtt_rw_00(1,2) - vtt_rw_00(2, 2)).^2) / 2;
[x, y] = pol2cart(a3, r);
vtt_rw_00 (3,:) = [x, y] + vtt_rw_00(1,:);
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);


% --- Executes on button press in toggleAxis.
function toggleAxis_Callback(hObject, eventdata, handles)
% hObject    handle to toggleAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppmPoints_00
r = sqrt((vtt_rw_00(1,1) - vtt_rw_00(2, 1)).^2 + (vtt_rw_00(1,2) - vtt_rw_00(2, 2)).^2) / 2;
p3 = PhysTrack.InverseTransformCart2Cart([r, 0], vtt_rw_00);
vtt_rw_00(2,:) = PhysTrack.InverseTransformCart2Cart([0, r * 2], vtt_rw_00);
vtt_rw_00(3,:) = p3;
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);



function unitMarkLen_Callback(hObject, eventdata, handles)
% hObject    handle to unitMarkLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unitMarkLen as text
%        str2double(get(hObject,'String')) returns contents of unitMarkLen as a double

global vtt_ppm_00 vtt_ppmPoints_00 vtt_rw_00 vtt_vr2o_00
if ~isempty(vtt_ppmPoints_00)
    d = PhysTrack.DistanceBetween(vtt_ppmPoints_00(1:2), vtt_ppmPoints_00(3:4));
    try
        vtt_ppm_00 = d / str2num(get(handles.unitMarkLen, 'String'));
    catch
    end
end
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);

% --- Executes during object creation, after setting all properties.
function unitMarkLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitMarkLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetUnit.
function resetUnit_Callback(hObject, eventdata, handles)
% hObject    handle to resetUnit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtt_ppm_00 vtt_ppmPoints_00 vtt_rw_00 vtt_vr2o_00
title('Draw a line on the known distance');
[kdx kdy] = getline();
vtt_ppmPoints_00 = [kdx(1),kdy(1), kdx(2),kdy(2)];
d = PhysTrack.DistanceBetween(vtt_ppmPoints_00(1:2), vtt_ppmPoints_00(3:4));
try
    vtt_ppm_00 = d / str2num(get(handles.unitMarkLen, 'String'));
catch
end
ShowImWithRef(vtt_vr2o_00, get(handles.slider1,'Value'), vtt_rw_00, get(handles.forceRGB, 'Value'), vtt_ppmPoints_00);
