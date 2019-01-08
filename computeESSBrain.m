function [  ] = computeESSBrain( ws )
%compute effective sample size for each voxel in the brain

%write message to screen
sprintf('Computing voxels'' effective sample sizes. This may take a few minutes')

%create ESS matrix
ESS_mat = nan(size(ws.images.relevant_voxels,1),3);

for voxel_num = 1:1:size(ws.images.relevant_voxels,1)
    
    ESS_mat(voxel_num,1) = computeESS(ws.images.seed(voxel_num,:),7);
    ESS_mat(voxel_num,2) = computeESS(ws.images.red(voxel_num,:),7);
    ESS_mat(voxel_num,3) = computeESS(ws.images.blue(voxel_num,:),7);
end

%average the three ESS estimates to generate a voxel-wise estimate
ESS_vec = mean(ESS_mat,2);
%organize the voxels in the 3d space
ESS_brain = nan(size(ws.images.mask));
ESS_brain(ws.images.relevant_voxels)= ESS_vec;

%apply robust smoothing (by Damien Garcia) to the resulting 3d image
ESS_brain = smoothn(ESS_brain,'robust');

%extract relevant voxels and save to ws
ws.TCA.ESS = ESS_brain(ws.images.relevant_voxels);