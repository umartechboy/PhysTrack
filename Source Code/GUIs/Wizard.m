function varargout = Wizard(varargin)
% WIZARD MATLAB code for Wizard.fig
%      WIZARD, by itself, creates a new WIZARD or raises the existing
%      singleton*.
%
%      H = WIZARD returns the handle to a new WIZARD or the handle to
%      the existing singleton*.
%
%      WIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD.M with the given input arguments.
%
%      WIZARD('Property','Value',...) creates a new WIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Wizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Wizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Wizard

% Last Modified by GUIDE v2.5 02-Jan-2019 15:53:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Wizard_OpeningFcn, ...
                   'gui_OutputFcn',  @Wizard_OutputFcn, ...
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


% --- Executes just before Wizard is made visible.
function Wizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Wizard (see VARARGIN)

% Choose default command line output for Wizard
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
evalin('base', 'global wizard_00_sections');
global wizard_00_sections
wizard_00_sections = varargin{1};
for ii = 2:11
   set(eval(['handles.b', num2str(ii)]), 'Enable', 'off');
end
for ii = 1:length(wizard_00_sections)
    set(eval(['handles.b', num2str(ii)]), 'String', wizard_00_sections(ii).Title);
end

for ii = length(wizard_00_sections)+1:1:11
    set(eval(['handles.b', num2str(ii)]), 'Visible', 'off');
end

% UIWAIT makes Wizard wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Wizard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b1.
function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b2.
function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b3.
function b3_Callback(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b4.
function b4_Callback(hObject, eventdata, handles)
% hObject    handle to b4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b5.
function b5_Callback(hObject, eventdata, handles)
% hObject    handle to b5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b6.
function b6_Callback(hObject, eventdata, handles)
% hObject    handle to b6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b7.
function b7_Callback(hObject, eventdata, handles)
% hObject    handle to b7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b8.
function b8_Callback(hObject, eventdata, handles)
% hObject    handle to b8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in enableAllB.
function enableAllB_Callback(hObject, eventdata, handles)
% hObject    handle to enableAllB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global wizard_00_sections
for ii = 1:length(wizard_00_sections)
    set(eval(['handles.b', num2str(ii)]), 'Enable', 'on');
end


% --- Executes on button press in b9.
function b9_Callback(hObject, eventdata, handles)
% hObject    handle to b9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b10.
function b10_Callback(hObject, eventdata, handles)
% hObject    handle to b10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in b11.
function b11_Callback(hObject, eventdata, handles)
% hObject    handle to b11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WizardStep;


% --- Executes on button press in clearall.
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all force

% --- Executes on button press in closeAllFigures.
function closeAllFigures_Callback(hObject, eventdata, handles)
% hObject    handle to closeAllFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PhysTrack.closeAll;

% --- Executes on button press in plotWhiteB.
function plotWhiteB_Callback(hObject, eventdata, handles)
% hObject    handle to plotWhiteB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

whitebg([1,1,1])

% --- Executes on button press in plotBlackB.
function plotBlackB_Callback(hObject, eventdata, handles)
% hObject    handle to plotBlackB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

whitebg([0,0,0])


% --- Executes on button press in cascadeB.
function cascadeB_Callback(hObject, eventdata, handles)
% hObject    handle to cascadeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PhysTrack.cascade
