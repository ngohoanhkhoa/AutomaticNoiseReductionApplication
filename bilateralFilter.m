function denoiseImage = bilateralFilter(noiseImage,windowSize,sigma_s,sigma_i)
noiseImage=noiseImage/255;

I_denoised = noiseImage;

spatial_weights=zeros(2*windowSize+1,2*windowSize+1);
for x_1=1:2*windowSize+1
    for x_2=1:2*windowSize+1
       spatial_weights(x_1,x_2) = exp(-((x_1-windowSize-1)^2+(x_2-windowSize-1)^2)/(2*sigma_s^2));
    end;
end;
% Step2. (From eq (5))
for p_1 = windowSize+1:size(noiseImage,1)-windowSize
   for p_2 = windowSize+1:size(noiseImage,2)-windowSize
       
       %Step 2a. (From eq 10)
       tilde_u=noiseImage(p_1-windowSize:p_1+windowSize,p_2-windowSize:p_2+windowSize);
       %Step 2b. 
       product_of_weights = exp(-(tilde_u-tilde_u(windowSize+1,windowSize+1)).^2/(2*sigma_i^2)).*spatial_weights;
       %Step 2c. With 2b this is eq 12.
       C=sum(product_of_weights(:));
       %Step 2d 
       I_denoised(p_1-windowSize,p_2-windowSize) = sum(product_of_weights(:).*tilde_u(:));
       %Step 2e with 2d this is eq 11.
       I_denoised(p_1-windowSize,p_2-windowSize) =I_denoised(p_1-windowSize,p_2-windowSize)/C;
       % done.              
   end;
end;

denoiseImage = I_denoised;

end

