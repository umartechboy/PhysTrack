function varargout = vidTrimTool(varargin)
% VIDTRIMTOOL MATLAB code for vidTrimTool.fig
%      VIDTRIMTOOL, by itself, creates a new VIDTRIMTOOL or raises the existing
%      singleton*.
%
%      H = VIDTRIMTOOL returns the handle to a new VIDTRIMTOOL or the handle to
%      the existing singleton*.
%
%      VIDTRIMTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDTRIMTOOL.M with the given input arguments.
%
%      VIDTRIMTOOL('Property','Value',...) creates a new VIDTRIMTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vidTrimTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vidTrimTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vidTrimTool

% Last Modified by GUIDE v2.5 27-Aug-2019 14:05:35

% Begin initialization code - DO NOT EDIT
addpath(fileparts(pwd));
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vidTrimTool_OpeningFcn, ...
                   'gui_OutputFcn',  @vidTrimTool_OutputFcn, ...
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

% --- Executes just before vidTrimTool is made visible.
function vidTrimTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vidTrimTool (see VARARGIN)

axes(handles.axes1);
global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
% Choose default command line output for vidTrimTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~exist('handles') 
    return; 
end
% movegui(handles.vtt, 'northwest');
if PhysTrack.vr2oExists;   
    vtt_vr2o_00 = evalin('base', 'vtt_vr2o_00');
    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', vtt_vr2o_00.obj.NumberOfFrames);
    set(handles.slider1, 'Value', vtt_vr2o_00.ifi);
    set(handles.ifiLabel, 'String', ['In-Frame: ', num2str(vtt_vr2o_00.ifi)]);
    set(handles.ofiLabel, 'String', ['Out-Frame: ', num2str(vtt_vr2o_00.ofi)]);    
    set(handles.curFrameLabel, 'String', ['Frame ',num2str(vtt_vr2o_00.ifi),' of ', num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    set(handles.totalFrameLabel, 'String', num2str(vtt_vr2o_00.obj.NumberOfFrames));
    axes(handles.axes1);
    I = PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.ifi, true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
    drawnow;
end

% UIWAIT makes vidTrimTool wait for user response (see UIRESUME)
uiwait(handles.vtt);

% --- Outputs from this function are returned to the command line.
function varargout = vidTrimTool_OutputFcn(hObject, eventdata, handles) 
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

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
watchon;
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    set(handles.slider1, 'Value', round(get(handles.slider1, 'Value')));
    axes(handles.axes1);
    I = PhysTrack.read2(vtt_vr2o_00, uint16(round(get(hObject,'Value'))), true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);

    set(handles.curFrameLabel, 'String', ['Frame ', ...
        num2str(round(get(handles.slider1,'Value'))),...
        ' of ',...
        num2str(vtt_vr2o_00.obj.NumberOfFrames)...
        ]);
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


% --- Executes on button press in markifi.
function markifi_Callback(hObject, eventdata, handles)
% hObject    handle to markifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  vtt_inFrameRect_00 vtt_outFrameRect_00 vtt_vr2o_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    if get(handles.slider1,'Value') > vtt_vr2o_00.ofi
        set(handles.slider1,'Value', vtt_vr2o_00.ofi);  
        I = PhysTrack.read2(vtt_vr2o_00, uint16(round(get(handles.slider1,'Value')), true, get(handles.forceRGB, 'Value'), true));
        I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
        imshow(I);
    end
    set(handles.ifiLabel, 'String', strcat(['In-Frame: ', num2str(round(get(handles.slider1,'Value')))]));
    vtt_vr2o_00.ifi = uint16(round(get(handles.slider1,'Value')));
    vtt_vr2o_00.TotalFrames = vtt_vr2o_00.ofi - vtt_vr2o_00.ifi + 1;
    set(handles.totalFrameLabel, 'String', num2str(vtt_vr2o_00.ofi - vtt_vr2o_00.ifi + 1));
end

% --- Executes on button press in markofi.
function markofi_Callback(hObject, eventdata, handles)
% hObject    handle to markofi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    if get(handles.slider1,'Value') < vtt_vr2o_00.ifi
        set(handles.slider1,'Value', vtt_vr2o_00.ifi);  
        I = PhysTrack.read2(vtt_vr2o_00, uint16(round(get(handles.slider1,'Value')), true, get(handles.forceRGB, 'Value'), true));
        I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
        imshow(I);
    end
    set(handles.ofiLabel, 'String', strcat(['Out-Frame: ', num2str(round(get(handles.slider1,'Value')))]));
    vtt_vr2o_00.ofi = uint16(round(get(handles.slider1,'Value')));
    vtt_vr2o_00.TotalFrames = vtt_vr2o_00.ofi - vtt_vr2o_00.ifi + 1;
    set(handles.totalFrameLabel, 'String', num2str(vtt_vr2o_00.ofi - vtt_vr2o_00.ifi + 1));
end

% --- Executes on button press in gotoifi.
function gotoifi_Callback(hObject, eventdata, handles)
% hObject    handle to gotoifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    set(handles.slider1, 'Value', vtt_vr2o_00.ifi);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(vtt_vr2o_00.ifi),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    I = PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.ifi, true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
end
% --- Executes on button press in gotoofi.
function gotoofi_Callback(hObject, eventdata, handles)
% hObject    handle to gotoofi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    set(handles.slider1, 'Value', vtt_vr2o_00.ofi);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(vtt_vr2o_00.ofi),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    
    I = PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.ofi, true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
end

% --- Executes on button press in closeB.
function closeB_Callback(hObject, eventdata, handles)
% hObject    handle to closeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.vtt);

% --- Executes on button press in firstf.
function firstf_Callback(hObject, eventdata, handles)
% hObject    handle to firstf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    set(handles.slider1, 'Value', 1);
    set(handles.curFrameLabel, 'String', ['Frame 1 of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    
    I = PhysTrack.read2(vtt_vr2o_00, 1, true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
end

% --- Executes on button press in prevf.
function prevf_Callback(hObject, eventdata, handles)
% hObject    handle to prevf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
elseif round(get(handles.slider1, 'Value')) > 1
    axes(handles.axes1);
    set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) - 1);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
end

% --- Executes on button press in lastf.
function lastf_Callback(hObject, eventdata, handles)
% hObject    handle to lastf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    set(handles.slider1, 'Value', vtt_vr2o_00.obj.NumberOfFrames);
    set(handles.curFrameLabel, 'String', ['Frame 1 of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
    
    I = PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.obj.NumberOfFrames, true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
end

% --- Executes on button press in nextf.
function nextf_Callback(hObject, eventdata, handles)
% hObject    handle to nextf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    if round(get(handles.slider1, 'Value')) < vtt_vr2o_00.obj.NumberOfFrames
        set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) + 1);
        set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
        
        I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
        I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
        imshow(I);
    end
end

% --- Executes on button press in playf.
function playf_Callback(hObject, eventdata, handles)
% hObject    handle to playf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if ~PhysTrack.vr2oExists
    delete(hObject);
else
    axes(handles.axes1);
    if strcmp(get(handles.playf, 'String'), 'Preview') % is stopped
        set(handles.playf, 'String', 'Stop');
    else
        set(handles.playf, 'String', 'Preview');
        return;
    end
    if strcmp(get(handles.playf, 'String'), 'Stop') % can play
        if round(get(handles.slider1, 'Value')) < vtt_vr2o_00.ifi
            set(handles.slider1, 'Value', vtt_vr2o_00.ifi)
        end    
        if round(get(handles.slider1, 'Value')) > vtt_vr2o_00.ofi
            set(handles.slider1, 'Value', vtt_vr2o_00.ofi)
        end
        for ii = round(get(handles.slider1, 'Value')):1:vtt_vr2o_00.ofi
            if ~strcmp(get(handles.playf, 'String'), 'Stop') % is playing
                break;
            end
                set(handles.slider1, 'Value', ii);
                set(handles.curFrameLabel, 'String', strcat(['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]));
                imshow(PhysTrack.read2(vtt_vr2o_00, ii, true, get(handles.forceRGB, 'Value'), true));
                drawnow;
                pause(1 / vtt_vr2o_00.FPS);
        end
    end
end
% --- Executes on button press in gotoxB.
function gotoxB_Callback(hObject, eventdata, handles)
% hObject    handle to gotoxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    try    
        toFrame = str2double(char(get(handles.framex, 'String')));
        if toFrame > 0 && toFrame <= vtt_vr2o_00.obj.NumberOfFrames    
            set(handles.slider1, 'Value', toFrame);
            set(handles.curFrameLabel, 'String', ['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(vtt_vr2o_00.obj.NumberOfFrames)]);
            I = PhysTrack.read2(vtt_vr2o_00, toFrame, true, get(handles.forceRGB, 'Value'), true);
            I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
            imshow(I);
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


% --- Executes on button press in resetCrop.
function resetCrop_Callback(hObject, eventdata, handles)
% hObject    handle to resetCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00
if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else  
    vroTemp = vtt_vr2o_00;
    vtt_vr2o_00.CropRect = [1, 1, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag];
    if vtt_vr2o_00.Rotation == 90 || vtt_vr2o_00.Rotation == 270
        vtt_vr2o_00.CropRect = [1, 1, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag];
    end
    I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
    I2 = showCropping(I, vroTemp.CropRect, 0.6);
    imshow(I2);
    %msgbox('Drag and Draw a Rectangle on the frame to be cropped.');
    cropRect = getrect();    
    [I, vtt_vr2o_00.CropRect] = showCropping(I, cropRect);
    imshow(I);
end

% --- Executes on button press in defCrop.
function defCrop_Callback(hObject, eventdata, handles)
% hObject    handle to defCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

if ~PhysTrack.vr2oExists
    delete(hObject);
else
    global vtt_vr2o_00
    vtt_vr2o_00.CropRect = [1, 1, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag];
    if vtt_vr2o_00.Rotation == 90 || vtt_vr2o_00.Rotation == 270
        vtt_vr2o_00.CropRect = [1, 1, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag];
    end
    imshow(PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true));
end

% --- Executes on button press in forceRGB.
function forceRGB_Callback(hObject, eventdata, handles)
% hObject    handle to forceRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of forceRGB
global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
    I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);

% --- Executes on button press in rotate0RB.
function rotate0RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate0RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if get(hObject, 'Value') == 1
    vtt_vr2o_00.Rotation = 0;
    vtt_vr2o_00.CropRect = [0,0, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag];
    set(handles.rotate90RB, 'Value', 0);
    set(handles.rotate180RB, 'Value', 0);
    set(handles.rotate270RB, 'Value', 0);
end
I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);
% Hint: get(hObject,'Value') returns toggle state of rotate0RB


% --- Executes on button press in rotate90RB.
function rotate90RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if get(hObject, 'Value') == 1
    vtt_vr2o_00.Rotation = 90;
    vtt_vr2o_00.CropRect = [0,0, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag];
    set(handles.rotate0RB, 'Value', 0);
    set(handles.rotate180RB, 'Value', 0);
    set(handles.rotate270RB, 'Value', 0);
end
I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);
% Hint: get(hObject,'Value') returns toggle state of rotate90RB


% --- Executes on button press in rotate180RB.
function rotate180RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate180RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if get(hObject, 'Value') == 1
    vtt_vr2o_00.Rotation = 180;
    vtt_vr2o_00.CropRect = [0,0, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag];
    set(handles.rotate90RB, 'Value', 0);
    set(handles.rotate0RB, 'Value', 0);
    set(handles.rotate270RB, 'Value', 0);
end

I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);
% Hint: get(hObject,'Value') returns toggle state of rotate180RB


% --- Executes on button press in rotate270RB.
function rotate270RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate270RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
if get(hObject, 'Value') == 1
    vtt_vr2o_00.Rotation = 270;    
    vtt_vr2o_00.CropRect = [0,0, vtt_vr2o_00.obj.Height * vtt_vr2o_00.PreMag, vtt_vr2o_00.obj.Width * vtt_vr2o_00.PreMag];
    set(handles.rotate90RB, 'Value', 0);
    set(handles.rotate180RB, 'Value', 0);
    set(handles.rotate0RB, 'Value', 0);
end

I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);
% Hint: get(hObject,'Value') returns toggle state of rotate270RB


% --- Executes on button press in locateInFrameIndicater.
function locateInFrameIndicater_Callback(hObject, eventdata, handles)
% hObject    handle to locateInFrameIndicater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
vtt_inFrameRect_00 = getrect();
I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);

% --- Executes on button press in locateOutFrameIndicater.
function locateOutFrameIndicater_Callback(hObject, eventdata, handles)
% hObject    handle to locateOutFrameIndicater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
vtt_outFrameRect_00 = getrect();

I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);

% --- Executes on button press in autoTrackTtrimming.
function autoTrackTtrimming_Callback(hObject, eventdata, handles)
% hObject    handle to autoTrackTtrimming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
vtt_vr2o_00 = processMarkersForTrimming(vtt_vr2o_00, vtt_inFrameRect_00, vtt_outFrameRect_00);

axes(handles.axes1);
set(handles.slider1,'Value', vtt_vr2o_00.ifi);  
I = PhysTrack.read2(vtt_vr2o_00, vtt_vr2o_00.ifi, true, get(handles.forceRGB, 'Value'), true);
I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
imshow(I);
set(handles.ifiLabel, 'String', strcat(['In-Frame: ', num2str(vtt_vr2o_00.ifi)]));
set(handles.ofiLabel, 'String', strcat(['Out-Frame: ', num2str(vtt_vr2o_00.ofi)]));
vtt_vr2o_00.TotalFrames = vtt_vr2o_00.ofi - vtt_vr2o_00.ifi + 1;
set(handles.totalFrameLabel, 'String', num2str(vtt_vr2o_00.TotalFrames));


% --- Executes on button press in useReverseKLTCB.
function useReverseKLTCB_Callback(hObject, eventdata, handles)
% hObject    handle to useReverseKLTCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useReverseKLTCB
global vtt_vr2o_00 vtt_inFrameRect_00 vtt_outFrameRect_00
    vtt_vr2o_00.TrackInReverse = get(handles.useReverseKLTCB, 'Value');
    I = PhysTrack.read2(vtt_vr2o_00, get(handles.slider1, 'Value'), true, get(handles.forceRGB, 'Value'), true);
    I = showTrimmingMarkers(I, vtt_inFrameRect_00, vtt_outFrameRect_00);
    imshow(I);
