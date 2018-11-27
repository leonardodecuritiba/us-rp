function F = calc_beam_tool(BEAM, DATA)
%==========================================================================
% Program to calculate the BEAMFORMING - DAS for a single frame
%==========================================================================
% Autor: Leonardo Zanin			Data: FEBRUARY 2015
%==========================================================================
%Parameters:
%     DATA: Matriz contendo os dados capturados em um único frame
%     % ============================================================
%     BEAM.x_values: Posições no eixo x da imagem resultante [m]
%     BEAM.z_values: Posições no eixo z da imagem resultante [m]
%     BEAM.c: Velocidade do som no meio [m/s]
%     BEAM.fs: Frequencia de amostragem [Hz]
%     BEAM.signal: Sinal transmitido
%     BEAM.Ne: Número de elementos sensores
%     BEAM.samples_init: Número de amostras inicias antes do início da ROI
%     BEAM.aperture_element_pos: Número de amostras inicias
%     % ============================================================

data = [zeros(BEAM.samples_init, BEAM.Ne); DATA];
% reconstructions.beam.image = calc_beam_tool(CONFIG, DATA);
TAM = length(data);

ts = 1/BEAM.fs; % Amostragem temporal
N = length(BEAM.signal); % Número de amostras do sinal de retorno
n_pulse = N*2 - 1; % Número de amostras do pulso de retorno "conv(pulso,pulso)"
t_pulse = (ts*(1:n_pulse)); % tempo máximo do sinal no tempo em relação ao pico máximo (centrado em 0) [ms]

x_values = BEAM.x_values;
z_values = BEAM.z_values;
mx = length(x_values);
mz = length(z_values);
m = mx * mz;
[x, z] = meshgrid(x_values, z_values);
grid_pos = [x(:), zeros(m,1), z(:)]*1e-3;

% Calculando as coordenadas dos sensores pontuais [mm]
aperture_element_pos = BEAM.aperture_element_pos;
Ne=BEAM.Ne;
aperture_central_element_pos = [0, 0, 0];

F = zeros(mz, mx); % Criação da imagem resultante

for ind_pt = 1:m
    sig_beam = zeros(n_pulse,1);
    pt_s = ones(Ne,1) * grid_pos(ind_pt,:); % Coordenada lateral do ponto/pixel [m]

    rnp = aperture_element_pos - pt_s;
    R_np = sqrt(sum(rnp.^2,2)); % Distância entre o ponto e o sensor n atual  

    rcp = (ones(Ne,1) *aperture_central_element_pos) - pt_s;
    R_cp = sqrt(sum(rcp.^2,2)); % Distância entre o ponto e o sensor central
    
    Rnp_Rcp = (R_np+R_cp) * ones(1,n_pulse)./BEAM.c; % Distância entre o ponto e o sensor central
    Tpulse = ones(Ne,1) * t_pulse;
    
    T_z = round((Rnp_Rcp + Tpulse).*BEAM.fs);            
    T_z = (T_z>1).*T_z + (T_z<=1).*1; 
    
    for sensor_n = 1:Ne
        tz = T_z(sensor_n,:);
        if(max(tz)<=TAM), sig_beam = sig_beam + data(tz,sensor_n); end
    end

    ws = gausswin(n_pulse); % Janela gaussiana para suavização da imagem
    sig_abs=abs(hilbert(sig_beam));
    F(ind_pt)= sum(ws(:).*sig_abs(:));
    
%     figure(1),
%         subplot(1,2,1),
%             plot(T_z(:,1));
%             ylim([1 2000]);
%         subplot(1,2,2),
%             imagesc(logCompression(F)), colormap(gray), axis square, title('DAS - LOG');
%   
end


% =================== OLD VERSION
% % for ind_pt = 1:M
% %     SIGNAL_BEAM = zeros(N_PULSO,1);
% %     for sensor_n = 1:CONFIG.Ne
% %         pt_s = grid_pos(ind_pt,:); % Coordenada lateral do ponto/pixel [m]
% % 
% %         rnp = aperture_element_pos(sensor_n,:) - pt_s;
% %         R_np = norm(rnp,2); % Distância entre o ponto e o sensor n atual   
% %         
% %         rcp = aperture_central_element_pos - pt_s;
% %         R_cp = norm(rcp,2); % Distância entre o ponto
% % 
% %         T_z = round((((R_np+R_cp)/CONFIG.c) + T_PULSO)*CONFIG.fs);            
% %         T_z = (T_z>1).*T_z + (T_z<=1).*1;            
% %         if(max(T_z)<=TAM)
% %             SIGNAL_BEAM = SIGNAL_BEAM + DATA(T_z,sensor_n);
% %         end                       
% %     end
% %     SIGNAL_abs=abs(hilbert(SIGNAL_BEAM));
% %     F(ind_pt)= sum(ws(:).*SIGNAL_abs(:));
% % end