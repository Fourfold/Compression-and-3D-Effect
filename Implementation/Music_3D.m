%EEN431 Final Project
%Image Compression and Blur
%By Firas Dimashki

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script read an audio file and applies a 3D effect on it. This effect
%is similar to audio panning. It creates the illusion that a speakeris
%rotating around the listener because as 1 side (left or right) has a
%higher volume, the other has a lower volume. This is achieved by
%multiplying the input audio parts each with a triangular signal, with the 
%right side triangular signal shifted.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%user defined variables
audio_filename = 'HealingRiver.mp3';
T_audio_effect = 8; %period of 3D audio effect

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[audio,fs] = audioread(audio_filename); %read audio file and its properties
N = T_audio_effect * fs; %number of samples in 3D period
tri = @(t) 0.5*sawtooth(2*pi/N*t,0.5) + 0.5 + 0.01; %3D audio effect signal
t = 1:length(audio); %samples of audio
%audio for left side
L = tri(t)'.*audio(:,1);
%audio for right side
R = tri(t-N/2)'.*audio(:,2); %delay of N/2 between two sides
out = [L, R]; %overall output signal
%play audio
player = audioplayer(out,fs);
play(player)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot input and output signals
subplot(2,1,1)
plot(audio) %input signal
hold on
plot(tri(t), 'c') %left triangular signal
plot(tri(t-N/2), 'y') %right triangular signal
hold off
ylim([-1.1 1.1])
title('Input Signal and 3D Audio Effect')
subplot(2,1,2)
plot(out) %output signal
ylim([-1.1 1])
title('Output Signal')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%