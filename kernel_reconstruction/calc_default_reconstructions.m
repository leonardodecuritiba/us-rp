function [reconstructions] = calc_default_reconstructions(matrix, ussys, flags, data, phantom, params)

% Calculate the images to compare
reconstructions.orig.image = calc_images(matrix, phantom, 'orig');
reconstructions.beam.image = calc_images(def_beam_params(matrix, ussys), data.G_BEAM, 'beam');
reconstructions.trans.image = calc_images(matrix, data.G, 'transpose', flags.calc_svd);
reconstructions.inv.image = calc_images(matrix, data.G, 'inverse', flags.calc_svd);
params.value = 0;
reconstructions.tik = calc_images(matrix, data.G, 'regularized_hansen', flags.calc_svd, params);

params.C = reconstructions.trans.image;
fista_image = calc_images(matrix, data.G, 'fista', flags.calc_svd, params);
reconstructions.fista.image = fista_image(:,:,end);

if(strcmp(matrix.type,'DIFFUSE'))
    imagem_difusa_temp = reconstructions.trans.image; calc_img_difusa;
    reconstructions.trans.image = imagem_difusa_temp;    
    imagem_difusa_temp = reconstructions.inv.image; calc_img_difusa;
    reconstructions.inv.image = imagem_difusa_temp;
    clear imagem_difusa_temp;
end

% C�lculo das dimens�es da imagem (Ploting)
reconstructions.plot.lateral_index = matrix.roi_x_values;
reconstructions.plot.axial_index = matrix.roi_z_values;
reconstructions.plot.text_x = 'Lateral Distance From Center Element [mm]';
reconstructions.plot.text_y = 'Axial Distance From the surface of Transducer [mm]';