%Optical Flow Measurement Interface
%optical Flow の広義は視覚表現で動きのあるものをベクトルであらわしたもの
classdef opticalFlowHandler < handle
    properties 
        baseUIFigure
        imageCells
        roiManually
        roiThreshold
        opticalFlowResult
    end

    methods (Access = public)
        function this = opticalFlowHandler(figure, imageCells)
            if nargin == 0
                this.baseUIFigure = uifigure('Position',[100,100,638,476]);
                dcmHandler = scripts.dicomHandler.DICOMHandler();
                dcmHandler.readDICOMDIR();
                this.imageCells = dcmHandler.readAllImage();
            else
                this.baseUIFigure = figure;
                this.imageCells = imageCells;
            end

            %%%% make GUI %%%%
            %ここはimageViewerClassにしてPanelでインスタンス化させよう

            preview = uiimage(this.baseUIFigure, "Position",[35,100,335,330]);
            
            uilabel(this.baseUIFigure,"Text",sprintf("Window\nWidth"), "Position",[13,63,46,29]);
            wwSlider = uislider(this.baseUIFigure, "Position",[80,63,265,3], ...
                "Limits",[0.001,0.5], "Value",0.5, "MajorTickLabels",{});
            
            uilabel(this.baseUIFigure, "Text", sprintf("Window\nLevel"), "Position",[13,28,46,29]);
            wlSlider = uislider(this.baseUIFigure, "Position",[80,28,265,3], ...
                "Limits",[0.001,0.999], "Value",0.5, "MajorTickLabels",{});

            uilabel(this.baseUIFigure, "Text", "slice", "Position", [380,395,30,20])
            sliceSlider = uislider(this.baseUIFigure, "Position",[385,126,255,3], ...
                "Orientation","vertical");
            

        end
        
        function setROIManually(this)
            this.roiManually = scripts.opticalFlowHandler.IOpticalFlowCalculator.roiCropManually(this);
        end

        function setROIThreshold(this)
            this.roiThreshold = scripts.opticalFlowHandler.IOpticalFlowCalculator.cropThreshold(this);
        end

        function mainCalculation(this)
            this.opticalFlowResult = scripts.opticalFlowHandler.IOpticalFlowCalculator.opticalFlowCalc(this);
        end

    end

end