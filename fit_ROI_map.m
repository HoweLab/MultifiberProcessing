function varargout = fit_ROI_map(varargin)
% fit_ROI_map MATLAB code for fit_ROI_map.fig
%      fit_ROI_map, by itself, creates a new fit_ROI_map or raises the existing
%      singleton*.
%
%      H = fit_ROI_map returns the handle to a new fit_ROI_map or the handle to
%      the existing singleton*.
%
%      fit_ROI_map('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in fit_ROI_map.M with the given input arguments.
%
%      fit_ROI_map('Property','Value',...) creates a new fit_ROI_map or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fit_ROI_map_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fit_ROI_map_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fit_ROI_map

% Last Modified by GUIDE v2.5 02-Oct-2023 09:34:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fit_ROI_map_OpeningFcn, ...
                   'gui_OutputFcn',  @fit_ROI_map_OutputFcn, ...
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


% --- Executes just before fit_ROI_map is made visible.
function fit_ROI_map_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fit_ROI_map (see VARARGIN)

% Choose default command line output for fit_ROI_map
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fit_ROI_map wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fit_ROI_map_OutputFcn(hObject, eventdata, handles) 
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

function initialize_the_rest(handles)
global output

% turn off some warnings
warning('off','imageio:tiffmexutils:libtiffWarning')
warning('off','imageio:tiffmexutils:libtiffErrorAsWarning')
warning('off','imageio:tifftagsread:expectedTagDataFormatMultiple')
warning('off','MATLAB:polyshape:repairedBySimplify')

% load ROIs and fill in relevant info
rois = load(output.reference_roi_map);   
output.temp.origROIs = rois.ROIs;
output.ROIs = output.temp.origROIs;

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
else
    output.temp.origRadius2 = rois.radius;
    output.temp.origRoiRad2List = [];
end
output.radius2 = output.temp.origRadius2;
output.roiRad2List = output.temp.origRoiRad2List;    
output.temp.origSnapshot = rois.snapshot;
set(handles.roiRad2,'String',output.temp.origRadius2)  

% dff window
set(handles.DFFwindow,'String',num2str(rois.FtoFcWindow))

% load data    
disp([output.temp.load_str output.datapath])    
tifinfo = imfinfo(output.datapath);
if size(tifinfo,1)>1 || (isfield(tifinfo,'ImageDescription') && startsWith(tifinfo.ImageDescription,'ImageJ'))
    try
        output.temp.data = load_tiffs_fast(output.datapath,'end_ind',output.temp.end_ind);
    catch exception
        output.temp.data = bfopen(output.datapath); 
    end
else
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
% snapshot and midpoint
output.snapshot = mean(double(output.temp.data),3);
output.temp.mid = fliplr((size(output.snapshot)+1)./2);
disp('data loaded')   

% update GUI: turn off things
set(handles.datapathbutton,'Enable','off')
set(handles.datapath,'Enable','off')
set(handles.roipathbutton,'Enable','off')
set(handles.roipath,'Enable','off')
set(handles.load_all_frames,'Enable','off')
set(handles.load_first_frame,'Enable','off')

% update GUI: turn on things
set(handles.colormap,'Enable','on')
set(handles.display_raw,'Enable','on')
set(handles.display_imadjust,'Enable','on')
set(handles.display_histeq,'Enable','on')
set(handles.display_adapthisteq,'Enable','on')
set(handles.min_slider,'Enable','on')
set(handles.max_slider,'Enable','on')
set(handles.reset,'Enable','on')
set(handles.reflectHoriz,'Enable','on')
set(handles.reflectVert,'Enable','on')
set(handles.shiftUp,'Enable','on')
set(handles.shiftDown,'Enable','on')
set(handles.shiftLeft,'Enable','on')
set(handles.shiftRight,'Enable','on')
set(handles.shiftMag,'Enable','on')
set(handles.rotateCW,'Enable','on')
set(handles.rotateCCW,'Enable','on')
set(handles.rotateAngle,'Enable','on')
set(handles.scaleVertUp,'Enable','on')
set(handles.scaleVertDown,'Enable','on')
set(handles.scaleHorizUp,'Enable','on')
set(handles.scaleHorizDown,'Enable','on')
set(handles.scaleBothUp,'Enable','on')
set(handles.scaleBothDown,'Enable','on')
set(handles.scaleMag,'Enable','on')
set(handles.roiRad1,'Enable','on')    
set(handles.roiRad2,'Enable','on')   
set(handles.roiList1Button,'Enable','on')    
set(handles.roiList2Button,'Enable','on')
set(handles.DFFwindow,'Enable','on')
set(handles.apply_all_frames,'Enable','on')
set(handles.apply_first_frame,'Enable','on')
set(handles.done,'Enable','on')
% visualize: let's put up the original snapshot and ROIs top R corner    
imagesc(handles.axes_orig,output.temp.origSnapshot)
axis off equal;
caxis(caxis);
hold on;
title(['total #ROIs: ' num2str(size(output.temp.origROIs,1))])
colors = lines(7); % max number of colors is 7
for r = 1:size(output.temp.origROIs,1)
    if ismember(r,output.temp.origRoiRad1List)
        tempPoly = nsidedpoly(16,'Center',output.temp.origROIs(r,:),'Radius',output.temp.origRadius1);
    else
        tempPoly = nsidedpoly(16,'Center',output.temp.origROIs(r,:),'Radius',output.temp.origRadius2);
    end
    thisColor = colors(1+rem(r,7),:);    
    plot(handles.axes_orig,polyshape(round(tempPoly.Vertices)),'EdgeColor',thisColor,'FaceAlpha',0,'LineWidth',2)
end
hold off;

% let's get started
manual_adjust_hist(handles);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% REFLECT %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in reflectHoriz.
function reflectHoriz_Callback(hObject, eventdata, handles)
global output
% hObject    handle to reflectHoriz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,1) = 2*output.temp.mid(1)-output.ROIs(:,1);
ROIs(handles)

% --- Executes on button press in reflectVert.
function reflectVert_Callback(hObject, eventdata, handles)
global output
% hObject    handle to reflectVert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,2) = 2*output.temp.mid(2)-output.ROIs(:,2);
ROIs(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% SHIFT %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in shiftDown.
function shiftDown_Callback(hObject, eventdata, handles)
global output
% hObject    handle to shiftDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,2) = output.ROIs(:,2)+str2double(get(handles.shiftMag,'String'));
ROIs(handles)

% --- Executes on button press in shiftUp.
function shiftUp_Callback(hObject, eventdata, handles)
global output
% hObject    handle to shiftUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,2) = output.ROIs(:,2)-str2double(get(handles.shiftMag,'String'));
ROIs(handles)

% --- Executes on button press in shiftLeft.
function shiftLeft_Callback(hObject, eventdata, handles)
global output
% hObject    handle to shiftLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,1) = output.ROIs(:,1)-str2double(get(handles.shiftMag,'String'));
ROIs(handles)

% --- Executes on button press in shiftRight.
function shiftRight_Callback(hObject, eventdata, handles)
global output
% hObject    handle to shiftRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,1) = output.ROIs(:,1)+str2double(get(handles.shiftMag,'String'));
ROIs(handles)

function shiftMag_Callback(hObject, eventdata, handles)
global output
% hObject    handle to shiftMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shiftMag as text
%        str2double(get(hObject,'String')) returns contents of shiftMag as a double


% --- Executes during object creation, after setting all properties.
function shiftMag_CreateFcn(hObject, eventdata, handles)
global output
% hObject    handle to shiftMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% ROTATE %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in rotateCW.
function rotateCW_Callback(hObject, eventdata, handles)
global output
% hObject    handle to rotateCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta = -deg2rad(str2double(get(handles.rotateAngle,'String')));
output.ROIs = (output.ROIs-output.temp.mid)*[cos(theta) -sin(theta); sin(theta) cos(theta)] + output.temp.mid;
ROIs(handles)

% --- Executes on button press in rotateCCW.
function rotateCCW_Callback(hObject, eventdata, handles)
global output
% hObject    handle to rotateCCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta = deg2rad(str2double(get(handles.rotateAngle,'String')));
output.ROIs = (output.ROIs-output.temp.mid)*[cos(theta) -sin(theta); sin(theta) cos(theta)] + output.temp.mid;
ROIs(handles)


function rotateAngle_Callback(hObject, eventdata, handles)
global output
% hObject    handle to rotateAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotateAngle as text
%        str2double(get(hObject,'String')) returns contents of rotateAngle as a double


% --- Executes during object creation, after setting all properties.
function rotateAngle_CreateFcn(hObject, eventdata, handles)
global output
% hObject    handle to rotateAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% SCALE %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in scaleBothUp.
function scaleBothUp_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleBothUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs = (1+(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs-output.temp.mid)+output.temp.mid;
ROIs(handles)

% --- Executes on button press in scaleBothDown.
function scaleBothDown_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleBothDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs = (1-(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs-output.temp.mid)+output.temp.mid;
ROIs(handles) 

% --- Executes on button press in scaleHorizUp.
function scaleHorizUp_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleHorizUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,1) = (1+(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs(:,1)-output.temp.mid(1))+output.temp.mid(1);
ROIs(handles)

% --- Executes on button press in scaleHorizDown.
function scaleHorizDown_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleHorizDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,1) = (1-(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs(:,1)-output.temp.mid(1))+output.temp.mid(1);
ROIs(handles)

% --- Executes on button press in scaleVertUp.
function scaleVertUp_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleVertUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,2) = (1+(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs(:,2)-output.temp.mid(2))+output.temp.mid(2);
ROIs(handles)

% --- Executes on button press in scaleVertDown.
function scaleVertDown_Callback(hObject, eventdata, handles)
global output
% hObject    handle to scaleVertDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output.ROIs(:,2) = (1-(str2double(get(handles.scaleMag,'String'))/100))*(output.ROIs(:,2)-output.temp.mid(2))+output.temp.mid(2);
ROIs(handles)


function scaleMag_Callback(hObject, eventdata, handles)
% hObject    handle to scaleMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleMag as text
%        str2double(get(hObject,'String')) returns contents of scaleMag as a double


% --- Executes during object creation, after setting all properties.
function scaleMag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% ROI RADIUS %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function roiRad1_Callback(hObject, eventdata, handles)
% hObject    handle to roiRad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiRad1 as text
%        str2double(get(hObject,'String')) returns contents of roiRad1 as a double
global output
warning('off','MATLAB:polyshape:repairedBySimplify')
if str2double(get(hObject,'String'))>0
    output.radius1 = str2double(get(hObject,'String'));
    ROIs(handles);    
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


function roiRad2_Callback(hObject, eventdata, handles)
% hObject    handle to roiRad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiRad2 as text
%        str2double(get(hObject,'String')) returns contents of roiRad2 as a double
global output
warning('off','MATLAB:polyshape:repairedBySimplify')
if str2double(get(hObject,'String'))>0
    output.radius2 = str2double(get(hObject,'String'));
    ROIs(handles);    
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
%%%%%% CONTRAST & DISPLAY %%%%%%%%%
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
%%%%%%%%%%%% VISUALIZE %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function manual_adjust_hist(handles)
global output
cla(handles.axes_hist)
histogram(handles.axes_hist,output.snapshot(:))
hold on
xline(handles.axes_hist,get(handles.min_slider,'Value')*65535,'-r')
xline(handles.axes_hist,get(handles.max_slider,'Value')*65535,'-r')
set(handles.axes_hist,'YTick',[],'XTick',[],'XLim',[0 65525]);
ROIs(handles)

function ROIs(handles)
global output
set(gcf,'CurrentAxes',(handles.axes_roi))
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
imagesc(handles.axes_roi,this_display)
if get(handles.colormap,'Value')==1
    colormap(gray)
else
    colormap(parula)
end
axis off equal;
caxis(caxis);
hold on;
output.radius1 = str2double(get(handles.roiRad1,'String'));
output.radius2 = str2double(get(handles.roiRad2,'String'));
colors = lines(7); % max number of colors is 7
for r = 1:size(output.ROIs,1) 
    thisColor = colors(1+rem(r,7),:);   
    if ismember(r,output.roiRad2List)
        thisRad = output.radius2;
    else
        thisRad = output.radius1;
    end
    tempPoly = nsidedpoly(16,'Center',output.ROIs(r,:),'Radius',thisRad);
    plot(handles.axes_roi,polyshape(round(tempPoly.Vertices)),'EdgeColor',thisColor,'FaceAlpha',0,'LineWidth',2)    
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
global output
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% reset to original ROIs and radius
output.ROIs=output.temp.origROIs;
output.radius1=output.temp.origRadius1;
output.radius2=output.temp.origRadius2;
set(handles.roiRad1,'String',output.radius1) 
set(handles.roiRad2,'String',output.radius2) 
ROIs(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% APPLY & SAVE %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function DFFwindow_Callback(hObject, eventdata, handles)
% hObject    handle to DFFwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DFFwindow as text
%        str2double(get(hObject,'String')) returns contents of DFFwindow as a double


% --- Executes during object creation, after setting all properties.
function DFFwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DFFwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
global output
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make ROI masks
disp('saving ROI data')
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
output.FtoFcWindow =  str2double(get(handles.DFFwindow,'String'));
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

% save out data, but don't overwrite existing
output.radius = min([output.radius1 output.radius2]); % for compatibility with old GUIs
outputPath = [output.datapath(1:end-4) '_ROIs.mat'];
if exist(outputPath,'file')
    outputPath = [outputPath(1:end-4) '_' datestr(clock,'YYmmdd_hhMMSS')];
    disp('ROI file exists. Will save alternate file with timestamp instead.')
end
    
% remove unnecessary fields
output = rmfield(output,'temp'); 
if ~isempty(output.ROIs)
    save(outputPath,'-struct','output')
end

close all
clear global

