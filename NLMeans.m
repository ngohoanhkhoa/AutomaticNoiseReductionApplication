function denoiseImage = NLMeans(noiseImage, noiseLevelFunction)

[M, N, T]   = size(noiseImage);

if T == 1
    windowRadius = 10;
    colorImageWindowRadius = 0;
    patchRadius = 3;
    colorImagePatchRadius = 0;
else
    windowRadius = 4;
    colorImageWindowRadius = 4;
    patchRadius = 3;
    colorImagePatchRadius = 2;
end


[Y, X, P] = meshgrid(min((1:N)-1, N+1-(1:N)), min((1:M)-1, M+1-(1:M)), min((1:T)-1, T+1-(1:T)));

patch = (abs(Y) <= patchRadius & abs(X) <= patchRadius) & (abs(P) <= colorImagePatchRadius);

patchSize  = sum(patch(:));
patch = patch / patchSize;
patch = conj(fftn(patch));

[meanExpectation,deviationExpectation] = MeanExpectationAndDeviationForNLMeans(noiseImage, noiseLevelFunction, patchRadius,colorImagePatchRadius );

sumWeight = zeros(M, N, T);
sumImage = zeros(M, N, T);

colorImageWindowRadius = min(colorImageWindowRadius, T);

for dx = -windowRadius:windowRadius
    for dy = -windowRadius:windowRadius
        for dz = -colorImageWindowRadius:colorImageWindowRadius
            
            x2range = mod((1:M) + dx - 1, M) + 1;
            y2range = mod((1:N) + dy - 1, N) + 1;
            z2range = mod((1:T) + dz - 1, T) + 1;
            
            I = noiseImage;
            J= noiseImage(x2range, y2range, z2range);
            
            diff = (I - J).^2 ./ (noiseLevelFunction(I) + noiseLevelFunction(J));
            
            diff = real(ifftn((patch .* fftn(diff))));
         
            w = exp(-abs(diff - meanExpectation)/ (deviationExpectation));
            w = real(ifftn((patchSize * patch .* fftn(w))));
            
            sumWeight = sumWeight + w;

            sumImage = sumImage + w .* noiseImage(x2range, y2range, z2range);
            
        end
        
    end
end

w_center = 1;
sumWeight = sumWeight + w_center;

sumImage = sumImage + w_center * noiseImage;

% Weighted average
denoiseImage = sumImage ./ sumWeight;

end