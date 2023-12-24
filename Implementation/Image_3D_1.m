%EEN431 Final Project
%Discrete 3D Image Effect
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script creates a 3D image with multiple layers. It consists of 5
%square images, each with an offset that creates a unique 3D effect. These
%3D images are added on top of each other for visualizing multiple layers
%in 3D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variable:
offset = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read square images
square1 = imread('Square1.jpg');
square2 = imread('Square2.jpg');
square3 = imread('Square3.jpg');
square4 = imread('Square4.jpg');
square5 = imread('Square5.jpg');
s = size(square1);
cols = s(2);
%placing read images in a list
input_images = cat(4, square1, square2, square3, square4, square5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%applying the 3D effect to the square images
g = uint8(zeros([s(1), s(2)-offset])); %green part of output (all zeroes)
output_image = cat(3, g, g, g); %initialize output image to zeroes
for i = 1:5
    %convert each input image to grayscale
    gray = rgb2gray(input_images(:,:,:,i));
    val = (i-1)*(offset/5); %offset calculated for each image
    r = gray(:, offset-val+1:cols-val); %shift red part
    r = rescale(r)/2; %rescale values
    b = gray(:, val+1:cols-(offset-val)); %shift blue part
    b = rescale(b); %rescale values
    rgb = cat(3, r, g, b); %colored image with effect
    output_image = output_image + rgb; %combine 3D images to one image
end
output_image = uint8(rescale(output_image)*255); %rescale output image
imshow(output_image)
imsave()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%