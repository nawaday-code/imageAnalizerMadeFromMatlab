classdef roiManager < handle
    properties (Access = public)
        baseFigure
        parent
        image3D
        imgViewer
        roiResult
    end

    events
        confirmed
    end

    methods(Access = public)
        function this = roiManager(constractParam)
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

            this.undoCount = 1;
            this.undoCell{this.undoCount} = this.image3D;
            createComponents(this);
        end
    end

    properties(SetAccess = private, GetAccess = public)
        undoCell cell = {}
        undoCount uint8 = -1
        redoCell cell = {}
        redoCount uint8 = -1
    end


    methods (Access = private)
        function createComponents(this)
            availableArea = this.parent.Position;
            previewPanel = uipanel(this.parent, "Position",[0,0,round(availableArea(3)*5/6), availableArea(4)]);
            this.imgViewer = scripts.imageViewer.guiImageViewer("figure",this.baseFigure, "parent", previewPanel, "image3D", this.image3D);
            
            buttonWidth = 100;
            buttonHeight = 50;
            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*5/6) + 50, availableArea(4) * 5/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) roiSet(this), ...
                "Text",sprintf("set ROI \n manually"));

            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*5/6) + 50, availableArea(4) * 4/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) initImg(this), ...
                "Text",sprintf("initialize"));

            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*5/6) + 50, availableArea(4) * 3/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) undoProcess(this), ...
                "Text",sprintf("undo"));

            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*5/6) + 50, availableArea(4) * 2/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) redoProcess(this), ...
                "Text",sprintf("redo"));

            uibutton(this.parent, ...
                "Position",[round(availableArea(3)*5/6) + 50, availableArea(4) * 1/7, buttonWidth, buttonHeight], ...
                "ButtonPushedFcn",@(src, event) confirmROI(this), ...
                "Text",sprintf("confirm \n ROI setting"));
        end

%         function spawnSliceChangeListener(this)
%             addlistener(this.imgViewer, 'changeSlice', @applyROI)
%             function applyROI(~, ~)
%                 
%             end
%         end

        function roiSet(this)
            roiFreehand = drawpolygon("Parent",this.imgViewer.getPreviewAx);
            roiMask = createMask(roiFreehand);

            this.undoCount = this.undoCount + 1;
            %redoを初期化
            this.redoCount = -1;
            this.redoCell = {};

            this.undoCell{this.undoCount} = this.undoCell{this.undoCount - 1} .* roiMask;
            
            this.imgViewer.setImages(this.undoCell{this.undoCount});
        end

        function undoProcess(this)
            try
                if this.undoCount <= 1
                    return
                end

                pop = this.undoCell{this.undoCount};
                this.undoCell{this.undoCount} = [];
                this.undoCount = this.undoCount -1;
                
                if this.redoCount <= -1
                    this.redoCount = 0;
                end
                this.redoCount = this.redoCount + 1;
                this.redoCell{this.redoCount} = pop;

                this.imgViewer.setImages(this.undoCell{this.undoCount});
            catch
                return
            end
        end

        function redoProcess(this)
            try
                if this.redoCount <= 0
                    return
                end

                pop = this.redoCell{this.redoCount};
                this.redoCell{this.redoCount}= [];
                this.redoCount = this.redoCount -1;

                this.undoCount = this.undoCount + 1;
                this.undoCell{this.undoCount} = pop;

                
                this.imgViewer.setImages(this.undoCell{this.undoCount});
            catch
                return
            end
        end

        function initImg(this)
            this.undoCount = this.undoCount + 1;
            %redoを初期化
            this.redoCount = -1;
            this.redoCell = {};

            this.undoCell{this.undoCount} = this.image3D;
            
            this.imgViewer.setImages(this.undoCell{this.undoCount});
        end

        function confirmROI(this)
            this.roiResult = this.undoCell{this.undoCount};
            notify(this, 'confirmed');
            delete(this.baseFigure);
        end

    end
end

