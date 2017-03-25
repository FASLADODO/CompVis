function [ result ] = Noisy(StartingImage,PSNR)
% This function creates a 'noisy' image which will be used
% as input in the edge detection algorithm
% White gaussian noise of mean = 0 and standard deviation sigma_n is used
% Sigma_n is calculated from the desired PSNR which is given as input

Imax = max( max(StartingImage) );
Imin = min( min(StartingImage) ); % keep max and min element of image

sigma_n = (Imax-Imin) / (10^(PSNR/20)); % standard deviation
var = sigma_n^ 2; % variance of noise signal, square of standard deviation
I_noise = imnoise(StartingImage,'gaussian',0,var);

result = I_noise;
end
