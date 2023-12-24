%EEN431 Final Project
%3D Video
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variables
offset = 30;
image_filename = 'Landscape1.jpg';
% image_filename = 'Landscape2.jpg';
% image_filename = 'Landscape3.jpg';

im = imread(image_filename);
gray = rgb2gray(im);
s = size(gray);
rows = s(1);
cols = s(2);
vertical_divisions = ceil(cols/offset);
horizontal_divisions = ceil(rows/vertical_divisions);
r = zeros(s-[0,vertical_divisions]);
b = zeros(s-[0,vertical_divisions]);

for i = 1:rows
	section = floor(i/horizontal_divisions/2);
	r(i,:) = gray(i,vertical_divisions+1-section:cols-section);
	b(i,:) = gray(i,1+section:cols-(vertical_divisions-section));
end

r = rescale(r)/2;
b = rescale(b);
g = zeros(size(r));
output = cat(3, r, g, b);
imshow(output)
imsave()






