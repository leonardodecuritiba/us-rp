function retorno = logCompression(imagem, escala)
% imagem = abs(imagem);
% imagem_dB=20*log10(imagem);
% imagem_dB=imagem_dB-max(max(imagem_dB));
% retorno=127*(imagem_dB+ganho)/ganho;

% Z = abs(imagem);
% Za = Z - min(Z(:));
% retorno = escala*log10((Za/(max(abs(Za(:)))))+0.1);

Z = abs(imagem);
Za = Z - min(Z(:));
% Za = Z/max(max(Z));
retorno = 20*log10((Za/(max(abs(Za(:)))))+0.01);
% retorno = 20*log10((Za/(max(abs(Za))+eps)));