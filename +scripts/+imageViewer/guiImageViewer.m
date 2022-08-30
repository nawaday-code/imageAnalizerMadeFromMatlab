%{
##########追加予定機能###########
・プレビュー上でマウスホイールを転がすとスライスが変えられる機能
・プレビュー上でドラッグすることでウィンドウ調整ができる機能
・プレニュー上にあるマウスポインタの位置における信号値を表示する機能



#################################

############改善予定#############
・applyToneCurveの高速・効率化

#################################
%}
classdef guiImageViewer < handle
    properties (Access=public)
        baseFigure
        parent
        sourceImg3D = []
        gradatedImg3D = [];
        imgWidth = []
        imgHeight = []

        sliceNumber = 1

        gradationer
    end

    events
        changeSlice
    end
    
    methods (Access = public)
        function this = guiImageViewer(constructParam)
            arguments
                constructParam.figure = []
                constructParam.parent = []
                constructParam.isReadingDICOM = false
                constructParam.image3D = []
                constructParam.imageWidth = []
                constructParam.imageHeight = []
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



            allocateArea(this);

            createPreviewComponents(this);
            createHistComponents(this);
            %引数オプションで、下2つはいずれかしか選択できないのであえてこの書き方にしています
            %かならずcomponentsをインスタンス化してから以下を実行するようにしてください
            if constructParam.isReadingDICOM
                dcmHandler = scripts.dicomHandler.DICOMHandler();
                dcmHandler.readDICOMDIR();
                this.setImg3D(dcmHandler.readAllImage());
                this.spawnWindowChangeListener(this.gradationer);
            elseif ~isempty(constructParam.image3D)
                this.setImg3D(constructParam.image3D);

                this.spawnWindowChangeListener(this.gradationer);
            end

            this.setImgMtx(constructParam.imageWidth, constructParam.imageHeight);


        end

        function setImg3D(this, image3D)
            this.sourceImg3D = image3D;
            set(this.sliceSlider, 'Limits', [1, size(this.sourceImg3D, 3)]);
            this.gradationer.set3DData(this.sourceImg3D);
            this.gradatedImg3D = this.gradationer.gradated;
            this.drawImg();
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

        function drawImg(this)
            this.preview = imshow(this.gradatedImg3D(:,:,this.sliceNumber), ...
                'Parent', this.previewAx);
            drawnow
        end

        function changeWindow(this)
            this.gradationer.applyToneCurve();
            this.gradatedImg3D = this.gradationer.gradated;
            this.drawImg();
        end

        function previewAx = getPreviewAx(this)
            previewAx = this.previewAx;
        end

        function imgObj = getImageObj(this)
            imgObj = this.preview;
        end


        function spawnWindowChangeListener(this, nobinHistogrammerInstance)
            addlistener(nobinHistogrammerInstance, ...
                'changeArea', @(src, event) changeWindow(this));
        end

    end


    properties (Access = private)
        previewPos
        histPos

        previewAx
        preview
        sliceSlider

        aspectRatioCheckBox
    end

    methods(Access = private)
        function allocateArea(this)
            availableArea = this.parent.Position;
            this.previewPos = [round(availableArea(3)/2 - availableArea(4)*2/5),round(availableArea(4)*1/4),availableArea(3), round(availableArea(4)*3/4)];
            this.histPos = [0,0,availableArea(3), round(availableArea(4)*1/4)];
        end



        function createPreviewComponents(this)
            this.previewAx = uiaxes(this.parent, ...
                "Position",[this.previewPos(1), this.previewPos(2), this.previewPos(4), this.previewPos(4)], ...
                "DataAspectRatioMode","manual", ...
                "DataAspectRatio",[1,1,1]);

            uilabel(this.parent, ...
                "Text", "slice", ...
                "Position", [this.previewPos(1)+this.previewPos(4)+30 ,this.previewPos(2)+this.previewPos(4)*9/10,30,20]);
            this.sliceSlider = uislider(this.parent, ...
                "Position",[this.previewPos(1)+this.previewPos(4)+30, this.previewPos(2)*1.125, this.previewPos(4)*6/7,3], ...
                "Orientation","vertical", ...
                "ValueChangingFcn",@(this, event) sliceChanging(event));

            this.aspectRatioCheckBox = uicheckbox(this.parent, ...
                "Value",0, ...
                'Enable','off', ...
                'Position',[this.previewPos(1)+this.previewPos(4)+30, this.previewPos(2)+this.previewPos(4)*15/16,84,22], ...
                'ValueChangedFcn',@(src, event)changeViewAspectRatio(this, src), ...
                'Text',sprintf('fill'));

            %%%%%%% Call Back Functions %%%%%%
        
    
            function sliceChanging(event)
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
            this.gradationer = scripts.imageViewer.gradationProcessor( ...
                'parent', this.parent, ...
                'baseFig', this.baseFigure, ...
                'Position', [this.histPos(1), this.histPos(2), this.histPos(3), this.histPos(4)]);
        end

    end
end