function varargout = KLTFilterTool(varargin)
% KLTFILTERTOOL MATLAB code for KLTFilterTool.fig
%      KLTFILTERTOOL, by itself, creates a new KLTFILTERTOOL or raises the existing
%      singleton*.
%
%      H = KLTFILTERTOOL returns the handle to a new KLTFILTERTOOL or the handle to
%      the existing singleton*.
%
%      KLTFILTERTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KLTFILTERTOOL.M with the given input arguments.
%
%      KLTFILTERTOOL('Property','Value',...) creates a new KLTFILTERTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KLTFilterTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KLTFilterTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KLTFilterTool

% Last Modified by GUIDE v2.5 14-Dec-2016 16:14:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KLTFilterTool_OpeningFcn, ...
                   'gui_OutputFcn',  @KLTFilterTool_OutputFcn, ...
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


% --- Executes just before KLTFilterTool is made visible.
function KLTFilterTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KLTFilterTool (see VARARGIN)

% Choose default command line output for KLTFilterTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~exist('handles') 
    return; 
end
% movegui(handles.vtt, 'northwest');
global klt_vr2o_00 klt_tObs_00
global klt_undoHist_00 klt_undoSteps_00
klt_undoHist_00 = [];
klt_undoSteps_00 = [];
for ii = 1:klt_tObs_00
    eval(['global klt_PointsValidity_00_bkp_',num2str(ii), ' klt_PointsValidity_00_',num2str(ii)]);
    eval(['klt_PointsValidity_00_bkp_',num2str(ii), ' = klt_PointsValidity_00_',num2str(ii),';']);
end
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', klt_vr2o_00.TotalFrames);
set(handles.slider1, 'Value', 1);
set(handles.curFrameLabel, 'String', ['Frame 1 of ', num2str(klt_vr2o_00.TotalFrames)]);
axis(handles.axes1);
imshow(insertTPs(1, get(handles.tpMeanCB, 'Value')));
drawnow;

% UIWAIT makes CoordinateSystemTool wait for user response (see UIRESUME)
uiwait(handles.vtt);


% --- Outputs from this function are returned to the command line.
function varargout = KLTFilterTool_OutputFcn(hObject, eventdata, handles) 
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
global klt_vr2o_00
set(handles.slider1, 'Value', round(get(handles.slider1, 'Value')));
axes(handles.axes1);
set(handles.curFrameLabel, 'String', ['Frame ', ...
    num2str(round(get(handles.slider1,'Value'))),...
    ' of ',...
    num2str(klt_vr2o_00.TotalFrames)...
    ]);
imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));
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
global klt_vr2o_00
axes(handles.axes1);
set(handles.slider1, 'Value', 1);
set(handles.curFrameLabel, 'String', ['Frame 1 of ',num2str(klt_vr2o_00.TotalFrames)]);
imshow(insertTPs(1, get(handles.tpMeanCB, 'Value')));

% --- Executes on button press in prevf.
function prevf_Callback(hObject, eventdata, handles)
% hObject    handle to prevf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
if round(get(handles.slider1, 'Value')) > 1
    global klt_vr2o_00
    axes(handles.axes1);
    set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) - 1);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(klt_vr2o_00.TotalFrames)]);
    imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));
end

% --- Executes on button press in lastf.
function gotoofi_Callback(hObject, eventdata, handles)
% hObject    handle to lastf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
global klt_vr2o_00
axes(handles.axes1);
set(handles.slider1, 'Value', klt_vr2o_00.TotalFrames);
set(handles.curFrameLabel, 'String', ['Frame ',num2str(klt_vr2o_00.TotalFrames),' of ',num2str(klt_vr2o_00.TotalFrames)]);
imshow(insertTPs(klt_vr2o_00.TotalFrames, get(handles.tpMeanCB, 'Value')));

% --- Executes on button press in nextf.
function nextf_Callback(hObject, eventdata, handles)
% hObject    handle to nextf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end
global klt_vr2o_00
axes(handles.axes1);
if round(get(handles.slider1, 'Value')) < klt_vr2o_00.TotalFrames
    set(handles.slider1,'Value', round(get(handles.slider1, 'Value')) + 1);
    set(handles.curFrameLabel, 'String', ['Frame ', num2str(get(handles.slider1, 'Value')),' of ',num2str(klt_vr2o_00.TotalFrames)]);
    imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));
end

% --- Executes on button press in playf.
function playf_Callback(hObject, eventdata, handles)
% hObject    handle to playf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global klt_vr2o_00
axes(handles.axes1);
if strcmp(get(handles.playf, 'String'), 'Preview') % is stopped
    set(handles.playf, 'String', 'Stop');
else
    set(handles.playf, 'String', 'Preview');
    return;
end
if strcmp(get(handles.playf, 'String'), 'Stop') % can play
    for ii = round(get(handles.slider1, 'Value')):1:klt_vr2o_00.TotalFrames
        if ~strcmp(get(handles.playf, 'String'), 'Stop') % is playing
            break;
        end
            set(handles.slider1, 'Value', ii);
            set(handles.curFrameLabel, 'String', strcat(['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(klt_vr2o_00.TotalFrames)]));
            imshow(insertTPs(ii, get(handles.tpMeanCB, 'Value')));
            drawnow;
            pause(1 / klt_vr2o_00.FPS);
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

global klt_vr2o_00
try    
    toFrame = str2double(char(get(handles.framex, 'String')));
    if toFrame > 0 && toFrame <= klt_vr2o_00.TotalFrames    
        set(handles.slider1, 'Value', toFrame);
        set(handles.curFrameLabel, 'String', ['Frame ', num2str(round(get(handles.slider1,'Value'))),' of ',num2str(klt_vr2o_00.TotalFrames)]);
        imshow(insertTPs(toFrame, get(handles.tpMeanCB, 'Value')));
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


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

global klt_vr2o_00   

% --- Executes on button press in remPoints.
function remPoints_Callback(hObject, eventdata, handles)
% hObject    handle to remPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playf, 'String'), 'Stop')
    return;
end

global klt_tObs_00 klt_undoHist_00 klt_undoSteps_00
rect = getrect(handles.axes1);
curInd = uint16(get(handles.slider1, 'Value'));
stepStarted = false;
for ii = 1:klt_tObs_00
    inS = num2str(ii);
    eval(['global klt_trackPoints_00_', inS]);
    eval(['global klt_PointsValidity_00_', inS]);
    ps = eval(['klt_trackPoints_00_', inS, '(:, :, curInd);']);
    for jj = 1:size(ps,1) % for every point
        if ps(jj,1) >= rect(1) && ps(jj,2) >= rect(2) && ps(jj,1) <= rect(1) + rect(3) && ps(jj,2) <= rect(2) + rect(4)
            %remove point from whole array.
            eval(['klt_PointsValidity_00_', inS,'(jj, :) = 0;']);
            if ~stepStarted
                klt_undoSteps_00(end + 1) = 1;
            else
                klt_undoSteps_00(end) = klt_undoSteps_00(end) + 1;
            end
            stepStarted = true;
            klt_undoHist_00(end + 1,:) = [ii, jj];
        end
    end    
end
imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global klt_tObs_00 klt_undoHist_00 klt_undoSteps_00 klt_redoHist_00 klt_redoSteps_00
if length(klt_undoSteps_00) > 0
    for jj = 1:klt_undoSteps_00(end)
        for ii = 1:klt_tObs_00
            inS = num2str(ii);
            eval(['global klt_PointsValidity_00_', inS]);
        end
        eval(['klt_PointsValidity_00_',num2str(klt_undoHist_00(end, 1)),'(',num2str(klt_undoHist_00(end, 2)),', :) = 1;']);
        klt_undoHist_00(end, :) = [];
    end
end
klt_undoSteps_00(end) = [];
imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));


% --- Executes on button press in tpMeanCB.
function tpMeanCB_Callback(hObject, eventdata, handles)
% hObject    handle to tpMeanCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tpMeanCB

imshow(insertTPs(uint16(round(get(handles.slider1,'Value'))), get(handles.tpMeanCB, 'Value')));
