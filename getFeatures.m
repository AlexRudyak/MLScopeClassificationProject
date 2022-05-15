function featureVec = getFeatures(data) 

    % Get FFT peaks
    L = size(data,1);
    fdata = fft(data);
    P2 = abs(fdata/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    dataFftPeaks = findpeaks(P1,'MinPeakHeight',0.015);

    dataFftPeak = maxk(dataFftPeaks,2); % 2 highest fft peaks

    % Get Auto-correlation peaks
    minprom = 0.0005;
    mindist_xunits = 0.3;
    minpkdist = floor(mindist_xunits/(1/2));
    datacorr = xcorr(data);
    [dataCorrPeaks,~] = findpeaks(datacorr,'minpeakprominence',minprom,'minpeakdistance',minpkdist);
    
    dataCorrPeak = maxk(dataCorrPeaks,2); % 2 highest auto correlation peaks

    % Get PSD Peaks
    fs = 50000;
    N = 4096;
    [p, ~] = pwelch(data,rectwin(length(data)),[],N,fs);

    dataPsdPeak = maxk(p,2); % 2 highest PSD peaks

    % Get Mean Value
    dataMean = mean(data); % the mean value

    % Get Variance Value
    dataVar = var(data);

    % Get RMS Value
    dataRMS = rms(data); % the rms value

    % Output a row vector of features
    featureVec = [dataFftPeak' dataCorrPeak' dataPsdPeak' dataMean dataVar dataRMS];
    
end