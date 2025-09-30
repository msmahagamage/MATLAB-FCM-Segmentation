# MATLAB Fuzzy C-Means for Image Segmentation

A simple, vectorized implementation of the Fuzzy C-Means (FCM) algorithm for grayscale image segmentation in MATLAB. 
This project provides a reusable function to segment any grayscale image into a specified number of clusters.

---

##  Features

- **Flexible and Reusable:** Packaged as a function that can be used on any grayscale image with a configurable number of clusters.
- **Customizable:** Allows control over key algorithm parameters like fuzziness, max iterations, and initial cluster centers.
- **Clear Output:** Generates a labeled matrix representing the segmented image, ready for visualization.

---

##  Requirements

- MATLAB (tested on R2020a and newer)
- Image Processing Toolbox (for `imread`, `imshow`, `label2rgb`)

---

##  How to Use

1.  Place the `fcmcluster.m` function in your MATLAB path.
2.  Create a driver script (e.g., `runMySegmentation.m`) to load your image and call the function.

Here is a complete example:

```matlab
% 1. Load a grayscale image
originalImage = imread('cameraman.tif'); % Example image from MATLAB

% 2. Set parameters for segmentation
numSegments = 4;
options.fuzziness = 2.5;
options.maxIter = 50;

% 3. Run the FCM algorithm
[segmentedLabels, finalCenters] = fcmcluster(originalImage, numSegments, options);

% 4. Visualize the results
figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
% Use label2rgb to create a colorized version of the segmentation
segmentedRGB = label2rgb(segmentedLabels);
imshow(segmentedRGB);
title(sprintf('Segmented Image (%d Clusters)', numSegments));
```

---

##  Function Reference: `fcmcluster.m`

**Syntax**

```matlab
[segImg, centers, U] = fcmcluster(image, numClusters)
[segImg, centers, U] = fcmcluster(image, numClusters, options)
```

**Inputs**

- `image`: A 2D numeric matrix (`H x W`) representing a grayscale image.
- `numClusters`: The number of segments (clusters) to create.
- `options`: (Optional) A struct with the following fields:
  - `.fuzziness`: (Default: `2.0`) The fuzziness exponent `m`. Must be > 1.
  - `.maxIter`: (Default: `100`) Maximum number of iterations.
  - `.tolerance`: (Default: `1e-5`) Stopping tolerance for convergence.
  - `.initialCenters`: A `numClusters x 1` vector of initial center values. If empty, centers are initialized randomly.

**Outputs**

- `segmentedImage`: A 2D matrix of the same size as the input, containing integer labels (from 1 to `numClusters`) for each pixel.
- `clusterCenters`: A `numClusters x 1` vector of the final cluster center gray levels.
- `membershipMatrices`: A `H x W x numClusters` matrix of the final membership values for each pixel.

---
