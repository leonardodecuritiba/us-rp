function H = calc_matrix_h(matrix, ussys, flags)
%==========================================================================
% Program to calculate the ULTRASOUND inverse solution
%==========================================================================
% Autor: Leonardo Zanin			Data: DEZEMBRO 2012
% Program to calculate matrix operator H (direct formulation)
%==========================================================================

if(flags.show_bar)
    win_wait_bar = waitbar(0,'Calculating H Matrix...');
end

H = [];
matriz_temp = [];

% -------------------------------------------------------------------------
phantom.amp = matrix.roi_amp(:);
step.Dx = matrix.roi_Dx;
step.Dz = matrix.roi_Dz;
n_pts = matrix.base.n_pts;

[x, z] = meshgrid(matrix.roi_x_values,matrix.roi_z_values);
matrix_pos = [x(:), zeros(matrix.M,1), z(:)];

Mm = matrix.M;
% matrix.cshape = 'non_simetric';

if(flags.calc_simetric_matrix || flags.calc_simetric_half_matrix)
    Mm = matrix.Mm;
end

for col_m = 1:matrix.Mm
    pht_pos = matrix_pos(col_m,:);

    if(flags.show_bar)
        waitbar(col_m / matrix.Mm); %Wait bar
    end        

    phantom.pos = calc_roi_ptos_pos(pht_pos, n_pts, step) * 1e-3; % Positions calculation of points in subpixel level    
    
    [datax.data_beam, datax.time_pre_beam] = calc_scat_multi(ussys.aperture_TX, ussys.aperture_RX, phantom.pos, phantom.amp);    
    data = calc_data(matrix, ussys, flags, datax);
    
    if(flags.calc_mat_normalized)
        data.G(:) = data.G(:)/norm(data.G(:));
    end
    H(:,col_m) = data.G(:);

    if(flags.calc_simetric_matrix && ~flags.calc_simetric_half_matrix)
        data_temp = flip(data.G,2);
        matriz_temp(:,col_m) = data_temp(:);
    end
    
end

if(flags.calc_simetric_matrix && ~flags.calc_simetric_half_matrix)
    XX = reshape(1:matrix.M - matrix.Mm, matrix.roi_pixels(3), ceil(matrix.roi_pixels(1)/2) - mod(matrix.roi_pixels(1),2));
    cols = flip(XX,2);
    H(:,matrix.Mm+1:matrix.M) = matriz_temp(:,cols(:));
end

if(flags.show_bar)
    close(win_wait_bar);
end

% % 
% % if(flags.show_bar)
% %     win_wait_bar = waitbar(0,'Calculating H Matrix...');
% % end
% % H = 0;
% % H = [];
% % 
% % % -------------------------------------------------------------------------
% % phantom.amp = matrix.roi.amp(:);
% % step.Dx = matrix.roi.Dx;
% % step.Dz = matrix.roi.Dz;
% % n_pts = matrix.base.n_pts;
% % 
% % [x, z] = meshgrid(matrix.roi.x_values,matrix.roi.z_values);
% % matrix_pos = [x(:), zeros(matrix.M,1), z(:)];
% % 
% % Mm = matrix.M;
% % 
% % for col_m = 1:COL_M
% %     pht_pos = matrix_pos(col_m,:);
% % 
% %     if(flags.show_bar)
% %         waitbar(col_m / COL_M); %Wait bar
% %     end        
% % 
% %     phantom.pos = calc_roi_ptos_pos(pht_pos, n_pts, step) * 1e-3; % Positions calculation of points in subpixel level
% %     data = calc_data(matrix, ussys, flags, phantom);
% % 
% %     if(flags.calc_mat_normalized)
% %         data(:) = data(:)/norm(data(:));
% %     end
% %     H(:,col_m) = data(:);
% % end
% % 
% % 
% % if(flags.show_bar)
% %     close(win_wait_bar);
% % end
