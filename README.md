# MultifiberProcessing
Matlab code to preprocess raw multifiber photometry data (see Vu et al, 2023). 

There are 2 main steps (the 3rd is optional):
1. Convert and motion-correct: run PREPROCESS_MULTIFIB_App to convert raw movie files (.cxd) to 3D .tif files, and motion-correct.
2. Extract ROI data: run MAP_ROIS_App to establish ROIs and extract relevant neural data.

Other useful functions included:
1. extract_ROI_timeseries.m: this is called by MAP_ROIS_App and also can be run as a standalone function to change the baseline window, or change the baseline calculation method (sliding 8th percentile vs exponential baseline). 



Update 11/27/23: This repository is currently in progress and code is actively being added. It should be complete shortly.

