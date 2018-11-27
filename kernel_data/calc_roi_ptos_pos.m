function pos = calc_roi_ptos_pos(pht_pos, n_pts, step)
%CALC_ROI_PTOS_POS Calculate ROI points.
%   pht_pos: Reference point to calculate (pht_pos.x, pht_pos.z)
%
%   num_ptos: Number of points in subpixel level
%
%   matrix: Data from the main matrix
%
%   Copyright 2012
%   Author: Leonardo Zanin
%   Creation: 2012/12/14

% % step.Dx = matrix.res_mm_px_x / n_pts; % Steps in [mm] to diffuse kernel positions (lateral)
% % step.Dz = matrix.res_mm_px_z / n_pts; % Steps in [mm] to diffuse kernel positions (axial)

if(~mod(n_pts,2)) % Testing if n_pts is odd or even
    pht_pos = pht_pos + [step.Dx/2 0 step.Dz/2];
    col_step = -(n_pts/2):(n_pts/2) -1;
else
    col_step = (-floor(n_pts/2):floor(n_pts/2));
end

MAT_step_Dx = (ones(1,n_pts))' * col_step;
MAT_step_Dz = col_step' * (ones(1,n_pts));

positions_x = pht_pos(:,1) + (step.Dx * MAT_step_Dx); % Posições em x
positions_z = pht_pos(:,3) + (step.Dz * MAT_step_Dz); % Posições em z
pos = [positions_x(:) zeros(n_pts * n_pts,1) positions_z(:)];


% % if(~mod(n_pts,2)) % Testing if n_pts is odd or even
% %     pht_pos.x = pht_pos.x + step.Dx/2;
% %     pht_pos.z = pht_pos.z + step.Dz/2;
% %     col_step = -(n_pts/2):(n_pts/2) -1;
% % else
% %     col_step = (-floor(n_pts/2):floor(n_pts/2));
% % end
% % 
% % MAT_step_Dx = (ones(1,n_pts))' * col_step;
% % MAT_step_Dz = col_step' * (ones(1,n_pts));
% % 
% % positions_x = pht_pos.x + (step.Dx * MAT_step_Dx); % Posições em x
% % positions_z = pht_pos.z + (step.Dz * MAT_step_Dz); % Posições em z
% % pos = [positions_x(:) zeros(n_pts * n_pts,1) positions_z(:)];

