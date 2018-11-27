function [data] = calc_data(matrix, ussys, flags, data_field)

%% Calculate DATA
data_beam = data_field.data_beam;
time_pre_beam = data_field.time_pre_beam;
[S, Ne] = size(data_beam); % S: Signal size in samples; Ne: Sensor quantities

% Parâmetros da ROI
roi_ind_init = matrix.roi_sample_init; % Índice correspondente ao início da ROI
roi_size = matrix.roi_samples; % Número de amostras da ROI
         
% Parâmetros do Sistema
fs = ussys.sampling_frequency; % Frequência de amostragem
fc = ussys.aperture_center_frequency; % Frequência de amostragem
calc_downsampling = flags.calc_mat_downsampling;
calc_force_mat_sparse = flags.calc_force_mat_sparse;
limiar_sparse = matrix.limiar_sparse;

% Definindo os parâmetros para o cálculo ==================================
sig_ind_init = int32(time_pre_beam * fs); % Signal init in samples [time-pixels]

janela_real = ones(S,Ne); %Janela para os números reais  
janela_real((data_beam<limiar_sparse) & (data_beam>-limiar_sparse)) = 0; %Janela para os números reais  
janela_real_roi = convert_sig_roi(roi_ind_init, roi_size, sig_ind_init, janela_real);
data_beamforming = convert_sig_roi(roi_ind_init, roi_size, sig_ind_init, data_beam).*janela_real_roi;

switch calc_downsampling
    case 0
        data_aux = data_beamforming;
    case 1 % (COMPLEX)         
        data_hil = hilbert(data_beam,S); %Transformada de hilbert
        data_aux = convert_sig_roi(roi_ind_init, roi_size, sig_ind_init, data_hil) .* janela_real_roi;
        
%         figure(), 
%             plot(real(data_hil(:,32)),'r', 'LineWidth',2), hold on
%             plot(imag(data_hil(:,32)),'k', 'LineWidth',2);
%             plot(abs(data_hil(:,32)),'*:');
         
    case 2 % (COMPLEXA_D) Modelo Complexo + Demodulado + Subamostrado
        roi_size_down = matrix.roi_samples_down; 
        
        data_hil = hilbert(data_beam,S); %Transformada de hilbert      
        data_hil = convert_sig_roi(roi_ind_init, roi_size, sig_ind_init, data_hil) .* janela_real_roi;
        shift = round(size(data_hil,1)/2*fc/(fs/2)); % Pegando o meio do sinal

        fft_dados_aux_hilb = fft(data_hil); % Demodulação + Transformada inversa
        fft_dados_aux_hilb_shift = circshift(fft_dados_aux_hilb, -round(shift), 1); % Aplicando a demodulação na frequencia
        hilb_filtered = [fft_dados_aux_hilb_shift(1:round(roi_size_down/2),:); fft_dados_aux_hilb_shift(end-floor(roi_size_down/2-1):end,:)]; % Aplicando a filtragem
        data_us = ifft(hilb_filtered); % iFFT
        
        janela_real_roi_us = janela_real_roi(ceil(linspace(1,roi_size,roi_size_down)),:);
        data_aux = data_us.*janela_real_roi_us;
%         data = data_us;
end
% %  data = (abs(data)>corte).* data;
if((calc_downsampling>0) && (calc_force_mat_sparse))
    data_aux = sparse(data_aux);
end
if(flags.simulation_single)
    data_aux = single(data_aux);    
end
%-----------------------------------------------------------------------
% Normalization
% data = calc_normz_data(data);

data.G = data_aux;
data.G_BEAM = data_beamforming;
