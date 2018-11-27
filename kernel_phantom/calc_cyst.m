function [ phantom ] = calc_cyst(roi_area, roi_x_values, roi_z_values, cis, N, option)

x_mm = roi_area(1)/1000;
y_mm = roi_area(2)/1000;
z_mm = roi_area(3)/1000;

switch(option)
    case 'random'
        % a - Aleatórios
        x = (rand (N,1)-0.5) * x_mm;
        y = (rand (N,1)-0.5) * y_mm; 
        z = rand (N,1)*z_mm + roi_z_values(1)*1e-3;    
    case 'grid'
        % b - Na grade
        [pos_z, pos_x] = meshgrid(roi_z_values, roi_x_values);
        N = length(roi_x_values)*length(roi_z_values);
        x = zeros(N,1);
        z = x;
        for ind = 1:N
            x(ind) = pos_x(ind)*1e-3;        
            z(ind) = pos_z(ind)*1e-3;
        end        
        y = (rand(N,1)-0.5)*y_mm;
end

%  Generate the amplitudes with a Gaussian distribution
% amp = randn(N,1);
amp = rand(N,1);

%  Make the cyst and set the amplitudes to zero inside
r = (cis(1,1)/2) * 1e-3;         %  Radius of cyst [mm]
xc = 0;                           %  Place of cyst x [mm]
zc = cis(1,2) * 1e-3;          %  Place of cyst z [mm]
inside = (((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside);

%  Make the high scattering region and set the amplitudes to 10 times inside
r = (cis(2,1)/2) * 1e-3;       %  Radius of cyst [mm]
xc = 0;                         %  Place of cyst [mm]
zc = cis(2,2) * 1e-3;        %  Place of cyst z [mm]
inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside;


%  Return the variables
phantom.amp = amp;
phantom.pos =[x y z];

end

