function [fwhm, fwtm, img_plot] = quality_fwhm_fwtm(IMAGEM, index, escala_log)
% IMG = simulation.beam.image;
% index = simulation.plot.lateral_index;
% tipo = 'beam';
% 
% escala_log = 1;

% % if(eixo == 'x')
% %     [mid x] = find(IMAGEM == max(max(IMAGEM)));
% %     f = IMAGEM(mid,:);    
% % else
% %     [x mid] = find(IMAGEM == max(max(IMAGEM)));
% %     f = IMAGEM(:,mid);
% % end
f = abs(IMAGEM);
img_plot = (f/max(f));
% if(min(img_plot)<0)
%     img_plot_min = img_plot - min(img_plot) +1;
%     img_plot = img_plot_min/max(img_plot_min);
% end

fwhm.value = fwhm_kwave(f, index, false); 
fwhm.index =(ones(1,length(index)) * 0.5);

fwtm.value = fwtm_kwave(f, index, false); 
fwtm.index =(ones(1,length(index)) * 0.1);

if escala_log
    img_plot = 20*log10(img_plot+eps);
    fwhm.index = 20*log10(fwhm.index);
    fwtm.index = 20*log10(fwtm.index);
end


% figure(2),
%     plot(x, img_plot, x, index_plot, '--');
%     ylabel([tipo ' Amplitude |f(\Deltax)|']), xlabel('\Deltax [mm]');
    
% % %     
% % %     subplot(1,3,2), fwtm_kwave(f, x, true, 'linear'); ylabel([tipo ' Amplitude |f(\Deltax)|']), xlabel('\Deltax [mm]');
% % %     subplot(1,3,3), plot(index, f, 'LineWidth', 1), title('Lateral Distance');
% % %                     hold on,
% % %                     plot(index, f(pos_psl), 'r.', 'LineWidth', 1);
% % %                     ylabel([tipo ' Amplitude |f(\Deltax)|']), xlabel('\Deltax [mm]');
% % %                     title(['(PSL): ' num2str(round(20*log10(psl_level/max(f)))) 'dB']);
