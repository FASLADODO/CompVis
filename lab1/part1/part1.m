clear all; close all; clc;
% Parameters
% PSNR = 10;
PSNR = 20;

% Sigma = 1;
Sigma = 1.5;
% Sigma = 2;
% Sigma = 3;

% ThetaEdge = 0.1;
ThetaEdge = 0.2;
% ThetaEdge = 0.3;

% ----------------- 1.1 -----------------
% ---------------- 1.1.1 ----------------
I0 = imread('edgetest_17.png');
I0_d = im2double(I0); % convert it to double, so as to add noise later

% ---------------- 1.1.2 ----------------
I_noise = Noisy(I0_d,PSNR);

% ----------------- 1.2 -----------------
% --- Linear ---
LaplaceType = 0;
D_0 = EdgeDetect(I_noise, Sigma, ThetaEdge, LaplaceType);
% --- Non Linear  ---
LaplaceType = 1;
D_1 = EdgeDetect(I_noise, Sigma, ThetaEdge, LaplaceType);

% ----------------- 1.3 -----------------
% ---------------- 1.3.1 ----------------
B = strel('disk',1); % create a flat morphological structuring element ( a cross of 1's in a 3x3 matrix )
% Calculate 'real' edges, on Starting Image I0
temp1 = imdilate (I0_d,B);
temp2 = imerode (I0_d,B);
M = temp1 - temp2;
ThetaRealEdge = 0.2;
T = (M > ThetaRealEdge); % convert to binary image

% ---------------- 1.3.2 ----------------
C(1) = Quality(T,D_0);
C(2) = Quality(T,D_1);

% ---------------- 1.3.3 ----------------
str = sprintf('PNSR = %d, ó = %.1f, è_e_d_g_e = %.1f',PSNR,Sigma,ThetaEdge);

figure; suptitle(str);
subplot(2,2,1); imshow(I0_d); title('Starting Image, no Noise');
subplot(2,2,2); imshow(~T); title('Starting Image Edges, è_r_e_a_l_e_d_g_e = 0.2');
subplot(2,2,3); imshow(I_noise); title('Noisy Image');
subplot(2,2,4); imshow(~D_0); title('Noisy Image Edges ( Linear Method )'); 

figure; suptitle(str);
subplot(2,2,1); imshow(I0_d); title('Starting Image, no Noise');
subplot(2,2,2); imshow(~T); title('Starting Image Edges, è_r_e_a_l_e_d_g_e = 0.2');
subplot(2,2,3); imshow(I_noise); title('Noisy Image');
subplot(2,2,4); imshow(~D_1); title('Noisy Image Edges ( Non Linear Method )'); 
