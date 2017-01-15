function denoiseImage = medianFilter(noiseImage,windowSize)

I_noisy=noiseImage/255;

I_denoised = I_noisy;

for p_1 = windowSize+1:size(I_noisy,1)-windowSize
   for p_2 = windowSize+1:size(I_noisy,2)-windowSize
       tilde_u = I_noisy(p_1-windowSize:p_1+windowSize,p_2-windowSize:p_2+windowSize);
       I_denoised(p_1, p_2) = median(tilde_u(:));  
   end
end
I_denoised = I_denoised(windowSize+1:size(I_noisy,1)-windowSize,windowSize+1:size(I_noisy,2)-windowSize );

denoiseImage = I_denoised;

end


