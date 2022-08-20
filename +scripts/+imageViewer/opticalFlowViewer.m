%{
guiImageViewerのサブクラスにするつもりだったが、カラー画像に対応していなかった
したがって似た機能をもつクラスを作成することになった
設計ミス。微妙な構造になってしまった
%}
classdef opticalFlowViewer < handle
        
    events
        changeSlice
    end


    properties (Access = public)
        baseFigure
        parent
        graySourceImg3D = []
        flowSourceImg3D = []
        grayGradatedImg3D = []
        flowGradatedImg3D = []
        colorArea3D logical = []
        fusionedImg3D = []

        imgWidth
        imgHeight

        grayGradationer
        flowGradationer
    end
    
    methods (Access = public)
        function this = opticalFlowViewer(constructParam)
            arguments
                constructParam.figure = []
                constructParam.parent = []
                constructParam.grayImg3D = []
                constructParam.flowImg3D = []
                constructParam.fusionedImg3D = []
                constructParam.imageWidth = -1
                constructParam.imageHeight = -1
            end

            if isempty(constructParam.figure)&&isempty(constructParam.parent)
                this.baseFigure = uifigure('Position',[10,10,800,650]);
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

            this.graySourceImg3D = constructParam.grayImg3D;
            this.flowSourceImg3D = constructParam.flowImg3D;
            this.fusionedImg3D = constructParam.fusionedImg3D;

            this.allocateArea();
            this.createComponents();
            this.createHistComponents();
            this.spawnWindowChangeListener(this.flowGradationer);
            this.spawnWindowChangeListener(this.grayGradationer);

            this.setImgMtx(constructParam.imageWidth, constructParam.imageHeight);

        end

        function drawImg(this)
            this.preview = imshow(this.fusionedImg3D(:,:,:,this.sliceNumber), ...
                'Parent', this.previewAx);
            drawnow
        end

        function setImgMtx(this, imgWidth, imgHeight)
            this.imgWidth = imgWidth;
            this.imgHeight = imgHeight;
            if isempty(imgWidth)&& isempty(imgHeight)
                return
            end
            this.aspectRatioCheckBox.Enable = 'on';
            this.changeViewAspectRatio(this.aspectRatioCheckBox);
        end

        function setFlowImg3D(this, flowImg3D)
            this.flowSourceImg3D = flowImg3D;
            this.flowGradationer.set3DData(this.flowSourceImg3D);
            this.flowGradatedImg3D = this.flowGradationer.gradated;
        end

        function setGrayImg3D(this, grayImg3D)
            this.graySourceImg3D = grayImg3D;
            this.grayGradationer.set3DData(this.graySourceImg3D);
            this.grayGradatedImg3D = this.grayGradationer.gradated;
        end

        function setFusionedImg3D(this, fusionedImg3D)
            this.fusionedImg3D = fusionedImg3D;
            this.sliceSlider.Limits = [1, size(this.fusionedImg3D, 4)];
            this.sliceSlider.Enable = 'on';
            this.drawImg();
        end

        function setColorArea3D(this, colorArea3D)
            this.colorArea3D = colorArea3D;
        end

        function fusioning(this)

            if isempty(this.grayGradatedImg3D) || isempty(this.flowGradatedImg3D) || isempty(this.colorArea3D)
               error('rack of data');
            end

            this.grayGradationer.applyToneCurve();
            this.grayGradatedImg3D = this.grayGradationer.gradated;
            
            this.flowGradationer.applyToneCurve();
            this.flowGradatedImg3D = this.flowGradationer.gradated;


            this.fusionedImg3D = this.partlyColorFusion3D(this.grayGradatedImg3D, this.flowGradatedImg3D, this.colorArea3D);

            this.setFusionedImg3D(this.fusionedImg3D);
        end

        function img = partlyColorFusion3D(this, grayImg3D, colorImg3D, colorArea3D)
        arguments
            this
            grayImg3D
            colorImg3D
            colorArea3D logical
        end
    % grayScaleとRGBScaleを合成するプログラム
    %  RGBScaleImage からRGBを分離
    
            inputSize = size(colorImg3D);
            rescaledGrayImg = rescale(grayImg3D);
            replacedR =  rescaledGrayImg;
            replacedG =  rescaledGrayImg;
            replacedB =  rescaledGrayImg;
        
            load('colormap_jet.mat', 'cmap');
            [category, ~, sourceValuePosition] = unique(colorImg3D);
            
            rConverted = cmap.R(category+1);
            gConverted = cmap.G(category+1);
            bConverted = cmap.B(category+1);
        
            rImg = reshape(rConverted(sourceValuePosition), inputSize);
            gImg = reshape(gConverted(sourceValuePosition), inputSize);
            bImg = reshape(bConverted(sourceValuePosition), inputSize);
        
            replacedR(colorArea3D) = rImg(colorArea3D); 
            replacedG(colorArea3D) = gImg(colorArea3D); 
            replacedB(colorArea3D) = bImg(colorArea3D); 
        
            testRGB = permute(cat(4, replacedR, replacedG, replacedB), [1, 2, 4, 3]);
        
            img = testRGB;
        end


    end

    properties(SetAccess=private, GetAccess=public)
        previewPos
        grayHistPos
        flowHistPos

        previewAx
        preview
        sliceSlider
        aspectRatioCheckBox

        sliceNumber = 1
        currentDisplay
    end

    methods (Access=private)

        function allocateArea(this)
            availableArea = this.parent.Position;
            this.previewPos = [round(availableArea(3)/2 - availableArea(4)*2/5),round(availableArea(4)*1/4),availableArea(3), round(availableArea(4)*3/4)];
            this.grayHistPos = [0,round(availableArea(4)*1/8),availableArea(3), round(availableArea(4)*1/8)];
            this.flowHistPos = [0,0,availableArea(3), round(availableArea(4)*1/8)];
        end

        function spawnWindowChangeListener(this, histogrammerInstance)
            addlistener(histogrammerInstance, ...
                'changeArea', @(src, event) changeWindow(this));
        end

        function changeWindow(this)
            this.fusioning();
            this.drawImg();
        end

        function createComponents(this)
            this.previewAx = uiaxes(this.parent, ...
                "Position",[this.previewPos(1), this.previewPos(2), this.previewPos(4), this.previewPos(4)], ...
                "DataAspectRatioMode","manual", ...
                "DataAspectRatio",[1,1,1]);

            uilabel(this.parent, ...
                "Text", "slice", ...
                "Position", [this.previewPos(1)+this.previewPos(4)+30 ,this.previewPos(2)+this.previewPos(4)*11/12,30,20]);
            this.sliceSlider = uislider(this.parent, ...
                "Position",[this.previewPos(1)+this.previewPos(4)+30, this.previewPos(2)+20, this.previewPos(4)*6/7,3], ...
                "Orientation","vertical", ...
                "ValueChangingFcn",@sliceChanging, ...
                "Enable", "off");

            this.aspectRatioCheckBox = uicheckbox(this.parent, ...
                "Value",0, ...
                'Enable','off', ...
                'Position',[this.previewPos(1)+this.previewPos(4)+30, this.previewPos(2)+this.previewPos(4)*15/16,84,22], ...
                'ValueChangedFcn',@(src, event)changeViewAspectRatio(this, src), ...
                'Text',sprintf('fill'));


            function sliceChanging(~, event)
                this.sliceNumber = round(event.Value);
                notify(this, 'changeSlice');
                this.drawImg();
            end
        end

        function changeViewAspectRatio(this, src)
            switch src.Value
                case 0
                    set(this.previewAx, 'DataAspectRatio', [this.imgWidth, this.imgHeight, 1]);
                case 1
                    set(this.previewAx, 'DataAspectRatio', [1, 1, 1]);
            end
            this.drawImg()
        end

        function createHistComponents(this)
            this.grayGradationer = scripts.imageViewer.gradationProcessor( ...
                'parent', this.parent, ...
                'baseFig', this.baseFigure, ...
                'Position', [this.grayHistPos(1), this.grayHistPos(2), this.grayHistPos(3), this.grayHistPos(4)]);
            this.flowGradationer = scripts.imageViewer.gradationProcessor( ...
                "parent", this.parent, ...
                "baseFig",this.baseFigure, ...
                "Position",[this.flowHistPos(1), this.flowHistPos(2),this.flowHistPos(3), this.flowHistPos(4)]);
        end
    end
end