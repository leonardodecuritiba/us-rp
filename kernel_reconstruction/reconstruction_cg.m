params.pcg.ite = 5; 
cg_image = calc_images(matrix, G, 'pcg', flags.calc_svd, params);
figure(),
    subplot(1,2,1),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            logCompression(cg_image)), colormap(gray), title(['CGLS - LOG ite= ' num2str(params.pcg.ite)]);
    subplot(1,2,2),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            abs(cg_image)), colormap(gray), title('CGLS - LOG');        
        
return;
for ind=1:params.pcg.ite
    figure(10),
    subplot(2,3,1),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            logCompression(reconstructions.inv.image)), colormap(gray), axis square, title('CGLS - LOG');
    subplot(2,3,2),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            logCompression(reconstructions.trans.image)), colormap(gray), axis square, title('CGLS - LOG');
    subplot(2,3,3),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            logCompression(cg_image)), colormap(gray), axis square, title('CGLS - LOG');
    subplot(2,3,4),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            abs(reconstructions.inv.image)), colormap(gray), axis square, title('CGLS - linear');
    subplot(2,3,5),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            abs(reconstructions.trans.image)), colormap(gray), axis square, title('CGLS - LOG');
    subplot(2,3,6),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, ...
            abs(cg_image)), colormap(gray), axis square, title('CGLS - LOG');        
    pause;
end 
