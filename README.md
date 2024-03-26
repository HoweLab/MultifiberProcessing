# MultifiberProcessing
MATLAB code to preprocess raw multifiber photometry data. This code was written and developed in MATLAB2020b. See [Vu et al., 2024](https://www.sciencedirect.com/science/article/pii/S0896627323009704?via%3Dihub).


# Main Steps

**Note** that each of these steps is packaged in a Matlab App. There are 2 ways to run each of these apps.
1. The .mlappinstall file contains the installer for the standalone app and includes the dependencies required.
2. If you have the dependencies required in your path (see below), you can alternatively just run the .mlapp file.

## 1) PREPROCESS_MULTIFIB
Convert raw movie files (.cxd) to 3D .tif files, and motion-correct. See PREPROCESS_MULTIFIB_README.pdf for instructions and more info.

![Screenshot 2023-12-01 161617](https://github.com/HoweLab/MultifiberProcessing/assets/21954946/dc77fdcd-b07d-489c-bde0-16c87edfcbf2)



## 2) MAP_ROIS 
Establish ROIs and extract relevant neural data. See MAP_ROIS_README.pdf for instructions and more info.
  
   
![Screenshot 2024-03-25 093832](https://github.com/HoweLab/MultifiberProcessing/assets/21954946/d9204dd5-12f1-481d-a483-faaab3c9c271)



## Other useful functions included:
1. **extract_ROI_timeseries.m**
   * This is called by MAP_ROIS and also can be run as a standalone function to change the baseline window, or change the baseline calculation method (sliding 8th percentile vs exponential baseline).
   * Type 'help extract_ROI_timeseries' in the Matlab command window for more info.
2. **motion_correct.m**, **load_tiffs_fast.m**, and **write_tiff_fast.m**, functions originally provided by Dr. Jason R. Climer (jason.r.climer@gmail.com). Any updates have been noted within the script.
     
## Dependencies
* [Bio-Formats](https://bio-formats.readthedocs.io/en/v7.0.1/users/matlab/index.html)
* [conv_fft2](https://www.mathworks.com/matlabcentral/fileexchange/31012-2-d-convolution-using-the-fft)
* [MATLAB Image Processing Toolbox](https://www.mathworks.com/products/image.html)
* [MATLAB Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html)
* [MATLAB Curve Fitting Toolbox](https://www.mathworks.com/products/curvefitting.html)








