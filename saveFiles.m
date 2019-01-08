function [  ] = saveFiles( ws )
%create a dir for output files and save files in it

mkdir(['./output/', ws.params.output_dir]);

%% save nifty files
template = ws.images.template;
%output images are three dimensional;
template.hdr.dime.dim(1) = 3;
template.hdr.dime.dim(5) = 1;
template.img = zeros(size(ws.images.mask));

% save correlation brains:
%seed_red
seed_red_brain = template;
seed_red_brain.img(ws.images.relevant_voxels) = ws.TCA.correlations.seed_red;
save_nii(seed_red_brain, ...
    ['./output/', ws.params.output_dir, '/seed_red_cor.nii.gz']);

%seed_blue
seed_blue_brain = template;
seed_blue_brain.img(ws.images.relevant_voxels) = ws.TCA.correlations.seed_blue;
save_nii(seed_blue_brain, ...
    ['./output/', ws.params.output_dir, '/seed_blue_cor.nii.gz']);

%red_blue
red_blue_brain = template;
red_blue_brain.img(ws.images.relevant_voxels) = ws.TCA.correlations.red_blue;
save_nii(red_blue_brain, ...
    ['./output/', ws.params.output_dir, '/red_blue_cor.nii.gz']);

%save unthresholded t-map
t_brain = template;
t_brain.img(ws.images.relevant_voxels) = ws.TCA.T;
save_nii(t_brain, ...
    ['./output/', ws.params.output_dir, '/t.nii.gz']);

%save fdr-corrected t-maps
fdr_t_brain = t_brain;
corrected_voxels = fdr_bh(ws.TCA.P);
fdr_t_brain.img(ws.images.relevant_voxels(~corrected_voxels))=0;
save_nii(fdr_t_brain, ...
    ['./output/', ws.params.output_dir, '/fdr_t.nii.gz']);
ws.TCA.red_FDR = corrected_voxels & ws.TCA.T>0;
ws.TCA.blue_FDR = corrected_voxels & ws.TCA.T<0;

%save thresholded t-maps
thresholded_t_brain = t_brain;
%use a voxel-wise threshold of 0.001
thresholded_voxels = ws.TCA.P<0.001; 
%leave only clusters of more than 20 adjacent voxels
thresholded_p_map = zeros(ws.images.brain_dimensions);
thresholded_p_map(ws.images.relevant_voxels(thresholded_voxels))=1;
thresholded_p_map = cleanSmallClusters(thresholded_p_map,20 );
thresholded_t_brain.img(~thresholded_p_map)=0;
save_nii(thresholded_t_brain, ...
    ['./output/', ws.params.output_dir, '/thresholded_t.nii.gz']);
ws.TCA.red_thresholded = thresholded_p_map(ws.images.relevant_voxels) ...
    & ws.TCA.T>0;
ws.TCA.blue_thresholded = thresholded_p_map(ws.images.relevant_voxels) ...
    & ws.TCA.T<0;

%organize voxels in 3d space;
thresholded_t_brain.img(ws.images.relevant_voxels(~corrected_voxels))=0;
%save ESS map
ESS_brain = template;
ESS_brain.img(ws.images.relevant_voxels) = ws.TCA.ESS;
save_nii(ESS_brain, ...
    ['./output/', ws.params.output_dir, '/ESS.nii.gz']);

%save p-values map
P_brain = template;
P_brain.img = ones(size(ws.images.mask));
P_brain.img(ws.images.relevant_voxels) = ws.TCA.ESS;
save_nii(P_brain, ...
    ['./output/', ws.params.output_dir, '/P.nii.gz']);

%save workspace
TCA = ws.TCA;
images = ws.images;
save(['./output/', ws.params.output_dir, '/TCA.mat'],'TCA');
save(['./output/', ws.params.output_dir, '/images.mat'],'images');


end

