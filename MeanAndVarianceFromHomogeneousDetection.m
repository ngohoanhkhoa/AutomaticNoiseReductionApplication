function [meanWindow,varianceWindow] = MeanAndVarianceFromHomogeneousDetection(noiseImage, windowSize, alphaDetectionProbability)

meanWindow = zeros(1, 0);
varianceWindow = zeros(1, 0);

alpha = alphaDetectionProbability;
[M, N, dimension] = size(noiseImage);
pValueImage = noiseImage;

for dim = 1:dimension
    for i = 1:windowSize:(M-windowSize+1)
        for j = 1:windowSize:(N-windowSize+1)
            windowImage = noiseImage(mod(i+(1:windowSize) - 2, M) + 1, mod(j+(1:windowSize) - 2, N) + 1 , dim);
            pValueImage(mod(i+(1:windowSize) - 2, M) + 1, mod(j+(1:windowSize) - 2, N) + 1 , dim) = ...
                KendallCorrelationCoefficient(windowImage);
            if(pValueImage(i,j,dim) > (1 - alpha) )
                meanWindow(end+1) = mean(windowImage(:));
                varianceWindow(end+1) = std (windowImage(:));
            end
        end
    end
end


n = length(noiseImage(:));
s = sort(noiseImage(:));

interval = s(round(linspace(1, n, 5+1)));
interval(end) = inf;
for k = 1:(length(interval)-1)
    q(k) = sum((interval(k) <= meanWindow) & (meanWindow < interval(k+1)));
end
res = min(q) >= 1;

if res
    disp('Not Enough Homogeneous Window');
else
    disp('Enough Homogeneous Window');
end

end

