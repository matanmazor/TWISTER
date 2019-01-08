classdef Workspace < handle
    properties
        images
        TCA
        params
    end
    methods
        function ws  = Workspace(def_file)
            
            addpath('./lib');
            
            %load def file
            load(def_file);
            %number of temporally concatenated runs
            run_num = numel(def.seed);
            
            %% load files to ws
            
            %load template file
            ws.images.template = load_nii(def.seed{1});
            
            %extract image properties
            ws.images.volumes_num = ws.images.template.hdr.dime.dim(5);
            ws.images.brain_dimensions = ws.images.template.hdr.dime.dim(2:4);
            ws.images.voxels_num = prod(ws.images.brain_dimensions);
            ws.images.voxel_size = ws.images.template.hdr.dime.pixdim(2:5);
            [ws.images.seed, ws.images.red, ws.images.blue] = ...
                deal([]);
            for cur_run = 1:run_num
                
                cur_seed_run = load_nii(def.seed{cur_run});
                ws.images.seed = cat(2,ws.images.seed, ...
                    zscore(reshape(cur_seed_run.img, ws.images.voxels_num, ...
                    ws.images.volumes_num)')');
                
                cur_red_run = load_nii(def.red{cur_run});
                ws.images.red = cat(2,ws.images.red, ...
                    zscore(reshape(cur_red_run.img, ws.images.voxels_num, ...
                    ws.images.volumes_num)')');
                
                cur_blue_run = load_nii(def.blue{cur_run});
                ws.images.blue = cat(2,ws.images.blue, ...
                    zscore(reshape(cur_blue_run.img, ws.images.voxels_num, ...
                    ws.images.volumes_num)')');
                
            end
            
            if ~strcmp(def.mask, '-')
                % if mask is defined, load it and apply to the
                % functional images
                
                mask = load_nii(def.mask);
                ws.images.mask = mask.img;
                ws.images.relevant_voxels = find(ws.images.mask);
                
            else
                %otherwise, all voxels are relevant
                ws.images.relevant_voxels = 1:ws.images.voxels_num;
            end
            
            %get relevant voxels coordinates in 3d space
            [x,y,z] = ind2sub(...
                ws.images.brain_dimensions, ws.images.relevant_voxels);
            ws.images.voxels_coordinates = [x y z];
            
            %save only relevant voxels
            ws.images.seed = ws.images.seed(ws.images.relevant_voxels,:);
            ws.images.red = ws.images.red(ws.images.relevant_voxels,:);
            ws.images.blue = ws.images.blue(ws.images.relevant_voxels,:);
            
            %set output directory
            ws.params.output_dir = def.output_dir;
            
            %save red and blue dimensions
            ws.TCA.blue_dimension = def.blue_dimension;
            ws.TCA.red_dimension = def.red_dimension;
        end
    end
end
