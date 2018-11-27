function kernel = calc_roi_ptos_amp(type, n_points, parameters)
switch(type)
    case 'spline' % ====== Spline basetion calculation (by coeficients)======     
        switch(parameters)           
            case 1
                switch(n_points)
                    case 1 
                        kernel = 1;                
                    case 3
                        kernel = [0 1 0];
                    case 5
                        kernel = [0 0 1 0 0];
                    case 7
                        kernel = [0 0 1/3 1 1/3 0 0];
                    case 9
                        kernel = [0 0 0 1/5 1 1/5 0 0 0];
                end
                return;
            case 2
                switch(n_points)
                    case 1
                        kernel = 1;                
                    case 3
                        kernel = [0 3/4 0];
                    case 5
%                         kernel = [0 1/8 3/4 1/8 0];
                        kernel = [0.0139 0.3472 3/4 0.3472 0.0139];
                    case 7
                        kernel = [0 0.0139 0.3472 3/4 0.3472 0.0139 0];
                    case 9
                        kernel = [0 0 1/8 1/2 3/4 1/2 1/8 0 0];
                end  
                return;
            case 3
                switch(n_points)
                    case 1
                        kernel = 1;                
                    case 3
                        kernel = [0 2/3 0];
                    case 5
                        kernel = [0 1/6 2/3 1/6 0];
                    case 7
                        kernel = [0 0.0494 0.3704 2/3 0.3704 0.0494 0];
                    case 9
                        kernel = [0 0.0208 1/6 0.4792 2/3 0.4792 1/6 0.0208 0];
                end    
                return;
            case 4
                switch(n_points)
                    case 1
                        kernel = 1;                
                    case 3
                        kernel = [0 2/3 0];
                    case 5
                        kernel = [0 1/6 2/3 1/6 0];
                    case 7
                        kernel = [0 0.0494 0.3704 2/3 0.3704 0.0494 0];
                    case 9
                        kernel = [0 0.0208 1/6 0.4792 2/3 0.4792 1/6 0.0208 0];
                end    
                return;                
            otherwise
                kernel = ones(1,n_points);
                return;
        end        
    case 'sinc' % ====== Sinc basetion calculation ======      
    case 'lambda' % ====== Sinc basetion calculation ======          
        kernel = ones(1,base.n_pts);
        return;
end


