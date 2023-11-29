function [ out, nframes ] = load_tiffs_fast(filepaths,varargin)
%FASTLOAD_TIFF Quickly load tiff stack data
% Quickly load data from tiffs, supports pulling partial frames for the use
% of a buffer.
%
% INPUT:
%   filepaths - Either a string for the filepath of the tiff or an ordered
%       cell array of filepaths of the different file parts
%
% OPTIONAL PARAMETERS;
%   start_ind (1): The starting frame to load
%   end_ind (inf): The end frame to load. If inf, loads all the data
%   display ('none'): Can also be 'verbose' or 'v'. If so, it will give
%       information about the time to load each file.
%   frame_skip (1): The number of frames between each frame to load. For
%       example, to load alternating frames frame_skip=2
%   nframes ([]): The number of frames in each file. If empy, is calculated
%       for each file but it takes some time due to the linked-list format
%       for TIFFs. It is recommended that nframes is provided whenever
%       possible.
%   mode ('auto')
%
% RETURNS:
%   out - the data in a matrix
%   nframes - The number of frames in each file
%
% Updated 11-10-2016 by Dr. Jason R. Climer

% Parse inputs
% keyboard
display = [];
ip = inputParser();
ip.addParameter('start_ind',1);
ip.addParameter('end_ind',inf);
ip.addParameter('frame_skip',1);
ip.addParameter('nframes',[]);
ip.addParameter('display','none');
ip.addParameter('value_offset',0);

if exist('filepaths','var')
    if ~iscell(filepaths)
        filepaths = {filepaths};
        if ismember(filepaths,ip.Parameters)
            varargin = [filepaths varargin];
            clear filepaths;
        end
    end
end

if ~exist('filepaths','var')
    [filepaths,j] = uigetfile('*.tif','MultiSelect','on');
    filepaths = cellfun(@(x)[j x],filepaths,'UniformOutput',false);
end

ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

end_ind = floor((end_ind-start_ind)/frame_skip)*frame_skip+start_ind;

getnframes = isempty(nframes);% Flag to get nframes

% The width and height of each file
width = NaN(size(filepaths));
height = width;
if getnframes
    nframes = height;
end

isimj = false(numel(filepaths),1);
% U = Tiff(filepaths{1},'r');

for i=1:numel(filepaths)
    %         keyboard
    T = Tiff(filepaths{i},'r');% Open the tiff
    width(i) = T.getTag('ImageWidth');% Get the width
    height(i) = T.getTag('ImageLength');% Get the height
    
    T.setDirectory(1);
    if T.lastDirectory
        try
            j = T.getTag('ImageDescription');
            if ~isempty(findstr(j,'ImageJ='))
                isimj(i) = true;
                k=findstr(j,'images=')+7;
                if getnframes
                    nframes(i)=str2num(j((1:find(j(k:end)==sprintf('\n'),1))+k-1));
                end
            end
        catch err
        end
    end
    
    if getnframes
        if ~isimj(i)
            searchme = i==1;
            if i>1
                if validate_last_dir(T,mode(nframes(1:i-1)))
                   searchme = false;
                   nframes(i) = mode(nframes(1:i-1));
                end
            end
            %%
            k = 2;
            if searchme
                nframes(i) = 1;
                while true
                    try
                        T.setDirectory(nframes(i)*k);
                        nframes(i) = nframes(i)*k;
                    catch err
                        searchwin = [nframes(i) nframes(i)*k];
                        break;
                    end
                end
                T.setDirectory(nframes(i));
            end
            
            while ~validate_last_dir(T,round(mean(searchwin)))
%                 disp(round(mean(searchwin)));
                try
                    T.setDirectory(round(mean(searchwin)));
                    %                     if max(max(T.read()))<2^(T.getTag('BitsPerSample')-2)
                    searchwin(1) = round(mean(searchwin));
                    %                     else
                    %                         searchwin(2) = round(mean(searchwin));
                    %                     end
                catch err
                    searchwin(2) = round(mean(searchwin));
                end
            end
            nframes(i) = round(mean(searchwin));
%             U.close();
%             U = T;
        end
    end
end
% U.close();

% Assert the sizes are all the same
assert(all(width(1)==width)&&all(height(1)==height),'LOAD_TIFFS_FAST:badSize','Images are not all the same size.')
height = height(1); width = width(1);

% Update end_ind
if isinf(end_ind), end_ind = sum(nframes);end

% Allocate the out variable
% keyboard
% keyboard

lastfile = 0;% To keep track of the file changes

nframes2 = nframes;
nframes2(cumsum(nframes2)<start_ind) = 0;
nframes2(find(nframes2~=0,1))=nframes(find(nframes2~=0,1))-(start_ind-sum(nframes(nframes2==0)));

I = 0;
if isequal(display,'verbose')||isequal(display,'v')
    tic;
end
i = 1;
while i<=(end_ind-start_ind)/frame_skip+1
    realframe = (i-1)*frame_skip+start_ind;
    % Verbosity display
    if isequal(display,'verbose')||isequal(display,'v')
        disp(sprintf('%i/%i (%i), %2.2g secs per, %s remaining.',i,(end_ind-start_ind)/frame_skip+1,realframe,toc/(i-1),secs2hms(toc/(i-1)*(end_ind-start_ind)/frame_skip+1-toc)));
    end
    
    file = find(realframe<=cumsum(nframes),1);% Identify the file
    if file~=lastfile% We need to load a new file
        % Close the last file open
        if lastfile>0&&isimj(lastfile)
            fclose(I);
        end
        T.close;
        
        T = Tiff(filepaths{file},'r');% Open the next file
        if isimj(file)% If this file is in the imj raw format
            
            I = fopen(filepaths{file},'r');% Open the file
            
            % Determine the format
            fseek(I,0,-1);
            endian = fread(I,1,'uint16');
            switch endian
                case 18761
                    endian = 'l';
                case 19789
                    endian = 'b';
            end
            
            % Find the first IFD
            fseek(I,4,-1);
            fseek(I,fread(I,1,'uint32',0,endian),-1);
            nentries = fread(I,1,'uint16',0,endian);
            
            % Load the offset & bit depth
            j = 1;
            offset = fread(I,1,'uint16',0,endian);
            while j<=nentries&&offset~=258
                fseek(I,10,0);
                offset = fread(I,1,'uint16',0,endian);
                j = j+1;
            end
            fseek(I,6,0);
            bits = fread(I,1,'uint16',0,endian);
            fseek(I,2,0);
            offset = fread(I,1,'uint16',0,endian);
            while j<=nentries&&offset~=273
                fseek(I,10,0);
                offset = fread(I,1,'uint16',0,endian);
                j = j+1;
            end
            fseek(I,6,0);
            offset = fread(I,1,'uint32',0,endian);
            
            % Move to the data
            fseek(I,offset+...
                (realframe-sum(nframes(1:file-1))-1)*width*height*bits/8,...
                -1);
            
            % Load the data
            temp = permute(...
                reshape(...
                fread(I,width*height*(min(end_ind,sum(nframes(1:file)))-start_ind+1-sum(nframes(1:file-1))),...
                [sprintf('uint%i',bits) '=>' sprintf('uint%i',bits)],0,endian)...
                ,[width height (min(end_ind,sum(nframes(1:file)))-start_ind+1-sum(nframes(1:file-1)))])...
                ,[2 1 3]);
            %             keyboard
            if ~exist('out','var')
                out = repmat(eval(['uint' num2str(bits) '(0)']),height,width,(end_ind-start_ind)/frame_skip+1);
            end
            
            out(:,:,(1:ceil(size(temp,3)/frame_skip)))=...
                temp(:,:,1:frame_skip:end);% Save the data in the correct frames
            
            i = i+size(temp,3)/frame_skip;% Jump to the next chunk
            clear temp;
        end
        
        lastfile = file;% Update lastfile
    end
    
    if ~isimj(file)% Reading frame by frame
        T.setDirectory(realframe-sum(nframes(1:file-1)));% Go to the next directory
        if ~exist('out','var')
            out = repmat(eval(['uint' num2str(T.getTag('BitsPerSample')) '(0)']),height,width,(end_ind-start_ind)/frame_skip+1);
        end
        out(:,:,i) = T.read();% Load the image
        i = i+1;% Jump to next frame
    end
end
T.close();% Make sure T is closed
if I~=0, fclose(I); end% Make sure I is closed
out = out-value_offset;

end

function out = validate_last_dir(T,ind)
out = false;
try
    T.setDirectory(ind);
    out = true;
    T.setDirectory(ind+1);
    out = false;
catch err
end
end