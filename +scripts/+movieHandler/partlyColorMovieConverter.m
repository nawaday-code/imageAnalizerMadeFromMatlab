classdef partlyColorMovieConverter < handle
    %UNTITLED このクラスの概要をここに記述
    %   詳細説明をここに記述

    properties
        baseFigure
        parent
%         timeSeriesImg
        graySourceTSImg = []
        flowSourceTSImg = []
        grayGradatedTSImg = []
        flowGradatedTSImg = []
        colorAreaTS logical = []


        imgWidth
        imgHeight
%         gradatedTSImg
        imgViewer
        movieFrame
        outputPath
    end

    methods
        function this = partlyColorMovieConverter(constructParam)
            %UNTITLED このクラスのインスタンスを作成
            %   詳細説明をここに記述
            arguments
                constructParam.figure = []
                constructParam.parent = []
                constructParam.graySourceTSImg = []
                constructParam.flowSourceTSImg = []
                constructParam.colorAreaTS = []
                constructParam.imageWidth = []
                constructParam.imageHeight = []
                constructParam.imageViewerObj = []
            end
            
            uiObjSequence = [~isempty(constructParam.figure), ~isempty(constructParam.parent)];

            switch true
                case isequal(uiObjSequence, [1,1])
                    this.baseFigure = constructParam.figure;
                    this.parent = constructParam.parent;
                case isequal(uiObjSequence, [1,0])
                    this.baseFigure = constructParam.figure;
                    this.parent = this.baseFigure;
                case isequal(uiObjSequence, [0,1])
                    error('parentのみを指定することはできません')
                case isequal(uiObjSequence, [0,0])
                    this.baseFigure = uifigure('Position',[10,10,800,650]);
                    this.parent = this.baseFigure;
                otherwise
                    error('予期せぬ引数指定がされています')
            end

            this.videoFormats = containers.Map( ...
                {'avi','mp4', 'mj2'}, ...
                {'Motion JPEG AVI','MPEG-4','Motion JPEG 2000'});

            createComponents(this);

            if ~isempty(constructParam.imageViewerObj)
                this.unPackImgViewerObj(constructParam.imageViewerObj)
            else
                this.imgWidth = constructParam.imageWidth;
                this.imgHeight = constructParam.imageHeight;
                this.graySourceTSImg = constructParam.graySourceTSImg;
                this.flowSourceTSImg = constructParam.flowSourceTSImg;
                this.colorAreaTS = constructParam.colorAreaTS;
            end


            

        end

        function unPackImgViewerObj(this, imgViewerObj)
            this.setTimeSeriesImg(imgViewerObj.graySourceImg3D, imgViewerObj.flowSourceImg3D);
            this.setImgMtx(imgViewerObj.imgWidth,imgViewerObj.imgHeight);
            this.setColorAreaTS(imgViewerObj.colorArea3D);
            this.imgViewer.updateFusion();
        end

        function setTimeSeriesImg(this, grayTSImg, flowTSImg)
            this.graySourceTSImg = grayTSImg;
            this.flowSourceTSImg = flowTSImg;
            this.imgViewer.setGrayImg3D(grayTSImg);
            this.imgViewer.setFlowImg3D(flowTSImg);

        end

        function setImgMtx(this, imgWidth, imgHeight)
            this.imgViewer.setImgMtx(imgWidth, imgHeight);
        end

        function setColorAreaTS(this, colorAreaTS)
            this.colorAreaTS = colorAreaTS;
            this.imgViewer.setColorArea3D(this.colorAreaTS);
        end
%         function convertedTSImg= convertImg4Movie(this, gradatedTSImg, imgWidth, imgHeight)
%         end
% 
%         function makeMovie(this, tsImg, option)
%             arguments
%                 this,
%                 tsImg,
%                 option.fps,
%                 option.format
%             end
    %         end
        function setOutputPath(this, option)
            arguments
                this,
                option.Path string = []
            end
            if isempty(option.Path)
                [filename, path] = uiputfile( ...
                    sprintf('*.%s', this.formatDropDown.Value), ...
                    '保存先を選択', ...
                    'sample');
                this.outputPath = append(path, filename);
            else
                this.outputPath = option.Path;
            end
        end

        function saveAsMovie(this, gradatedTSImg)
            videoHandler = VideoWriter(this.outputPath, this.videoFormats(this.formatDropDown.Value));
            videoHandler.FrameRate=this.fpsSetBox.Value;
            videoHandler.open();
            for i = 1:size(gradatedTSImg, 4)
                videoHandler.writeVideo(gradatedTSImg(:,:,:,i));
            end
            videoHandler.close();
        end

        function saveHandler(this)
            this.setOutputPath()
            this.saveAsMovie(this.imgViewer.fusionedImg3D);
        end

    end

    properties(SetAccess = private, GetAccess=public)
        formatDropDown
        videoFormats
        fpsSetBox
        saveButton

        imgViewArea
        operateArea

        imgViewPanel
    end

    methods(Access = private)
        
        function allocateArea(this)
            availableArea = this.parent.Position;
            this.imgViewArea = struct( ...
                'left', availableArea(1)+10, ...
                'bottom', availableArea(2)+10, ...
                'width', round(availableArea(3)*3/4), ...
                'height', round(availableArea(4)-20));

            this.operateArea = struct( ...
                'left', availableArea(1)+round(availableArea(3)*3/4), ...
                'bottom', availableArea(2)+10, ...
                'width', round(availableArea(3)*1/4), ...
                'height', round(availableArea(4)-20));
        end
        
        function createComponents(this)
            this.allocateArea();

            this.imgViewPanel = uipanel( ...
                'Parent',this.parent, ...
                'Position', [this.imgViewArea.left, this.imgViewArea.bottom, this.imgViewArea.width, this.imgViewArea.height]);

            this.imgViewer = scripts.imageViewer.opticalFlowViewer( ...
                "figure", this.baseFigure, ...
                "parent", this.imgViewPanel);

            buttonWidth = 100;
            buttonHeight = 50;

            uilabel('Parent', this.parent, ...
                'Position', [this.operateArea.left + 30, this.operateArea.bottom + this.operateArea.height * 4/5 + 30, 100, 30], ...
                'Text',sprintf('FPS'));
            this.fpsSetBox = uieditfield(this.parent, ...
                'numeric', ...
                'Position',[this.operateArea.left + 30, this.operateArea.bottom + this.operateArea.height * 4/5, 100, 30], ...
                'Value',60);


            uilabel('Parent', this.parent, ...
                'Position', [this.operateArea.left + 30, this.operateArea.bottom + this.operateArea.height * 3/5 + 30, 100, 30], ...
                'Text',sprintf('保存形式'));
            this.formatDropDown = uidropdown( ...
                'Parent', this.parent, ...
                'Position', [this.operateArea.left + 30, this.operateArea.bottom + this.operateArea.height * 3/5, buttonWidth, buttonHeight/2], ...
                'Items',this.videoFormats.keys());
        


            this.saveButton = uibutton(this.parent, ...
                'Position', [this.operateArea.left + 30, this.operateArea.bottom + this.operateArea.height * 1/15, buttonWidth, buttonHeight], ...
                'Text',sprintf('保存'), ...
                'ButtonPushedFcn',@(src, evevnt)saveHandler(this));
        
            this.imgViewer.spawnWindowChangeListener(this.imgViewer.grayGradationer);
            this.imgViewer.spawnWindowChangeListener(this.imgViewer.flowGradationer);
        end
    end
end