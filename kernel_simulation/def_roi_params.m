if(isfield(matrix,'roi_area') && (isfield(matrix,'roi_pixels'))) 
    matrix.roi_resolution = matrix.roi_area ./ matrix.roi_pixels; % Resolution [mm/px]
else if(isfield(matrix,'roi_area') && (isfield(matrix,'roi_resolution')))
        matrix.roi_pixels = round(matrix.roi_area ./ matrix.roi_resolution); % Pixels [px]
        matrix.roi_area = matrix.roi_pixels .* matrix.roi_resolution; % Area [mm]
    else
        matrix.roi_area = matrix.roi_pixels .* matrix.roi_resolution; % Area [mm]
    end
end