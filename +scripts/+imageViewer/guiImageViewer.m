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

        histogrammer
    end

    events
        changeSlice
    end
    
    methods (Access = public)
        function this = guiImageViewer(constractParam)
            arguments
                constractParam.figure = []
                constractParam.parent = []
                constractParam.isReadingDICOM = false
                constractParam.image3D = []
            end

            if isempty(constractParam.figure)&&isempty(constractParam.parent)
                this.baseFigure = uifigure('Position',[10,10,800,650]);
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

            %↓うまくいかないのでやめました
            %Figureグラフィックオブジェクトを見つけるまでparent階層をあがって検索するつもりです
%             parentPosition = parent.InnerPosition;
%             this.baseFigure = findobj(parent, 'type', 'figure');
%             this.basePanel = uipanel(parent,"Position",parentPosition);

            allocateArea(this);

            createPreviewComponents(this);
            createHistComponents(this);
            


            %引数オプションで、下2つはいずれかしか選択できないのであえてこの書き方にしています
            if constractParam.isReadingDICOM
                dcmHandler = scripts.dicomHandler.DICOMHandler();
                dcmHandler.readDICOMDIR();
                this.image3D = dcmHandler.readAllImage();

                this.mountDisplay();
                this.spawnWindowChangeListener(this.histogrammer);
            elseif ~isempty(constractParam.image3D)
                this.image3D = constractParam.image3D;

                this.mountDisplay();
                this.spawnWindowChangeListener(this.histogrammer);
            end
            

        end

        function setImages(this, image3D)
            this.image3D = image3D;
            this.mountDisplay();
            drawnow;
        end


        %rescaleやimadjustを使わずにわざわざ作成しました。理由は強度イメージデータが扱いにくいと感じたためです。
        %imadjustを仕様する場合、doubleの強度イメージデータをuint8に変更すれば
        %contrast stretchも効かせられて良いかもしれませんが、変換が無駄だと考えています。
        %categoryのみに階調処理をかけて計算速度を向上させる予定。
        function convertedData = applyToneCurve(this, preConvertData, windowMin, windowMax, option)
            arguments
                this
                preConvertData
                windowMin
                windowMax
                option.brightness = 0
                option.gamma = 1
            end
            
            %arrayfunよりもベクトル化を採用
            
            convertedGOGToneCurve = this.gogToneCurveFunc(preConvertData, windowMin, windowMax, option.brightness, option.gamma);

            %なんとこれで最低値以下のものを最低値で飽和させることができます
            saturatedMin = max(convertedGOGToneCurve, 0);
            %最大値の場合も同様
            saturatedMax = min(saturatedMin, 255);

            convertedData = uint8(round(saturatedMax));
        end

        function converted = gogToneCurveFunc(~, rawData, wMin, wMax, brightness, gamma)
            delta = 255 / (wMax - wMin);
            intercept = brightness - wMin*delta;
            converted = (rawData.*delta + intercept).^gamma;
        end

        %contrast Stretch 機能（ウィンドウ自動調整機能）は後々実装します。
        

        function updateImage(this)
            this.currentPreview = this.applyToneCurve(this.currentDisplaySource, this.histogrammer.xMin, this.histogrammer.xMax);
%             this.preview.ImageSource = cat(3, this.currentPreview, this.currentPreview ,this.currentPreview);
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
            this.histogrammer.setData(this.currentDisplaySource);
            this.histogrammer.createBoundsSetLine();
            this.updateImage();
            imDimension = size(this.image3D);
            sliceNum = imDimension(3);
            set(this.sliceSlider, 'Limits', [1, sliceNum]);
            
        end

        function spawnWindowChangeListener(this, nobinHistogrammerInstance)
            addlistener(nobinHistogrammerInstance, ...
                'changeArea', @applyWindowToImg);
            function applyWindowToImg(src, ~)
                this.currentWindowMin = src.xMin;
                this.currentWindowMax = src.xMax;
                this.updateImage();
            end
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
            this.histogrammer = scripts.measureTools.nobinHistogrammer('parent', this.parent, 'baseFig', this.baseFigure, ...
                'Position', [this.histPos(1), this.histPos(2), this.histPos(3), this.histPos(4)]);
        end

    end
end