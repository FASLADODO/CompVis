function [ result ] = BlobDetection ( I0_d , sd_s , theta_corn )
% ----------------- 2.3 -----------------
% ---------------- 2.3.1 ----------------
n_s = ceil(3*sd_s)*2 + 1;
Gaussian_s = fspecial('gaussian',n_s,sd_s);

I_sigma = imfilter(I0_d,Gaussian_s,'symmetric'); % Convolution of 2D Gaussian filter with Image

[Lx,Ly] = gradient(I_sigma);
[Lxx,Lxy] = gradient(Lx);
[Lyx,Lyy] = gradient(Ly);

R = Lxx.*Lyy - Lxy.*Lyx; % Cornerness criterium ( Lxy = Lyx )

% ---------------- 2.3.2 ----------------
% Condition1 keeps pixels that are local maxima inside
% square windows, whose size depends on n_s
B_sq = strel('disk',n_s);
Cond1 = ( R==imdilate(R,B_sq) ); 

% Condition2 keeps pixels that have greater R than a percentage of the
% maximum value of R
R_max = max(max(R));
Cond2 = ( R > theta_corn*R_max );

Success = ( Cond1 & Cond2 ); % keep only pixels that satisfy both conditions
% figure,imshow(Success); title('Pixels that satisfy the Corner Criterion');

[ xS , yS ] = find(Success); % keep coordinates of the pixels

temp5 = repmat(sd_s , length(xS) , 1);
result = [yS xS temp5];

end