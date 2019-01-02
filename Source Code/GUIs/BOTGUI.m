function varargout = BOTGUI(varargin)
% BOTGUI MATLAB code for BOTGUI.fig
%      BOTGUI, by itself, creates a new BOTGUI or raises the existing
%      singleton*.
%
%      H = BOTGUI returns the handle to a new BOTGUI or the handle to
%      the existing singleton*.
%
%      BOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOTGUI.M with the given input arguments.
%
%      BOTGUI('Property','Value',...) creates a new BOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BOTGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BOTGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BOTGUI

% Last Modified by GUIDE v2.5 01-Jan-2019 18:16:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BOTGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BOTGUI_OutputFcn, ...
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


% --- Executes just before BOTGUI is made visible.
function BOTGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BOTGUI (see VARARGIN)

% Choose default command line output for BOTGUI
handles.output = hObject;

% Update handles structure

guidata(hObject, handles);
evalin('base', 'global bot_gui_handle_00')
global bot_gui_handle_00
bot_gui_handle_00 = hObject;
handles.output = hObject;
axes(handles.axes1);


% --- Outputs from this function are returned to the command line.
function varargout = BOTGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in autoUpdateL.
function autoUpdateL_Callback(hObject, eventdata, handles)
% hObject    handle to autoUpdateL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoUpdateL



% --- Executes on button press in beginB.
function beginB_Callback(hObject, eventdata, handles)
% hObject    handle to beginB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.abortB, 'Enable', 'on')
BOTGUI_Begin;

global bot_guiHandle_00
handle = bot_guiHandle_00;
close(bot_guiHandle_00);
evalin('base', 'clear klt_gui_handle_00');

% --- Executes on button press in abortB.
function abortB_Callback(hObject, eventdata, handles)
% hObject    handle to abortB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.abortB, 'Enable', 'off');