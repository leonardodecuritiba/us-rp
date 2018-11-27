%% #########################################################################
% Matrix params calculation ------------------------------------------
% calc_matrix_params; % Matrix params calculation
%==========================================================================
% Program to calculate the ULTRASOUND inverse solution
%==========================================================================
% Autor: Leonardo Zanin			Data: DEZEMBRO 2012
% Program to calculate matrix params
%==========================================================================
matrix.M = matrix.roi_pixels(1)*matrix.roi_pixels(3); % Matrix columns
matrix.sampling_frequency = ussys.sampling_frequency;

% Matrix's physical dimension calculation ---------------------------------
% lateral dimension
% half = floor(matrix.roi_pixels(1)/2 - mod(matrix.roi_pixels(1),2))*matrix.roi_resolution(1);
x_init = matrix.roi_center(1) - ((matrix.roi_pixels(1) - mod(matrix.roi_pixels(1),2))/2 * matrix.roi_resolution(1)) + (~mod(matrix.roi_pixels(1),2)* matrix.roi_resolution(1))/2; % Start spatial position in x dimension [mm]
% x_init = matrix.roi_center(1) - half; % Start spatial position in x dimension [mm]

if(flags.calc_simetric_matrix)
    x_end = -x_init; 
else
%     x_end = matrix.roi_center(1) + ((matrix.roi_pixels(1) - mod(matrix.roi_pixels(1),2))/2 * matrix.roi_resolution(1)) - (~mod(matrix.roi_pixels(1),2)* matrix.roi_resolution(1))/2;  % End spatial position in x dimension [mm]
    x_end  = matrix.roi_center(1) + half;
end
matrix.roi_x_values = x_init:matrix.roi_resolution(1):x_end; % ROI dimension values in axial dimension [mm]

% axial dimension
% z_init = matrix.roi_center(3) - ((matrix.roi_pixels(3) - mod(matrix.roi_pixels(3),2))/2 * matrix.roi_resolution(3)) + (~mod(matrix.roi_pixels(3),2)* matrix.roi_resolution(3))/2; % Start spatial position in z dimension [mm]
half = floor(matrix.roi_pixels(3)/2 - mod(matrix.roi_pixels(3),2))*matrix.roi_resolution(3);
z_init = matrix.roi_center(3) - half;
z_end  = matrix.roi_center(3) + half;

% z_end = matrix.roi_center(3) + ((matrix.roi_pixels(3) - mod(matrix.roi_pixels(3),2))/2 * matrix.roi_resolution(3)) - (~mod(matrix.roi_pixels(3),2)* matrix.roi_resolution(3))/2; % End spatial position in z dimension [mm]
% matrix.roi_z_values = z_init:matrix.roi_resolution(3):z_end; % ROI dimension values in axial dimension [mm]
matrix.roi_z_values = linspace(z_init,z_end,matrix.roi_pixels(3)); % ROI dimension values in axial dimension [mm]

% mx=floor(matrix.roi_pixels(1)/2)+mod(matrix.roi_pixels(1),2); % Centro da roi em x
% mz=floor(matrix.roi_pixels(3)/2)+mod(matrix.roi_pixels(3),2); % Centro da roi em z
mx=floor(matrix.roi_pixels(1)/2 + mod(matrix.roi_pixels(1),2)); % Centro da roi em x
mz=floor(matrix.roi_pixels(3)/2 + mod(matrix.roi_pixels(3),2)); % Centro da roi em z

matrix.roi_xz_center = [matrix.roi_x_values(mx) 0 matrix.roi_z_values(mz)];
% matrix.roi_xz_center = [matrix.roi_x_values(floor(end/2)+1) 0 matrix.roi_z_values(floor(end/2)+1)];
% Cálculo dos índices de início e fim da parte do vetor que contem os dados da ROI

% Init/End ROI vector index
d1 = ussys.aperture_physical_Ne * (ussys.aperture_element_width + ussys.aperture_element_kerf);
d2 = (matrix.roi_z_values(1) - matrix.roi_resolution(3) + matrix.roi_area(3)) * 1e-3;
matrix.roi_center_end = sqrt(d1^2 + d2^2); % Spatial (center) ROI end [mm]

if(isfield(ussys,'aperture_TX')), tx_focusing_time = xdc_get(ussys.aperture_TX, 'focus'); else tx_focusing_time = 0; end
matrix.roi_sample_init = round((2 * matrix.roi_z_values(1) * 1e-3/ussys.sound_speed) * ussys.sampling_frequency - length(ussys.impulse_response.signal)/2); % Matrix init index [pix]
matrix.roi_sample_end = round((2 * matrix.roi_center_end/ussys.sound_speed) * ussys.sampling_frequency + floor(max(abs(tx_focusing_time))) + length(ussys.excitation_pulse)); % Matrix end index [pix]
matrix.roi_samples = matrix.roi_sample_end - matrix.roi_sample_init + mod(matrix.roi_sample_end - matrix.roi_sample_init,2); % ROI Length in pixels (max) [pix]

% Cálculo das dimensões da imagem (Ploting)
reconstructions.plot.lateral_index = matrix.roi_x_values;
reconstructions.plot.axial_index = matrix.roi_z_values;
reconstructions.plot.text_x = 'Lateral Distance From Center Element [mm]';
reconstructions.plot.text_y = 'Axial Distance From the surface of Transducer [mm]';

if(flags.calc_simetric_matrix || flags.calc_simetric_half_matrix)
    matrix.Mm = matrix.roi_pixels(1) + matrix.roi_pixels(1)*(matrix.roi_pixels(3)/2 - 1) + mod(matrix.roi_pixels(1),2) * (matrix.roi_pixels(3)/2);
end

matrix.wavelength = ussys.aperture_wavelength*1e3;
clear x_init x_end z_init z_end d1 d2 tx_focusing_time mx mz;