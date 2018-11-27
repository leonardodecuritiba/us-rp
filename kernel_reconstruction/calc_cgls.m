cg_image = calc_images(matrix, G, 'pcg', params);
reconstructions.cgls.image = cg_image(:,:,params.cgls.ite);

return;
for ind=1:params.cgls.ite
    figure(10),
    subplot(1,2,1),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, logCompression(cg_image(:,:,ind))), colormap(gray), axis square, title('CGLS - LOG');
    subplot(1,2,2),
        imagesc(reconstructions.plot.lateral_index, reconstructions.plot.axial_index, abs(cg_image(:,:,ind))), colormap(gray), axis square, title('CGLS - linear');
    pause;
end 
