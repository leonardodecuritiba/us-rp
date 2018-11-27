function data_aux = convert_sig_roi(roi_init, roi_size, data_init, data)

[S, Ne] = size(data); % S: Signal size in samples; Ne: Sensor quantities
data_aux = zeros(roi_size, Ne); % data_aux CONTÉM O SINAL FINAL

sig_ind_end = data_init + S; % Signal end in samples [time-pixels]
roi_ind_end = roi_init + roi_size;

DIFF_I = sig_ind_end - roi_init; % Diferença entre os índices do fim do sinal e início da ROI
DIFF_F = roi_ind_end - data_init; % Diferença entre os índices do fim da ROI e início do sinal

if(DIFF_I > 0 && DIFF_F > 0) % Sinal dentro;
    if(sig_ind_end <= roi_ind_end)            
        if(data_init <= roi_init) % SITUAÇÃO 2 - Sinal ainda não entrou tudo
            data_aux(1:DIFF_I,:) = data(roi_init - data_init + 1:end,:);
        else
            ini_data = data_init - roi_init;
            end_data = ini_data+S;
            data_aux(ini_data:end_data-1,:) = data(:,:); % SITUAÇÃO 3 - Sinal entrou tudo
        end
    else
        if(data_init > roi_init) 
            data_aux((data_init - roi_init + 1):end,:) = data(1:(roi_size - (data_init - roi_init)),:); % SITUAÇÃO 4 - Sinal está saindo
        else
            data_aux = data((roi_init - data_init + 1):(roi_init - data_init)+roi_size,:); % SITUAÇÃO 6 - Sinal é maior que a roi e já entrou
        end
    end    
end % Sinal está fora
