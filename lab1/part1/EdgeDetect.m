% ----------------- 1.2 -----------------
function [ result ] = EdgeDetect(InputImage, sigma , ThetaEdge , LaplaceType )
% ---------------- 1.2.1 ----------------
n = ceil(3*sigma)*2 + 1;
% [n n] defines rows and columns of filter
% alliws [n n] !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
TwoDGaussian = fspecial('gaussian',n,sigma); % 2D Gaussian filter
LaplacianOfGaussian = fspecial('log',n,sigma);  % Laplacian-of-Gaussian filter

% ---------------- 1.2.2 ----------------
I_sigma = imfilter(InputImage,TwoDGaussian,'symmetric'); % Convolution of 2D Gaussian filter with (noisy) Image
% xreiazetai to symmetric ? ? ? ?

B = strel('disk',1); % create a flat morphological structuring element ( a cross of 1's in a 3x3 matrix )
if LaplaceType == 0 % Linear
    %i)
    L = imfilter(InputImage,LaplacianOfGaussian,'symmetric'); % Convolution of Laplacian of Gaussian filter with (noisy) Image   
else % Non-Linear
    %ii)
    temp1 = imdilate (I_sigma,B);
    temp2 = imerode (I_sigma,B);
    L = temp1 + temp2 - 2*I_sigma;
end

% ---------------- 1.2.3 ----------------
X = ( L >= 0 ); % create binary sign image of L
temp3 = imdilate(X,B);
temp4 = imerode(X,B);
Y = temp3 - temp4; % outline of X

% ---------------- 1.2.4 ----------------
% Reject zero-crossings on nearly smooth areas
[GradX,GradY] = gradient(I_sigma);
GradIm = sqrt(GradX.^2 + GradY.^2);
max_grad = max(max(GradIm));

Z = ( (Y==1) & (GradIm > ThetaEdge*max_grad) );

result = Z;
end
