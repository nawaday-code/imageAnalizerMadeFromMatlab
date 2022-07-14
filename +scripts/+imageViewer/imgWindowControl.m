%imcontrastを参考にしたウィンドウ調整機能とヒストグラムを用いた値範囲指定class
classdef imgWindowControl


    methods (Access = public)

        % Create Draggable Clim Window on the histogram.
        hHistAx = findobj(hPanelHist,'type','axes');
        histStruct = images.internal.getHistogramData(imageHandle);
        maxCounts = max(histStruct.counts);
        windowAPI = createClimWindowOnAxes(hHistAx,newClim,maxCounts);




        function newClim = validateClim(clim)
    
            % Prevent new endpoints from exceeding the min and max of the
            % histogram range, which is a little less than the xlim endpoints.
            % Don't want to get to the actual endpoints because there is a
            % problem with the painters renderer and patches at the edge
            % (g298973).  histStruct is a variable calculated in the beginning
            % of createHistogramPalette.
            histRange = histStruct.histRange;
            newMin = max(clim(1), histRange(1));
            newMax = min(clim(2), histRange(2));
    
            if ~isDoubleOrSingleData
                % If the image has an integer datatype, don't allow the new endpoints
                % to exceed the min or max of that datatype.  For example, We don't
                % want to allow this because it wouldn't make sense to set the clim
                % of a uint8 image beyond 255 or less than 0.
                minOfDataType = double(intmin(getClassType(imgModel)));
                maxOfDataType = double(intmax(getClassType(imgModel)));
                newMin = max(newMin, minOfDataType);
                newMax = min(newMax, maxOfDataType);
            end
    
            % Keep min < max
            if ( ((newMax - 1) < newMin) && ~isDoubleOrSingleData )
    
                % Stop at limiting value.
                Clim = getClim;
                newMin = Clim(1);
                newMax = Clim(2);
    
                %Made this less than or equal to as a possible workaround to g226780
            elseif ( (newMax <= newMin) && isDoubleOrSingleData )
    
                % Stop at limiting value.
                Clim = getClim;
                newMin = Clim(1);
                newMax = Clim(2);
            end
    
            newClim = [newMin newMax];
        end
    end
end