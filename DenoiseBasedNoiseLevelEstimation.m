function [denoiseImage,coefficient] = DenoiseBasedNoiseLevelEstimation(noiseImage)

windowSize = 16;
alphaDetectionProbability = 0.6;

[meanWindow, varianceWindow] = MeanAndVarianceFromHomogeneousDetection(noiseImage, windowSize, alphaDetectionProbability);

[noiseLevelFunction, coefficient] = NoiseLevelFunctionEstimation(varianceWindow, meanWindow);

denoiseImage = NLMeans(noiseImage, noiseLevelFunction);

end



