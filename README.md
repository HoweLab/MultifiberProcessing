# MultifiberProcessing
Matlab code to preprocess raw multifiber photometry data. See [Vu et al., 2023](https://www.biorxiv.org/content/10.1101/2023.11.17.567425v1).

Update 11/27/23: This repository is currently in progress and code is actively being added. It should be complete shortly.

## Main Steps
1. PREPROCESS_MULTIFIB
   * Convert raw movie files (.cxd) to 3D .tif files, and motion-correct.
2. MAP_ROIS
   * Establish ROIs and extract relevant neural data.


Note that each of these steps is packaged in a Matlab App. There are 2 ways to run each of these apps.
1. The .mlappinstall file contains the installer for the standalone app and includes the dependencies required.
2. If you have the dependencies required in your path (see below), you can alternatively just run the .mlapp file.

## Dependencies

## Other useful functions included:
1. extract_ROI_timeseries.m:
   * This is called by MAP_ROIS and also can be run as a standalone function to change the baseline window, or change the baseline calculation method (sliding 8th percentile vs exponential baseline). 





