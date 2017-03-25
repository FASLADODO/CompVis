function [ resultado ] = BlobDetectionMultiScale ( I0_d , sd_s , theta_corn , s , N )
% ----------------- 2.4 -----------------
% ---------------- 2.4.1 ----------------
% Calculate coordinates of pixels that are corners with the Harris-Stephens method
for i = 1 : N
    curr_sd_s = s^(i-1) * sd_s;
    n_s = ceil(3*curr_sd_s)*2 + 1;
    Gaussian_s = fspecial('gaussian',n_s,curr_sd_s);
     
    I_sigma = imfilter(I0_d,Gaussian_s,'symmetric'); %Convolution of 2D Gaussian filter with Image

    [Lx,Ly] = gradient(I_sigma);
    [Lxx,Lxy] = gradient(Lx);
    [Lyx,Lyy] = gradient(Ly);

    R = Lxx.*Lyy - Lxy.*Lyx; % Cornerness criterium ( Lxy = Lyx )
    
    % Condition1 keeps pixels that are local maxima inside
    % square windows, whose size depends on n_s
    B_sq = strel('disk',n_s);
    Cond1 = ( R==imdilate(R,B_sq) ); 

    % Condition2 keeps pixels that have greater R than a percentage of the
    % maximum value of R
    R_max = max(max(R));
    Cond2 = ( R > theta_corn*R_max );

    Success = ( Cond1 & Cond2 ); % keep only pixels that satisfy both conditions
%   figure,imshow(Success); title('Pixels that satisfy the Corner Criterion');

    [ xS , yS ] = find(Success); % keep coordinates of the pixels

    temp5 = repmat(curr_sd_s , length(xS) , 1);
    result{i} = [yS xS temp5];
    
    LaplacianOfGaussian = fspecial('log',n_s,curr_sd_s);
    LoG = imfilter(I0_d,LaplacianOfGaussian,'symmetric');
    LoG_norm{i} = curr_sd_s^2 * abs(LoG); % normalized Laplacian = sigma_i^2 * Laplacian
end

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
