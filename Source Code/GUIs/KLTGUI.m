function varargout = KLTGUI(varargin)
% KLTGUI MATLAB code for KLTGUI.fig
%      KLTGUI, by itself, creates a new KLTGUI or raises the existing
%      singleton*.
%
%      H = KLTGUI returns the handle to a new KLTGUI or the handle to
%      the existing singleton*.
%
%      KLTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KLTGUI.M with the given input arguments.
%
%      KLTGUI('Property','Value',...) creates a new KLTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KLTGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KLTGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KLTGUI

% Last Modified by GUIDE v2.5 01-Jan-2019 14:25:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KLTGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @KLTGUI_OutputFcn, ...
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


% --- Executes just before KLTGUI is made visible.
function KLTGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KLTGUI (see VARARGIN)

% Choose default command line output for KLTGUI
evalin('base', 'global klt_gui_handle_00')
global klt_gui_handle_00
klt_gui_handle_00 = hObject;
handles.output = hObject;
axes(handles.axes1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KLTGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KLTGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in autoUpdateCB.
function autoUpdateCB_Callback(hObject, eventdata, handles)
% hObject    handle to autoUpdateCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoUpdateCB


% --- Executes on button press in showTrailCB.
function showTrailCB_Callback(hObject, eventdata, handles)
% hObject    handle to showTrailCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showTrailCB


% --- Executes on button press in showAllPointsCB.
function showAllPointsCB_Callback(hObject, eventdata, handles)
% hObject    handle to showAllPointsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showAllPointsCB


% --- Executes on button press in beginB.
function beginB_Callback(hObject, eventdata, handles)
% hObject    handle to beginB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.abortB, 'Enable', 'on')
KLTGUI_Begin;

global klt_gui_handle_00
handle = klt_gui_handle_00;
evalin('base', 'clear klt_gui_handle_00');

close(handle);

% --- Executes on button press in abortB.
function abortB_Callback(hObject, eventdata, handles)
% hObject    handle to abortB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.abortB, 'Enable', 'off');

% --- Executes on button press in getDataB.
function getDataB_Callback(hObject, eventdata, handles)
% hObject    handle to getDataB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
