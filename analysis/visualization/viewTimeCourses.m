function [  ] = viewTimeCourses( output_dir )

close all;

if ~exist('output_dir', 'var')
    output_dir = uigetdir('please choose output directory');
end

%% load files
load(fullfile(output_dir,'TCA.mat'));
load(fullfile(output_dir,'images.mat'));

%%create TCA triplet
triplet_fig = makeTCATriplet(TCA.blue_dimension, TCA.red_dimension);

%% fix mask and add filler data to non-brain voxels

mask                    = double(images.mask);
mask(find(mask))        = 1:size(images.relevant_voxels,1);
mask(find(mask==0))     = size(images.relevant_voxels,1)+1;

seed                    = [images.seed; zeros(1, size(images.seed,2))];
blue                    = [images.blue; zeros(1, size(images.blue,2))];
red                     = [images.red; zeros(1, size(images.red,2))];
T                       = [TCA.T; 0];
seed_red_c              = [TCA.correlations.seed_red; 0];
seed_blue_c             = [TCA.correlations.seed_blue; 0];
red_blue_c              = [TCA.correlations.red_blue; 0];

%% set structural image to first volume in the template image
structural = squeeze(images.template.img(:,:,:,1));

%% create statistical maps
empty_map = zeros(size(structural));
[red_map, blue_map, FDR_red_map, FDR_blue_map] = deal(empty_map);
red_map(images.relevant_voxels) = TCA.T.*TCA.red_thresholded;
blue_map(images.relevant_voxels) = -TCA.T.*TCA.blue_thresholded;
FDR_red_map(images.relevant_voxels) = TCA.T.*TCA.red_FDR;
FDR_blue_map(images.relevant_voxels) = -TCA.T.*TCA.blue_FDR;

%% create figures
timecourses = figure('units','centimeters', 'Position', [0, 15, 20, 3],...
    'MenuBar', 'none', 'Color', [1, 1, 1], 'NumberTitle', 'off');
drawnow()
coronal = figure('units','centimeters', 'Position', [0, 10, 5, 5],...
    'MenuBar', 'none', 'Color', [0, 0, 0], 'NumberTitle', 'off');
drawnow()
sagittal = figure('units','centimeters', 'Position', [5, 10, 5, 5],...
    'MenuBar', 'none', 'Color', [0, 0, 0], 'NumberTitle', 'off');
drawnow()
axial = figure('units','centimeters', 'Position', [10, 10, 5, 5],...
    'MenuBar', 'none', 'Color', [0, 0, 0], 'NumberTitle', 'off');
drawnow()
%open scatter figure
% voxels_scatter = figure('units','centimeters', 'Position', [0, 0, 10, 10],...
%     'MenuBar', 'none', 'Color',[1, 1, 1]);
% drawnow()
% figure(voxels_scatter);
% subplot('position', [0.2,0.2,0.8,0.8]);
% hold on;
% scatter(TCA.correlations.seed_red,...
%     TCA.correlations.seed_blue, 50, 'MarkerFaceColor','black',...
%     'MarkerEdgeColor','black', 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
% xlabel(sprintf('red (%s) correlation', TCA.red_dimension)); 
% ylabel(sprintf('blue (%s) correlation', TCA.blue_dimension));
% xlim([-1 1]); ylim([-1 1]);
% plot([0,1],[0,1],'black');
% plot([-1 1], [0 0],'black');
% plot([0 0], [-1 1],'black');
% xticks([-1:0.5:1]);
% yticks([-1:0.5:1]);

TCA.FDR=TCA.blue_FDR+TCA.red_FDR;

voxels_scatter = figure('units','centimeters', 'Position', [0, 0, 10, 10],...
    'MenuBar', 'none', 'Color',[1, 1, 1]);
drawnow()
figure(voxels_scatter);
subplot('position', [0.2,0.2,0.8,0.8]);

colorMap = [linspace(0,255,256)' linspace(111,0,256)' linspace(254,0,256)']/256;
hold on;
scatter(TCA.correlations.seed_red,...
    TCA.correlations.seed_blue, 50, TCA.T);
colormap(colorMap)

scatter(TCA.correlations.seed_red(TCA.FDR>0),...
    TCA.correlations.seed_blue(TCA.FDR>0), 50, TCA.T(TCA.FDR>0),'filled', 'MarkerEdgeColor','black');

xlabel(sprintf('red (%s) correlation', TCA.red_dimension)); 
ylabel(sprintf('blue (%s) correlation', TCA.blue_dimension));
xlim([-0.25 0.6]); ylim([-0.25 0.6]);
plot([0,1],[0,1],'black');
plot([-0.25 1], [0 0],'black');
plot([0 0], [-0.25 1],'black');
xticks([-1:0.5:1]);
yticks([-1:0.5:1]);

scattr_dcm = datacursormode(voxels_scatter);
cor_dcm = datacursormode(coronal);
sag_dcm = datacursormode(sagittal);
axi_dcm = datacursormode(axial);
set(scattr_dcm, 'enable', 'on')
set(sag_dcm, 'enable', 'on')
set(axi_dcm, 'enable', 'on')
set(cor_dcm, 'enable', 'on')

%initialize cursor variables
sag_cursor = [];
cor_cursor = [];
axi_cursor = [];
scttr_cursor = [];


%% create map
% generate a TCA map
map = adjustMapsForView( structural, red_map, ...
    blue_map, FDR_red_map, FDR_blue_map);

%% if not given by user, use center coordinates.
%otherwise, multiply by the voxel size factors

x = round(size(structural,1)/2); % right<->left
y = round(size(structural,2)/2); % back<->front
z = round(size(structural,3)/2); % up<->down

%obtain voxel_id
voxel_id = mask(x,y,z);
figure(voxels_scatter);
red_voxel = scatter(TCA.correlations.seed_red(voxel_id),...
    TCA.correlations.seed_blue(voxel_id), 50, 'red');

%% set colors

red_rgb = [243, 23, 23];
blue_rgb = [0, 112, 255];
ref_rgb = [0, 0, 0];

%% MAIN LOOP

disp('click any voxel, either on the brain maps or on the scatter plot, and hit Enter')

while length(findobj('type','figure'))==6

    figure(voxels_scatter);
    delete(red_voxel);
    red_voxel = scatter(seed_red_c(voxel_id),...
        seed_blue_c(voxel_id), 50, 'red');
    
    figure(timecourses)
    plot(1:size(seed,2),  zscore(seed(voxel_id,:)), 'color', ref_rgb/255); hold on;
    plot(1:size(seed,2), zscore(red(voxel_id,:)), 'color', red_rgb/255); hold on;
    plot(1:size(seed,2), zscore(blue(voxel_id,:)), 'color',blue_rgb/255);
    xlim([1, size(seed,2)]);
    title(sprintf('The red (%s) correlation is %.2f and the blue (%s) correlation is %.2f %s',...
        TCA.red_dimension, seed_red_c(voxel_id), TCA.blue_dimension, seed_blue_c(voxel_id)));
    hold off
    drawnow()
   
    
    sagittal_slice = squeeze(map(x,:,:,:));
    %draw axes
     sagittal_slice(y,:,:) = max(1.3*sagittal_slice(y,:,:), 0.2*max(map(:)));
     sagittal_slice(:,z,:) = max(1.3*sagittal_slice(:,z,:), 0.2*max(map(:)));
    sagittal_slice = flip(flip(permute(sagittal_slice,[2,1,3]),1),2);
    
    coronal_slice = squeeze(map(:,y,:,:));
    %draw axes
     coronal_slice(x,:,:) = max(1.3*coronal_slice(x,:,:), 0.2*max(map(:)));
     coronal_slice(:,z,:) = max(1.3*coronal_slice(:,z,:), 0.2*max(map(:)));
    coronal_slice = flip(flip(permute(coronal_slice,[2,1,3]),1),2);
    
    axial_slice = squeeze(map(:,:,z,:));
    %draw axes
     axial_slice(x,:,:) = max(1.3*axial_slice(x,:,:), 0.2*max(map(:)));
     axial_slice(:,y,:) = max(1.3*axial_slice(:,y,:), 0.2*max(map(:)));
    axial_slice = flip(flip(permute(axial_slice,[2,1,3]),1),2);
    
    
    figure(sagittal);
    subplot('position', [0,0,1,1]);
    imshow(sagittal_slice, [min(map(:)),max(map(:))]);
    title(sprintf('x = %d, y = %d, z = %d',x,y,z));
    drawnow()
    
    figure(coronal);
    subplot('position', [0,0,1,1]);
    imshow(coronal_slice, [min(map(:)),max(map(:))]);
    title(sprintf('x = %d, y = %d, z = %d',x,y,z));
    drawnow()
    
    figure(axial);
    subplot('position', [0,0,1,1]);
    imshow(axial_slice, [min(map(:)),max(map(:))]);
    title(sprintf('x = %d, y = %d, z = %d',x,y,z));
    drawnow()
    
    pause;
       
    if ~isequal(scttr_cursor, getCursorInfo(scattr_dcm))
        scttr_cursor = getCursorInfo(scattr_dcm);
        voxel_id = find((TCA.correlations.seed_red == scttr_cursor.Position(1)) &...
            (TCA.correlations.seed_blue == scttr_cursor.Position(2)),1);
        x = images.voxels_coordinates(voxel_id,1);
        y = images.voxels_coordinates(voxel_id,2);
        z = images.voxels_coordinates(voxel_id,3);
    elseif ~isequal([], getCursorInfo(axi_dcm))
        axi_cursor = getCursorInfo(axi_dcm);
        x = images.brain_dimensions(1)-axi_cursor.Position(1)+1;
        y = images.brain_dimensions(2)-axi_cursor.Position(2)+1;
        voxel_id = mask(x,y,z);
    elseif ~isequal([], getCursorInfo(cor_dcm))
        cor_cursor = getCursorInfo(cor_dcm);
        x = images.brain_dimensions(1)-cor_cursor.Position(1)+1;
        z = images.brain_dimensions(3)-cor_cursor.Position(2)+1;
        voxel_id = mask(x,y,z);
    elseif ~isequal([], getCursorInfo(sag_dcm))
        sag_cursor = getCursorInfo(sag_dcm);
        y = images.brain_dimensions(2)-sag_cursor.Position(1)+1;
        z = images.brain_dimensions(3)-sag_cursor.Position(2)+1;
        voxel_id = mask(x,y,z);
    end
end
close all;

end

