% #########################################################################
% Script de definição de configurações relativas ao tipo da matriz
switch(matrix.type)
    case 'REAL'
        flags.calc_mat_downsampling = 0;
        matrix.base.n_pts = 1; % Number of points in subpixel level.
    case 'COMPLEX'
        flags.calc_mat_downsampling = 1;
        matrix.base.n_pts = 1; % Number of points in subpixel level
    case 'COMPLEX_D_NY'
        flags.calc_mat_downsampling = 2;
        matrix.base.n_pts = 1; % Number of points in subpixel level
        matrix.sampling_frequency_down = ussys.aperture_center_frequency*2; % New sampling frequency
        matrix.fs_down_ratio = ussys.sampling_frequency/matrix.sampling_frequency_down; % New fs down ratio
        matrix.roi_samples_down = floor(matrix.roi_samples/matrix.fs_down_ratio); % New data samples
    case 'COMPLEX_D_BW'
        flags.calc_mat_downsampling = 2;
        matrix.base.n_pts = 1; % Number of points in subpixel level
        matrix.sampling_frequency_down = ussys.aperture_bandwidth; % New sampling frequency
        matrix.fs_down_ratio = ussys.sampling_frequency/matrix.sampling_frequency_down; % New fs down ratio
        matrix.roi_samples_down = floor(matrix.roi_samples/matrix.fs_down_ratio); % New data samples      
    case 'COMPLEX_D_HBW'
        flags.calc_mat_downsampling = 2;
        matrix.base.n_pts = 1; % Number of points in subpixel level
        matrix.sampling_frequency_down = ussys.aperture_bandwidth/2; % New sampling frequency
        matrix.fs_down_ratio = ussys.sampling_frequency/matrix.sampling_frequency_down; % New fs down ratio
        matrix.roi_samples_down = floor(matrix.roi_samples/matrix.fs_down_ratio); % New data samples   
    case 'COMPLEX_D'
        flags.calc_mat_downsampling = 2;
        matrix.base.n_pts = 1; % Number of points in subpixel level
        if(~isfield(matrix,'sampling_frequency_down'))
            if(~isfield(matrix,'fs_down_ratio')), matrix.fs_down_ratio = 2; end % Frequency down ratio
            matrix.sampling_frequency_down = ussys.sampling_frequency/matrix.fs_down_ratio; % New data samples
        else
            matrix.fs_down_ratio = ussys.sampling_frequency/matrix.sampling_frequency_down; % New fs down ratio
        end
        matrix.roi_samples_down = floor(matrix.roi_samples/matrix.fs_down_ratio); % New data samples
        matrix.type = [matrix.type '_fs_' num2str(matrix.sampling_frequency_down*1e-6)];        
    case 'DIFFUSE'
        flags.calc_mat_downsampling = 0;
        matrix.base.type = 'spline'; % Type of base function
        matrix.base.n_pts = 5; % Number of points in subpixel level
        matrix.base.param = 3; % Parameter for base function (spline order)
end

matrix.roi_amp = calc_roi_ptos_amp(matrix.base.type, matrix.base.n_pts, matrix.base.param); % Amplitude calculation of points in subpixel level
if(~strcmp(matrix.base.type,'lambda'))
    matrix.roi_amp = (matrix.roi_amp' * matrix.roi_amp)/max(matrix.roi_amp(:));
end

matrix.roi_Dx = matrix.roi_resolution(1)/matrix.base.n_pts;
matrix.roi_Dz = matrix.roi_resolution(3)/matrix.base.n_pts;

if(~isfield(matrix,'limiar_sparse')), matrix.limiar_sparse = 0; end


