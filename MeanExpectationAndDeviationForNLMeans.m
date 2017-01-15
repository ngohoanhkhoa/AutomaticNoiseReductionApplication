function [meanExpectation,deviationExpectation] = MeanExpectationAndDeviationForNLMeans(noiseImage, noiseLevelFunction,patchRadius, colorImagePatchRadius)

[M, N, T] = size(noiseImage);

if T == 1
    x = mean(noiseImage(:)) * ones(512,512);
else
    x = mean(noiseImage(:)) * ones(64,64,min(T,64));
end

[M, N, T] = size(x);

[Y, X, P] = meshgrid(min((1:N)-1, N+1-(1:N)), min((1:M)-1, M+1-(1:M)), min((1:T)-1, T+1-(1:T)));

patch = (abs(Y) <= patchRadius & abs(X) <= patchRadius) & (abs(P) <= colorImagePatchRadius);
patchSize  = sum(patch(:));


img_nse1 = x + sqrt(noiseLevelFunction(x)) .* randn(M, N, T);
img_nse2 = x + sqrt(noiseLevelFunction(x)) .* randn(M, N, T);

img_nse1 = imgaussfilt(img_nse1,0.5);
img_nse2 = imgaussfilt(img_nse2,0.5);

patch_nse1  = zeros(M*N*T, patchSize);
patch_nse2  = zeros(M*N*T, patchSize);

n = 1;
for k = -(patchRadius+1):(patchRadius+1)
    for l = -(patchRadius+1):(patchRadius+1)
        for t = -(colorImagePatchRadius+1):(colorImagePatchRadius+1)
            if patch(mod(k, M) + 1, mod(l, N) + 1, mod(t, T) + 1) == 1
                patch_nse1(:, n) = reshape(circshift(img_nse1, [k, l, t]), [M*N*T, 1]);
                patch_nse2(:, n) = reshape(circshift(img_nse2, [k, l, t]), [M*N*T, 1]);
                n = n + 1;
            end
        end
    end
end

I = patch_nse1;
J = patch_nse2(randperm(M*N*T), :);

d = (I - J).^2 ./ (noiseLevelFunction(I) + noiseLevelFunction(J));
d = mean(d, 2);

meanExpectation = mean(d);
deviationExpectation = std(d);

clear img_nse1;
clear img_nse2;
clear patch_nse1;
clear patch_nse2;

end
