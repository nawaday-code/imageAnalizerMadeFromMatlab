classdef  imgControlTools

    %細部は改変しようと考えているので、静的メソッドしか持たないclassにしました
    methods(Static)

        function rgbtypeGrayImage = grayToRGB(imgDataSource)
            arguments
                %引数のアサーション追加予定
                imgDataSource
            end
            rgbtypeGrayImage = cat(3, imgDataSource, imgDataSource, imgDataSource);
        end

        function displayable = convertForDisplay(rawSignalImage)
            displayable = imadjust(rescale(rawSignalImage));
        end

        function dispCells = convertAllForDisplay(rawSignalImgCells)
            rawSignalImgNum = length(rawSignalImgCells);
            dispCells = cell(rawSignalImgNum, 1);
            parfor i = 1:rawSignalImgNum
                dispCells{i} =scripts.imageViewer.imgControlTools.convertForDisplay(rawSignalImgCells{i});
            end
        end

        function  windowWidthHalf = wwLimitter(value, currentWindowLevel)
            [minW, maxW] = scripts.imageViewer.imgControlTools.windowMinMaxLimitter(value, currentWindowLevel);
            windowWidthHalf = max([(maxW - minW)/2, 0.001]);
        end

        function windowLevel = wlLimitter(value, currentWindowWidthHalf)
            if (value + currentWindowWidthHalf) > 1
                windowLevel = 1-currentWindowWidthHalf;
            elseif (value - currentWindowWidthHalf) < 0
                windowLevel = 0 + currentWindowWidthHalf;
            else
                windowLevel = value;
            end
        end
        
        function adjustedWindowImg = applyWindow(displayableImgSource, windowWidthHalf, windowLevel)
%           imadjustでガンマ補正できます
            [minW, maxW] = scripts.imageViewer.imgControlTools.windowMinMaxLimitter(windowWidthHalf, windowLevel);
            adjustedWindowImg = imadjust(displayableImgSource, [minW, maxW]);
        end

        function [minW, maxW] = windowMinMaxLimitter(windowWidthHalf, windowLevel)
            minW = max([windowLevel - windowWidthHalf, 0]);
            maxW = min([windowLevel + windowWidthHalf, 1]);
        end


    end
    
end