function [noisySignal,requestedNoise] = mixSNR(signal, noise, ratio)
    numSamples = size(signal,1);
    
    % Trim or expand noise to match signal size
    if size(noise,1)>=numSamples
        noise = noise(1:numSamples);
    else
        numReps = ceil(numSamples/size(noise,1));
        temp = repmat(noise,numReps,1);
        noise = temp(1:numSamples);
    end

    signalNorm = norm(signal);
    noiseNorm = norm(noise);
    
    goalNoiseNorm = signalNorm/(10^(ratio/20));
    factor = goalNoiseNorm/noiseNorm;
    
    requestedNoise = noise.*factor;
    noisySignal = signal + requestedNoise;
end