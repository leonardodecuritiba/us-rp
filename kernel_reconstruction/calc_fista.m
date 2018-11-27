fista_image = calc_images(matrix, G, 'fista', flags.calc_svd, params);
reconstructions.fista.image = fista_image(:,:,params.fista.ite);

return;
for ind=1:params.fista.ite
    figure(10),
    subplot(1,2,1),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(fista_image(:,:,ind))), colormap(gray), axis square, title('Fista - LOG');
    subplot(1,2,2),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(fista_image(:,:,ind))), colormap(gray), axis square, title('Fista - linear');
    pause;
end 
