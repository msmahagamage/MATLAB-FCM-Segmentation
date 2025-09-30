function [segmentedImage, clusterCenters, membershipMatrices] = segmentImageFCM(image, numClusters, options)
% --- 1. Setup and Validation ---
if nargin < 3, options = struct(); end

% Set default options
defaultOptions = struct('fuzziness', 2.0, 'maxIter', 100, 'tolerance', 1e-5, 'initialCenters', []);
optionNames = fieldnames(defaultOptions);
for i = 1:length(optionNames)
    if ~isfield(options, optionNames{i})
        options.(optionNames{i}) = defaultOptions.(optionNames{i});
    end
end

imageData = double(image);
[height, width] = size(imageData);
epsilon = 1e-9; % Small value to prevent division by zero

% --- 2. Initialization ---
if isempty(options.initialCenters)
    % Initialize centers with random values from the image's data range
    minVal = min(imageData(:));
    maxVal = max(imageData(:));
    clusterCenters = minVal + (maxVal - minVal) * rand(numClusters, 1);
else
    clusterCenters = options.initialCenters;
end

membershipMatrices = zeros(height, width, numClusters);

% --- 3. Main Iteration Loop ---
for iter = 1:options.maxIter
    oldCenters = clusterCenters;
    
    % --- Vectorized Calculation of Membership Values ---
    % Calculate distance from each pixel to every cluster center
    distances = zeros(height, width, numClusters);
    for k = 1:numClusters
        distances(:,:,k) = (imageData - clusterCenters(k)).^2 + epsilon;
    end

    % Calculate the inverse distance sum for the denominator
    invDistSum = sum(1./distances, 3);
    
    % Update membership for each cluster
    for k = 1:numClusters
        membershipMatrices(:,:,k) = 1 ./ (distances(:,:,k) .* invDistSum);
    end

    % --- Vectorized Calculation of New Cluster Centers ---
    mf = membershipMatrices.^options.fuzziness;
    for k = 1:numClusters
        numerator = sum(mf(:,:,k) .* imageData, 'all');
        denominator = sum(mf(:,:,k), 'all');
        clusterCenters(k) = numerator / denominator;
    end
    
    % --- Check for Convergence ---
    centerChange = max(abs(clusterCenters - oldCenters) ./ oldCenters);
    if centerChange < options.tolerance
        fprintf('Converged after %d iterations.\n', iter);
        break;
    end
end

if iter == options.maxIter
    fprintf('Reached maximum iterations (%d).\n', options.maxIter);
end

% --- 4. Create Final Segmented Image ---
% Assign each pixel to the cluster with the highest membership
[~, segmentedImage] = max(membershipMatrices, [], 3);

end
