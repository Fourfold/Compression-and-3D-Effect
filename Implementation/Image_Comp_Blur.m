%EEN431 Final Project
%Image Compression and Blur
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script compresses and blurs an image according to the compression
%ratio specified below. Note that this implementation of the blur effect
%works best on images with low resolution, so the presence of the 
%compression effect is convenient for the blur effect. This script also
%shows the multicolor frequency spectra of the original and compresses
%images.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variables:
image_filename = 'flower.jpg';
compression_ratio = 15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read image and properties
im1 = imread(image_filename); %read image
r = im1(:, :, 1); %red part of image
g = im1(:, :, 2); %green part of image
b = im1(:, :, 3); %blue part of image
s = size(im1);
rowsIn = s(1); %input number of pixel rows
colsIn = s(2); %input number of pixel columns
ratio = sqrt(compression_ratio);
rowsOut = ceil(rowsIn/ratio); %output number of pixel rows
colsOut = ceil(colsIn/ratio); %output number of pixel columns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate number of rows and columns to be removed
rows1 = floor((rowsIn-rowsOut)/2);
rows2 = rowsIn - rows1;
cols1 = floor((colsIn-colsOut)/2);
cols2 = colsIn - cols1;
rows1=rows1+1;
cols1=cols1+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%compress image
%apply fft to red, green, and blue parts of image
R = fft2(r);
G = fft2(g);
B = fft2(b);
%shift fft for rgb parts
Rsh = fftshift(R);
Gsh = fftshift(G);
Bsh = fftshift(B);
%crop transform in frequency domain to reduce resolution
Rsh2 = Rsh(rows1:rows2, cols1:cols2);
Gsh2 = Gsh(rows1:rows2, cols1:cols2);
Bsh2 = Bsh(rows1:rows2, cols1:cols2);
%apply inverse fft shifting
R2 = ifftshift(Rsh2);
G2 = ifftshift(Gsh2);
B2 = ifftshift(Bsh2);
%apply inverse fft
r2 = ifft2(R2);
g2 = ifft2(G2);
b2 = ifft2(B2);
compressed = real(cat(3, r2, g2, b2)); %compressed image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%blur image
s2 = size(compressed);
rows3 = ceil(s2(1)); %rows of compressed image
cols3 = ceil(s2(2)); %columns of compressed image
blurred = compressed; %intialize blurred image
%blur colors from adjacent pixels, 
%an offset of 2 pizels from the edges are ignored
for i = 3:rows3-2
    for j = 3:cols3-2
        for k = 1:3
            blurred(i, j, k) = 0.25*compressed(i, j, k) ...
                + 0.09*(compressed(i-1,j,k)+compressed(i,j-1,k) ...
                +compressed(i,j+1,k)+compressed(i+1,j,k))...
                + 0.06*(compressed(i-1,j-1,k)+compressed(i-1,j+1,k) ...
                +compressed(i+1,j-1,k)+compressed(i+1,j+1,k))...
                + 0.02*(compressed(i-2,j,k)+compressed(i+2,j,k) ...
                +compressed(i,j-2,k)+compressed(i,j+2,k));
        end
    end
end
blurred = blurred(3:rows3-2, 3:cols3-2, :); %remove 2 pixels from edges

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%show images
compressed = rescale(compressed); %rescale compressed image
blurred = rescale(blurred); %rescale blurred image
%show original image
figure(1)
imshow(im1)
title('Original Image')
%show frequency spectra of original image (log transform)
%each color layer is shown alone then the total rgb spectrum is shown
figure(2)
title('Original Image')
subplot(2,2,1)
Rshl = log(1+abs(Rsh));
imshow(rescale(Rshl))
title('RED Frequency Spectrum')
subplot(2,2,2)
Gshl = log(1+abs(Gsh));
imshow(rescale(Gshl))
title('GREEN Frequency Spectrum')
subplot(2,2,3)
Bshl = log(1+abs(Bsh));
imshow(rescale(Bshl))
title('BLUE Frequency Spectrum')
subplot(2,2,4)
imshow(rescale(cat(3, Rshl, Gshl, Bshl)))
title('RGB Frequency Spectrum')
%show frequency spectra of compressed image
figure(3)
subplot(2,2,1)
Rsh2l = log(1+abs(Rsh2));
imshow(rescale(Rsh2l))
title('RED Frequency Spectrum')
subplot(2,2,2)
Gsh2l = log(1+abs(Gsh2));
imshow(rescale(Gsh2l))
title('GREEN Frequency Spectrum')
subplot(2,2,3)
Bsh2l = log(1+abs(Bsh2));
imshow(rescale(Bsh2l))
title('BLUE Frequency Spectrum')
subplot(2,2,4)
imshow(rescale(cat(3, Rsh2l, Gsh2l, Bsh2l)))
title('RGB Frequency Spectrum')
%show compressed image
figure(4)
imshow(compressed)
title('Compressed Image')
%show blurred image
figure(5)
imshow(blurred)
title('Blurred Image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%