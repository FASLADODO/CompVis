function [d_x,d_y] = lk(I1,I2,rho,epsilon,d_x0,d_y0)
    n = ceil(3*rho)*2 + 1;
    Gaussian_shit = fspecial('gaussian',n,rho);

    dx_k = d_x0;
    dy_k = d_y0;

    [x_0,y_0] = meshgrid(1:size(I1,2) , 1:size(I1,1));
    [dIn_1_dx , dIn_1_dy] = gradient(I1);
    for k =1:10

        In_1 = interp2(I1,x_0+dx_k, y_0+dy_k , 'linear',0);

        A1  = interp2(dIn_1_dx,x_0+dx_k, y_0+dy_k , 'linear',0);
        A2  = interp2(dIn_1_dy,x_0+dx_k, y_0+dy_k , 'linear',0);

        E = I2 - In_1;

        temp1 = imfilter(A1.*A1,Gaussian_shit)+epsilon;
        temp2 = imfilter(A1.*A2,Gaussian_shit);
        temp3 = imfilter(A2.*A2,Gaussian_shit)+epsilon;

        temp4 = imfilter(A1.*E,Gaussian_shit);
        temp5 = imfilter(A2.*E,Gaussian_shit);

        size_x = size(temp1,1);
        size_y = size(temp1,2);

        % u = A\B solves the system of linear equations A*u = B.
        for i = 1:size_x
            for j = 1:size_y
                A = [temp1(i,j) temp2(i,j) ; temp2(i,j) temp3(i,j)]; 
                B = [temp4(i,j) ; temp5(i,j)];
                u = A\B;
                dx_k(i,j) = dx_k(i,j) + u(1);
                dy_k(i,j) = dy_k(i,j) + u(2);
            end
        end
    end
    d_x = dx_k;
    d_y = dy_k;
end