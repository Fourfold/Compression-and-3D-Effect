%EEN431 Final Project
%Continuous 3D Image Effect
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script applies a continuous 3D image effect to a single image. What
%this means for this implementation is that the top part of the image has
%the effect of being far away while the bottom part of the image seems
%close up. This implementation works best for lansdscapes with no tall
%objects that are close to the bottom (like trees).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variables
offset = 30;
image_filename = 'Landscape1.jpg';
% image_filename = 'Landscape2.jpg';
% image_filename = 'Landscape3.jpg';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read image
im = imread(image_filename); %read image
gray = rgb2gray(im); %convert to gray scale
s = size(gray);
rows = s(1); %number of rows
cols = s(2); %number of columns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate vertical and horizontal divisions
vertical_divisions = ceil(cols/offset);
horizontal_divisions = ceil(rows/vertical_divisions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculating red and blue parts row by row
r = zeros(s-[0,vertical_divisions]); %initializing red part
b = zeros(s-[0,vertical_divisions]); %initializing blue part
for i = 1:rows
    %determine which section to apply corresponding 3D offset
	section = floor(i/horizontal_divisions/2);
	r(i,:) = gray(i,vertical_divisions+1-section:cols-section);
	b(i,:) = gray(i,1+section:cols-(vertical_divisions-section));
end
r = rescale(r)/2; %rescale red part
b = rescale(b); %rescale blue part
g = zeros(size(r)); %green part (all zeroes)
output = cat(3, r, g, b); %combine colors
imshow(output)
imsave()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%