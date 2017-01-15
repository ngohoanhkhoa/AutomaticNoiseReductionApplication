filename = 'lena.png';
img = double(imread(filename));

[M, N, T] = size(img);

noiseLevelFunction = @(x) 0.0312 * x.^2 + 0.75 * x + 400;
noiseImage = img + sqrt(noiseLevelFunction(img)) .* randn(M, N, T);

%denoiseImage = bilateralFilter(noiseImage,3,1,5);
%denoiseImage = medianFilter(noiseImage,5);

windowSize = 16;
alphaDetectionProbability = 0.6;

[meanWindow, varianceWindow] = MeanAndVarianceFromHomogeneousDetection(noiseImage, windowSize, alphaDetectionProbability);

[noiseLevelFunction, coefficient] = NoiseLevelFunctionEstimation(varianceWindow, meanWindow);

disp(coefficient)

denoiseImage = NLMeans(noiseImage, noiseLevelFunction);

noiseImage = mat2gray(noiseImage);
figure; imshow(noiseImage);title('Noise Image');

denoiseImage = mat2gray(denoiseImage);
figure;imshow(denoiseImage);title('Denoise Image');

