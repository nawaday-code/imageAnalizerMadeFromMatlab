function scaledImg = scaling(dcmInfo)
    scaledImg = double(dicomread(dcmInfo)).*dcmInfo.RescaleSlope + dcmInfo.RescaleIntercept;
end