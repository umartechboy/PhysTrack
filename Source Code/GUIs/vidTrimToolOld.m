function varargout = vidTrimToolOld(varargin)
%VIDTRIMTOOLOLD M-file for vidTrimToolOld.fig
%      VIDTRIMTOOLOLD, by itself, creates a new VIDTRIMTOOLOLD or raises the existing
%      singleton*.
%
%      H = VIDTRIMTOOLOLD returns the handle to a new VIDTRIMTOOLOLD or the handle to
%      the existing singleton*.
%
%      VIDTRIMTOOLOLD('Property','Value',...) creates a new VIDTRIMTOOLOLD using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to vidTrimToolOld_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VIDTRIMTOOLOLD('CALLBACK') and VIDTRIMTOOLOLD('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VIDTRIMTOOLOLD.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vidTrimToolOld

% Last Modified by GUIDE v2.5 10-Sep-2018 13:25:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vidTrimToolOld_OpeningFcn, ...
                   'gui_OutputFcn',  @vidTrimToolOld_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before vidTrimToolOld is made visible.
function vidTrimToolOld_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for vidTrimToolOld
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vidTrimToolOld wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vidTrimToolOld_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in firstf.
function firstf_Callback(hObject, eventdata, handles)
% hObject    handle to firstf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gotoifi.
function gotoifi_Callback(hObject, eventdata, handles)
% hObject    handle to gotoifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in prevf.
function prevf_Callback(hObject, eventdata, handles)
% hObject    handle to prevf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in playf.
function playf_Callback(hObject, eventdata, handles)
% hObject    handle to playf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in nextf.
function nextf_Callback(hObject, eventdata, handles)
% hObject    handle to nextf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gotoofi.
function gotoofi_Callback(hObject, eventdata, handles)
% hObject    handle to gotoofi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on gotoofi and none of its controls.
function gotoofi_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to gotoofi (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lastf.
function lastf_Callback(hObject, eventdata, handles)
% hObject    handle to lastf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gotoxB.
function gotoxB_Callback(hObject, eventdata, handles)
% hObject    handle to gotoxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in markifi.
function markifi_Callback(hObject, eventdata, handles)
% hObject    handle to markifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in markofi.
function markofi_Callback(hObject, eventdata, handles)
% hObject    handle to markofi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in closeB.
function closeB_Callback(hObject, eventdata, handles)
% hObject    handle to closeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function framex_Callback(hObject, eventdata, handles)
% hObject    handle to framex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framex as text
%        str2double(get(hObject,'String')) returns contents of framex as a double


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


% --- Executes on button press in rotate0RB.
function rotate0RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate0RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate0RB


% --- Executes on button press in rotate90RB.
function rotate90RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate90RB


% --- Executes on button press in rotate180RB.
function rotate180RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate180RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate180RB


% --- Executes on button press in rotate270RB.
function rotate270RB_Callback(hObject, eventdata, handles)
% hObject    handle to rotate270RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate270RB
