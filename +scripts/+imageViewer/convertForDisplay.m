%namespace guiImageHandler
function displayable = convertForDisplay(rawSignalImage)
    displayable = imadjust(rescale(rawSignalImage));
end


