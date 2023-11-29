function varargout = create_ROI_map(varargin)
% create_ROI_map MATLAB code for create_ROI_map.fig
%      create_ROI_map, by itself, creates a new create_ROI_map or raises the existing
%      singleton*.
%
%      H = create_ROI_map returns the handle to a new create_ROI_map or the handle to
%      the existing singleton*.
%
%      create_ROI_map('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in create_ROI_map.M with the given input arguments.
%
%      create_ROI_map('Property','Value',...) creates a new create_ROI_map or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before create_ROI_map_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to create_ROI_map_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help create_ROI_map

% Last Modified by GUIDE v2.5 02-Oct-2023 07:57:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @create_ROI_map_OpeningFcn, ...
                   'gui_OutputFcn',  @create_ROI_map_OutputFcn, ...
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


% --- Executes just before create_ROI_map is made visible.
function create_ROI_map_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to create_ROI_map (see VARARGIN)

% Choose default command line output for create_ROI_map
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes create_ROI_map wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = create_ROI_map_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% PATHS TO DATA %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data_path_Callback(hObject, eventdata, handles)
% hObject    handle to data_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_path as text
%        str2double(get(hObject,'String')) returns contents of data_path as a double


% --- Executes during object creation, after setting all properties.
function data_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in locate_data.
function locate_data_Callback(hObject, eventdata, handles)
% hObject    handle to locate_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.tif');
set(handles.data_path,'String',[pathname filename])


function roi_map_path_Callback(hObject, eventdata, handles)
% hObject    handle to roi_map_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_map_path as text
%        str2double(get(hObject,'String')) returns contents of roi_map_path as a double


% --- Executes during object creation, after setting all properties.
function roi_map_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_map_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in locate_roi_map.
function locate_roi_map_Callback(hObject, eventdata, handles)
% hObject    handle to locate_roi_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*ROI*.mat');
set(handles.roi_map_path,'String',[pathname filename])


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

% load ROI path if applicable
% check if we're editing a preexisting ROI set or making a new one
roipath = get(handles.roi_map_path,'String');
if ~isempty(roipath) && exist(roipath,'file') && ~strncmp(roipath,'00',2)
    rois = load(roipath);    
    output.ROIs = rois.ROIs;
    output.radius = rois.radius;
    set(handles.roi_radius,'String',output.radius)
    output.temp.editing = 1;
else    
    output.ROIs = [];
    output.temp.editing = 0;
end

% load data
output.datapath = get(handles.data_path,'String');
if endsWith(output.datapath,'.tif') && exist(output.datapath,'file')
    tifinfo = imfinfo(output.datapath);
    disp([output.temp.load_str output.datapath])
    
    % if this is a multiplane tif
    if size(tifinfo,1)>1 || (isfield(tifinfo,'ImageDescription') && startsWith(tifinfo.ImageDescription,'ImageJ'))
        output.temp.data = load_tiffs_fast(output.datapath,'end_ind',output.temp.end_ind);
    else % otherwise it's a single tif
        data = imread(output.datapath);
        if size(data,3)==3 % in case it's color
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
    
    % snapshots
    output.snapshot = mean(double(output.temp.data),3);         
    output.temp.snapshotThresh = output.snapshot;
else
    set(handles.data_path,'String','...no data...')
    disp('cannot find data')
    output.snapshot = [];
    return
end

% disable some things
set(handles.locate_data,'Enable','off')
set(handles.data_path,'Enable','off')
set(handles.locate_roi_map,'Enable','off')
set(handles.roi_map_path,'Enable','off')
set(handles.load_all_frames,'Enable','off')
set(handles.load_first_frame,'Enable','off')

% enable some things
set(handles.display_colormap,'Enable','on')
set(handles.display_raw,'Enable','on')
set(handles.display_imadjust,'Enable','on')
set(handles.display_histeq,'Enable','on')
set(handles.display_adapthisteq,'Enable','on')
set(handles.min_slider,'Enable','on','Value',0)
set(handles.max_slider,'Enable','on','Value',1)
set(handles.selected_roi,'Enable','on')
set(handles.adding_rois,'Enable','on')
set(handles.deleting_rois,'Enable','on')
set(handles.delete_button,'Enable','on')
set(handles.roi_radius,'Enable','on')
set(handles.dff_baseline_window_frames,'Enable','on')
set(handles.apply_all_frames,'Enable','on')
set(handles.apply_first_frame,'Enable','on')
if output.temp.editing == 1
    set(handles.overwrite_file,'Enable','on')
end
set(handles.done,'Enable','on')

% initialize these
output.temp.deleting=0;
output.temp.selected_roi = 0;

% plot histogram & get going
manual_adjust_hist(handles);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% DISPLAY CONTROL %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in display_colormap.
function display_colormap_Callback(hObject, eventdata, handles)
% hObject    handle to display_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of display_colormap
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
%%%%%%% ONGOING ROI CONTROL %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function roi_radius_Callback(hObject, eventdata, handles)
global output
warning('off','MATLAB:polyshape:repairedBySimplify')
% hObject    handle to radtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_count as text
%        str2double(get(hObject,'String')) returns contents of radtext as a double
output.radius = str2double(get(hObject,'String'));
if output.radius>0
    ROIs(handles);    
end

% --- Executes during object creation, after setting all properties.
function roi_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function selected_roi_Callback(hObject, eventdata, handles)
global output
% hObject    handle to selected_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_roi as text
%        str2double(get(hObject,'String')) returns contents of selected_roi as a double
output.temp.selected_roi = str2double(get(hObject,'String'));
ROIs(handles)

% --- Executes during object creation, after setting all properties.
function selected_roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function roi_count_Callback(hObject, eventdata, handles)
% hObject    handle to radtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_radius as text
%        str2double(get(hObject,'String')) returns contents of radtext as a double



% --- Executes on button press in adding_rois.
function adding_rois_Callback(hObject, eventdata, handles)
global output
% hObject    handle to adding_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of adding_rois
output.temp.deleting = ~get(hObject,'Value');
output.temp.selected_roi = 0;
set(handles.selected_roi,'String',num2str(output.temp.selected_roi))
ROIs(handles)

% --- Executes on button press in deleting_rois.
function deleting_rois_Callback(hObject, eventdata, handles)
global output
% hObject    handle to deleting_rois (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deleting_rois
output.temp.deleting = get(hObject,'Value');
ROIs(handles)



% --- Executes on button press in delete_button.
function delete_button_Callback(hObject, eventdata, handles)
global output
% hObject    handle to delete_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.deleting_rois,'Value')==1
    if output.temp.selected_roi>0 && output.temp.selected_roi<=size(output.ROIs,1)
        output.ROIs(output.temp.selected_roi,:) = [];        
    end
end
ROIs(handles)

function manual_adjust_hist(handles)
global output
cla(handles.axes2)
histogram(handles.axes2,output.snapshot(:))
hold on
xline(handles.axes2,get(handles.min_slider,'Value')*65535,'-r')
xline(handles.axes2,get(handles.max_slider,'Value')*65535,'-r')
set(handles.axes2,'YTick',[],'XTick',[],'XLim',[0 65525]);
ROIs(handles)


function ROIs(handles)
global output
warning('off','MATLAB:polyshape:repairedBySimplify')
hold off
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
cla
imagesc(handles.axes1,this_display)
axis off equal;
if get(handles.display_colormap,'Value')==1
    colormap(gray)
else
    colormap(parula)
end
hold on;
output.radius = str2double(get(handles.roi_radius,'String'));
colors = lines(7); % max number of colors is 7
for r = 1:size(output.ROIs,1) 
    if output.temp.selected_roi>0
        if r == output.temp.selected_roi
            thisColor = colors(7,:);
        else
            thisColor = colors(1,:);
        end         
    else
        thisColor = colors(1+rem(r,7),:);
    end
    tempPoly = nsidedpoly(16,'Center',output.ROIs(r,:),'Radius',output.radius);
    plot(handles.axes1,polyshape(round(tempPoly.Vertices)),'EdgeColor',thisColor,'FaceAlpha',0,'LineWidth',2)
    text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',[0 0 0],'FontWeight','bold');
    text(output.ROIs(r,1),output.ROIs(r,2),num2str(r),'Color',thisColor);   
    set(handles.roi_count,'String',['#ROIs: ' num2str(size(output.ROIs,1))])        
end
title('select ROIs')            
try
    upoint=drawpoint('InteractionsAllowed','none');
    x = upoint.Position(1);
    y = upoint.Position(2); 
    if output.temp.deleting==1
        roidist = ((output.ROIs(:,1)-x).^2+(output.ROIs(:,2)-y).^2).^.5;
        [~,roinum] = min(roidist);
        output.temp.selected_roi = roinum;
        set(handles.selected_roi,'String',num2str(roinum))            
    else
        output.ROIs = [output.ROIs; x y]; 
    end 
    ROIs(handles)
catch exception
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% APPLY & SAVE %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dff_baseline_window_frames_Callback(hObject, eventdata, handles)
% hObject    handle to dff_baseline_window_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dff_baseline_window_frames as text
%        str2double(get(hObject,'String')) returns contents of dff_baseline_window_frames as a double
global output
if str2double(get(hObject,'String'))<13
    set(hObject,'String','13');
end
output.FtoFcWindow=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function dff_baseline_window_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dff_baseline_window_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overwrite_file.
function overwrite_file_Callback(hObject, eventdata, handles)
% hObject    handle to overwrite_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overwrite_file


% --- Executes on button press in apply_all_frames.
function apply_all_frames_Callback(hObject, eventdata, handles)
% hObject    handle to apply_all_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of apply_all_frames


% --- Executes on button press in apply_first_frame.
function apply_first_frame_Callback(hObject, eventdata, handles)
% hObject    handle to apply_first_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of apply_first_frame

% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
global output
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make ROI masks
output.ROImasks = [];
for r = 1:size(output.ROIs,1)    
    tempPoly = nsidedpoly(16,'Center',output.ROIs(r,:),'Radius',output.radius);        
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

% get DFF    
output.FtoFcWindow = str2double(get(handles.dff_baseline_window_frames,'String'));
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

% save out data, but don't overwrite existing if we're not supposed to
if output.temp.editing==1
    outputPath = get(handles.roi_map_path,'String');
    if get(handles,'overwrite_file','Value') == 0
        outputPath = [outputPath(1:end-4) '_' datestr(clock,'YYmmdd_hhMMSS')];
    end
else
    outputPath = [output.datapath(1:end-4) '_ROIs.mat'];
    if exist(outputPath,'file')
        outputPath = [outputPath(1:end-4) '_' datestr(clock,'YYmmdd_hhMMSS')];
        disp('ROI file exists. Will save alternate file with timestamp instead.')
    end
end

% remove unnecessary fields and then save out
output = rmfield(output,'temp');
if ~isempty(output.ROIs)
    save(outputPath,'-struct','output')
end
close all
clear global


