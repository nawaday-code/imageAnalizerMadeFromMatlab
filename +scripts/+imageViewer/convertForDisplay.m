%namespace guiImageViwer
function displayable = convertForDisplay(rawSignalImage)
    displayable = imadjust(rescale(rawSignalImage));
end


