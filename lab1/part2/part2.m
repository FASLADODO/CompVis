clear all;close all;clc

sd_s = 2; % differentiation scale
sd_r = 2.5; % integration scale (both are standard deviations of two Gaussian smoothing operators)
k = 0.05; 
theta_corn = 0.005;
s = 1.5; % scaling factor
N = 4; % number of scales

filename = 'matrix17.png';
% filename = 'sunflowers17.png';

I0 = imread(filename);
figure, imshow(I0);
title('Starting Image');

I0_g = rgb2gray(I0);
I0_d = im2double(I0_g); % convert it to double

% ----------------- 2.1 -----------------
result1 = HarrisStephens ( I0_d , sd_s , sd_r , k , theta_corn );
figure,interest_points_visualization(I0,result1);
print('1 Harris Stephens','-dpng');

% ----------------- 2.2 -----------------
result2 = HarrisLaplacian ( I0_d , sd_s , sd_r , k , theta_corn , s , N );
figure,interest_points_visualization(I0,result2);
print('2 Harris Laplacian','-dpng');

% ----------------- 2.3 -----------------
result3 = BlobDetection ( I0_d , sd_s , theta_corn );
figure,interest_points_visualization(I0,result3);
print('3 Blob Detection','-dpng');

% ----------------- 2.4 -----------------
result4 = BlobDetectionMultiScale ( I0_d , sd_s , theta_corn , s , N );
figure,interest_points_visualization(I0,result4);
print('4 Blob Detection Multi Scale','-dpng');

% ----------------- 2.5 -----------------
result5 = IntegralImageBoxFilter( I0_d , sd_s , theta_corn );
figure,interest_points_visualization(I0,result5);
print('5 Integral Image Box Filter','-dpng');

% ---------------- 2.5.4 ----------------
result6 = IntegralImageBoxFilterMultiScale( I0_d , sd_s , theta_corn , s , N );
figure,interest_points_visualization(I0,result6);
print('6 Integral Image Box Filter Multi Scale','-dpng');