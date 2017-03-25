function [ resultado ] = HarrisLaplacian ( I0_d , sd_s , sd_r , k , theta_corn , s , N )
% ----------------- 2.2 -----------------
% ---------------- 2.2.1 ----------------
% Calculate coordinates of pixels that are corners with the Harris-Stephens method
for i = 1 : N
    curr_sd_s = s^(i-1) * sd_s;
    curr_sd_r = s^(i-1) * sd_r;
    n_s = ceil(3*curr_sd_s)*2 + 1;
    Gaussian_s = fspecial('gaussian',n_s,curr_sd_s);
    n_r = ceil(3*curr_sd_r)*2 + 1;
    Gaussian_r = fspecial('gaussian',n_r,curr_sd_r);
     
    I_sigma = imfilter(I0_d,Gaussian_s,'symmetric'); %Convolution of 2D Gaussian filter with Image
    
    [GradX,GradY] = gradient(I_sigma);
    temp1 = GradX.*GradX;
    temp2 = GradX.*GradY;
    temp3 = GradY.*GradY;

    J1 = imfilter(temp1,Gaussian_r,'symmetric'); 
    J2 = imfilter(temp2,Gaussian_r,'symmetric'); 
    J3 = imfilter(temp3,Gaussian_r,'symmetric'); 

%   figure
%   subplot(1,3,1); imshow(J1/max(max(J1))); title('J1');
%   subplot(1,3,2); imshow(J2/max(max(J2))); title('J2');
%   subplot(1,3,3); imshow(J3/max(max(J3))); title('J3');

    temp4 = (J1-J3).*(J1-J3) + 4*J2.*J2;
    l_plus = 1/2 * (J1 + J3 + sqrt(temp4));
    l_minus = 1/2 * (J1 + J3 - sqrt(temp4));

%   figure
%	subplot(1,2,1); imshow(l_plus/max(max(l_plus))); title('ë+');
%	subplot(1,2,2); imshow(l_minus/max(max(l_minus))); title('ë-');

    R = l_minus.*l_plus - k*(l_minus+l_plus).*(l_minus+l_plus);

    % Condition1 keeps pixels that are local maxima inside
    % square windows, whose size depends on n_s
    B_sq = strel('disk',n_s);
    Cond1 = ( R==imdilate(R,B_sq) ); 

    % Condition2 keeps pixels that have greater R than a percentage of the
    % maximum value of R
    R_max = max(max(R));
    Cond2 = ( R > theta_corn*R_max );

    Success = ( Cond1 & Cond2 ); % keep only pixels that satisfy both conditions
%	figure,imshow(Success); title('Pixels that satisfy the Corner Criterion');

    [ xS , yS ] = find(Success); % keep coordinates of the pixels

    temp5 = repmat(curr_sd_s , length(xS) , 1);
    result{i} = [yS xS temp5];
    
    LaplacianOfGaussian = fspecial('log',n_s,curr_sd_s);
    LoG = imfilter(I0_d,LaplacianOfGaussian,'symmetric');
    LoG_norm{i} = curr_sd_s^2 * abs(LoG); % normalized Laplacian = sigma_i^2 * Laplacian
end

% ---------------- 2.2.2 ----------------
% Auto scale detection
final = [];

for i = 1 : N
    temp6 = result{i}(:, 1:2); % keep only coordinates of current scale examined 
	% keep only pixels that maximize Gaussian in a neighborhood of 2 
    if( i == 1)
        for j = 1 : size( temp6(:,1) )
            Cond3 = LoG_norm{i}(temp6(j,2),temp6(j,1)) > LoG_norm{i+1}(temp6(j,2),temp6(j,1));
            if Cond3
                final = [ final ; result{i}(j,:) ] ;
            end
        end
    elseif ( i == N )
        for j = 1 : size( temp6(:,1) )
            Cond4 = LoG_norm{i}(temp6(j,2),temp6(j,1)) > LoG_norm{i-1}(temp6(j,2),temp6(j,1));
            if Cond4
                final = [ final ; result{i}(j,:) ] ;
            end
        end
    else
        for j = 1 : size( temp6(:,1) )
            Cond3 = LoG_norm{i}(temp6(j,2),temp6(j,1)) > LoG_norm{i+1}(temp6(j,2),temp6(j,1));
            Cond4 = LoG_norm{i}(temp6(j,2),temp6(j,1)) > LoG_norm{i-1}(temp6(j,2),temp6(j,1));
            if (Cond3 && Cond4)
                final = [ final ; result{i}(j,:) ] ;
            end
        end
    end
end

resultado = final ;

end