% This script loads an image and uses the segmentImageFCM function
% to perform a segmentation analysis.
clear; clc; close all;

% --- 1. Load Data ---
imagePath = 'cameraman.tif';
try
    originalImage = imread(imagePath);
catch
    error('Could not find image file: %s', imagePath);
end

% If it's a color image, convert to grayscale
if size(originalImage, 3) == 3
    originalImage = rgb2gray(originalImage);
end

% --- 2. Set Parameters and Run Segmentation ---
numSegments = 4; % Easily change the number of segments

% Optional: Set initial centers. 
options.initialCenters = [20; 80; 150; 220]; 

options.fuzziness = 2.5;
options.maxIter = 50;
options.tolerance = 1e-4;

fprintf('Segmenting image into %d classes...\n', numSegments);
tic;
[segmentedLabels, finalCenters] = segmentImageFCM(originalImage, numSegments, options);
toc;

% --- 3. Display and Save Results ---
figure('Name', 'Image Segmentation Results');
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
% Use label2rgb to create a colorized version of the segmentation
segmentedRGB = label2rgb(segmentedLabels, jet(numSegments), 'k', 'shuffle');
imshow(segmentedRGB);
title(sprintf('Segmented Image (%d Clusters)', numSegments));

% Save the output
imwrite(uint8(segmentedLabels * (255/numSegments)), 'fuzzysegmented.jpg');
fprintf('Segmented image saved as "fuzzysegmented.jpg"\n');

disp('Final cluster centers are:');
disp(sort(finalCenters));
