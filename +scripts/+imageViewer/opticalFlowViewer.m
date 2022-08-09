%{
guiImageViewerのサブクラスにするつもりだったが、カラー画像に対応していなかった
したがって似た機能をもつクラスを作成することになった
設計ミス。微妙な構造になってしまった
%}
classdef opticalFlowViewer < handle
    properties (Access = public)
        baseFigure
        parent
        flow3D
    end
    
    methods (Access = public)
        function this = opticalFlowViewer(constractParam)
            arguments
                constractParam.figure = []
                constractParam.parent = []
                constractParam.flow3D = []
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

            this.flow3D = constractParam.flow3D;
            if~isempty(this.flow3D)
                this.setImages(this.flow3D);
            end

            this.createComponents();

        end

        function updateImage(this)
            this.preview = imshow(this.currentDisplay, ...
                'Parent', this.previewAx);
            drawnow;
        end

        function setImages(this, flow3D)
            this.flow3D = flow3D;
            this.currentDisplay = this.flow3D(:,:,:,1);
            this.sliceSlider.Limits = [1, size(flow3D, 4)];
            this.sliceSlider.Enable = 'on';
            this.updateImage();
        end



    end

    properties(SetAccess=private, GetAccess=public)
        previewAx
        preview
        sliceSlider

        sliceNum
        currentDisplay
    end

    methods (Access=private)
        function createComponents(this)
            previewPos = this.parent.Position;
            this.previewAx = uiaxes(this.parent, ...
                "Position",[0, 0, previewPos(4)-30, previewPos(4)-30], ...
                "DataAspectRatioMode","manual", ...
                "DataAspectRatio",[1,1,1]);

            uilabel(this.parent, ...
                "Text", "slice", ...
                "Position", [previewPos(1)+previewPos(4)+30 ,previewPos(2)+previewPos(4)*11/12,30,20]);
            this.sliceSlider = uislider(this.parent, ...
                "Position",[previewPos(1)+previewPos(4)+30, previewPos(2)+20, previewPos(4)*6/7,3], ...
                "Orientation","vertical", ...
                "ValueChangingFcn",@(src, event) sliceChanging(this, event), ...
                "Enable", "off");

            function sliceChanging(this, event)
                this.sliceNum = round(event.Value);
                this.currentDisplay = this.flow3D(:,:,:,this.sliceNum);
                this.updateImage()
            end
        end
    end
end