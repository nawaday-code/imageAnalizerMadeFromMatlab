function varargout = dicomexport(varargin)
% DICOMEXPORT MATLAB code for dicomexport.fig
%      DICOMEXPORT, by itself, creates a new DICOMEXPORT or raises the existing
%      singleton*.
%
%      H = DICOMEXPORT returns the handle to a new DICOMEXPORT or the handle to
%      the existing singleton*.
%
%      DICOMEXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOMEXPORT.M with the given input arguments.
%
%      DICOMEXPORT('Property','Value',...) creates a new DICOMEXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dicomexport_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dicomexport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dicomexport

% Last Modified by GUIDE v2.5 05-Sep-2014 17:43:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dicomexport_OpeningFcn, ...
                   'gui_OutputFcn',  @dicomexport_OutputFcn, ...
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


% --- Executes just before dicomexport is made visible.
function dicomexport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dicomexport (see VARARGIN)

% Choose default command line output for dicomexport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dicomexport wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dicomexport_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function SarchCrit_Callback(hObject, eventdata, handles)
% hObject    handle to SarchCrit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SarchCrit as text
%        str2double(get(hObject,'String')) returns contents of SarchCrit as a double


% --- Executes during object creation, after setting all properties.
function SarchCrit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SarchCrit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Sarch.
function Sarch_Callback(hObject, eventdata, handles)
% hObject    handle to Sarch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = getVnames;
h_f_d1 = findobj('tag','VarNameList');
set(h_f_d1,'String',list);

% --- Executes on selection change in VarNameList.
function VarNameList_Callback(hObject, eventdata, handles)
% hObject    handle to VarNameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VarNameList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VarNameList


% --- Executes during object creation, after setting all properties.
function VarNameList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VarNameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StudyDescription_Callback(hObject, eventdata, handles)
% hObject    handle to StudyDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StudyDescription as text
%        str2double(get(hObject,'String')) returns contents of StudyDescription as a double


% --- Executes during object creation, after setting all properties.
function StudyDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StudyDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StudyID_Callback(hObject, eventdata, handles)
% hObject    handle to StudyID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StudyID as text
%        str2double(get(hObject,'String')) returns contents of StudyID as a double


% --- Executes during object creation, after setting all properties.
function StudyID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StudyID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ProtocolName_Callback(hObject, eventdata, handles)
% hObject    handle to ProtocolName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProtocolName as text
%        str2double(get(hObject,'String')) returns contents of ProtocolName as a double


% --- Executes during object creation, after setting all properties.
function ProtocolName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProtocolName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ManufacturerModelName_Callback(hObject, eventdata, handles)
% hObject    handle to ManufacturerModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ManufacturerModelName as text
%        str2double(get(hObject,'String')) returns contents of ManufacturerModelName as a double


% --- Executes during object creation, after setting all properties.
function ManufacturerModelName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManufacturerModelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PatientBirthDate_Callback(hObject, eventdata, handles)
% hObject    handle to PatientBirthDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PatientBirthDate as text
%        str2double(get(hObject,'String')) returns contents of PatientBirthDate as a double


% --- Executes during object creation, after setting all properties.
function PatientBirthDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PatientBirthDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PatientID_Callback(hObject, eventdata, handles)
% hObject    handle to PatientID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PatientID as text
%        str2double(get(hObject,'String')) returns contents of PatientID as a double


% --- Executes during object creation, after setting all properties.
function PatientID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PatientID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FamilyName_Callback(hObject, eventdata, handles)
% hObject    handle to FamilyName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FamilyName as text
%        str2double(get(hObject,'String')) returns contents of FamilyName as a double


% --- Executes during object creation, after setting all properties.
function FamilyName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FamilyName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in flip4sliice.
function flip4sliice_Callback(hObject, eventdata, handles)
% hObject    handle to flip4sliice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns flip4sliice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from flip4sliice


% --- Executes during object creation, after setting all properties.
function flip4sliice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flip4sliice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SequenceName_Callback(hObject, eventdata, handles)
% hObject    handle to SequenceName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SequenceName as text
%        str2double(get(hObject,'String')) returns contents of SequenceName as a double


% --- Executes during object creation, after setting all properties.
function SequenceName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SequenceName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionTime_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RepetitionTime as text
%        str2double(get(hObject,'String')) returns contents of RepetitionTime as a double


% --- Executes during object creation, after setting all properties.
function RepetitionTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EchoTime_Callback(hObject, eventdata, handles)
% hObject    handle to EchoTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EchoTime as text
%        str2double(get(hObject,'String')) returns contents of EchoTime as a double


% --- Executes during object creation, after setting all properties.
function EchoTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EchoTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SpacingBetweenSlices_Callback(hObject, eventdata, handles)
% hObject    handle to SpacingBetweenSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SpacingBetweenSlices as text
%        str2double(get(hObject,'String')) returns contents of SpacingBetweenSlices as a double


% --- Executes during object creation, after setting all properties.
function SpacingBetweenSlices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpacingBetweenSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SliceThickness_Callback(hObject, eventdata, handles)
% hObject    handle to SliceThickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SliceThickness as text
%        str2double(get(hObject,'String')) returns contents of SliceThickness as a double


% --- Executes during object creation, after setting all properties.
function SliceThickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceThickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumberOfPhaseEncodingStep_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfPhaseEncodingStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberOfPhaseEncodingStep as text
%        str2double(get(hObject,'String')) returns contents of NumberOfPhaseEncodingStep as a double


% --- Executes during object creation, after setting all properties.
function NumberOfPhaseEncodingStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfPhaseEncodingStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PercentPhaseFieldOfView_Callback(hObject, eventdata, handles)
% hObject    handle to PercentPhaseFieldOfView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PercentPhaseFieldOfView as text
%        str2double(get(hObject,'String')) returns contents of PercentPhaseFieldOfView as a double


% --- Executes during object creation, after setting all properties.
function PercentPhaseFieldOfView_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PercentPhaseFieldOfView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PixelSpacing_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSpacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PixelSpacing as text
%        str2double(get(hObject,'String')) returns contents of PixelSpacing as a double


% --- Executes during object creation, after setting all properties.
function PixelSpacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSpacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DirPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to DirPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DirPrefix as text
%        str2double(get(hObject,'String')) returns contents of DirPrefix as a double


% --- Executes during object creation, after setting all properties.
function DirPrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DirPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir = uigetdir(strcat(pwd,'�ۑ��t�H���_�̎w��')) ;
h = findobj('tag','DirPrefix');
set(h,'string',dir);


% --- Executes on button press in AutoComp.
function AutoComp_Callback(hObject, eventdata, handles)
% hObject    handle to AutoComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PresetNumber = double(getPresetFlag);
Info = PresetValue(PresetNumber);

h_w_min = findobj('tag','StudyID');
set(h_w_min,'String',Info.StudyID);

h_w_min = findobj('tag','ProtocolName');
set(h_w_min,'String',Info.ProtocolName);

h_w_min = findobj('tag','ManufacturerModelName');
set(h_w_min,'String',Info.ManufacturerModelName);

h_w_min = findobj('tag','PatientID');
set(h_w_min,'String',Info.PatientID);

h_w_min = findobj('tag','PatientBirthDate');
set(h_w_min,'String',Info.PatientBirthDate);

h_w_min = findobj('tag','RepetitionTime');
set(h_w_min,'String',Info.RepetitionTime);

h_w_min = findobj('tag','EchoTime');
set(h_w_min,'String',Info.EchoTime);

h_w_min = findobj('tag','SequenceName');
set(h_w_min,'String',Info.SequenceName);

h_w_min = findobj('tag','SliceThickness');
set(h_w_min,'String',Info.SliceThickness);

h_w_min = findobj('tag','SpacingBetweenSlices');
set(h_w_min,'String',Info.SpacingBetweenSlices);

h_w_min = findobj('tag','NumberOfPhaseEncodingStep');
set(h_w_min,'String',Info.NumberOfPhaseEncodingStep);

h_w_min = findobj('tag','PercentPhaseFieldOfView');
set(h_w_min,'String',Info.PercentPhaseFieldOfView);

h_w_min = findobj('tag','PixelSpacing1');
set(h_w_min,'String',Info.PixelSpacing_Y_Direction);

h_w_min = findobj('tag','PixelSpacing2');
set(h_w_min,'String',Info.PixelSpacing_X_Direction);

h_w_min = findobj('tag','StudyDescription');
set(h_w_min,'String',Info.StudyDescription);

h_w_min = findobj('tag','FamilyName');
set(h_w_min,'String',Info.FamilyName);        


% --- Executes on button press in StartExport.
function StartExport_Callback(hObject, eventdata, handles)
% hObject    handle to StartExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[names,savedir,settings] = getSettings;
% names % for Debug
mautoDicomExport(names,savedir,settings)

function PixelSpacing1_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSpacing1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function PixelSpacing1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSpacing1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PixelSpacing2_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSpacing2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function PixelSpacing2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSpacing2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function [names,savedir,settings] = getSettings

% �ϐ��f�[�^�擾
names = getVnames;

% StudyDescription�擾
h_f_d1 = findobj('tag','StudyDescription');
n_f_d1 = get(h_f_d1,'String');
settings.StudyDescription = n_f_d1; 

% StudyID�擾
h_f_d1 = findobj('tag','StudyID');
n_f_d1 = get(h_f_d1,'String');
settings.StudyID = n_f_d1; 

% ProtocolName�擾
h_f_d1 = findobj('tag','ProtocolName');
n_f_d1 = get(h_f_d1,'String');
settings.ProtocolName = n_f_d1; 

% ManufacturerModelName �擾
h_f_d1 = findobj('tag','ManufacturerModelName');
n_f_d1 = get(h_f_d1,'String');
settings.ManufacturerModelName = n_f_d1; 

% FamilyName �擾
h_f_d1 = findobj('tag','FamilyName');
n_f_d1 = get(h_f_d1,'String');
settings.FamilyName = n_f_d1; 

% PatientID �擾
h_f_d1 = findobj('tag','PatientID');
n_f_d1 = get(h_f_d1,'String');
settings.PatientID = n_f_d1; 

% PatientBirthDate �擾
h_f_d1 = findobj('tag','PatientBirthDate');
n_f_d1 = get(h_f_d1,'String');
settings.PatientBirthDate = n_f_d1; 


% RepetitionTime �擾
h_f_d1 = findobj('tag','RepetitionTime');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.RepetitionTime = n_f_d1; 

% EchoTime �擾
h_f_d1 = findobj('tag','EchoTime');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.EchoTime = n_f_d1; 

% SequenceName �擾
h_f_d1 = findobj('tag','SequenceName');
n_f_d1 = get(h_f_d1,'String');
settings.SequenceName = n_f_d1; 

% SliceThickness �擾
h_f_d1 = findobj('tag','SliceThickness');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.SliceThickness = n_f_d1; 

% SpacingBetweenSlices �擾
h_f_d1 = findobj('tag','SpacingBetweenSlices');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.SpacingBetweenSlices = n_f_d1; 

% NumberOfPhaseEncodingStep �擾
h_f_d1 = findobj('tag','NumberOfPhaseEncodingStep');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.NumberOfPhaseEncodingStep = n_f_d1; 

% PercentPhaseFieldOfView �擾
h_f_d1 = findobj('tag','PercentPhaseFieldOfView');
n_f_d1 = str2double(get(h_f_d1,'String'));
settings.PercentPhaseFieldOfView = n_f_d1; 

% PixelSpacing �擾
h_f_d1 = findobj('tag','PixelSpacing1');
h_f_d2 = findobj('tag','PixelSpacing2');
n_f_d1 = str2double(get(h_f_d1,'String'));
n_f_d2 = str2double(get(h_f_d2,'String'));

settings.PixelSpacing = [n_f_d1,n_f_d2]; 


% �摜�o�̓p�����[�^  
  settings.viewMsgBox = 0;
%   settings.maximum = 1;
%   settings.minimum  = 0;

% flip4sliice �擾

settings.flip4sliice = double(logical(getFlip4sliice)); 

% �ۑ��f�B���N�g�� �擾
h_f_d1 = findobj('tag','DirPrefix');
head = get(h_f_d1,'String');
savedir = datestr(now,'yyyy-mmdd-HHMM');
savedir = strcat(head,'\',savedir,'-DICOM_export');
mkdir(savedir);
  

function list = getVnames
h_f_d1 = findobj('tag','SarchCrit');
str = get(h_f_d1,'String');
str = sprintf('who(''%s'')',str);
list = evalin('base',str);

function ret = getPresetFlag
h_f_d1 = findobj('tag','flip4sliice');
% str = get(h_f_d1,'String');
val = get(h_f_d1,'Value');
ret = val-1;

function ret = getFlip4sliice
n = getPresetFlag;
Info = PresetValue(n);
ret = Info.Flip4Slice;
%{
% h_f_d1 = findobj('tag','flip4sliice');
% % str = get(h_f_d1,'String');
% val = get(h_f_d1,'Value');
% ret = (abs(val-2) + val-2)/2;
% if strcmp(n_f_d1,'�I�����Ă�������'); ret = 0; end;
% if strcmp(n_f_d1,'����{�����e�B�A'); ret = 0; end;
% if strcmp(n_f_d1,'���l�t�@���g��'); ret = 1; end;
% if strcmp(n_f_d1,'�}�\�p�f�[�^'); ret = 2; end;
% ret
%}


function mautoDicomExport(datanames,savedir,settings)
% 
% 
% autoDicomExport(datanames,savedir,settings)
% 
% %%%%   ����   %%%% 
% datanames: �ۑ�����ϐ��� or �ϐ������X�g (char or cell) 
% settings�F �ۑ��̐ݒ�l�B���L�̃e���v���[�g���g�p�̂��ƁB
% savedir�F �ۑ��f�B���N�g���B���͂̂Ȃ��ꍇ��pwd�Ƀt�H���_�����܂��B
% 
% �E���͂����ϐ�������Ȃ�̐ݒ��DICOM�ɏ����o���܂��B
% �E1�ϐ� = 1series�Ƃ��ĕۑ�
% �Edatanames�������̏ꍇ�A������1study�Ƃ��ĕۑ�
% 
% %%%% settings �e���v���[�g %%%% 
% settings.StudyDescription = '******';
% settings.FamilyName = '******';
% settings.RepetitionTime = 99;
% settings.EchoTime = 9;
% settings.SequenceName = 'simulation';
% settings.SliceThickness = 1;
% settings.SpacingBetweenSlices = 1;
% settings.PatientID = '';
% settings.PatientBirthDate = '19000101';
% settings.PercentPhaseFieldOfView = 100;
% settings.NumberOfPhaseEncodingStep = 999999;
% settings.ProtocolName = '******';
% settings.StudyID = datestr(floor(now),'yyyy-mmdd-HHMM');
% settings.PixelSpacing = [1,1];
% settings.ManufacturerModelName = '********';
% settings.viewMsgBox = 1;
% settings.maximum = 300;
% 
% %%%% �t�H���_�쐬 �e���v���[�g %%%% 
% head = 'dir';
% savedir = datestr(now,'yyyy-mmdd-HHMM');
% savedir = strcat(head,'\',savedir,'-DICOM_export');
% mkdir(savedir);
% 
%       2014-0222 written by T.Saito
% 
% 
% 
% ��y�͂��Ώo����q�ł���B 
% �@�@�@�@����
% �@�@�@�i�L��֥�j
% �@�@ �Q|�@���^(�Q�Q_
% �@�^�@��-(�Q�Q�Q_�^
% �@�P�P�P�P�P�P�P
% �@���C�͂܂��Ȃ�
% 
% �@�@ ���܁^�R-�A�Q_
% �@�^��_/�Q�Q�Q�Q �^
% �@�P�P�P�P�P�P�P

disp('DICOM�����o����������...');


% disp(' ��y�͂��Ώo����q�ł���B ');
dispneko(1);


% www = waitbar(0,'DICOM�����o����������...','Name','autoDicomExport'); %%����forgui
%% �����̃`�F�b�N
if iscell(datanames)
    indmax = numel(datanames);
elseif ischar(datanames)
    indmax = 1;
    datanames = cellstr(datanames);
else
    hoge = whos('datanames');
    hoge = hoge.class;
    error(strcat('datanames�ɂȂ񂩕ςȒl�������Ă܂�(�N���X�F',hoge,'�j'));
end

if nargin < 3
% default settings  
settings.StudyDescription = '******';
settings.FamilyName = '******';
settings.RepetitionTime = 99;
settings.EchoTime = 9;
settings.SequenceName = 'simulation';
settings.SliceThickness = 1;
settings.SpacingBetweenSlices = 1;
settings.PatientID = '';
settings.PatientBirthDate = '19000101';
settings.PercentPhaseFieldOfView = 100;
settings.NumberOfPhaseEncodingStep = 999999;
settings.ProtocolName = '******';
settings.StudyID = datestr(floor(now),'yyyy-mmdd-HHMM');
settings.PixelSpacing = [1,1];
settings.ManufacturerModelName = '********';
settings.viewMsgBox = 1;

end
if nargin <2
% default save directory  
hoge = datestr(now,'yyyy-mmdd-HHMM');
hogedir = strcat(hoge,'-DICOM_export');
mkdir(hogedir);
hogedir = strcat(pwd,'\',hogedir);
savedir = hogedir;
end

% window����
savedata = evalin('base',datanames{1});

if not(isfield(settings,'maximum'));
settings.maximum = abs(max(savedata(:)));
end
if not(isfield(settings,'minimum'));
settings.minimum = abs(min(savedata(:)));
end

if not(isfield(settings,'flip4sliice'));
settings.flip4sliice = 0;
end

maximum = settings.maximum;
minimum = settings.minimum;
RRRR = floor(log10(65535/maximum));
RRRR = 10^RRRR;



for hogehoge = 1:1 % �L���b�L���b�L���b �j���[�@�̂Ƃ��� (�܂������s�v�ȕ���)
T = 60/110; % �P���̒���(sec)
T2 = 60/30; % �P���̒���(sec)
B = 4; % ���q
nyflag = (rand(1,1)>=0.99);
if nyflag
    nyaa = '(�v�E�ցE)�v���[�I';    
    T = 60/60; % �P���̒���(sec)
else
    nyaa = '(���f�ցf) �����';
end

mTime = T;
mTime2 = T2;
T_count = 0;
T_count2 = 0;
neko = getNeko(T_count2,1);

end

for hogehoge = 1:1  % ����DICOM�w�b�_�[�̐���

Info = InitiDicomInfo; % ����B
Info.InstanceCreationDate = datestr(floor(now),'yyyymmdd');
Info.InstanceCreationTime = datestr(floor(now),'HHMMSS');
Info.StudyDate = datestr(floor(now),'yyyymmdd');
Info.SeriesDate = Info.StudyDate;
Info.AcquisitionDate = Info.StudyDate;
Info.StudyTime = datestr(floor(now),'HHMMSS');
% Info.AccessionNumber = strcat(datestr(now,'mmdd-HHMM'),sprintf('-x%d',RRRR));
RRRRR = round(log10(RRRR));
Info.AccessionNumber = strcat(datestr(now,'mmdd-HHMM'),sprintf('-x10^%d',RRRRR));
Info.StudyDescription = settings.StudyDescription;
Info.PatientName.FamilyName  = settings.FamilyName;
Info.RepetitionTime = settings.RepetitionTime;
Info.EchoTime = settings.EchoTime;
Info.SequenceName = settings.SequenceName;
Info.SliceThickness = settings.SliceThickness;
Info.SpacingBetweenSlices = settings.SpacingBetweenSlices;
Info.PatientID = settings.PatientID;
Info.PatientBirthDate = settings.PatientBirthDate;
Info.InPlanePhaseEncodingDirection = 'ROW';
Info.FlipAngle = 90;
Info.SAR = 0;
Info.ImageOrientationPatient = [1;0;0;0;1;0];
Info.PercentPhaseFieldOfView = settings.PercentPhaseFieldOfView;
Info.NumberOfPhaseEncodingSteps = settings.NumberOfPhaseEncodingStep;
Info.ReconstructionDiameter = 102.4;
Info.PixelBandwidth = 999;
Info.EchoNumber = 1;
Info.NumberOfAverages = 1;
Info.ProtocolName = settings.ProtocolName;
Info.StudyID = settings.StudyID;
Info.PixelSpacing = settings.PixelSpacing;
Info.ManufacturerModelName = settings.ManufacturerModelName;
% Info.StudyInstanceUID = '1.2.392.200036.9116.4.2.7090.1467.20131025083820238.2.35';
Info.StudyInstanceUID = dicomuid; % 
Info.SmallestImagePixelValue = minimum*RRRR;
Info.LargestImagePixelValue = maximum*RRRR;
minimum = Info.SmallestImagePixelValue;
maximum = Info.LargestImagePixelValue;
end

% disp(' �@���C�͂܂��Ȃ�');
dispneko(2);


% fprintf('�ۑ��f�B���N�g���F%s\n',savedir);
% pause(1)

tic
for indx = 1:indmax
    tmpdataname = datanames{indx};
    hogestr = strrep(tmpdataname,'_',' ');
    savedata = abs(evalin('base',tmpdataname))*RRRR;
    N = size(savedata);
    fprintf('\nNo.%d : %s �������o����...\n',indx,tmpdataname);

    for hogehoge = 1:1 % DICOM�^�O�̕ҏW
    Info.SeriesTime = datestr(floor(now),'HHMMSS');
    Info.AcquisitionTime = datestr(floor(now),'HHMMSS');
    Info.SeriesDescription = tmpdataname;
    Info.SeriesNumber = indx;
    Info.AcquisitionNumber = indx;
    Info.InstanceNumber = indx;
    Info.SeriesID = indx ;% �C�ӁH
    Info.StackID = indx;
    % Info.SeriesInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1002';
    Info.SeriesInstanceUID = dicomuid;

    Info.Rows = N(2);
    Info.Columns = N(1);

    %{
    Info.SmallestImagePixelValue = abs(min(savedata(:)));
    Info.LargestImagePixelValue = abs(max(savedata(:)));
    Info.SmallestImagePixelValue = minimum*RRRR;
    Info.LargestImagePixelValue = maximum*RRRR;
    minimum = Info.SmallestImagePixelValue;
    maximum = Info.LargestImagePixelValue;
    %}
    
    Info.RescaleSlope = (maximum-minimum);
    Info.RescaleIntercept = minimum;
    Info.RescaleType = 'normalized';
    Info.WindowCenter = (maximum+minimum)/2;
    Info.WindowWidth = maximum-minimum;

if settings.flip4sliice
    savedata = flipdim(uint16(abs(savedata)),3);
else
    savedata = uint16(abs(savedata));
end
    refuid = dicomuid;
    Info.FrameOfReferenceUID = refuid;        
    end
%     for hogehoge = 1:1 % ����Ȃ�����(�N�\�l�~�\��)
%     if rand(1,1) <= 0.2;
%     dispneko(1);
%     else
%     dispneko(2);
%     end
%     end
% neko = getNeko(indx,1);

sz3 = size(savedata,3);
    
        for n = 1:sz3
            if n == 1
                Info.SOPinstanceUID = refuid;
            else     
                Info.SOPinstanceUID = dicomuid;        
            end
            Info.ImagePositionPatient = [0;0;Info.SpacingBetweenSlices * (n-1)];
            Info.SliceLocation = Info.SpacingBetweenSlices * (n-1);


        %% �������݁I
            dicomwrite(abs(savedata(:,:,n)),strcat(savedir,'\',sprintf('%s_%04d',tmpdataname,n),'.dcm'),Info);

                    for hogehoge = 1:1 % �A�C���[�X�V(�s�v�j
    ttiimmee = toc;
    ttiimmee2 = ttiimmee;
    dTime = ttiimmee - mTime;
    dTime2 = ttiimmee2 - mTime2;

    if dTime2 > T2
        mTime2 = ttiimmee2;
        T_count2 = T_count2+1;
        neko = getNeko(T_count2,1);
    end
    
    
    if dTime > T; 
        mTime = ttiimmee;
        T_count = T_count+1;
        B_count = mod(T_count,B);
    if nyflag
        switch B_count
            case 0
                nyaa = '(�v�E�ցE)�v���[�I';
            case 1
                nyaa = ' (/�E�ցE)/�ɂ�[�I';
            case 2
                nyaa = '(�v�E�ցE)�v���[�I';
            case 3
                nyaa = ' (/�E�ցE)/�ɂ�[�I';
        end
    else 
        switch B_count
            case 0
                nyaa = '(���f�ցf) �����';
            case 1
                nyaa = '(�f�ցf��) �����';
            case 2
                nyaa = '(���f�ցf) �����';
            case 3
                nyaa = '( �f�ցf) �j���A';
        end
    end
    end
                    end
%{
                    for hogehoge = 1:1 % waitbar�X�V
    waitbar(n/sz3,www,sprintf(...
        'Writing " %s " (x10^%d, %d/%d, rem %d)\n %s  %s'...
        ,hogestr,RRRRR,n,sz3,(indmax-indx+1),nyaa,nyaa...
        ));
                    end
%} 
                    %%����forgui

 
                    for hogehoge = 1:1 % �X�e�[�^�X�X�V
                        setStr1(sprintf('Writing " %s "',hogestr))
                        setStr2(sprintf('scale : x10^%d,  slice : %d/%d',RRRRR,n,sz3))
                        setStr3(sprintf('�c��ϐ� %d �R',(indmax-indx+1)))
                        setAA(strcat(nyaa,' ',nyaa))
                        setAA2(neko)
                        drawnow;
                    end

        end
end

% close(www) %%����forgui

if settings.viewMsgBox
 msgbox('DICOM�ւ̏����o�����I�����܂����B','autoDicomExport');
 disp('completed.')
else
 disp('DICOM�����o�������B');
end
                        setStr1(sprintf('�����o���I�����܂����B'))
                        setStr2('')
                        setStr3(sprintf('�M���l�� 10^%d �{���ĕۑ����܂����B',RRRRR))
                        setAA(strcat('(�L��֥`)'))
                        setAA2(getNeko(1,0))
                        drawnow;




function ret = InitiDicomInfo



ret.Format = 'DICOM';
ret.BitDepth = 16;
ret.ColorType = 'grayscale';
ret.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.4'; % 
ret.MediaStorageSOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
% ret.FileMetaInformationVersion = '�v���p';
% ret.TransferSyntaxUID = '1.2.840.10008.1.2.1'; % �G���f�B�A�����w��H���⑼�ɂ����낢�날��炵�����ǁB�l��'Implicit'
ret.mplementationClassUID =  '1.2.392.200036.9116.4.2.10'; % ����MRI��UID���ؗp�B�����炢�̈Ӗ��炵���BISO.�o�ώY�Ə�.���{�H�ƕW��������.���Ń��f�B�J���V�X�e���Y.(�x���_�[��`)
ret.ImplementationVersionName = 'TM_MR_DCM_V3.0'; % �s��
ret.ImageType = 'ORIGINAL\PRIMARY\GDC';
ret.InstanceCreatorUID = '1.2.392.200036.9116.4.2.7090';
ret.SOPClassUID = '1.2.840.10008.5.1.4.1.1.4';
ret.SOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
ret.Modality = 'MR';
ret.Manufacturer = '*******'; % ����ǂ��Ȃ񂾂낤�ˁc
ret.InstitutionName = 'Tohoku University School of Medicine';
ret.ManufacturerModelName = '******';
ret.PatientBirthDate = '19000101'; % �{���͈Ⴂ�܂��B
ret.PatientSex = 'M';
ret.BodyPartExamined = 'HEAD'; % �Ƃ肠���������Œ�ŁB
ret.ScanningSequence = 'GR'; % �K�v�ɉ����ĉ���
ret.SequenceVariant = 'NONE';
ret.MRAcquisitionType = '3D';
ret.ImagingFrequency = 123.1975; % �v����
ret.MagneticFieldStrength = 3; % �v����
ret.DeviceSerialNumber = '7090'; % �ؗp
ret.SoftwareVersion = 'V2.21*R001'; % �ؗp
ret.ReceiveCoilName = 'Atlas Head'; % ���΂炭����ł������낤
ret.PatientPosition = 'HFS'; % ���΂炭����ł������낤
% Private_0019_100b: [258x1 uint8] % �Ȃ񂾂낤

function dispneko(f)

switch f
    case 1
% disp(' �@�@�@�@����');
% disp(' �@�@�@�i�L��֥�j');
% disp(' �@�@ �Q|�@���^(�Q�Q_');
% disp(' �@�^�@��-(�Q�Q�Q_�^');
% disp(' �@�P�P�P�P�P�P�P');
    case 2
% disp(' ');
% disp(' �@�@ ���܁^�R-�A�Q_');
% disp(' �@�^��_/�Q�Q�Q�Q �^');
% disp(' �@�P�P�P�P�P�P�P');
end

function setAA(str)
h_f_d1 = findobj('tag','AA');
set(h_f_d1,'String',str);
function setStr1(str)
h_f_d1 = findobj('tag','States1');
set(h_f_d1,'String',str);
function setStr2(str)
h_f_d1 = findobj('tag','States2');
set(h_f_d1,'String',str);
function setStr3(str)
h_f_d1 = findobj('tag','States3');
set(h_f_d1,'String',str);


function neko = getNeko(f,mode)
switch mode
    case 0
        neko{1} = ('How to Use');
        neko{2} = ('1. �u���������v�ɏ����o���ϐ��������(��Fimg*)');
        neko{3} = ('2. �u�����o���ϐ��v���m�F�B');
        neko{4} = ('3. �u�����o����v�̃t�H���_���Q�ƁA�m�F�B');
        neko{5} = ('4. �u�v���Z�b�g�l����́v(�I��)');
        neko{6} = ('5. �u�������́v�Ŋe��p�����[�^�����͂���܂��B');
        neko{7} = ('6. �K�v�ɉ����ăp�����[�^������������B');
        neko{8} = ('7. �u�����o���J�n�v��DICOM�Ƀf�[�^�������o����܂��B');

    case 1
                hoge = mod(f,4);
        switch hoge
            case 1
        neko{1} = (' ');
        neko{2} = (' ');
        neko{3} = ('���������������������');
        neko{4} = ('��݁@�@�@�@ ���������');
        neko{5} = ('��� (��`��֥)�@������');
        neko{6} = ('�@�Q/_Ђ�/�P�P�P/');
        neko{7} = ('�@�@�@�_/�Q�Q�Q/�P�P');
            case 2
        neko{1} = (' ');
        neko{2} = (' ');
        neko{3} = (' ');
        neko{4} = ('�@ ��݁@�@�@�͂�');
        neko{5} = ('��� (��`��֥) ��� �͂�');
        neko{6} = ('�@�@/ Ђ�/�P�P�P/');
        neko{7} = ('�P�P�_/�Q�Q�Q/');
        neko{8} = (' ');
            case 3
        neko{1} = ('�@�@�@ ;�@�f�@ �G');
        neko{2} = ('�@�@�@�@�@�_,( ��;;)');
        neko{3} = ('�@�@�@�@�@(;;(:;��)�^');
        neko{4} = ('�@�@�@�@(;.(�� ,;))�f');
        neko{5} = ('�@(�L���((:,( ,;;),');
        neko{6} = ('�@( �� ��/�P�P�P/');
        neko{7} = ('�P�P�_/�Q�Q�Q/�P�P');
            case 0
        neko{1} = (' ');
        neko{2} = (' ');
        neko{3} = ('���������������������');
        neko{4} = ('����@�@�@�@ ���������');
        neko{5} = ('��� (��`��֥)�@������');
        neko{6} = ('�@�Q/_Ђ�/�P/');
        neko{7} = ('�@�@�@�@/�Q/�P�P�P�P');
        end


end



function setAA2(AAdata)
h_f_d1 = findobj('tag','AA2');
set(h_f_d1,'String',AAdata);


% --- Executes on selection change in AA2.
function AA2_Callback(hObject, eventdata, handles)
% hObject    handle to AA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AA2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AA2


% --- Executes during object creation, after setting all properties.
function AA2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
