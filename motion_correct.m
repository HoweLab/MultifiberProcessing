function [xshifts,yshifts] = motion_correct_(filepath,varargin)
timerstart = tic;
%MOTION_CORRECT Correct motion by aligning to a referance frame
% Align frames to a referance frame using the center of mass of the
% cross-correlation (Pearson normalized) above a threshold
%
% INPUT:
%   filepath - The filepath to the source file (the file to be corrected)
%   outfile - The filepath for the destination of the corrected file
%
% OPTIONAL PARAMETERS (RECOMMENDED TO BE SET ARE INDICATED WITH *)
%   crop_points* ([]) - The portion of the video (pixels) to
%       be aligned - larger regions are slower, but will yield more
%       consistent results. If not provided, will query user with the
%       still_frame.
%   maxshift_x* ([]) - The maximum shift in the x direction (pixels)
%   maxshift_y* ([]) - The maximum shift in the y direction (pixels)
%       If either of these are not provided, it will ask by randomly
%       jumping between 20 frames, asking for the user to click on the same
%       feature in all 20.
%   numframes ([]) - The number of frames in the file. If left empty,
%       calculates from the file
%   still_frame ([]) - The index of the frame to be aligned to. If left
%       empty, the algorithm chooses the frame that has the smallest mean
%       change in intenstity between pixels to the next frame. Still frame
%       can also be 'mean', in which case it uses the mean for the whole
%       video
%   interplevel (4) - How many times to interpolate the autocorrelogram to
%       reduce edge effects
%   correlation_threshold (0.8) - The threshold for the cross-correlation
%       to contribute to the center of mass
%   min_samples (75) - The smallest number of samples that must be
%       considered to contribute to the center of mass. If not at least
%       this many are above correlation_threshold, the highest min_samples
%       in correlation are used to calculate the center of mass
%   xshifts ([]) - Uses this value if not empty
%   yshifts ([]) - Uses this value if not empty
%
% RETURNS:
%   xshifts - The offsets in the x direction
%   yshifts - The offsets in the y direction
%
% Updated 11-15-2016 by Dr. Jason R. Climer (jason.r.climer@gmail.com)
%
% Updated 9/4/2020 by Mai-Anh Vu: removed some unnecessary functionality:
% remove possibility of using parallel computing toolbox: this doesn't end 
% up saving that much time for us, it  FIXES the problem of randomly 
% duplcated frames
%
% Updated 6/25/2021 print out the GPU message with a potential fix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SET UP AND SOME CHECKS %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% turn off various tiff warnings
%%% [msg,msgID] = lastwarn
warning('off','imageio:tiffmexutils:libtiffWarning')
warning('off','imageio:tiffmexutils:libtiffErrorAsWarning')
warning('off','imageio:tifftagsread:expectedTagDataFormatMultiple')

% Declare variables (static workspace)
% keyboard;
crop_points=[];
maxshift_x=[];
maxshift_y=[];
numframes=[];
still_frame=[];
interplevel=[];
correlation_threshold=[];
min_samples=[];
yshifts = [];
xshifts = [];
cropresult = [];
outfile = [];

% Parse inputs (and if none given, defaults are shown)
ip = inputParser;
ip.addParamValue('crop_points',[]);
ip.addParamValue('maxshift_x',[]);
ip.addParamValue('maxshift_y',[]);
ip.addParamValue('numframes',[]);
ip.addParamValue('yshifts',[]);
ip.addParamValue('xshifts',[]);
ip.addParamValue('still_frame',[]);
ip.addParamValue('interplevel',4);
ip.addParamValue('correlation_threshold',0.8);
ip.addParamValue('min_samples',75);
ip.addParamValue('cropresult',false);
ip.addParamValue('usegpu',[]);
ip.addParamValue('outfile',[filepath(1:end-4) '_MC.tif']);

if ischar(filepath)&& exist('filepath','var')&&ismember(filepath,ip.Parameters)
   varargin = [{filepath} varargin];
   clear filepath;
end
if ischar(filepath) && ~exist('filepath','var')
    [filepath,j] = uigetfile('*.tif');
    filepath = [j filepath];
end

% parse inputs
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

% whether or not to use gpu
if isempty(usegpu)
    usegpu = isequal(which('gpuArray'),'gpuArray is a built-in method');
end

% get number of frames and load the first frame
% if the filepath is not a string, and so is actually the data itself (matrix)
if ~ischar(filepath) 
   data3d = filepath;
   filepath = [];
   numframes = size(data3d,3);
   data = data3d(:,:,1);
else
    % Look up number of frames if necessary
    if isempty(numframes)
        [data,numframes]=load_tiffs_fast(filepath,'end_ind',1);
    else
        data = load_tiffs_fast(filepath,'end_ind',1,'nframes',numframes);
    end
end

% we need the number of frames to be at least the number of cores, so if
% the data's too small, then tell the user to pad the array or something
nCores = feature('numCores');
if numframes<nCores
    disp(['this computer has ' num2str(nCores) 'cores']);
    disp('we need at least that many frames');
    disp('pad your data with frames at the end and retry');
    return
end

% Look up sizes
width = size(data,2);
height = size(data,1);
orig_data_size = size(data);

if isempty(crop_points) && (isempty(xshifts)|isempty(yshifts))
    [crop_points] = get_motcorr_points(filepath,[1 0 0],numframes); 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% CALCULATE SHIFTS %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% if the user didn't provide maxshift_x or maxshift_y, have them click through to estimate this
if (isempty(maxshift_x)||isempty(maxshift_y)) && (isempty(xshifts)|isempty(yshifts))
   temp = cell(2,1);
   [~,temp{:}] = get_motcorr_points(filepath,[0 1 0],numframes);
   if isempty(maxshift_x)
      maxshift_x = temp{1}; 
   end
   if isempty(maxshift_y)
      maxshift_y = temp{2}; 
   end
end

% if the shift hasn't been provided, calculate 
if isempty(yshifts)||isempty(xshifts)
    if isempty(still_frame)% Still frame hasn't been provided        
        % set up a memory buffer to read in the data in chunks
        maxbuff = memory;
        maxbuff = min(...
            2^(nextpow2(maxbuff.MaxPossibleArrayBytes/8/4/width/height)-1)...
            ,round(numframes/4));        
         meandiffs = zeros(round(numframes/4)-1,1);
        
        % loop over chunks      
        for i=1:ceil((numel(meandiffs)+1)/maxbuff)
            if ~isempty(filepath)
                meandiffs((i-1)*maxbuff+1:min(i*maxbuff,numel(meandiffs)))=...                
                    mean(mean(abs(diff(load_tiffs_fast(filepath...
                    ,'start_ind',(i-1)*maxbuff+floor(numframes*3/8)...
                    ,'end_ind',min(i*maxbuff+floor(numframes*3/8),floor(numframes*3/8)+numel(meandiffs))...
                    ,'nframes',numframes),[],3))));% Find the mean change in intensity between frames
            else
                meandiffs((i-1)*maxbuff+1:min(i*maxbuff,numel(meandiffs)))=...                
                mean(mean(abs(diff(data3d((i-1)*maxbuff+floor(numframes*3/8):min(i*maxbuff+floor(numframes*3/8),floor(numframes*3/8)+numel(meandiffs)))))));
            end
        end
        
        [~,still_frame] = min(meandiffs);
        still_frame = still_frame+floor(numframes*3/8);
    end
    
    if isequal(still_frame,'mean')
        still_image = mean_image(filepath);
    elseif isscalar(still_frame)
        if ~isempty(filepath)
            still_image = double(load_tiffs_fast(filepath,'start_ind',still_frame,'end_ind',still_frame,'nframes',numframes));
        else
           still_image = double(data3d(:,:,still_frame)); 
        end
    end
                
    still_image = still_image(max(crop_points(2),1):min(crop_points(4),height),max(crop_points(1),1):min(crop_points(3),width));
    still_image = still_image-mean(still_image(:));
    
    maxshift_x = min(maxshift_x,size(still_image,2)-1);
    maxshift_y = min(maxshift_y,size(still_image,1)-1);
    %disp(['maxshift_x: ' num2str(maxshift_x) ', maxshift_y: ' num2str(maxshift_y)])
    
    X = -size(still_image,2)+1:size(still_image,2)-1;
    Y = -size(still_image,1)+1:size(still_image,1)-1;
      
    xin = -maxshift_x:maxshift_x;
    yin = -maxshift_y:maxshift_y;
    
    xint = -maxshift_x:1/interplevel:maxshift_x;
    yint = -maxshift_y:1/interplevel:maxshift_y;
    
    [yyin,xxin] = meshgrid(xin,yin);
    [yyint,xxint] = meshgrid(yint,xint);
    
    interplevel = 4;
    vect = @(x)x(:);
    
    n = xcorr2(ones(size(still_image)),ones(size(still_image)));
    
%     keyboard;
    if usegpu
       try
        h = gpuDevice(); 
        maxbuff = min(2^(nextpow2(h.AvailableMemory/8/4/width/height)-1),numframes);
       catch err
         usegpu = false;
       end
    end

    if ~usegpu
    maxbuff = memory;
    maxbuff = min(...
        2^(nextpow2(maxbuff.MaxPossibleArrayBytes/8/4/width/height)-1)...
        ,numframes);
    end
%     
     workers = 1; % not using parallel computing toolbox, so set this to 1
     XSHIFTS = cell(1,1);
     YSHIFTS = cell(1,1);
     yshifts = [];
     xshifts = [];
     
    lastFrame = 0;
    for i=1:ceil(numframes/maxbuff)% For each chunk
        ii1 = lastFrame+1;
        ii2 = min(i*maxbuff,numframes);        
        lastFrame = ii2;
        disp(['     processing frames ' num2str(ii1) ':' num2str(ii2)])
        if usegpu            
            reset(gpuDevice());
        end
        % Load the next chunk of data
        if ~isempty(filepath)
            dataw = double(load_tiffs_fast(filepath,'start_ind',ii1,'end_ind',ii2,'nframes',numframes));
        else
           dataw = double(data3d(:,:,ii1:ii2));
        end        
                
        % Crop data
        dataw = dataw(max(crop_points(2),1):min(crop_points(4),height),max(crop_points(1),1):min(crop_points(3),width),:);
        if usegpu
            try
                dataw = cellfun(@gpuArray,dataw,'UniformOutput',false);
            catch exception
                disp('          Possibly running into a GPU problem, not sure.')
                disp('          Trying a workaround, which may or may not result ')
                disp('          in slower motion correction. What might help:')                
                disp('          make you have admin access to your computer.')
                disp('          You may also need to uninstall and reinstall Matlab')
                disp('          as admin.')
                dataw = gpuArray(dataw);
            end
        end
        
        XSHIFTS = NaN(size(dataw,3),1);
        YSHIFTS = XSHIFTS;
         
        for m=1:numel(XSHIFTS)
            % Do cross correlation (Person's correlation normalized) using fft
            % method (>100X as fast)
            corrmat = conv_fft2(dataw(:,:,m)-mean(mean(dataw(:,:,m))),rot90(conj(still_image),2))./n/std(vect(dataw(:,:,m)))/std(vect(still_image));% Takes 18.033 s for 4000 calls, and I think we can make this faster
            corrmat = interp2(yyin,xxin,corrmat(ismember(Y,yin),ismember(X,xin)),yyint,xxint);
            corrmat(isnan(corrmat))=0;

            % Find the correlation threshold that allows us to have at least
            % min_samples above, no higher than correlation_threshold
            correlation_threshold_temp=correlation_threshold;
            if sum(sum(corrmat>correlation_threshold))<min_samples
                correlation_threshold_temp=quantile(corrmat(:),1-min_samples/numel(corrmat));
            end

            % Mask by the threshold
            corrmat = corrmat.*(corrmat>correlation_threshold_temp);

            % Find the shifts
            YSHIFTS(m) = gather(real(sum(sum(corrmat).*yint)/sum(corrmat(:))));
            XSHIFTS(m) = gather(real(sum(sum(corrmat,2).*xint(:))/sum(corrmat(:))));
        end
        yshifts = [yshifts;XSHIFTS];
        xshifts = [xshifts;YSHIFTS];
    end           
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% APPLY SHIFTS & WRITE OUT %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Interpolate and write back out
y = 1:height;
x = 1:width;
[xx,yy] = meshgrid(x,y);

yshifts = yshifts-median(yshifts);
xshifts = xshifts-median(xshifts);

if usegpu
   yshifts = gather(yshifts);
   xshifts = gather(xshifts);
end

Y = -ceil(max([yshifts;0])):height-floor(min([yshifts;0]));
X = -ceil(max([xshifts;0])):width-floor(min([xshifts;0]));
[XX,YY] = meshgrid(X,Y);

    function out = shift(i1,i2)
        if i1~=1 || i2~=1 % display if it's not just i1==1 and i2==1
            disp(['     writing frames ' num2str(i1) ':' num2str(i2)])
        end
        if ~isempty(filepath)
            dataw=double(load_tiffs_fast(filepath,'start_ind',i1,'end_ind',i2,'nframes',numframes));
        else
           dataw = double(data3d(:,:,i1:i2)); 
        end
        out = zeros([size(YY) size(dataw,3)]);
        for k=1:i2-i1+1
            out(:,:,k) = interp2(xx-xshifts(k+i1-1),yy-yshifts(k+i1-1),dataw(:,:,k),XX,YY,'linear',0);
        end  
        if cropresult
            out = out(Y>-min(yshifts)&Y<height-max(yshifts),X>-min(xshifts)&X<width-max(xshifts),:);
        end
        clear dataw;        
    end
write_tiff_fast(outfile,@shift,'end_ind',numframes);
time_elapsed = toc(timerstart);
if ~exist('outfile','var') || isempty(outfile)
    outfile = [filepath(1:end-4) '_MC.tif'];
end
save([outfile(1:end-4) '_shifts.mat'],'yshifts','xshifts','crop_points','orig_data_size','time_elapsed')

end
