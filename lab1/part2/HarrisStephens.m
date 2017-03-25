function [ result ] = HarrisStephens ( I0_d , sd_s , sd_r , k , theta_corn )
% ----------------- 2.1 -----------------
% ---------------- 2.1.1 ----------------
n_s = ceil(3*sd_s)*2 + 1;
Gaussian_s = fspecial('gaussian',n_s,sd_s);
n_r = ceil(3*sd_r)*2 + 1;
Gaussian_r = fspecial('gaussian',n_r,sd_r);

I_sigma = imfilter(I0_d,Gaussian_s,'symmetric'); % Convolution of 2D Gaussian filter with Image
% figure, imshow(I_sigma); title('Convolution of Starting Image with Gaussian filter Gs');

[GradX,GradY] = gradient(I_sigma);
temp1 = GradX.*GradX;
temp2 = GradX.*GradY;
temp3 = GradY.*GradY;

J1 = imfilter(temp1,Gaussian_r,'symmetric'); 
J2 = imfilter(temp2,Gaussian_r,'symmetric'); 
J3 = imfilter(temp3,Gaussian_r,'symmetric'); 

% figure
% subplot(1,3,1); imshow(J1/max(max(J1))); title('J1');
% subplot(1,3,2); imshow(J2/max(max(J2))); title('J2');
% subplot(1,3,3); imshow(J3/max(max(J3))); title('J3');

% ---------------- 2.1.2 ----------------
temp4 = (J1-J3).*(J1-J3) + 4*J2.*J2;
l_plus = 1/2 * (J1 + J3 + sqrt(temp4));
l_minus = 1/2 * (J1 + J3 - sqrt(temp4));

% figure
% subplot(1,2,1); imshow(l_plus/max(max(l_plus))); title('ë+');
% subplot(1,2,2); imshow(l_minus/max(max(l_minus))); title('ë-');

% ---------------- 2.1.3 ----------------
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
% figure,imshow(Success); title('Pixels that satisfy the Corner Criterion');

[ xS , yS ] = find(Success); % keep coordinates of the pixels

temp5 = repmat(sd_s , length(xS) , 1);
result = [yS xS temp5];

end