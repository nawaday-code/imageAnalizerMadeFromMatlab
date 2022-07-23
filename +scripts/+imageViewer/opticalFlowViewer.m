classdef opticalFlowViewer < scripts.imageViewer.guiImageViewer
    methods (Access = public)
        function this = opticalFlowViewer(constractParam)
            arguments
                constractParam.figure = []
                constractParam.parent = []
                constractParam.isReadingDICOM = false
                constractParam.image3D = []
            end
            
            this@scripts.imageViewer.guiImageViewer( ...
                "figure", constractParam.figure, ...
                "parent", constractParam.parent, ...
                "isReadingDICOM", constractParam.isReadingDICOM, ...
                "image3D", constractParam.image3D);

        end

        function 
            
        end

    end
end