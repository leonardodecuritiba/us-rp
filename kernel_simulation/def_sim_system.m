%% #########################################################################
if(flags.simulation_real_data)
    VSX = load(vsx_data.filename);
    
    % -------------------------------------------------------------------------
    % ----------------------- Simulation parameters ---------------------------
    % -------------------------------------------------------------------------
    ussys.sound_speed = 1540; % velocidade no Phantom Fluke 84-317 (imita figado sadio) [m/s]
    %ussys.sound_speed = 1570; % Literatura: velocidade no figado sadio [m/s]
    
    ussys.aperture_center_frequency = VSX.Trans.frequency * 1e6; % Center frequency [Hz]
    ussys.aperture_wavelength = ussys.sound_speed/ussys.aperture_center_frequency ; % Wavelength [m]

    if(isfield(VSX.Trans,'Bandwidth')), ussys.aperture_bandwidth = (VSX.Trans.Bandwidth(2)-VSX.Trans.Bandwidth(1)) * 1e6; 
    else ussys.aperture_bandwidth = VSX.Trans.bandwidth * 1e6; end % BandWidth [Hz]
    
    ussys.aperture_fractional_bandwidth = ussys.aperture_bandwidth/ussys.aperture_center_frequency; % Fractional BandWidth [%]
    ussys.samplesPerWave = VSX.Receive(1).samplesPerWave; % Samples per wave
    ussys.sampling_frequency = ussys.aperture_center_frequency * ussys.samplesPerWave; % Sampling Frequency [Hz]
    ussys.sampling_time = 1/ussys.sampling_frequency; % Sampling Time

    % -------------------------------------------------------------------------
    % ----------------------- Aperture parameters -----------------------------
    % -------------------------------------------------------------------------    
    ussys.aperture_physical_Ne = VSX.Resource.Parameters.numRcvChannels; % No. elements
    ussys.aperture_element_height = 5e-3; % Height of element [m]
    ussys.aperture_element_spacing = VSX.Trans.spacingMm * 1e-3; % Width of element [m]
    ussys.aperture_element_width = VSX.Trans.elementWidth * 1e-3; % Element width [m]
    ussys.aperture_element_kerf = (ussys.aperture_element_spacing-ussys.aperture_element_width); % Element pitch [m]
    ussys.aperture_size = (ussys.aperture_element_spacing*ussys.aperture_physical_Ne - ussys.aperture_element_spacing); % Aperture Size [mm]
    ussys.aperture_element_pos = [linspace(-ussys.aperture_size, ussys.aperture_size, ussys.aperture_physical_Ne)'/2, zeros(ussys.aperture_physical_Ne, 1), zeros(ussys.aperture_physical_Ne, 1)]; % Element positions [m]

    % -------------------------------------------------------------------------
    % ----------------------- Impulse Response configuration ------------------
    % -------------------------------------------------------------------------    
    if(isfield(VSX.TW,'Wvfm2Wy64Fc')), ussys.impulse_response.Waveform = VSX.TW.Wvfm2Wy64Fc'; 
    else ussys.impulse_response.Waveform = VSX.TW.Waveform';  end % Electroacustical impulse response
    ussys.impulse_response.fs_Waveform = ussys.aperture_center_frequency * VSX.TW.samplesPerWL; % Sampling frequency of Electroacustical impulse response [Hz]
    ussys.impulse_response.signal = ussys.impulse_response.Waveform(1:(ussys.aperture_center_frequency * VSX.TW.samplesPerWL / ussys.sampling_frequency):end); % Electroacustical impulse response
    
    % ================================================================================
    % Simulation parameters
    vsx_data.startSample = VSX.Receive(1).startSample;
    vsx_data.endSample = VSX.Receive(1).endSample;

    vsx_data.startDepth = VSX.Receive(1).startDepth;
    vsx_data.endDepth = VSX.SFormat.endDepth;
    
    % ================================================================================
    % Data parameters
    if(ussys.aperture_physical_Ne==64), si=33;sf=96; else si=1;sf=128; end        
    TEMP.RcvData = double(VSX.RcvData{1}(:,si:sf,:)); % Obtendo todos os frames
    TEMP.RcvData = mean(TEMP.RcvData,3); % Cálculo da média dos frames
    vsx_data.RcvData = TEMP.RcvData(vsx_data.startSample:vsx_data.endSample,:); 
    vsx_data.IQData = double(VSX.IQData{1}); % Obtendo todos os frames
    
    TEMP_IND_INIT = 1; % 2*round(242/10);
    
    vsx_data.data_beam = vsx_data.RcvData(TEMP_IND_INIT:vsx_data.endSample,:);
    vsx_data.time_pre_beam = vsx_data.startDepth(1)/2*1e-3/ussys.sound_speed;
    
    
    % ATENÇÃO, ESSA LINHA DE BAIXO É TEMPORÁRIA E PODERÁ MUDAR FUTURAMENTE!!!!!!!!!
    vsx_data.endSample_complex = (((vsx_data.endSample - 2048) < 0 ) * vsx_data.endSample) + (((vsx_data.endSample - 2048) > 0 ) * 2048);
    vsx_data.data_beam_complex = vsx_data.IQData(1:vsx_data.endSample_complex,:);
    
    
    clear VSX;
    
% else if(flags.simulation_old_config)
%        if(~isfield(ussys,'sound_speed')), ussys.sound_speed = 1540; end % Speed of sound [m/s]
%        if(~isfield(ussys,'aperture_center_frequency')), ussys.aperture_center_frequency = 5e6; end% Transducer center frequency [Hz]
%        if(~isfield(ussys,'aperture_wavelength')), ussys.aperture_wavelength = ussys.sound_speed/ussys.aperture_center_frequency; end % Wavelength [m]
%        if(~isfield(ussys,'aperture_fractional_bandwidth')), ussys.aperture_fractional_bandwidth = 0.8; end % Fractional BandWidth [%]
%        if(~isfield(ussys,'aperture_bandwidth')), ussys.aperture_bandwidth = ussys.aperture_center_frequency*ussys.aperture_fractional_bandwidth; end% BandWidth [Hz]
%        if(~isfield(ussys,'samplesPerWave')), ussys.samplesPerWave = 10; end % Samples per wave
%        if(~isfield(ussys,'sampling_frequency')), ussys.sampling_frequency = ussys.aperture_center_frequency * ussys.samplesPerWave; end% Sampling Frequency [Hz]
%        if(~isfield(ussys,'sampling_time')), ussys.sampling_time = 1/ussys.sampling_frequency; end % Sampling Time
%
%        % -------------------------------------------------------------------------
%        % ----------------------- Aperture parameters -----------------------------
%        % -------------------------------------------------------------------------
%        if(~isfield(ussys,'aperture_physical_Ne')), ussys.aperture_physical_Ne = 64; end % Number of physical elements
%        if(~isfield(ussys,'aperture_element_height')), ussys.aperture_element_height = 5e-3; end % Height of element [m]
%        if(~isfield(ussys,'aperture_element_spacing')), ussys.aperture_element_spacing = 2.7e-4; end % Distance between transducer elements [m]
%        if(~isfield(ussys,'aperture_element_width')), ussys.aperture_element_width = 3e-4; end % Width of element [m]
%        if(~isfield(ussys,'aperture_element_kerf')), ussys.aperture_element_kerf = ussys.aperture_element_width - ussys.aperture_element_spacing; end % Width of element [m]
%        % if(~isfield(ussys,'aperture_size')), ussys.aperture_size = (ussys.aperture_element_spacing*ussys.aperture_physical_Ne - ussys.aperture_element_spacing); end % Aperture Size [mm]
%        if(~isfield(ussys,'aperture_size')), ussys.aperture_size = (ussys.aperture_element_width + ussys.aperture_element_kerf) * ussys.aperture_physical_Ne; end % Aperture Size [mm]
%        if(~isfield(ussys,'aperture_element_pos')), ussys.aperture_element_pos = [linspace(-ussys.aperture_size, ussys.aperture_size, ussys.aperture_physical_Ne)'/2, zeros(ussys.aperture_physical_Ne, 1), zeros(ussys.aperture_physical_Ne, 1)]; end % Element positions [m]
%    end
end
% -------------------------------------------------------------------------
% ----------------------- Simulation parameters ---------------------------
% -------------------------------------------------------------------------
if(~isfield(ussys,'sound_speed')), ussys.sound_speed = 1540; end % velocidade no Phantom Fluke 84-317 (imita figado sadio) [m/s]
%if(~isfield(ussys,'sound_speed')), ussys.sound_speed = 1570; end 
if(~isfield(ussys,'aperture_center_frequency')), ussys.aperture_center_frequency = 6.25e6; end% Transducer center frequency [Hz]
if(~isfield(ussys,'aperture_wavelength')), ussys.aperture_wavelength = ussys.sound_speed/ussys.aperture_center_frequency; end % Wavelength [m]
if(~isfield(ussys,'aperture_bandwidth')), ussys.aperture_bandwidth = 3.75e6; end% BandWidth [Hz]
if(~isfield(ussys,'aperture_fractional_bandwidth')), ussys.aperture_fractional_bandwidth = ussys.aperture_bandwidth/ussys.aperture_center_frequency; end % Fractional BandWidth [%]
if(~isfield(ussys,'samplesPerWave')), ussys.samplesPerWave = 4; end % Samples per wave
if(~isfield(ussys,'sampling_frequency')), ussys.sampling_frequency = ussys.aperture_center_frequency * ussys.samplesPerWave; end% Sampling Frequency [Hz]
if(~isfield(ussys,'sampling_time')), ussys.sampling_time = 1/ussys.sampling_frequency; end % Sampling Time

% -------------------------------------------------------------------------
% ----------------------- Aperture parameters -----------------------------
% -------------------------------------------------------------------------
if(~isfield(ussys,'aperture_physical_Ne')), ussys.aperture_physical_Ne = 64; end % Number of physical elements
if(~isfield(ussys,'aperture_element_height')), ussys.aperture_element_height = 5e-3; end % Height of element [m]
if(~isfield(ussys,'aperture_element_spacing')), ussys.aperture_element_spacing = 2.7e-4; end % Distance between transducer elements [m]
if(~isfield(ussys,'aperture_element_width')), ussys.aperture_element_width = 3e-4; end % Width of element [m]
if(~isfield(ussys,'aperture_element_kerf')), ussys.aperture_element_kerf = ussys.aperture_element_width - ussys.aperture_element_spacing; end % Width of element [m]
% if(~isfield(ussys,'aperture_size')), ussys.aperture_size = (ussys.aperture_element_spacing*ussys.aperture_physical_Ne - ussys.aperture_element_spacing); end % Aperture Size [mm]
if(~isfield(ussys,'aperture_size')), ussys.aperture_size = (ussys.aperture_element_width + ussys.aperture_element_kerf) * ussys.aperture_physical_Ne; end % Aperture Size [mm]
if(~isfield(ussys,'aperture_element_pos')), ussys.aperture_element_pos = [linspace(-ussys.aperture_size, ussys.aperture_size, ussys.aperture_physical_Ne)'/2, zeros(ussys.aperture_physical_Ne, 1), zeros(ussys.aperture_physical_Ne, 1)]; end % Element positions [m]

% -------------------------------------------------------------------------
% ----------------------- Field II Parameters -----------------------------
% -------------------------------------------------------------------------
% CORRECAO NO AJUSTE DAS VARIAVEIS DE ATENUACAO PARA A CORRETA CRIACAO DA MATRIX H PARA USAR
% COM OS DADOS DA VERASONICS, OBTIDOS A PARTIR DO PHANTOM FLUKE 84-317 -- Solivan 06/11/2016
% Verificar as orientacoes que constam no cabecalho do arquivo  set_filed.m :
%   att                   Frequency independent attenuation in dB/m.
%   freq_att              Frequency dependent attenuation in dB/[m Hz]
%                         around the center frequency att_f0.
%   att_f0                Attenuation center frequency in Hz.
%
%  Example:  Set the attenuation to 1.5 dB/cm, 0.5 dB/[MHz cm] around
%            3 MHz and use this:
%               set_field ('att',1.5*100);
%               set_field ('Freq_att',0.5*100/1e6);
%               set_field ('att_f0',3e6);
%               set_field ('use_att',1);
%  /!\ Note that the frequency independent and frequency dependent attenuation
%      should normally agree, so that  Freq_att*att_f0 =  att.
% ussys.freq_att = 0.3*100/1e6; % Frequency Attenuation around the att_f0 [dB/(m Hz)]
ussys.att_f0 = ussys.aperture_center_frequency; % Frequency Dependent Attenuation (FDA) [Hz]
% ussys.freq_att = 0;
ussys.freq_att = 0.5*100/1e6; % Frequency dependent attenuation in dB/[m Hz] around the center frequency att_f0.
                              % Phantom Fluke 84-317 Attenuation coefficient = 0.5 dB/cm/MHz
% ussys.att = 312.5;
ussys.att = ussys.freq_att * ussys.att_f0; % Frequency Independent Attenuation [dB/m]

ussys.excitation_voltage = 100; % Excitation Voltage [V]
ussys.aperture_N_math_x = 4; % Number of mathematical elements in x dimension
ussys.aperture_N_math_y = 4; % Number of mathematical elements in y dimension
ussys.TX_Ne_elements = ussys.aperture_physical_Ne; % Number of physical elements in transmission (TX aperture)
ussys.RX_Ne_elements = ussys.aperture_physical_Ne; % Number of physical elements in reception (RX aperture)

% -------------------------------------------------------------------------
% ----------------------- Impulse Response configuration ------------------
% -------------------------------------------------------------------------
% Impulse Response --------------------------------------------------------
% Type 1
if(~isfield(ussys,'impulse_response'))
    TEMP.tc = gauspuls('cutoff', ussys.aperture_center_frequency, ussys.aperture_fractional_bandwidth, -6, -40);
    TEMP.t = -TEMP.tc : 1/ussys.sampling_frequency : TEMP.tc;
    TEMP.signal = gauspuls(TEMP.t, ussys.aperture_center_frequency, ussys.aperture_fractional_bandwidth);
    ussys.impulse_response = TEMP;
    % plot(parametros.impulse_response.signal, 'r'), hold;    
end  

% Defining Excitation Pulse -----------------------------------------------
ussys.excitation_pulse = ussys.excitation_voltage/2; % Delta excitation
    
% % % fs = parametros.sampling_frequency*1e-6;
% % % shift = fs / 2;
% % % tf = linspace(-fs/2,fs/2,fs);
% % % FFT_g = fft(parametros.impulse_response.signal, fs); %TF de g    
% % % FFT_g_shift = circshift(FFT_g.',shift).'; %Espectro de Fourier voltando pra base
% % % FFT_g_log = 20*log10(FFT_g_shift/max(FFT_g_shift));
% % % linha_40 = -40*ones(1,fs);
% % % linha_40_lin = 1e-2*max(abs(FFT_g_shift)) *ones(1,fs);
% % % figure(), 
% % %     subplot(2,1,1),plot(tf, abs(FFT_g_shift), tf, linha_40_lin);
% % % %     subplot(2,1,1),plot(tf, abs(FFT_g_shift), tf, linha_40_lin);
% % %     subplot(2,1,2),plot(tf, FFT_g_log, tf, linha_40);
% % %     return;
        
% % % Type 2
% % ussys.impulse_response.time_signal = (0 : 1/ussys.sampling_frequency : 0.5/ussys.aperture_center_frequency);
% % ussys.impulse_response.tc = max(ussys.impulse_response.time_signal);
% % ussys.impulse_response.sin_signal = sin(2 * pi * ussys.aperture_center_frequency * ussys.impulse_response.time_signal);
% % ussys.impulse_response.signal_envelope = gausswin(length(ussys.impulse_response.time_signal))';
% % ussys.impulse_response.signal_envelope = ones(1,length(ussys.impulse_response.time_signal));
% % ussys.impulse_response.signal = ussys.impulse_response.sin_signal .* ussys.impulse_response.signal_envelope;
% % figure, plot(ussys.impulse_response.signal), 
% Defining Excitation Pulse -----------------------------------------------
% % % Type 2 - 
% % ussys.impulse_response.excitation_pulse = ussys.impulse_response.time_signal; % Sin excitation

% Setting Focusing
if(flags.calc_focusing), 
    ussys.aperture_focus = roi.center*1e-3; % Initial electronic focus
else
    ussys.aperture_focus = [0 0 50e6]; % Defocusing
end

clear TEMP;

% matrix.wavelength = ussys.aperture_wavelength*1e3;
% MID_GRID = (0.1425+0.1543);
