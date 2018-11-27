%% #########################################################################
% -------------------------------------------------------------------------
% ------------------ Setting Initial Conditions ---------------------------
% -------------------------------------------------------------------------
set_field('fs', ussys.sampling_frequency); % Set Sampling Frequency
set_field('c', ussys.sound_speed); % Set Sound Speed
set_field('att', ussys.att); % Set Frequency Independent Attenuation
set_field('freq_att', ussys.freq_att); % Set Frequency Attenuation around the att_f0 
set_field('att_f0', ussys.att_f0); % Set Frequency Dependent Attenuation
if((ussys.sound_speed~=0)||(ussys.att~=0)||(ussys.freq_att~=0)) % Whether to use Frequency Independent Attenuation
    set_field('use_att',1);
else
    set_field('use_att',0);
end

% -------------------------------------------------------------------------
% ----------------------- Setting Aperture --------------------------------
% -------------------------------------------------------------------------
% Define the aperture (TX and RX)
ussys.aperture_TX = xdc_linear_array (ussys.TX_Ne_elements, ...
            ussys.aperture_element_width, ussys.aperture_element_height, ...
            ussys.aperture_element_kerf, ussys.aperture_N_math_x, ...
            ussys.aperture_N_math_y, ussys.aperture_focus);
        
ussys.aperture_RX = xdc_linear_array (ussys.RX_Ne_elements, ...
            ussys.aperture_element_width, ussys.aperture_element_height, ...
            ussys.aperture_element_kerf, ussys.aperture_N_math_x, ...
            ussys.aperture_N_math_y, ussys.aperture_focus);

% Setting the impulse response of the apertures
xdc_impulse(ussys.aperture_TX, ussys.impulse_response.signal);
xdc_impulse(ussys.aperture_RX, ussys.impulse_response.signal);

% Setting Scale Factor
ussys.scale_factor = 1;
if(flags.calc_scale_factor)    
    zvalues = linspace(matrix.roi_center(3) - matrix.roi_area(3)/2, matrix.roi_center(3) + matrix.roi_area(3)/2, 10)/1000; 
    ussys.scale_factor = field_calc_peak_int(ussys, zvalues); 
end

% Set the excitation of the aperture trought 
xdc_excitation(ussys.aperture_TX, ussys.excitation_pulse * ussys.scale_factor.factor);

% Calculating Apodization
apo_vector_seed_x = ones(1, ussys.TX_Ne_elements);
if(flags.calc_apodization), apo_vector_seed_x = gausswin(ussys.TX_Ne_elements)'; end

% Setting Apodization
ussys.tx_apo_vector = apo_vector_seed_x;
ussys.rx_apo_vector = apo_vector_seed_x;

xdc_apodization (ussys.aperture_TX, 0, ussys.tx_apo_vector);
xdc_apodization (ussys.aperture_RX, 0, ussys.rx_apo_vector);

clear zvalues apo_vector_seed_x;