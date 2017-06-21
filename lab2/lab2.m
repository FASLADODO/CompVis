clear;close all;clc;

load('skinSamplesRGB.mat');
skinSamplesRGB = im2double(skinSamplesRGB);
%imshow(skinSamplesRGB);

Y_Cb_Cr_sample = rgb2ycbcr(skinSamplesRGB);
[x_size,y_size,~] = size(Y_Cb_Cr_sample);

Cb_sample = Y_Cb_Cr_sample(:,:,2);
Cr_sample = Y_Cb_Cr_sample(:,:,3);

Cb_mono_sample = reshape(Cb_sample,x_size*y_size,1);
mo_cb_sample = mean(Cb_mono_sample);
Cr_mono_sample = reshape(Cr_sample,x_size*y_size,1);
mo_cr_sample = mean(Cr_mono_sample);

CbCr_mono_sample = [Cb_mono_sample Cr_mono_sample ];
mo = [mo_cb_sample mo_cr_sample];

S = cov(CbCr_mono_sample); 
% Calculated mean value and covariance will be used for the 
% 2D Gaussian that will model human skin color

curr=1;
name = sprintf('./GreekSignLanguage/GSLframes/%d.png',curr);
Image = im2double(imread(name));
pos = fd(Image,mo,S);
% subplot(2,2,4);imshow(Image);
% titlos = sprintf('%d',curr);
% title('Bounding box of face area');
% r=rectangle('Position',pos,'EdgeColor','g','LineWidth',2);

I1 = imcrop(rgb2gray(Image),pos); %keep bounding box
% figure;imshow(croppedImage1);

epsilon = 0.01;
rho=1;

scrsz = get(groot,'ScreenSize');
figure('OuterPosition',[1 scrsz(4)/2 3*scrsz(3)/4 scrsz(4)/2]);

for curr=2:72
    name = sprintf('./GreekSignLanguage/GSLframes/%d.png',curr);
    currImage = im2double(imread(name));
    I2 = imcrop(rgb2gray(currImage),pos);

%     [d_x,d_y] = lk(I1,I2,rho,epsilon);
    [d_x,d_y] = multi_lk(I1,I2,rho,epsilon);

    [displ_x,displ_y,energy] = displ(d_x,d_y);    
    pos(1) = pos(1)+displ_x;
    pos(2) = pos(2)+displ_y;
    
    d_x_r = imresize(d_x,0.3);
    d_y_r = imresize(d_y,0.3);
    subplot(1,3,1);quiver(flipud(-d_x_r),flipud(-d_y_r)); title('Optical Flow');
    axis([-10 30 0 40]);
    subplot(1,3,2);imshow(energy,[]); title('Optical Flow Energy');
    subplot(1,3,3);imshow(currImage);
    r=rectangle('Position',pos,'EdgeColor','g','LineWidth',2);
    titlos = sprintf('Frame %d',curr);
    title(titlos);
    
%     cd Outputs; print(titlos,'-djpeg');cd ..;
    cd OutputsMultiScale; print(titlos,'-djpeg');cd ..;
    pause(0.001);
    I1 = I2;
end
