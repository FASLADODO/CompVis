function [d_x,d_y] = multi_lk(I1,I2,rho,epsilon)    
    rho_pyr = 3;
    n_pyr = ceil(3*rho_pyr)*2 + 1;
    G_pyr = fspecial('gaussian',n_pyr,rho_pyr);
    N = 4; % Number of different scales that will be examined
    
    I1_pyr = pyramid(I1,G_pyr,N);
    I2_pyr = pyramid(I2,G_pyr,N);
    
    d_x0 = zeros(size(I1_pyr{N},1), size(I1_pyr{N},2));
    d_y0 = zeros(size(I1_pyr{N},1), size(I1_pyr{N},2));

    d_x_l = d_y0; %starting conditions
    d_y_l = d_x0;
    for l = N:-1:1
        if (l ~= N)
            d_x_l = imresize(d_x_l, size(I1_pyr{l}));
            d_y_l = imresize(d_y_l, size(I1_pyr{l}));            
        end
        [d_x_l, d_y_l] = lk(I1_pyr{l}, I2_pyr{l}, rho, epsilon, d_x_l, d_y_l);
    end

    d_x = d_x_l;
    d_y = d_y_l;
end