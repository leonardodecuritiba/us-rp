function [HtH_inv, norm_HtH, simulation, svd_H, HtH] = calc_matrix_inv(matrix_H, flags, simulation)

%% INVERSION
% sim_inversion;
if(flags.calc_svd)
    % Calculate SVD
    tic;    
    
    [svd_H.U, svd_H.s, svd_H.V] = csvd(matrix_H);
    simulation.time_calc_svd = round(toc);
    print_inf('Time to calculate the compact SVD of H matrix: %.1f seconds.', simulation.time_calc_svd);

    % HtH Matrix calculation --------------------------------------
    tic;
    HtH = bsxfun(@times,svd_H.V,svd_H.s.^2.')*svd_H.V';
    simulation.time_calc_HtH = round(toc);
    print_inf('Time to calculate the HtH matrix: %.1f seconds.', simulation.time_calc_HtH); % Printing times to Calculate
    % Matrix Inversion --------------------------------------------    
    
    tic;
    if(flags.calc_pseu_svd)   
%         nome = 'pseu'; 
        [m,n]=size(HtH);
        S = diag(svd_H.s);
        r=rank(S);
        SR=S(1:r,1:r);
        SRc=[SR^-2 zeros(r,m-r);zeros(n-r,r) zeros(n-r,m-r)];
        HtH_inv = bsxfun(@times,svd_H.V,SRc)*svd_H.V';  
    else
%         nome = 'pinv';
        HtH_inv = pinv(full(HtH));
    end       
    simulation.time_calc_pinv = round(toc);
    print_inf('Time to calculate the pseudoinverse of H matrix: %.1f seconds.', simulation.time_calc_pinv);
    
else
    svd_H = 0;
    % HtH Matrix calculation --------------------------------------
    tic;
    HtH = calc_hth_frac(matrix_H, size(matrix_H,2)*0.1); 
    simulation.time_calc_HtH = round(toc);
    print_inf('Time to calculate the HtH matrix: %.1f seconds.', simulation.time_calc_HtH); % Printing times to Calculate
    % Matrix Inversion --------------------------------------------
    tic;
    HtH_inv = pinv(full(HtH));
    simulation.time_calc_pinv = round(toc);
    print_inf('Time to calculate the pseudoinverse of H matrix: %.1f seconds.', simulation.time_calc_pinv);
end
norm_HtH = norm(HtH(:));
% matrix = rmfield(matrix,'H');
