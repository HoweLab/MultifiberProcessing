% outputFilepaths = cxd2tif(cxdFilepath,varargin)
%
% convert cxd (Hamamatsu) video files to 1 or more .tif files
%
% required input:
% path to the cxd file, as a string, e.g., cxd2tif('path/to/data.cxd')
% 
% optional inputs:
% 1. maxSizeGB - the maximum file size (in GB) of your output tif(s). If the
% data are bigger than that, it will write out multiple tifs. Default = 15.
% 2. outputFilepath - the filepath to save out to: default is same as .cxd
% filepath, but .tif instead
%
% examples (note: you can mix and match optional outputs, in whatever order)
% cxd2tif('path/to/data.cxd','outputFilepath','/path/to/output.tif','maxSizeGB',15)
% cxd2tif('path/to/data.cxd','maxSizeGB',15,'outputFilepath','/path/to/output.tif')
%
% this function returns the path(s) to the output(s) as a cell array
%
% Mai-Anh Vu
% updated 12/1/2023

function cxd2tif(cxdFilepath,varargin)

%%%  parse inputs %%%
ip = inputParser;
ip.addParameter('outputFilepath',[cxdFilepath(1:end-4) '.tif']);
ip.addParameter('maxSizeGB',15)
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end
% check that the filepath exists
if ~exist(cxdFilepath,'file')
    disp('cxdFilepath does not exist.')
    disp('try again.')
    return
end

% initialize reader 
try
    reader = bfGetReader(cxdFilepath);
catch exception
    if exist('reader','var')
        reader.close();
    end
    if strcmp(exception.identifier,'MATLAB:Java:GenericException')
        disp('ERROR: you will need to increase your JAVA heap memory')
        disp('see https://www.mathworks.com/help/matlab/matlab_external/java-heap-memory-preferences.html')
        return
    end
end
%omeMeta = reader.getMetadataStore();
nFrames = reader.getImageCount;

% let's loop through and save out
currentData = [];
currentOutput = 1;
for idx = 1:nFrames    
    thisFrame = bfGetPlane(reader, idx);
    thisFrameSize = whos('thisFrame');
    thisFrameSize = thisFrameSize.bytes;
    currentDataSize = whos('currentData');
    currentDataSize = currentDataSize.bytes;
    % if we're still under the file limit, just concatenate it
    if (currentDataSize+thisFrameSize)/1e9 <= (maxSizeGB-1.5) % little buffer just in case        
        currentData = cat(3,currentData,thisFrame);
        % if we happen to be at the end of the movie, write it out
        if idx==nFrames
            thisOutput = [outputFilepath(1:end-4) '_' num2str(currentOutput) '.tif'];
            save_tif(thisOutput,currentData)                                                 
        end
    % otherwise, write out what we've got, then update what file we're on,
    % and then set the unconcatenated frame as currentData
    else
        thisOutput = [outputFilepath(1:end-4) '_' num2str(currentOutput) '.tif'];
        save_tif(thisOutput,currentData)        
        currentOutput = currentOutput+1;
        currentData = thisFrame;
    end
end
reader.close();
if currentOutput == 1 % if we only wrote one file, re-save it without the number
    movefile(thisOutput,[thisOutput(1:end-6) '.tif']);
end

% save tif
function save_tif(filepath,data)
fTIF = Fast_BigTiff_Write(filepath,0,Tiff.Compression.LZW);    
for i = 1:size(data,3)
    fTIF.WriteIMG(data(:,:,i));
end
fTIF.close;

