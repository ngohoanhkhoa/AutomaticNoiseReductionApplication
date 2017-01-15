function [noiseLevelFunction, coefficient] = NoiseLevelFunctionEstimation(varianceWindow, meanWindow)

Niter = 10000;
varianceSquared = (varianceWindow.^2)';
variable = [ones(size(meanWindow)); meanWindow; meanWindow.^2]';

% mb = mean(b(:));
% b = b / mb;
% mA = diag(mean(A, 1));
% A = A * inv(mA);

% Parameters
proxFet = @(p) p./max(abs(p),1);
proxG   = @(x) max(x,0);
sigma   = 1./sum(abs(variable),2);
tau     = 1./sum(abs(variable'),2);

% Initialization
coefficientDifferent = zeros(size(variable,2),1);
coefficient  = zeros(size(variable,2),1);
variance  = zeros(size(varianceSquared));

% Core
for k=1:Niter
    variance   = proxFet(variance + sigma .* (variable * coefficientDifferent - varianceSquared));
    coefficientBefore = coefficient;
    coefficient   = proxG( coefficient - tau .* (variable' * variance) );
    coefficientDifferent  = 2*coefficient - coefficientBefore;

end

%coefficient = inv(mA) * coefficient * mb;


noiseLevelFunction = @(x) coefficient(3) * x.^2 + coefficient(2) * x + coefficient(1);
end