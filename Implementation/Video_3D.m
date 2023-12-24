%EEN431 Final Project
%3D Video
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script creates a video with 3D effects on both image frames and
%audio. The image frames have a common 3D background, and each frame has a
%center image that appears to be moving inwards and outwards of the screen.
%The audio effect creates the illusion of a speaker being rotated around
%the viewer. Note that to experience this audio illusion you have to use
%headphones or speakers with stereo properties.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variables:
background_filename = 'back.jpg';
center_filename = 'note.jpg';
audio_filename = 'HealingRiver.mp3';
output_filename = 'video_out.avi';
fps = 20; %video frame rate
T_audio_effect = 15; %period of 3D audio effect
offset = 20; %maximum offset of pixels 
hi_offset = 0; %offset from maximum (closest) image (to be ignored)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read images and their properties
background = imread(background_filename); %read background image
center = imread(center_filename); %read center image
szb = size(background); %size of background image
szc = size(center); %size of center image
diffr = floor((szb(1)-szc(1))/2); %vertical(row) difference in size
diffc = floor((szb(2)-szc(2))/2); %horizontal(column) difference in size
gray = rgb2gray(center); %convert to grayscale
rows = szc(1); %number of pixel rows
cols = szc(2); %number of pixel columns
szc = szc -[0, offset,0]; %size of center after applying effect

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create frames list
%initialize matrix to contain image for different distances
%frames list is 4 dimensional, 2 for rows and columns,
%1 for rgb layers, 1 for different frames
frames = cat(4);
g = zeros([rows, cols-offset]); %green part of output image is zero
%create images for different distances
for i = 1:offset-hi_offset
    r = gray(:, offset-i+1:cols-i); %shift red part
    r = rescale(r)/2; %rescale values
    b = gray(:, i+1:cols-(offset-i)); %shift blue part
    b = rescale(b); %rescale values
    rgb = cat(3, r, g, b); %colored image with effect
    rgb = uint8(rgb*255); %rescale to 8 bit integers
    %create output image that has the same size as background but contains
    %the center image
    output = uint8(zeros(szb)); %initialize output to zero
    %change center of output to hold center image
    output(diffr+1:szc(1)+diffr, diffc+1:szc(2)+diffc,:) = rgb;
    frames = cat(4, frames, output); %add image to frames list
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%create audio_offset which affects the image frames according to volume
[audio, fs] = audioread(audio_filename); %read audio
% audio = audio(1500000:3000000, 1); %crop audio (optional)
%rescale audio file values to positive numbers between 0 and 1
audio_rescale = rescale(abs(audio));
%create video writer object
videoWriter = ...
    vision.VideoFileWriter(output_filename, 'AudioInputPort', true);
%calculate number of frames in video
nFrames = floor(size(audio, 1)/fs*fps);
videoWriter.FrameRate = fps; %specify frame rate
% videoWriter.VideoCompressor = "DV Video Encoder"; %compress video
%calculate length of audio frame
audio_frame_length = floor(size(audio, 1)/nFrames);
%array that contains average volume values for every frame
audio_offset = zeros([nFrames, 1]);
%calculate average for every audio frame
for i = 0:nFrames-1
    audio_offset(i+1) = ...
        sum(audio_rescale((i*fs)/fps+1:(i+1)*fs/fps), 'all');
end
%rescale to get the indexes of images
audio_offset = uint8(rescale(audio_offset, 0, size(frames, 4)-1))+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%apply 3D audio effect
N = T_audio_effect * fs; %number of samples in 3D period
tri = @(t) abs(sawtooth(2*pi/N*t,0.5)+0.2); %3D audio effect signal
t = 1:length(audio);
%audio for left side
L = tri(t)'.*audio(:,1);
%audio for right side
R = tri(t-N/4)'.*audio(:,2); %delay of N/4 between two sides
audio = [L, R]; %overall output signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%write video file frame by frame
for i = 1:nFrames
    %get image frame
    image_frame = 3*frames(:, :, :, audio_offset(i))+2*background;
    %get audio frame
    audio_frame = ...
        audio(audio_frame_length*(i-1)+1:audio_frame_length*i, :);
    %write audio frame to temporary file
    audiowrite('audio_frame.wav', audio_frame, fs)
    %write image frame and audio frame from temporary file
    step(videoWriter, image_frame, audioread('audio_frame.wav')); 
end
release(videoWriter) %release output video
delete 'audio_frame.wav' %delete temporary audio frame file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%