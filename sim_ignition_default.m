clear all;
close all;

% ==========================================================================
% Definição dos diretórios das funções e locais para salvar os resultados
% ==========================================================================
addpath(genpath('kernel_simulation')); % Define simulation path
sim_gen_paths; % Generating paths
TEMP.a = dbstack;
DEFAULT_SAVE_PATH = [TEMP.a.name];
TEMP.t = clock;
DIR = [pwd '\RESULTS\' date '\t_' num2str(TEMP.t(4))  '-' num2str(TEMP.t(5)) '-' num2str(round(TEMP.t(6))) '\' DEFAULT_SAVE_PATH '\'];
clear TEMP;
% ==========================================================================
matrix.type = 'REAL';%,'COMPLEX', 'COMPLEX_D_NY','COMPLEX_D_BW','COMPLEX_D_HBW'};

ussys.name = 'Simulation Default';
%vsx_data.filename = 'vsx_data/configs_exp2';      % pontual (ROI reduzida e estendida)
vsx_data.filename = 'vsx_data/exp_phantom_cyst';  % cisto
%vsx_data.filename = 'vsx_data/configs_exp4';       % multipontos
%vsx_data.filename = 'vsx_data/exp_pts';
flags.simulation_real_data = 1; % 1:Verasonics
flags.calc_force_mat_sparse = 1; 
flags.simulation_single = 0;
flags.calc_pseu_svd = 0;

%% Defining simulation parameters
def_sim_flags; % Defining simulation flags
def_sim_system; % Defining simulation parameters

%% Forward Problem formulation parameters
% ROI parameters
wavelength = ussys.aperture_wavelength*1e3;

%matrix.roi_center = [0, 0, 140] * wavelength; % ROI center point (x,y,z)[mm]
%matrix.roi_center = [0, 0, 6];  % ROI center point (x,y,z)[mm] -- original
%matrix.roi_center = [0, 0, 6];  % ROI center point (x,y,z)[mm] -- ROI estendida
%matrix.roi_center = [0, 0, 6];  % ROI center point (x,y,z)[mm] -- ROI estendida (verif sincro g e H)
matrix.roi_center = [0, 0, 29]; % ROI center point (x,y,z)[mm] -- cisto
%matrix.roi_center = [0, 0, 36];  % ROI center point (x,y,z)[mm] -- multipontos

%matrix.roi_resolution = [1, 0, 1] * wavelength;
%matrix.roi_resolution = [1.0, 0, 0.5] * wavelength; % [mm/pix]  -- original
%matrix.roi_resolution = [1.0, 0, 1.0] * wavelength; % [mm/pix]  -- ROI estendida (verif sincro g e H)
%matrix.roi_resolution = [1.0, 0, 1.0] * wavelength; % [mm/pix]  -- cisto
matrix.roi_resolution = [0.3, 0, 0.3] * wavelength; % [mm/pix]  -- cisto
%matrix.roi_resolution = [1.0, 0, 1.0] * wavelength; % [mm/pix]  -- multipontos

%matrix.roi_area = [30, 0, 30] * wavelength; % Area [mm]
%matrix.roi_area = [ 5, 0,  5]; % Area [mm] --  original
%matrix.roi_area = [11, 0, 11]; % Area [mm] -- ROI estendida
%matrix.roi_area = [10, 0, 10]; % Area [mm] -- ROI estendida (verif sincro g e H)
%matrix.roi_area = [20, 0, 20]; % Area [mm] -- cisto
matrix.roi_area = [8, 0, 8]; % Area [mm] -- cisto
%matrix.roi_area = [20, 0, 20]; % Area [mm] -- multipontos

%% Simulation parameters
def_roi_params;

% Base Function Parameters
matrix.base.type = 'spline'; % Base function type
matrix.base.param = 0; % Parameter for base function (spline order)

%% Simulation Inicialization
field_init(-1); % FIELD II Inicialization
field_set_params; % Setting FIELD II parameters
calc_matrix_params; % Calculate matrix parameters
def_matrix_type; % Defining matrix type parameters

%% ------------------- Forward/Inverse formulation ------------------------
% Calculating the matrix
tic;    
matrix.H = calc_matrix_h(matrix, ussys, flags);
simulation.time_calc_H = round(toc);
print_inf('Time to calculate the H matrix: %.1f seconds.', simulation.time_calc_H);

% Calculating the inverse matrix
[matrix.HtH_inv, matrix.norm_HtH, simulation, matrix.svd] = calc_matrix_inv(matrix.H, flags, simulation); % Invertion matrix operation

%% -------------------------- Reconstruction ------------------------------    
phantom.amp = 1;
phantom.pos = [matrix.roi_xz_center(1) 0 matrix.roi_xz_center(2)] * 1e-3; 

% % performing default reconstructions
% % Fista parameters =========================
% reconstructions.fista.iter = 10;
% if(strcmp(matrix.type, 'COMPLEX_D'))
%     reconstructions.fista.a = 1.5e1;
% else
%     reconstructions.fista.a = 0.28e1;
% end
% reconstructions.fista.a = 0.55e1;
% % ==========================================
% Calculate the images to compare
params.fista.ite = 20;
params.fista.ratio_lmbda = 0.1;
% ==========================================

DIR_OUT = [DIR matrix.type '\'];
mkdir(DIR_OUT);

data = calc_data(matrix, ussys, flags, vsx_data);


reconstructions = calc_default_reconstructions(matrix, ussys, flags, data, phantom, params);

scrsz = get(0, 'ScreenSize');
POS_TELA = [100 100 1800 900];
figure1 = figure(1); set(figure1, 'Position', POS_TELA)
        subplot(2,6,1),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reconstructions.orig.image)), colormap(gray), axis square, title('Original - LOG');
        subplot(2,6,2),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reconstructions.beam.image)), colormap(gray), axis square, title('Beamforming - LOG');
        subplot(2,6,3),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reconstructions.trans.image)), colormap(gray), axis square, title('Transposta - LOG');
        subplot(2,6,4),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reconstructions.inv.image)), colormap(gray), axis square, title('Inversa - LOG');
        subplot(2,6,5),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reconstructions.tik.image)), colormap(gray), axis square, title('tik - LOG');
        subplot(2,6,6),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(reshape(reconstructions.fista.image(:,:,end),matrix.roi_pixels(3),matrix.roi_pixels(1)))), colormap(gray), axis square, title('Fista - LOG');
        subplot(2,6,7),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reconstructions.orig.image)), colormap(gray), axis square, title('Original - Linear');
        subplot(2,6,8), 
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reconstructions.beam.image)), colormap(gray), axis square, title('Beamforming - Linear');
        subplot(2,6,9),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reconstructions.trans.image)), colormap(gray), axis square, title('Transposta - Linear');
        subplot(2,6,10),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reconstructions.inv.image)), colormap(gray), axis square, title('Inversa - Linear');
        subplot(2,6,11),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reconstructions.tik.image)), colormap(gray), axis square, title('tik - Linear');
        subplot(2,6,12),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(reshape(reconstructions.fista.image(:,:,end),matrix.roi_pixels(3),matrix.roi_pixels(1)))), colormap(gray), axis square, title('Fista - Linear');

export_fig(figure1,[DIR_OUT 'reconstructions_verasonics.png'],'-transparent');
save([DIR_OUT 'reconstructions_verasonics.mat'],'reconstructions');
field_end;
