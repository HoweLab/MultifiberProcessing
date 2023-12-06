function varargout = refine_ROI_map(varargin)
% refine_ROI_map MATLAB code for refine_ROI_map.fig
%      refine_ROI_map, by itself, creates a new refine_ROI_map or raises the existing
%      singleton*.
%
%      H = refine_ROI_map returns the handle to a new refine_ROI_map or the handle to
%      the existing singleton*.
%
%      refine_ROI_map('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in refine_ROI_map.M with the given input arguments.
%
%      refine_ROI_map('Property','Value',...) creates a new refine_ROI_map or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before refine_ROI_map_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to refine_ROI_map_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help refine_ROI_map

% Last Modified by GUIDE v2.5 02-Oct-2023 09:46:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @refine_ROI_map_OpeningFcn, ...
                   'gui_OutputFcn',  @refine_ROI_map_OutputFcn, ...
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


% --- Executes just before refine_ROI_map is made visible.
function refine_ROI_map_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to refine_ROI_map (see VARARGIN)

% Choose default command line output for refine_ROI_map
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes refine_ROI_map wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = refine_ROI_map_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% PATHS TO DATA %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function datapath_Callback(hObject, eventdata, handles)
% hObject    handle to datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datapath as text
%        str2double(get(hObject,'String')) returns contents of datapath as a double
global output
output.datapath = get(hObject,'String');
if exist(output.datapath,'file') && isfield(output,'reference_roi_map') && exist(output.reference_roi_map,'file')
    set(handles.load_all_frames,'Enable','on')
    set(handles.load_first_frame,'Enable','on')
end

% --- Executes during object creation, after setting all properties.
function datapath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in datapathbutton.
function datapathbutton_Callback(hObject, eventdata, handles)
% hObject    handle to datapathbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
[filename,pathname]=uigetfile('*.tif');
if filename~=0
    set(handles.datapath,'String',[pathname filename])
    output.datapath = [pathname filename];
    if exist(output.datapath,'file') && isfield(output,'reference_roi_map') && exist(output.reference_roi_map,'file')
        set(handles.load_all_frames,'Enable','on')
        set(handles.load_first_frame,'Enable','on')
    end
end
    

function roipath_Callback(hObject, eventdata, handles)
% hObject    handle to roipath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roipath as text
%        str2double(get(hObject,'String')) returns contents of roipath as a double
global output
output.reference_roi_map = get(hObject,'String');
if exist(output.reference_roi_map,'file') && isfield(output,'datapath') && exist(output.datapath,'file')
    set(handles.load_all_frames,'Enable','on')
    set(handles.load_first_frame,'Enable','on')
end



% --- Executes during object creation, after setting all properties.
function roipath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roipath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in roipathbutton.
function roipathbutton_Callback(hObject, eventdata, handles)
% hObject    handle to roipathbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
[filename,pathname]=uigetfile('*ROI*.mat');
if filename~=0
    set(handles.roipath,'String',[pathname filename])
    output.reference_roi_map = [pathname filename];
    if exist(output.reference_roi_map,'file') && isfield(output,'datapath') && exist(output.datapath,'file')
        set(handles.load_all_frames,'Enable','on')
        set(handles.load_first_frame,'Enable','on')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% INITIALIZE %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in load_all_frames.
function load_all_frames_Callback(hObject, eventdata, handles)
global output
% hObject    handle to load_all_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% turn off some warnings
% load data and make snapshot
output.temp.end_ind = Inf;
output.temp.load_str = 'loading all frames: ';
set(handles.apply_all_frames,'Value',1);
initialize_the_rest(handles)

% --- Executes on button press in load_first_frame.
function load_first_frame_Callback(hObject, eventdata, handles)
% hObject    handle to load_first_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.temp.end_ind = 1;
output.temp.load_str = 'loading first frame: ';
set(handles.apply_first_frame,'Value',1);
initialize_the_rest(handles)

% --- Executes on button press in load_all_frames.
function initialize_the_rest(handles)
global output

% turn off some warnings
warning('off','imageio:tiffmexutils:libtiffWarning')
warning('off','imageio:tiffmexutils:libtiffErrorAsWarning')
warning('off','imageio:tifftagsread:expectedTagDataFormatMultiple')
warning('off','MATLAB:polyshape:repairedBySimplify')

% load ROIs
rois = load(output.reference_roi_map);
output.temp.origROIs = rois.ROIs;
output.ROIs = output.temp.origROIs;
output.temp.origSnapshot = rois.snapshot;

% radii
if isfield(rois,'radius1')
    output.temp.origRadius1 = rois.radius1;
    output.temp.origRoiRad1List = rois.roiRad1List;
else
    output.temp.origRadius1 = rois.radius;
    output.temp.origRoiRad1List = [1:size(rois.ROIs,1)];
end
output.radius1 = output.temp.origRadius1;
output.roiRad1List = output.temp.origRoiRad1List;
set(handles.roiRad1,'String',output.temp.origRadius1)   
if isfield(rois,'radius2')
    output.temp.origRadius2 = rois.radius2;
    output.temp.origRoiRad2List = rois.roiRad2List;
    set(handles.roiSz2,'Value',1)
    set(handles.roiList1Button,'Enable','on')
    set(handles.roiRad2Text,'Enable','on')
    set(handles.roiRad2,'Enable','on')
    set(handles.roiList2Button,'Enable','on')
else
    output.temp.origRadius2 = rois.radius;
    output.temp.origRoiRad2List = [];
end
output.radius2 = output.temp.origRadius2;
output.roiRad2List = output.temp.origRoiRad2List;
set(handles.roiRad2,'String',output.temp.origRadius2) 

% dff window
set(handles.windframes,'String',num2str(rois.FtoFcWindow));

% load data
tifinfo = imfinfo(output.datapath);
if size(tifinfo,1)>1 || (isfield(tifinfo,'ImageDescription') && startsWith(tifinfo.ImageDescription,'ImageJ'))
    output.temp.data = load_tiffs_fast(output.datapath,'end_ind',output.temp.end_ind);
else % otherwise it's a single tif
    data = imread(output.datapath);
    if size(data,3)==3            
        data = rgb2gray(data);
    end            
    output.temp.data = data;
end
% if it's a single ROI, concatenate
if size(output.temp.data,3) == 1
    output.temp.single_frame = 1;
    output.temp.data = cat(3,output.temp.data,output.temp.data);
else
    output.temp.single_frame = 0;
end
output.snapshot = mean(double(output.temp.data),3);         
disp('data loaded')    

% disable things
set(handles.datapathbutton,'Enable','off')
set(handles.roipathbutton,'Enable','off')
set(handles.datapath,'Enable','off')
set(handles.roipath,'Enable','off')
set(handles.load_all_frames,'Enable','off')
set(handles.load_first_frame,'Enable','off')

% enable things
set(handles.resetButton,'Enable','on')
set(handles.colormap,'Enable','on')
set(handles.display_raw,'Enable','on')
set(handles.display_imadjust,'Enable','on')
set(handles.display_histeq,'Enable','on')
set(handles.display_adapthisteq,'Enable','on')
set(handles.min_slider,'Enable','on')
set(handles.max_slider,'Enable','on')
set(handles.roinumText,'Enable','on')
set(handles.roinum,'Enable','on')
set(handles.shiftUp,'Enable','on')
set(handles.shiftDown,'Enable','on')
set(handles.shiftLeft,'Enable','on')
set(handles.shiftRight,'Enable','on')
set(handles.roiSz1,'Enable','on')
set(handles.roiSz2,'Enable','on')
set(handles.roiRad1Text,'Enable','on')
set(handles.roiRad1,'Enable','on')
set(handles.windframesText,'Enable','on')
set(handles.windframes,'Enable','on')
set(handles.apply_all_frames,'Enable','on')
set(handles.apply_first_frame,'Enable','on')
set(handles.overwriteButton,'Enable','on')
set(handles.done,'Enable','on')

% initialize these
output.temp.selected_roi=1;
set(handles.roinum,'String',1);

% plot histogram and get going
manual_adjust_hist(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in colormap.
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colormap
if get(hObject,'Value') == 1
    set(hObject,'String','display COLOR')        
    ROIs(handles)
else
    set(hObject,'String','display GRAY')        
    ROIs(handles)
end
    

% --- Executes on button press in display_raw.
function display_raw_Callback(hObject, eventdata, handles)
% hObject    handle to display_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_raw
ROIs(handles)

% --- Executes on button press in display_imadjust.
function display_imadjust_Callback(hObject, eventdata, handles)
% hObject    handle to display_imadjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_imadjust
ROIs(handles)

% --- Executes on button press in display_histeq.
function display_histeq_Callback(hObject, eventdata, handles)
% hObject    handle to display_histeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_histeq
ROIs(handles)

% --- Executes on button press in display_adapthisteq.
function display_adapthisteq_Callback(hObject, eventdata, handles)
% hObject    handle to display_adapthisteq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_adapthisteq
ROIs(handles)



% --- Executes on slider movement.
function min_slider_Callback(hObject, eventdata, handles)
% hObject    handle to min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if get(hObject,'Value') > get(handles.max_slider,'Value')
    set(hObject,'Value',get(handles.max_slider,'Value')-0.1);
end
manual_adjust_hist(handles);


% --- Executes during object creation, after setting all properties.
function min_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function max_slider_Callback(hObject, eventdata, handles)
% hObject    handle to max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if get(hObject,'Value') < get(handles.min_slider,'Value')
    set(hObject,'Value',get(handles.min_slider,'Value')+0.1);
end
manual_adjust_hist(handles);

% --- Executes during object creation, after setting all properties.
function max_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% ROI ADJUST %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function roinum_Callback(hObject, eventdata, handles)
global output
% hObject    handle to roinum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roinum as text
%        str2double(get(hObject,'String')) returns contents of roinum as a double
output.temp.selected_roi = str2double(get(hObject,'String'));
if output.temp.selected_roi < 1
    output.temp.selected_roi = 1;
end
if output.temp.selected_roi > size(output.ROIs,1)
    output.temp.selected_roi = size(output.ROIs,1);
end
ROIs(handles)

% --- Executes during object creation, after setting all properties.
function roinum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roinum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in shiftUp.
function shiftUp_Callback(hObject, eventdata, handles)
% hObject    handle to shiftUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.ROIs(output.temp.selected_roi,2) = output.ROIs(output.temp.selected_roi,2)-1;
ROIs(handles)

% --- Executes on button press in shiftLeft.
function shiftLeft_Callback(hObject, eventdata, handles)
% hObject    handle to shiftLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.ROIs(output.temp.selected_roi,1) = output.ROIs(output.temp.selected_roi,1)-1;
ROIs(handles)

% --- Executes on button press in shiftRight.
function shiftRight_Callback(hObject, eventdata, handles)
% hObject    handle to shiftRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.ROIs(output.temp.selected_roi,1) = output.ROIs(output.temp.selected_roi,1)+1;
ROIs(handles)

% --- Executes on button press in shiftDown.
function shiftDown_Callback(hObject, eventdata, handles)
% hObject    handle to shiftDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.ROIs(output.temp.selected_roi,2) = output.ROIs(output.temp.selected_roi,2)+1;
ROIs(handles)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% ROI RADII %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in roiSz1.
function roiSz1_Callback(hObject, eventdata, handles)
% hObject    handle to roiSz1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roiSz1
if get(hObject,'Value')==1
    set(handles.roiSz2,'Value',0)
    set(handles.roiList1Button,'Enable','off')
    set(handles.roiRad2Text,'Enable','off')
    set(handles.roiRad2,'Enable','off')
    set(handles.roiList2Button,'Enable','off')
else
    set(handles.roiSz2,'Value',1)
    set(handles.roiList1Button,'Enable','on')
    set(handles.roiRad2Text,'Enable','on')
    set(handles.roiRad2,'Enable','on')
    set(handles.roiList2Button,'Enable','on')
end
ROIs(handles)

% --- Executes on button press in roiSz2.
function roiSz2_Callback(hObject, eventdata, handles)
% hObject    handle to roiSz2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roiSz2
if get(hObject,'Value')==1
    set(handles.roiSz1,'Value',0)
    set(handles.roiList1Button,'Enable','on')
    set(handles.roiRad2Text,'Enable','on')
    set(handles.roiRad2,'Enable','on')
    set(handles.roiList2Button,'Enable','on')
else
    set(handles.roiSz1,'Value',1)
    set(handles.roiList1Button,'Enable','off')
    set(handles.roiRad2Text,'Enable','off')
    set(handles.roiRad2,'Enable','off')
    set(handles.roiList2Button,'Enable','off')
end
ROIs(handles)

function roiRad1_Callback(hObject, eventdata, handles)
global output
warning('off','MATLAB:polyshape:repairedBySimplify')
% hObject    handle to roiRad1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roicount as text
%        str2double(get(hObject,'String')) returns contents of roiRad1Text as a double
if str2double(get(hObject,'String'))>0
    output.radius1 = str2double(get(hObject,'String'));
    ROIs(handles);  
else
    set(hObject,'String',num2str(output.radius1));
end

% --- Executes during object creation, after setting all properties.
function roiRad1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiRad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in roiList1Button.
function roiList1Button_Callback(hObject, eventdata, handles)
% hObject    handle to roiList1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
[filename, pathname] = uigetfile('*.txt','Select ROI list for radius 1');
if filename~=0
    output.roiRad1ListPath = fullfile(pathname,filename);
    output.roiRad1List = dlmread(output.roiRad1ListPath);
    ROIs(handles);
end

function roiRad2_Callback(hObject, eventdata, handles)
% hObject    handle to roiRad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiRad2 as text
%        str2double(get(hObject,'String')) returns contents of roiRad2 as a double
global output
if str2double(get(hObject,'String'))>0
    output.radius2 = str2double(get(hObject,'String'));
    ROIs(handles);  
else
    set(hObject,'String',num2str(output.radius2));
end

% --- Executes during object creation, after setting all properties.
function roiRad2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiRad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in roiList2Button.
function roiList2Button_Callback(hObject, eventdata, handles)
% hObject    handle to roiList2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
[filename, pathname] = uigetfile('*.txt','Select ROI list for radius 2');
if filename~=0
    output.roiRad2ListPath = fullfile(pathname,filename);
    output.roiRad2List = dlmread(output.roiRad2ListPath);
    ROIs(handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% APPLY & % SAVE %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function windframes_Callback(hObject, eventdata, handles)
% hObject    handle to windframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windframes as text
%        str2double(get(hObject,'String')) returns contents of windframes as a double
global output
if str2double(get(hObject,'String'))>=13
    output.FtoFcWindow = str2double(get(hObject,'String'));
else
    set(hObject,'String','13');
end
ROIs(handles);    


% --- Executes during object creation, after setting all properties.
function windframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overwriteButton.
function overwriteButton_Callback(hObject, eventdata, handles)
% hObject    handle to overwriteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overwriteButton

% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
global output
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('saving ROI data')
% make ROI masks
output.ROImasks = [];
for r = 1:size(output.ROIs,1)  
    if ismember(r,output.roiRad2List)
        thisRad = output.radius2;
    else
        thisRad = output.radius1;
    end
    tempPoly = nsidedpoly(16,'Center',output.ROIs(r,:),'Radius',thisRad);
    output.ROImasks = cat(3,output.ROImasks,roipoly(output.snapshot,tempPoly.Vertices(:,1),tempPoly.Vertices(:,2)));
end



% if we're only applying to the first frame but loaded all the frames
if get(handles.apply_first_frame,'Value') == 1
    if size(output.temp.data,3)>2 && output.temp.single_frame == 0
        output.temp.data = cat(3,output.temp.data(:,:,1),output.temp.data(:,:,1));
    end
    output.temp.single_frame = 1;
end
% if we only loaded the first frame but want to apply to all the frames
if get(handles.apply_all_frames,'Value') == 1 && output.temp.single_frame == 1
    tifinfo = imfinfo(output.datapath);
    disp(['loading all frames now: ' output.datapath])
    
    % if this is a multiplane tif, load it all
    if size(tifinfo,1)>1 || (isfield(tifinfo,'ImageDescription') && startsWith(tifinfo.ImageDescription,'ImageJ'))
        output.temp.data = load_tiffs_fast(output.datapath,'end_ind',inf);
    else % otherwise it's a single tif
        data = imread(output.datapath);
        if size(data,3)==3 % in case it's color
            data = rgb2gray(data);
        end            
        output.temp.data = data;
    end
    % reestablish whether it's a single frame or not
    if size(output.temp.data,3) == 1
        output.temp.single_frame = 1;
        output.temp.data = cat(3,output.temp.data,output.temp.data);
    else
        output.temp.single_frame = 0;
    end
end

% get the timeseries and dF/F
output.FtoFcWindow =  str2double(get(handles.windframes,'String'));
tmp = extract_ROI_timeseries('data',output.temp.data,...
    'roi_masks',output.ROImasks,'baseline_window',output.FtoFcWindow);
output.F = tmp.F;
output.Fc = tmp.Fc;
output.Fc_baseline = tmp.Fc_baseline;
output.Fc_center = tmp.Fc_center;
if output.temp.single_frame == 1
    output.F = output.F(1,:);
    output.Fc = output.Fc(1,:);
    output.Fc_baseline = output.Fc_baseline(1,:);    
end
clear tmp

% save out data
output.radius = min([output.radius1 output.radius2]); % for compatibility with old GUIs
if get(handles.overwriteButton,'Value')==1
    outputPath = output.reference_roi_map;
else
    outputPath = [output.reference_roi_map(1:end-4) '_adjusted.mat'];
    if exist(outputPath,'file')
        outputPath = [outputPath(1:end-4) '_' datestr(clock,'YYmmdd_hhMMSS')];
        disp('adjusted ROI file exists. Will save alternate file with timestamp instead.')
    end
end
output = rmfield(output,'temp'); % remove unnecessary fields
if ~isempty(output.ROIs)
    save(outputPath,'-struct','output')
end

% clear global variable and close figure
clearvars -global output
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% RUN %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function manual_adjust_hist(handles)
global output
cla(handles.axes2)
histogram(handles.axes2,output.snapshot(:))
hold on
xline(handles.axes2,get(handles.min_slider,'Value')*65535,'-r')
xline(handles.axes2,get(handles.max_slider,'Value')*65535,'-r')
set(handles.axes2,'YTick',[],'XTick',[],'XLim',[0 65525]);
ROIs(handles)


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
output.ROIs=output.temp.origROIs;
output.radius1=output.temp.origRadius1;
output.radius2=output.temp.origRadius2;
set(handles.roiRad1,'String',output.radius1) 
set(handles.roiRad2,'String',output.radius2) 
ROIs(handles)

function ROIs(handles)
global output
set(gcf,'CurrentAxes',(handles.axes1))
warning('off','MATLAB:polyshape:repairedBySimplify')
hold off
cla
output.temp.snapshotThresh = imadjust(uint16(output.snapshot),...
    [get(handles.min_slider,'Value') get(handles.max_slider,'Value')]);
if get(handles.display_imadjust,'Value')==1
    this_display = imadjust(uint16(output.temp.snapshotThresh));
elseif get(handles.display_histeq,'Value')==1
    this_display = histeq(uint16(output.temp.snapshotThresh));
elseif get(handles.display_adapthisteq,'Value')==1
    this_display = adapthisteq(uint16(output.temp.snapshotThresh));
else
    this_display = uint16(output.temp.snapshotThresh);
end

imagesc(handles.axes1,this_display)
% appearance
if get(handles.colormap,'Value')==1
    colormap(gray)
else
    colormap(parula)
end
axis off equal;
caxis(caxis);
hold on;
% update some things
output.radius1 = str2double(get(handles.roiRad1,'String'));
output.radius2 = str2double(get(handles.roiRad2,'String'));
output.temp.selected_roi = str2double(get(handles.roinum,'String'));
% define colors
colors = lines(7); 
colorSelect = colors(7,:);
colorUnselect = colors(1,:);
% display ROIs
for r = 1:size(output.ROIs,1) 
    if get(handles.roiSz2,'Value')==1 && ismember(r,output.roiRad2List)
        thisRad = output.radius2;
    else
        thisRad = output.radius1;
    end
    tempPoly = nsidedpoly(16,'Center',output.ROIs(r,:),'Radius',thisRad);
    if r == output.temp.selected_roi
        plot(handles.axes1,polyshape(round(tempPoly.Vertices)),'EdgeColor',colorSelect,'FaceAlpha',0,'LineWidth',2)    
        text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',[0 0 0],'FontWeight','bold');
        text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',colorSelect);   
    
    else
        plot(handles.axes1,polyshape(round(tempPoly.Vertices)),'EdgeColor',colorUnselect,'FaceAlpha',0,'LineWidth',2) 
        text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',[0 0 0],'FontWeight','bold');
        text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',colorUnselect);       
    end
end
try % get user point to define roi num
    upoint=drawpoint(handles.axes1,'InteractionsAllowed','none');
    x = upoint.Position(1);
    y = upoint.Position(2); 
    roidist = ((output.ROIs(:,1)-x).^2+(output.ROIs(:,2)-y).^2).^.5;
    [~,roinum] = min(roidist);
    set(handles.roinum,'String',num2str(roinum))            
    ROIs(handles)
catch exception
end




