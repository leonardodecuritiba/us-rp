function phantom = sim_gen_phantom(matrix, tipo)
% mid_grid_z=0.134;
% mid_grid_z=matrix.roi_resolution(3)/2;

% Testando para saber se � do tipo cysto
if(strncmp(tipo, 'cyst', 4))
    raio = (matrix.roi_area(3)/4); % [mm]
    cis(1,:) = [raio, matrix.roi_z_values(1)+raio];
    cis(2,:) = [raio, matrix.roi_z_values(1)+(raio*3)]; 
    N = 10000;
end

switch(tipo)
    case 'ongrid'        
        phantom.amp = 1;
        phantom.pos = [matrix.roi_xz_center(1) 0 matrix.roi_xz_center(3)] * 1e-3;  
    case 'outgrid'
        phantom.amp = 1;      
        phantom.pos = ([matrix.roi_x_values(ceil(end/2)) 0 matrix.roi_z_values(ceil(end/2))] + [matrix.roi_resolution(1)/2 0 matrix.roi_resolution(3)/2]) * 1e-3;            
    case 'setgrid_quad'
        outx = (matrix.roi_resolution(1)/2);
%         outz = 0.36*matrix.wavelength/2;
        outz = (matrix.roi_resolution(3)/2);
        pht(1,:) = [matrix.roi_x_values(floor(0.25*matrix.roi_pixels(1))), 0, matrix.roi_z_values(floor(0.25*matrix.roi_pixels(3)))] ;
        pht(2,:) = [matrix.roi_x_values(ceil(0.75*matrix.roi_pixels(1))), 0, matrix.roi_z_values(floor(0.25*matrix.roi_pixels(3)))] + [outx 0 0];
        pht(3,:) = [matrix.roi_x_values(floor(0.25*matrix.roi_pixels(1))), 0, matrix.roi_z_values(ceil(0.75*matrix.roi_pixels(3)))] + [0 0 outz];
        pht(4,:) = [matrix.roi_x_values(ceil(0.75*matrix.roi_pixels(1))), 0, matrix.roi_z_values(ceil(0.75*matrix.roi_pixels(3)))] + [outx 0 outz];
        phantom.amp = ones(4,1);
        phantom.pos = pht*1e-3;
    case 'setgrid_z'        
        outx = (matrix.roi_resolution(1)/2);
%         outz = mid_grid_z*matrix.wavelength;
        outz = matrix.roi_resolution(3)/2;
        pht(2,:) = [matrix.roi_xz_center(1), 0, matrix.roi_z_values(floor(0.375*matrix.roi_pixels(3)))] + [outx 0 outz];
        pht(3,:) = [matrix.roi_xz_center(1), 0, matrix.roi_z_values(floor(0.625*matrix.roi_pixels(3)))] + [0 0 outz];
        pht(1,:) = [matrix.roi_xz_center(1), 0, matrix.roi_z_values(floor(0.125*matrix.roi_pixels(3)))] + [outx 0 0];
        pht(4,:) = [matrix.roi_xz_center(1), 0, matrix.roi_z_values(floor(0.875*matrix.roi_pixels(3)))];
        phantom.amp = ones(4,1);
        phantom.pos = pht*1e-3;        
    case 'outgrid_z'
        phantom.amp = 1;  
        phantom.pos = ([matrix.roi_xz_center(1) 0 matrix.roi_xz_center(3)] + [0 0 matrix.roi_resolution(3)/2]) * 1e-3;
    case 'outgrid_x'
        phantom.amp = 1;      
        phantom.pos = ([matrix.roi_xz_center(1) 0 matrix.roi_xz_center(3)] + [matrix.roi_resolution(1)/2 0 0]) * 1e-3;
    case 'cyst_ongrid'
        phantom = calc_cyst( matrix.roi_area, matrix.roi_x_values, matrix.roi_z_values, cis, N, 'grid');
    case 'cyst_outgrid'
        phantom = calc_cyst( matrix.roi_area, matrix.roi_x_values, matrix.roi_z_values, cis, N, 'random');
end