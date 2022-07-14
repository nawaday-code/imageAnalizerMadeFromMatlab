function varargout = BMP_saver(varargin)
% BMP_SAVER MATLAB code for BMP_saver.fig
%      BMP_SAVER, by itself, creates a new BMP_SAVER or raises the existing
%      singleton*.
%
%      H = BMP_SAVER returns the handle to a new BMP_SAVER or the handle to
%      the existing singleton*.
%
%      BMP_SAVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BMP_SAVER.M with the given input arguments.
%
%      BMP_SAVER('Property','Value',...) creates a new BMP_SAVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BMP_saver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BMP_saver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BMP_saver

% Last Modified by GUIDE v2.5 09-Jun-2013 15:04:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BMP_saver_OpeningFcn, ...
                   'gui_OutputFcn',  @BMP_saver_OutputFcn, ...
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


% --- Executes just before BMP_saver is made visible.
function BMP_saver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BMP_saver (see VARARGIN)

% Choose default command line output for BMP_saver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BMP_saver wait for user response (see UIRESUME)
% uiwait(handles.BMP_save);


% --- Outputs from this function are returned to the command line.
function varargout = BMP_saver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function dirview_Callback(hObject, eventdata, handles)
% hObject    handle to dirview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirview as text
%        str2double(get(hObject,'String')) returns contents of dirview as a double




% --- Executes during object creation, after setting all properties.
function dirview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dirview.
function dirview_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dirview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in getdir.
function getdir_Callback(hObject, eventdata, handles)
% hObject    handle to getdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir = uigetdir(strcat(pwd,'保存フォルダの指定')) ;
h = findobj('tag','dirview');
set(h,'string',dir);



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_data = genData;

% 保存するファイル名を入力
h_fn = findobj('tag','filename');
fileName = strcat(get(h_fn,'String'),'.bmp');

%保存画像のウィンドウを入力
h_w_max = findobj('tag','window_max');
h_w_min = findobj('tag','window_min');
window_max = get(h_w_max,'String');
window_min = get(h_w_min,'String');

% assignin('base', 'window_min', window_min);

window_max = str2double(window_max) ; % 描画する画素値の最大値、ウィンドウの上限値
window_min = str2double(window_min) ; % 描画する画素値の最小値、ウィンドウの下限値

% 保存ディレクトリ設定

h_dir = findobj('tag','dirview');
dir= get(h_dir,'String');

% ウィンドウ幅算出
ww=window_max-window_min;



% ウィンドウ調節
data = (save_data > window_max).*ww; % dataが大きすぎる場合→上限をウィンドウ幅の大きさに。
data = (save_data < window_min) .* 0 + data; % dataが小さすぎる場合→ゼロに。
data = and(not(save_data > window_max),not(save_data < window_min)).*(save_data-window_min) + data; % その間の場合

% 8ビットに変換→画像書き込み
rate=256/ww;
imwrite(uint8(data*rate),fullfile(dir,fileName),'bmp');





function window_max_Callback(hObject, eventdata, handles)
% hObject    handle to window_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_max as text
%        str2double(get(hObject,'String')) returns contents of window_max as a double


% --- Executes during object creation, after setting all properties.
function window_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_min_Callback(hObject, eventdata, handles)
% hObject    handle to window_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_min as text
%        str2double(get(hObject,'String')) returns contents of window_min as a double


% --- Executes during object creation, after setting all properties.
function window_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_data as text
%        str2double(get(hObject,'String')) returns contents of save_data as a double


% --- Executes during object creation, after setting all properties.
function save_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% プレビューデータを設定

save_data = genData;

% ウィンドウを設定
h_w_max = findobj('tag','window_max');
h_w_min = findobj('tag','window_min');


window_max = get(h_w_max,'String');
window_min = get(h_w_min,'String');

% assignin('base', 'window_min', window_min); % デバッグ  

window_max = str2double(window_max) ; % 描画する画素値の最大値、ウィンドウの上限値
window_min = str2double(window_min) ; % 描画する画素値の最小値、ウィンドウの下限値

figure('Name','プレビュー');imshow(save_data,[window_min window_max],'Border','tight');colormap(gray);

% --- Executes on button press in save1data.
function save1data_Callback(hObject, eventdata, handles)
% hObject    handle to save1data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_s_m_d = findobj('tag','savemultidata');
set(h_s_m_d,'Value',0.0);
% Hint: get(hObject,'Value') returns toggle state of save1data


% --- Executes on button press in savemultidata.
function savemultidata_Callback(hObject, eventdata, handles)
% hObject    handle to savemultidata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_s_1_d = findobj('tag','save1data');
set(h_s_1_d,'Value',0.0);
% Hint: get(hObject,'Value') returns toggle state of savemultidata



function data1_Callback(hObject, eventdata, handles)
% hObject    handle to data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data1 as text
%        str2double(get(hObject,'String')) returns contents of data1 as a double


% --- Executes during object creation, after setting all properties.
function data1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data2_Callback(hObject, eventdata, handles)
% hObject    handle to data2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data2 as text
%        str2double(get(hObject,'String')) returns contents of data2 as a double


% --- Executes during object creation, after setting all properties.
function data2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data3_Callback(hObject, eventdata, handles)
% hObject    handle to data3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data3 as text
%        str2double(get(hObject,'String')) returns contents of data3 as a double


% --- Executes during object creation, after setting all properties.
function data3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data4_Callback(hObject, eventdata, handles)
% hObject    handle to data4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data4 as text
%        str2double(get(hObject,'String')) returns contents of data4 as a double


% --- Executes during object creation, after setting all properties.
function data4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data5_Callback(hObject, eventdata, handles)
% hObject    handle to data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data5 as text
%        str2double(get(hObject,'String')) returns contents of data5 as a double


% --- Executes during object creation, after setting all properties.
function data5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data6_Callback(hObject, eventdata, handles)
% hObject    handle to data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data6 as text
%        str2double(get(hObject,'String')) returns contents of data6 as a double


% --- Executes during object creation, after setting all properties.
function data6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in direct.
function direct_Callback(hObject, eventdata, handles)
% hObject    handle to direct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direct contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direct


% --- Executes during object creation, after setting all properties.
function direct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function save_data = genData
h_mode_1 = findobj('tag','save1data');
h_mode_multi = findobj('tag','savemultidata');
h_mode_direct = findobj('tag','direct');
% 横が1、縦が2

if get(h_mode_1,'Value');
    
h_s_d = findobj('tag','save_data');
save_data = evalin('base', get(h_s_d,'String'));

elseif get(h_mode_multi,'Value');
    direct = get(h_mode_direct,'Value');
    direct = 3-direct;
    
    h_s_d1 = findobj('tag','data1');  
    h_s_d2 = findobj('tag','data2');  
    h_s_d3 = findobj('tag','data3');  
    h_s_d4 = findobj('tag','data4');  
    h_s_d5 = findobj('tag','data5');  
    h_s_d6 = findobj('tag','data6');  

%     assignin('base', 'out', get(h_s_d6,'String')); % デバッグ  
    
    if not(isempty(get(h_s_d1,'String')))
    save_data1 = evalin('base', get(h_s_d1,'String'));
    save_data = save_data1;
    end
    if not(isempty(get(h_s_d2,'String')))
    save_data2 = evalin('base', get(h_s_d2,'String'));
    save_data = cat(direct,save_data,save_data2);
    end
    if not(isempty(get(h_s_d3,'String')))
    save_data3 = evalin('base', get(h_s_d3,'String'));
    save_data = cat(direct,save_data,save_data3);
    end
    if not(isempty(get(h_s_d4,'String')))
    save_data4 = evalin('base', get(h_s_d4,'String'));
    save_data = cat(direct,save_data,save_data4);
    end
    if not(isempty(get(h_s_d5,'String')))
    save_data5 = evalin('base', get(h_s_d5,'String'));
    save_data = cat(direct,save_data,save_data5);
    end
    if not(isempty(get(h_s_d6,'String')))
    save_data6 = evalin('base', get(h_s_d6,'String'));
    save_data = cat(direct,save_data,save_data6);
    end
      
   
end

if not(isreal(save_data))
save_data = abs(save_data);
end


h_sli = findobj('tag','slice');
sli = str2double(get(h_sli,'String'));
save_data = save_data(:,:,sli);
save_param

function save_param

h_direct = findobj('tag','direct');
n_direct = get(h_direct,'value');

h_dirview = findobj('tag','dirview');
n_dirview = get(h_dirview,'String');

h_f_n = findobj('tag','filename');
n_f_n = get(h_f_n,'String');

h_f_d = findobj('tag','save_data');
n_f_d = get(h_f_d,'String');

h_f_d1 = findobj('tag','data1');
n_f_d1 = get(h_f_d1,'String');

h_f_d2 = findobj('tag','data2');
n_f_d2 = get(h_f_d2,'String');

h_f_d3 = findobj('tag','data3');
n_f_d3 = get(h_f_d3,'String');

h_f_d4 = findobj('tag','data4');
n_f_d4 = get(h_f_d4,'String');

h_f_d5 = findobj('tag','data5');
n_f_d5 = get(h_f_d5,'String');

h_f_d6 = findobj('tag','data6');
n_f_d6 = get(h_f_d6,'String');

h_sli = findobj('tag','slice');
n_sli = get(h_sli,'String');

h_w_max = findobj('tag','window_max');
n_w_max = get(h_w_max,'String');

h_w_min = findobj('tag','window_min');
n_w_min = get(h_w_min,'String');

save('BMP_save.mat','n_*')

function slice_Callback(hObject, eventdata, handles)
% hObject    handle to slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slice as text
%        str2double(get(hObject,'String')) returns contents of slice as a double


% --- Executes during object creation, after setting all properties.
function slice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_input.
function auto_input_Callback(hObject, eventdata, handles)
% hObject    handle to auto_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('BMP_save.mat');
h_direct = findobj('tag','direct');
set(h_direct,'value',n_direct);

h_dirview = findobj('tag','dirview');
set(h_dirview,'String',n_dirview);

h_f_n = findobj('tag','filename');
set(h_f_n,'String',n_f_n);

h_f_d = findobj('tag','save_data');
set(h_f_d,'String',n_f_d);

h_f_d1 = findobj('tag','data1');
set(h_f_d1,'String',n_f_d1);

h_f_d2 = findobj('tag','data2');
set(h_f_d2,'String',n_f_d2);

h_f_d3 = findobj('tag','data3');
set(h_f_d3,'String',n_f_d3);

h_f_d4 = findobj('tag','data4');
set(h_f_d4,'String',n_f_d4);

h_f_d5 = findobj('tag','data5');
set(h_f_d5,'String',n_f_d5);

h_f_d6 = findobj('tag','data6');
set(h_f_d6,'String',n_f_d6);

h_sli = findobj('tag','slice');
set(h_sli,'String',n_sli);

h_w_max = findobj('tag','window_max');
set(h_w_max,'String',n_w_max);

h_w_min = findobj('tag','window_min');
set(h_w_min,'String',n_w_min);
