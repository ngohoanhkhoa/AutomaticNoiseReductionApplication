function pValueImage = KendallCorrelationCoefficient(noiseImageWindow)
[W, W, T] = size(noiseImageWindow);
pValueImage = noiseImageWindow;
for t = 1:T
    sequenceHorizontalFirst = zeros(1, 0);
    sequenceHorizontalSecond = zeros(1, 0);
    for wj = 1:W
        for wi = 1:2:(W-1)
            sequenceHorizontalFirst(end+1) = noiseImageWindow(wi,wj,t);
            sequenceHorizontalSecond(end+1) = noiseImageWindow(wi+1, wj,t);
        end
    end
    
    [RHO,pValueHorizontal] = corr(sequenceHorizontalFirst.',sequenceHorizontalSecond.','Type','Kendall');
    
    sequenceVerticalFirst = zeros(1, 0);
    sequenceVerticalSecond = zeros(1, 0);
    for wi = 1:(W-1)
        for wj = 1:2:(W-1)
            sequenceVerticalFirst(end+1) = noiseImageWindow(wi,wj,t);
            sequenceVerticalSecond(end+1) = noiseImageWindow(wi, wj+1,t);
        end
    end
    [RHO,pValueVertical] = corr(sequenceVerticalFirst.',sequenceVerticalSecond.','Type','Kendall');
    
    sequenceDiagonalAFirst = zeros(1, 0);
    sequenceDiagonalASecond = zeros(1, 0);
    for wj = 1:2:(W-1)
        for wi = 1:(W-1)
            sequenceDiagonalAFirst(end+1) = noiseImageWindow(wi,wj,t);
            sequenceDiagonalASecond(end+1) = noiseImageWindow(wi+1, wj+1,t);
        end
    end
    [RHO,pValueDiagonalA] = corr(sequenceDiagonalAFirst.',sequenceDiagonalASecond.','Type','Kendall');
    
    sequenceDiagonalBFirst = zeros(1, 0);
    sequenceDiagonalBSecond = zeros(1, 0);
    for wj = 1:2:(W-1)
        for wi = 1:(W-1)
            sequenceDiagonalBFirst(end+1) = noiseImageWindow(wi,wj+1,t);
            sequenceDiagonalBSecond(end+1) = noiseImageWindow(wi+1, wj,t);
        end
    end
    [RHO,pValueDiagonalB] = corr(sequenceDiagonalBFirst.',sequenceDiagonalBSecond.','Type','Kendall');
    
    pValueImage(:,:,t) = min([pValueHorizontal,pValueVertical,pValueDiagonalA, pValueDiagonalB]);
end
end

