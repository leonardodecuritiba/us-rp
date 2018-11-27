% -------------------------------------------------------------------------
% -------------------------- CALCULATE Flags ------------------------------
% -------------------------------------------------------------------------
% ---- Matrix calculation ----
if(~isfield(flags,'calc_simetric_matrix')),     flags.calc_simetric_matrix = 1;     end % 1:Perform simetric matrix
if(~isfield(flags,'calc_simetric_half_matrix')),flags.calc_simetric_half_matrix = 0;end % 1:Perform simetric and half matrix part
if(~isfield(flags,'calc_force_mat_sparse')),    flags.calc_force_mat_sparse = 1;    end % 1:Force sparse matrix
if(~isfield(flags,'calc_mat_sparse')),          flags.calc_mat_sparse = 1;          end % 1:Turn sparse matrix
if(~isfield(flags,'calc_mat_normalized')),      flags.calc_mat_normalized = 0;      end % 1:Turn matrix normalized
if(~isfield(flags,'calc_svd')),                 flags.calc_svd = 1;                 end % 1:Calculate matrix SVD
if(~isfield(flags,'calc_pseu_svd')),            flags.calc_pseu_svd = 0;            end % 1:Calculate pseudoinverse matrix by SVD
if(~isfield(flags,'calc_fsdown')),              flags.calc_fsdown = 0;              end % 1:Calculate downsampling


% ---- System calculation ----
if(~isfield(flags,'calc_scale_factor')),        flags.calc_scale_factor = 1;        end % 1:Scale Factor
if(~isfield(flags,'calc_apodization')),         flags.calc_apodization = 0;         end % 1:Apodization
if(~isfield(flags,'calc_focusing')),            flags.calc_focusing = 0;            end % 1:Focusing
if(~isfield(flags,'simulation_old_config')),    flags.simulation_old_config = 0;    end % 1:Calculate old system config

% ---- Simulate calculation ----
if(~isfield(flags,'calc_noise')),               flags.calc_noise = 0;               end % 1:Noisy
% SNR = 20; % Aquisition SNR [dB]

% -------------------------------------------------------------------------
% ---------------------------- SHOW Flags ---------------------------------
% -------------------------------------------------------------------------
if(~isfield(flags,'show_bar')),                 flags.show_bar = 1;                 end % 1: Show matrix status bar
if(~isfield(flags,'show_data_corre')),          flags.show_data_corre = 0;          end % 1: Show correlation data plotting

% -------------------------------------------------------------------------
% ---------------------------- SAVE Flags ---------------------------------
% -------------------------------------------------------------------------
if(~isfield(flags,'save_matrix')),              flags.save_matrix = 0;              end % 
if(~isfield(flags,'save_svd')),                 flags.save_svd = 0;                 end % 
if(~isfield(flags,'save_data')),                flags.save_data = 0;                end %
if(~isfield(flags,'save_images')),              flags.save_images = 0;              end %

% -------------------------------------------------------------------------
% ---------------------- SIMULATION Flags ---------------------------------
% -------------------------------------------------------------------------
if(~isfield(flags,'simulation_real_data')),     flags.simulation_real_data = 0;     end % 
if(~isfield(flags,'ht_svd')),                   flags.ht_svd = 1;                   end % Calculate Ht via SVD
if(~isfield(flags,'simulation_single')),        flags.simulation_single = 0;        end % Force single data type
