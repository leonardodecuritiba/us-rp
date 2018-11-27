
fista_par = [0.01, 0.03, 0.05, 0.1, 0.2, 0.5, 0.6];
for indf=1:5
    params.fista.ratio_lmbda = fista_par(indf); 
    params.fista.ite = 150; 

    dados = G;
    ite = params.fista.ite;
    B = dados(:)/max(abs(dados(:)));
    AA = full(matrix.H);
    AA = AA/max(abs(dados(:)));
    C = AA'*B;
    a = max(abs(C(:)))*params.fista.ratio_lmbda; 
    F = zeros(matrix.roi_pixels(3),matrix.roi_pixels(1));
    restart = 1;        
    fig_fista = figure(1000);
    [fista_image,ERR,COST,DIF,TIM,RES]=solve_is_fista(B,AA,a,C,F,restart,ite,eps*eps,1);

    DIR_FISTA = [DIR_OUT 'fista_par' num2str(indf) '/'] ;
    mkdir(DIR_FISTA);
    
    export_fig(fig_fista,[DIR_FISTA 'errfista.png'],'-transparent');
    for ind=1:1:size(fista_image,3)
        figure10 = figure(10); set(figure1, 'Position', POS_TELA);
        subplot(2,3,1),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                logCompression(reconstructions.inv.image)), colormap(gray), title('INV - LOG');
        subplot(2,3,2),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                logCompression(reconstructions.trans.image)), colormap(gray), title('TRANS - LOG');
        subplot(2,3,3),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                logCompression(fista_image(:,:,ind))), colormap(gray), title(['FISTA - LOG i:' num2str(ind)]);
        subplot(2,3,4),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                abs(reconstructions.inv.image)), colormap(gray), title('INV - LINEAR');
        subplot(2,3,5),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                abs(reconstructions.trans.image)), colormap(gray), title('TRANS - LINEAR');
        subplot(2,3,6),
            imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
                abs(fista_image(:,:,ind))), colormap(gray), title(['FISTA - LINEAR k:' num2str(params.fista.ratio_lmbda)]);        

        export_fig(figure10,[DIR_FISTA 'fista_' num2str(ind) '.png'],'-transparent');
    end 
end
