classdef (Abstract) IimageViewControl
    methods 
        convertedCells = convertAllForDisplay(this, imageCells)

        windowWidthHalf = wwLimitter(value, currentWindowLevel)

        windowLevel = wlLimitter(value, currentWindowWidth)
        
        adjustedWindowImg = applyWindow(displayableImgSource, windowWidth, windowLevel)
        
        displayableImg = grayToRGB(imgDataSource)
    end
end