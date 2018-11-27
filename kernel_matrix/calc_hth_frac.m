function matrix_HtH = calc_frac_hth(matrix_H, part)

M = size(matrix_H,2);
matrix_HtH = zeros(M, M);
win_wait_bar = waitbar(0,'Calculating HtH Matrix...');

% part = matrix.M/10;
for ind = 1:part:M, 
    waitbar(ind / M); %Wait bar
    matrix_HtH(ind+(0:part-1),:) = full(matrix_H(:,ind+(0:part-1))'*matrix_H); 
end

close(win_wait_bar);
