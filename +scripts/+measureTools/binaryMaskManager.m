classdef binaryMaskManager < handle
    %THRESHOLDMANAGER このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        baseFigure
        parent
        image3D
        imgViewer
        histogrammer
        threshold
        
        binaryMaskResult
    end

    events
        confirmed
    end
    
    methods (Access = public)
        function this = binaryMaskManager(constractParam)
            %   詳細説明をここに記述
            arguments
                constractParam.figure = []
                constractParam.parent = []
                constractParam.image3D = []
            end

            if isempty(constractParam.figure)&&isempty(constractParam.parent)
                this.baseFigure = uifigure('Position',[50,50,1200,700]);
                this.parent = this.baseFigure;
            elseif isempty(constractParam.figure)&& ~isempty(constractParam.parent)
                error('parentのみを指定することはできません')
            elseif ~isempty(constractParam.figure) && isempty(constractParam.parent)
                this.baseFigure = constractParam.figure;
                this.parent = this.baseFigure;
            elseif ~isempty(constractParam.figure) && ~isempty(constractParam.parent)
                this.baseFigure = constractParam.figure;
                this.parent = constractParam.parent;
            else
                error('予期せぬ引数指定がされています')
            end

            if isempty(constractParam.image3D)
                this.image3D = ones([100,100,3]);
            else
                this.image3D = constractParam.image3D;
            end

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
                "image3D", this.image3D);
            this.histogrammer = scripts.measureTools.binaryMaskHistogrammer( ...
                "baseFig", this.baseFigure, ...
                "Position", [round(availableArea(3)*3/5), round(availableArea(4)*1/2)-20, round(availableArea(3)*2/5), round(availableArea(4)* 3/7)]);
            this.histogrammer.setData(this.image3D);
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
            binaryArea = this.image3D;
            binaryArea(binaryArea < this.threshold) = 0;
            binaryArea(binaryArea ~= 0) = 1;
            this.binaryMaskResult = this.image3D .* binaryArea;
            this.imgViewer.setImages(this.binaryMaskResult);
        end

        function confirmBinaryMask(this)
            notify(this, 'confirmed');
            delete(this.baseFigure);
        end
    end
end

