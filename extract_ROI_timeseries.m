% function ROI_struct = extract_ROI_timeseries(varargin)
%
% This function extracts ROI timeseries from multifiber photometry
% acquisitions. It returns a struct with at least the following fields:
%   ROImasks        m x n x p matrix, where m x n = the imaging FOV, and
%                   p = the # ROIs. Each p-slice is a binary roi mask.
%   FtoFc_window    the # frames used for sliding 8th percentile baseline; 
%                   -1 if the baseline is calculated using exponential fit
%   F               the raw fluorescence
%   Fc              "corrected F", i.e., delta-F-over-F
%   Fc_baseline     the calculated F baseline, either by sliding 8th
%                   percentile or exponential fit
%   Fc_center       The median of the F/Fc_baseline, resulting Fc is
%                   median-centered.
%
% There are multiple ways to run it.
%
% One way to run it is to supply the following 3 inputs:
% 1. 'data'             3D imaging data matrix, where z-slices = frames, 
%                       or path to the 3D .tif containig the imaging data
% 2. 'roi_masks'        m x n x p matrix, where m x n = the imaging FOV, 
%                       and p = # ROIs. Each p-slice is a binary ROI mask
% 3. 'baseline_window'  the # frames for sliding 8th percentile baseline
%                       calculation; set to -1 for exponential-fit baseline
%
% So, for example: 
% roi_struct = extract_ROI_timeseries('data',myData,...
%               'roi_masks',myROIMasks,'baseline_window',900);
% roi_struct = extract_ROI_timeseries('data','path\to\myData.tif',...
%               'roi_masks',myROIMasks,'baseline_window',900);
%
% 
%
% You can also run this on an existing roi_struct. This is useful in cases
% where you want to recalculate the baseline (change the baseline window,
% or change baseline calculation method). In this case, you need to supply
% at least 
% 1. 'roi'              an ROI struct, as output from MAP_ROIs
%
% If only 'roi' is supplied, the baseline and delta-F-over-F are calculated
% from the parameters contained in the struct. In cases where you want to
% change the baseline and delta-F-over-F calculation, you should also
% supply 
% 2. 'baseline_window'  see description above
%
% So, for example:
% roi = extract_ROI_timeseries('roi',myRoiStruct,'baseline_window',450)
% or
% % roi = extract_ROI_timeseries('roi',myRoiStruct,'baseline_window',-1)
%
% This function includes within it the functions FtoFc and apply_filter, 
% provided by Dr. Jason R. Climer (jason.r.climer@gmail.com)
% 
%
% updated Mai-Anh Vu, 11/29/2023
%

function roi = extract_ROI_timeseries(varargin) 

%%%  parse inputs %%%
ip = inputParser;
ip.addParameter('roi',[]);
ip.addParameter('roi_masks',[]);
ip.addParameter('data',[]);
ip.addParameter('baseline_window',[]); % #frames for sliding 8th percentile; set to -1 to use an exponential fit instead
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end
    
% if an ROI struct has not been supplied and if  other inputs are lacking
if isempty(roi) && (isempty(data) || isempty(roi_masks) || isempty(baseline_window))    
    disp('Please include either an ROI struct,')
    disp('or all 3 of the following inputs:')
    disp('  1) data: 3D matrix or path to 3D .tif')
    disp('  2) baseline_window: #frames for sliding 8th percentile,')
    disp('     or -1 to use exponential fit instead')
    disp('  3) roi_masks: m x n x p matrix, where m x n is movie FOV,')
    disp('     and p is # ROIs. Each p-slice is a binary ROI mask')
end

% get F from data and roi_masks if necessary
if isempty(roi)
    roi = struct;
    roi.FtoFcWindow = baseline_window;
    roi.ROImasks = roi_masks;
    roi.F = apply_roi_masks(data,roi_masks);
end

% if roi struct is supplied, baseline window:
if ~isempty(roi)    
    if isempty(baseline_window) 
        baseline_window = roi.FtoFcWindow;
    else
        roi.FtoFcWindow = baseline_window;
    end    
end

% get FtoFc
if baseline_window > 0
    [roi.Fc, roi.Fc_baseline, roi.Fc_center] = FtoFc(roi.F, roi.FtoFcWindow);
elseif baseline_window == -1
    [roi.Fc, roi.Fc_baseline, roi.Fc_center] = FtoFc_exp(roi.F);
elseif baseline_window == 0
    disp('baseline_window must be > 0 or == -1');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    apply_roi_masks     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = apply_roi_masks(data,roi_masks)
if ischar(data) % if this is a path to the 3D .tif, read it in
    data = tiffreadVolume(data,'PixelRegion',{[1 Inf],[1 Inf],[1 Inf]});
end
% reshape 
data = reshape(data,[size(data,1)*size(data,2) size(data,3)]);
% preallocate
F = zeros(size(data,2),size(roi_masks,3));
noise_offset = 0;
% get F
for h = 1:size(roi_masks,3)
    F(:,h) = apply_filter(data(roi_masks(:,:,h)==1,:)-noise_offset,ones(sum(sum(roi_masks(:,:,h))),1));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%    apply_filter     %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ F ] = apply_filter( X,B )
%APPLY_FILTER Applies the filter from cellsort2 to calcium imaging data
%
%   INPUTS
%       X - The data to be filtered as a nXmXp matrix, where p is the
%           number of frames and n and m correspond with the width and height
%           of the video.
%       B - The filters to apply as a nXmXq matrix, where q is the number
%           of filters.
%
%   OUTPUTS
%       F - A pXq matrix of the score at each point. The filters (B) are
%           weighted such that if a frame of X had an average in the region
%           where the filter is not 0 of 1 and correlated exactly with the
%           filter, the score in F would be 1.
%
% Jason R. Climer, PhD (jason.r.climer@gmail.com) 11 January, 2017

vect = @(x)x(:);

if ndims(X)==3
X = reshape(X,[size(X,1)*size(X,2) size(X,3)]);
end
if ndims(B)==3||size(B,1)~=size(X,1)
   B = reshape(B, [size(X,1) size(B,3)]);
end
if ~isequal(class(X),'double')
    X = double(X); 
end
F = zeros(size(X,2),size(B,2));
for i=1:size(B,2)
   F(:,i)=(B(:,i)/((B(:,i)~=0)'*B(:,i)))'*X;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%       FtoFc        %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Fc, scale, center ] = FtoFc( F, scale_window )
%FTOFC Normalizes by the 8th percentile in a sliding window and subtracts
%   the median to create the modified DFoF
% function provided by Dr. Jason R. Climer (jason.r.climer@gmail.com)

if ~exist('scale_window','var'), scale_window = 1e3; end

scale = zeros(size(F));
for i=1:size(scale,1)
    scale(i,:) = quantile(F(max(i-scale_window,1):min(i+scale_window,size(F,1)),:),0.08);
end
Fc = F./scale;
center = median(Fc);
Fc = bsxfun(@minus,Fc,center);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       FtoFc_exp        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Fc, scale, center ] = FtoFc_exp(F,varargin)
% An alternative to the FtoFc function (above) to calculate DFF.
% FtoFc.m calculates the baseline (B) using a sliding 8th percentile 
% window, and then normalizes F to that B in the following way:
% (F./B) - median(F./B)
%
% This function calculates the baseline B by fitting 2-term exponential
% function to the F instead.
%
% Options: Instead of fitting the exponential to the F (raw fluorescence), 
% you can insetad fit the exponential to a sliding baseline. To do that,
% supply BOTH of the following optional inputs:
%   'baseline_window'   - the number of frames for the sliding window
%   'baseline_perc'     - the percentile you want 
%                         (e.g.,8 for 8th percentile, 20 for 20th, etc) 
%
% Dr. Mai-Anh Vu, 5/16/2023

%%%  parse optional inputs %%%
ip = inputParser;
ip.addParameter('baseline_window',[]);
ip.addParameter('baseline_perc',[]);
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

% whether or not the Y variable is the F or a sliding baseline
if ~isempty(baseline_window) && ~isempty(baseline_perc)    
    y_all = zeros(size(F));
    for i = 1:size(y_all,1)
        y_all(i,:) = prctile(F(max(i-baseline_window,1):min(i+baseline_window,size(F,1)),:),baseline_perc);
    end
else
    y_all = F;
end

% now fit the exponential to calculate the baseline
scale = nan(size(y_all));
x = 1:size(F,1);
x = x(:);
for i = 1:size(y_all,2)
    y = y_all(:,i);
    mdl = fit(x(:),y,'exp2');    
    scale(:,i) = mdl.a*exp(mdl.b*x)+mdl.c*exp(mdl.d*x);
end

% DFF normalization
Fc = F./scale;
center = median(Fc);
Fc = Fc - center;