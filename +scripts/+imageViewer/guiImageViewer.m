%{
##########追加予定機能###########
・プレビュー上でマウスホイールを転がすとスライスが変えられる機能
・プレビュー上でドラッグすることでウィンドウ調整ができる機能
・プレニュー上にあるマウスポインタの位置における信号値を表示する機能
・簡易ROI測定機能


#################################

############改善予定#############
・applyToneCurveの高速・効率化

#################################
%}
classdef guiImageViewer < handle
    properties (Access=public)
        baseFigure
        parent
        image3D = []

        windowWidthHalf
        windowLevel

        currentWindowMin
        currentWindowMax

        sliceNumber
        currentDisplaySource
        currentPreview

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

            %↓うまくいかないのでやめました
            %Figureグラフィックオブジェクトを見つけるまでparent階層をあがって検索するつもりです
%             parentPosition = parent.InnerPosition;
%             this.baseFigure = findobj(parent, 'type', 'figure');
%             this.basePanel = uipanel(parent,"Position",parentPosition);

            allocateArea(this);

            createPreviewComponents(this);
            createHistComponents(this);
            


            %引数オプションで、下2つはいずれかしか選択できないのであえてこの書き方にしています
            if constructParam.isReadingDICOM
                dcmHandler = scripts.dicomHandler.DICOMHandler();
                dcmHandler.readDICOMDIR();
                this.image3D = dcmHandler.readAllImage();

                this.mountDisplay();
                this.spawnWindowChangeListener(this.gradationer);
            elseif ~isempty(constructParam.image3D)
                this.image3D = constructParam.image3D;

                this.mountDisplay();
                this.spawnWindowChangeListener(this.gradationer);
            end
            

        end

        function setImages(this, image3D)
            this.image3D = image3D;
            this.mountDisplay();
            drawnow;
        end

        function updateImage(this)
            this.gradationer.setData(this.currentDisplaySource);
            this.currentPreview = this.gradationer.applyToneCurve();
            this.preview = imshow(this.currentPreview, 'Parent',this.previewAx);
            drawnow;
        end

        function previewAx = getPreviewAx(this)
            previewAx = this.previewAx;
        end

        function imgObj = getImageObj(this)
            imgObj = this.preview;
        end

    end


    properties (Access = private)
%         previewPanel
%         histPanel
        previewPos
        histPos

        previewAx
        preview
        sliceSlider
    end

    methods(Access = private)
        function allocateArea(this)
            availableArea = this.parent.Position;
            this.previewPos = [round(availableArea(3)/2 - availableArea(4)*2/5),round(availableArea(4)*1/4),availableArea(3), round(availableArea(4)*3/4)];
            this.histPos = [0,0,availableArea(3), round(availableArea(4)*1/4)];
        end


        function mountDisplay(this)
            this.currentDisplaySource = this.image3D(:,:,1);
            this.gradationer.setData(this.currentDisplaySource);
            this.updateImage();
            set(this.sliceSlider, 'Limits', [1, size(this.image3D, 3)]);
            
        end

        function spawnWindowChangeListener(this, nobinHistogrammerInstance)
            addlistener(nobinHistogrammerInstance, ...
                'changeArea', @(src, event) updateImage(this));
        end

        function createPreviewComponents(this)
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
                "ValueChangingFcn",@(this, event) sliceChanging(event));

            %%%%%%% Call Back Functions %%%%%%
        
    
            function sliceChanging(event)
                this.sliceNumber = round(event.Value);
                this.currentDisplaySource = this.image3D(:,:,this.sliceNumber);
                notify(this, 'changeSlice');
                this.updateImage();
            end
        end

        function createHistComponents(this)
            this.gradationer = scripts.imageViewer.gradationProcessor( ...
                'parent', this.parent, ...
                'baseFig', this.baseFigure, ...
                'Position', [this.histPos(1), this.histPos(2), this.histPos(3), this.histPos(4)]);
        end

    end
end