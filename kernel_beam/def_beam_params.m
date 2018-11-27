function BEAM = def_beam_params(matrix, ussys)
% ============================================================
BEAM.x_values = matrix.roi_x_values; % Posições no eixo x da imagem resultante [m]
BEAM.z_values = matrix.roi_z_values; % Posições no eixo z da imagem resultante [m]
BEAM.roi_pixels = matrix.roi_pixels; % Pixels
BEAM.c = ussys.sound_speed; % Velocidade do som no meio [m/s]
BEAM.fs = ussys.sampling_frequency; % Frequencia de amostragem [Hz]
BEAM.signal = ussys.impulse_response.signal; % Sinal transmitido
BEAM.Ne = ussys.aperture_physical_Ne; % Número de elementos sensores
BEAM.samples_init = matrix.roi_sample_init; % Número de amostras inicias
BEAM.aperture_element_pos = ussys.aperture_element_pos; % Número de amostras inicias
BEAM.pixels = [size(BEAM.x_values) 0 size(BEAM.z_values)]; % Número de amostras inicias
% ============================================================
