function [reg_corner,rho,eta,reg_param,u_rho,rho_c,u_eta,eta_c,GCV_values] = procura_param(U,sm,b,method,reg_param,metodo,plot_locate)
% Reference: [1] M. V. W. Zibetti, F. S. V. Bazan, and J. Mayer,
% “Determining the regularization parameters for super-resolution problems,” 
%Signal Processing, vol. 88, no. 12, pp. 2890–2901, 2008.

% Marcelo V. W. Zibetti, UTFPR, June 26, 2013.

% Initialization.
locate = 1;
reg_corner = 0;
rho = 0;
eta = 0;
u_rho = 0;
rho_c = 0;
u_eta = 0;
eta_c = 0;
GCV_values = 0;

[m,n] = size(U); 
[p,ps] = size(sm);
% % 
% % if (nargout > 0) 
% %     locate = 1; 
% % else
% %     locate = 0;
% % end

beta = U'*b; 
beta2 = norm(b)^2 - norm(beta)^2;

if (ps==1)
  s = sm; 
  beta = beta(1:p);
else if (ps==1)
        s = s(p:-1:1,1)./s(p:-1:1,2); 
        beta = beta(p:-1:1);
    else
        s = sm(p:-1:1,1)./sm(p:-1:1,2); 
        beta = beta(p:-1:1);
    end
end

if (reg_param == 0)
    npoints = 200;  % Number of points on the L-curve for Tikh and dsvd.
    smin_ratio = 16*eps;  % Smallest regularization parameter.
        
    reg_param(npoints) = max([s(p),s(1)*smin_ratio]);
    ratio = (s(1)/reg_param(npoints))^(1/(npoints-1));
    for i=npoints-1:-1:1
        reg_param(i) = ratio*reg_param(i+1); 
    end
else
    npoints = length(reg_param);
end

xi = beta(1:p)./s;
eta = zeros(npoints,1); 
GCV_values = 0;
rho = eta;
s2 = s.^2;

if(strcmp(metodo,'gcv'))
    delta0 = 0;
    if (m > n & beta2 > 0), delta0 = beta2; end

    GCV_values = eta;
    % Vector of GCV-function values.
    for i=1:npoints
        GCV_values(i) = gcvfun(reg_param(i),s2,beta(1:p),delta0,m-n);
    end 

% % %     % Plot GCV function.
% % %     loglog(reg_param,GCV_values,['-' 'k'],'LineWidth',3), xlabel('\lambda'), ylabel('G(\lambda)')
% % %     title('GCV function')

    % Find minimum, if requested.
    if (locate)
        [minG,minGi] = min(GCV_values); % Initial guess.
        reg_corner = fminbnd('gcvfun',...
          reg_param(min(minGi+1,npoints)),reg_param(max(minGi-1,1)),...
          optimset('Display','off'),s2,beta(1:p),delta0,m-n); % Minimizer.
        minG = gcvfun(reg_corner,s2,beta(1:p),delta0,m-n); % Minimum of GCV function.
% % %         ax = axis;
% % %         HoldState = ishold; hold on;
% % %         loglog(reg_corner,minG,'sr','LineWidth',3), hold on;
% % %         loglog([reg_corner,reg_corner],[minG/1000,minG],'r','LineWidth',2);
% % %         title(['GCV function, minimum at \lambda = ',num2str(reg_corner)])
% % %         axis(ax)
% % %         if (~HoldState), hold off; end
    end
else
    for i=1:npoints
        f = s2./(s2 + reg_param(i)^2);
        eta(i) = norm(f.*xi,2);
        rho(i) = norm((1-f).*beta(1:p),2);
    end
    if (m > n & beta2 > 0)
        rho = sqrt(rho.^2 + beta2); 
    end

    % Locate the "corner" of the L-curve, if required.
    marker = '-'; txt = 'Tikh.';
    if (locate)
        switch(metodo)
            case 'zibetti'
                u_rho = sqrt(1/mean(s2));
                u_eta = sqrt(1/length(sm));
                cost = u_rho*rho+u_eta*eta;
                [val,pos] = min(cost);
                rho_c = rho(pos);
                eta_c = eta(pos);
                reg_corner = reg_param(pos);
                % Make plot.
% %                 if(plot_locate)
% %                     plot_lc_sqrt(u_rho*rho,u_eta*eta,marker,ps,reg_param);
% %                     xlabel('residual norm || g - Hf ||_2');
% %                     ylabel('solution norm || f ||_2');
% %                 end                

            case 'hansen'
                u_rho = 0;
                u_eta = 0;
                [reg_corner,rho_c,eta_c] = l_corner(rho,eta,reg_param,U,sm,b,method);
% %                 if(plot_locate)
% %                     plot_lc(rho,eta,marker,ps,reg_param,metodo);
% %                     xlabel('residual norm || g - Hf ||_2');
% %                     ylabel('solution norm || f ||_2');
% %                 end
        end
    end

% %     if plot_locate
% %         ax = axis;
% %         HoldState = ishold; hold on;
% %         switch(metodo)
% %             case 'zibetti'  
% %                 plot([u_rho*rho_c+u_eta*eta_c 0],[0 u_rho*rho_c+u_eta*eta_c],'r');
% %                 plot(u_rho*rho_c,u_eta*eta_c,'sk')   
% %                 title(['Sqrt L-curve, ',txt,' corner at ',num2str(reg_corner)]);
% %                 axis(ax)
% %                 if (~HoldState), hold off; end
% %             case 'hansen'
% %                 loglog([min(rho)/100,rho_c],[eta_c,eta_c],':r',...
% %                 [rho_c,rho_c],[min(eta)/100,eta_c],':r')
% %                 title(['L-curve, ',txt,' corner at ',num2str(reg_corner)]);
% %                 axis(ax)
% %                 if (~HoldState), hold off; end
% %         end
    end
end