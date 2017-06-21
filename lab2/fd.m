function result = fd(Image, mu , cov)
    Y_Cb_Cr = rgb2ycbcr(Image);
	[x_size,y_size,~] = size(Y_Cb_Cr);

	Cb = Y_Cb_Cr(:,:,2);
	Cr = Y_Cb_Cr(:,:,3);
	Cb_mono = reshape(Cb,x_size*y_size,1);
	Cr_mono = reshape(Cr,x_size*y_size,1);
	CbCr_mono = [Cb_mono Cr_mono];

	y = mvnpdf(CbCr_mono,mu,cov);
	max_y = max(y); 
	threshold = 0.2*max_y;
	z = y>threshold; % thresholded binary image of skin
	z=reshape(z,x_size,y_size); %figure;imshow(z,[]);

	%opening = (X-B)+B (with small B)
	%closing = (X+B)-B (with big B)
	B1 = strel('disk',1); % me 2 peftoun ligo ta frames pou einai mesa kai ta xeria....8a doume m auto
	B2 = strel('disk',7); 
    
    z = imerode(z,B1);	
	z = imdilate(z,B1);	
%     subplot(2,2,1);imshow(z,[]); title('Opening with small B');
	
    z = imdilate(z,B2); 
	z = imerode(z,B2);  
%     subplot(2,2,2);imshow(z,[]); title('Closing with big B');

    greatest = bwareafilt(z,1); %keep greatest object(face)
% 	subplot(2,2,3);imshow(greatest,[]); title('Keeping object with greatest surface(face)');

	[y, x]=find(greatest==1);
	y_min = min(y);
	y_max = max(y);
	x_min = min(x);
	x_max = max(x); %find indexes of the rectangle(bounding box)

	width = x_max - x_min;
	height = y_max - y_min;
	result = [x_min y_min width height];
end