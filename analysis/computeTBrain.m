function [  ] = computeTBrain( ws )
%The function generates a vector of t values comparing the consistencies
%along the blue and red dimensions for all voxels in the brain

%write message to screen
sprintf('Computing voxels'' temporal consistency asymmetry cofficients')

%% set empty vectors
[t_vec, p_vec] = deal(nan(size(ws.images.relevant_voxels)));

%% loop over voxels and compute a t and a p value for each
for cur_voxel = 1:size(ws.images.relevant_voxels,1)
    
   %set negative correlations to zero
   seed_red_c = max(0,ws.TCA.correlations.seed_red(cur_voxel));
   seed_blue_c = max(0,ws.TCA.correlations.seed_blue(cur_voxel));
   red_blue_c = max(0,ws.TCA.correlations.red_blue(cur_voxel));
   
   %get relevant ESS value
   ESS = ws.TCA.ESS(cur_voxel);
   
   %compute t value
   t_vec(cur_voxel) = ...
       HotellingWilliams(seed_red_c, seed_blue_c, red_blue_c, ESS);
   
   %compute p value
   if t_vec(cur_voxel)==0
       p_vec(cur_voxel)=1;
   else
       %two tailed
       p_vec(cur_voxel) = 2*tcdf(-abs(t_vec(cur_voxel)), ESS-3);
   end
end

%% save resulting vectors
ws.TCA.T = t_vec;
ws.TCA.P = p_vec;

end

