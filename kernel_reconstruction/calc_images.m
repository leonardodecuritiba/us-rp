function img = calc_imgs(matrix, dados, type, flag_calc_svd, params)

img_MODELO = zeros( matrix.roi_pixels(3), matrix.roi_pixels(1));
switch(type)
    case 'orig'
        % =================================================================
        % ORIGINAL ========================================================
        phantom = dados;
        img = img_MODELO;
        pesos = img_MODELO;
        ind_max = size(phantom.pos, 1);
        for ind = 1:ind_max
            phantom_x = round(((phantom.pos(ind,1)*1e3) - (matrix.roi_x_values(1))) / (matrix.roi_resolution(1)))+1;
            phantom_z = round(((phantom.pos(ind,3)*1e3) - (matrix.roi_z_values(1))) / (matrix.roi_resolution(3)))+1;
            if (phantom_x >= 1 && phantom_x <= matrix.roi_pixels(1) && phantom_z >= 1 && phantom_z <= matrix.roi_pixels(3))
        %         img(phantom_z,phantom_x) = img(phantom_z,phantom_x) + abs(phantom.amp(ind));
                img(phantom_z,phantom_x) = img(phantom_z,phantom_x) + phantom.amp(ind);
                pesos(phantom_z,phantom_x) = pesos(phantom_z,phantom_x) + 1;
            end
        end
        img = img./pesos;
        img(find(isnan(img))) = 0;     
        % =================================================================
    case 'transpose'
        % =================================================================
        % TRANSPOSTA ======================================================
        disp('Cálculo da TRANSPOSTA');
        if(flag_calc_svd)
%             ht = bsxfun(@times,matrix.svd.V,diag(matrix.svd.s))*matrix.svd.U';
            ht = matrix.svd.V*diag(matrix.svd.s)*matrix.svd.U';
        else
            ht = matrix.H';
        end
        Htg = ht*dados(:);                
        img = img_MODELO;
        img(:) = full(Htg);
        % =================================================================
    case 'inverse'
        % =================================================================
        % INVERSA =========================================================
        disp('Cálculo da INVERSA'); 
        if(flag_calc_svd)
%             ht = bsxfun(@times,matrix.svd.V,diag(matrix.svd.s))*matrix.svd.U';
            ht = matrix.svd.V*diag(matrix.svd.s)*matrix.svd.U';
        else
            ht = matrix.H';
        end
        Htg = ht*dados(:);
        img = img_MODELO;
        img(:) = matrix.HtH_inv*Htg;
        % =================================================================
    case 'regularized' 
        % =================================================================
        % REGULARIZADA ====================================================
        disp('Cálculo do INVERSA REGULARIZADA');
        if(flag_calc_svd)
            img = reshape(tikhonov(matrix.svd.U, matrix.svd.s, matrix.svd.V, dados(:), params.value), matrix.roi_pixels(3), matrix.roi_pixels(1)); 
        else
            Htg = matrix.H'*dados(:);     
            img = img_MODELO;        
            matrix.H_reg = matrix.HtH + matrix.norm_HtH * eye(size(matrix.HtH,1));
            img(:) = pinv(matrix.H_reg)*Htg;
        end               
        % =================================================================
    case 'regularized_hansen' 
        % =================================================================
        % REGULARIZADA ESCOLHA DO PARÂMETRO PELA CURVA-L ==================
        % OP.param = 0: calcula automaticamente
        disp('Cálculo do INVERSA REGULARIZADA (hansen)');
        if(flag_calc_svd)
            [reg_corner,rho,eta,reg_param,u_rho,rho_c,u_eta,eta_c] = procura_param(matrix.svd.U, matrix.svd.s, dados(:), 'Tikh', params.value, 'hansen', 0);     
            img.image = reshape(tikhonov(matrix.svd.U, matrix.svd.s, matrix.svd.V, dados(:), reg_corner), matrix.roi_pixels(3), matrix.roi_pixels(1));  
            img.reg = reg_corner; 
        else
            disp('Cálculo do INVERSA REGULARIZADA');
            Htg = matrix.H'*dados(:);     
            img = img_MODELO;        
            matrix.H_reg = matrix.HtH + matrix.norm_HtH * eye(size(matrix.HtH,1));
            img(:) = pinv(matrix.H_reg)*Htg;            
        end        
        % =================================================================        
    case 'pcg'
        % =================================================================
        % PCG =============================================================
        disp('Cálculo do PCG'); 
        if(flag_calc_svd)
            ht = matrix.svd.V*diag(matrix.svd.s)*matrix.svd.U';
            HtH = matrix.svd.V*diag(matrix.svd.s.^2)*matrix.svd.V';
        else
            ht = matrix.H';
            HtH = matrix.HtH;
        end                
        Htg = ht*dados(:);    
        img = img_MODELO;
        img(:) = pcg(HtH, Htg, 2*eps, params.pcg.ite);
        % =================================================================
    case 'cgls'
        % =================================================================
        % PCG =============================================================
        disp('Cálculo do CGLS'); 
        if(flag_calc_svd)
            ht = matrix.svd.V*diag(matrix.svd.s)*matrix.svd.U';
            HtH = matrix.svd.V*diag(matrix.svd.s.^2)*matrix.svd.V';
        else
            ht = matrix.H';
            HtH = matrix.HtH;
        end           
        Htg = ht*dados(:);
        img = reshape(cgls(HtH, Htg, params.cgls.ite),matrix.roi_pixels(3), matrix.roi_pixels(1),params.cgls.ite);
        % =================================================================        
    case 'beam'
        % =================================================================
        % BEAM ============================================================
        disp('Cálculo do BEAMFORMING');
        img = calc_beam_tool(matrix, dados);
        % =================================================================
    case 'fista'
        % =================================================================
        % Fista ============================================================
        disp('Cálculo do FISTA');
        ite = params.fista.ite;
        B = dados(:)/max(abs(dados(:)));
%         AA = full(matrix.svd.U*diag(matrix.svd.s)*matrix.svd.V');
        AA = full(matrix.H);
        AA = AA/max(abs(dados(:)));
        C = AA'*B;
        a = max(abs(C(:)))*params.fista.ratio_lmbda; 
        F = zeros(matrix.roi_pixels(3),matrix.roi_pixels(1));
        restart = 1;        
        [img,ERR,COST,DIF,TIM,RES]=solve_is_fista(B,AA,a,C,F,restart,ite,2*eps,0);
        % =================================================================        
end

