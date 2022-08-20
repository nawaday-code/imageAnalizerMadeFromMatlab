classdef binaryMaskManager < handle
    %THRESHOLDMANAGER このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        baseFigure
        parent
        image3D
        imgWidth
        imgHeight
        imgViewer
        histogrammer
        threshold

        binaryArea
        
        binaryMaskResult
    end

    events
        confirmed
    end
    
    methods (Access = public)
        function this = binaryMaskManager(constructParam)
            %   詳細説明をここに記述
            arguments
                constructParam.figure = []
                constructParam.parent = []
                constructParam.image3D = []
                constructParam.imageWidth = -1
                constructParam.imageHeight = -1
            end

            if isempty(constructParam.figure)&&isempty(constructParam.parent)
                this.baseFigure = uifigure('Position',[50,50,1200,700]);
                this.parent = this.baseFigure;
            elseif isempty(constructParam.figure)&& ~isempty(constructParam.parent)
                error('parentのみを指定することはできません')
            elseif ~isempty(constructParam.figure) && isempty(constructParam.parent)
                this.baseFigure = constructParam.figure;
                this.parent = this.baseFigure;
            elseif ~isempty(constructParam.figure) && ~isempty(constructParam.parent)
                this.baseFigure = constructParam.figure;
                this.parent = constructParam.parent;
            else
                error('予期せぬ引数指定がされています')
            end

            if isempty(constructParam.image3D)
                this.image3D = ones([100,100,3]);
            else
                this.image3D = constructParam.image3D;
            end


            this.imgWidth = constructParam.imageWidth;
            this.imgHeight = constructParam.imageHeight;

            createComponents(this);
            
        end


    end

    methods (Access = private)
        function createComponents(this)
            availableArea = this.parent.Position;
            previewPanel = uipanel(this.parent, ...
                "Position",[0,0,round(availableArea(3)*3/5), availableArea(4)]);
            this.imgViewer = scripts.imageViewer.guiImageViewer( ...
                "figure",this.baseFigure, ...
                "parent", previewPanel, ...
                "image3D", this.image3D, ...
                "imageWidth",this.imgWidth, ...
                "imageHeight", this.imgHeight);
            this.histogrammer = scripts.measureTools.binaryMaskHistogrammer( ...
                "baseFig", this.baseFigure, ...
                "Position", [round(availableArea(3)*3/5), round(availableArea(4)*1/2)-20, round(availableArea(3)*2/5), round(availableArea(4)* 3/7)]);
            this.histogrammer.set3DData(this.image3D);
            addlistener(this.histogrammer, 'changeThreshold', @(src, event)makeBinaryMaskImg(this));

            buttonWidth = 100;
            buttonHeight = 50;

            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*3/4), availableArea(4) * 1/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) confirmBinaryMask(this), ...
                "Text",sprintf("confirm \n binaryMask"));



        end

        function makeBinaryMaskImg(this)
            this.threshold = this.histogrammer.threshold;
            this.binaryArea = this.image3D;
            this.binaryArea(this.binaryArea < this.threshold) = 0;
            this.binaryArea(this.binaryArea ~= 0) = 1;
            this.binaryMaskResult = this.image3D .* this.binaryArea;
            this.imgViewer.setImg3D(this.binaryMaskResult);
            this.imgViewer.gradationer.applyToneCurve;
            this.imgViewer.drawImg();
        end

        function confirmBinaryMask(this)
            notify(this, 'confirmed');
            delete(this.baseFigure);
        end
    end
end

