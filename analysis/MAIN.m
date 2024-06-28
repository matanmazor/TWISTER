%% Temporal Consistency Analysis
% the script follows the anaylsis steps as described in 
% []...

%% 1. Load files and flatten images to 2d matrices
%     accepted formats are nii and nii.gz
%     normally, preprocessing should include motion correction, 
%     temporal highpass filtering and possibly spatial smoothing.

%     create workspace based on def file
ws = Workspace('./config/config_example.mat');

%% 2. Perform validation tests

if ~(isequal(size(ws.images.seed),size(ws.images.red)) &...
        isequal(size(ws.images.seed),size(ws.images.blue)))
    error('images are not equal in size')
end

if ~isequal(size(ws.images.template.img(:,:,:,1)), size(ws.images.mask))
    error('mask is not equal in size to functional images')
end

%% 3. Extract voxel-wise correlations
computeCorrelations(ws);

%% 4. Extract voxel-wise effective sample size
computeESSBrain(ws);

%% 5. Compute Hotelling-Williams voxel-wise t value
 %     based on Williams, E. J. (1959). The comparison of regression variables. 
%     Journal of the Royal Statistical Society. Series B (Methodological), 396-399.
computeTBrain(ws);

%% 6. Save and visualize results
saveFiles(ws);
addpath('./visualization');
viewTimeCourses(fullfile('output',ws.params.output_dir));