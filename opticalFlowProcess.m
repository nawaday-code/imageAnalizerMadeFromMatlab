classdef opticalFlowProcess < handle

    properties (SetAccess = private, GetAccess=public)
        baseFigure
        basePanel
        imgSource
        medianFiltered
        manualROI
        binaryMask
%         threshold

        manualROIImg
        binaryMaskImg
        opticalFlowImg
        
    end
    
    methods (Access = public)
        function this = opticalFlowProcess(constractParam)
            arguments
                constractParam.figure = []
                constractParam.parent = []
                constractParam.image3D = []
            end

            if isempty(constractParam.figure)&&isempty(constractParam.parent)
                this.baseFigure = uifigure( ...
                    'Position',[30,30,1200,650]);
                availableArea = this.baseFigure.InnerPosition;
                this.basePanel = uipanel(this.baseFigure, ...
                    'Position', [0,0,availableArea(3),availableArea(4)]);
            elseif isempty(constractParam.figure)&& ~isempty(constractParam.parent)
                error('parentのみを指定することはできません')
            elseif ~isempty(constractParam.figure) && isempty(constractParam.parent)
                this.baseFigure = constractParam.figure;
                availableArea = this.baseFigure.InnerPosition;
                this.basePanel = uipanel(this.baseFigure, ...
                    'Position',[0,0,availableArea(3),availableArea(4)]);
            elseif ~isempty(constractParam.figure) && ~isempty(constractParam.parent)
                this.baseFigure = constractParam.figure;
                availableArea = this.baseFigure.InnerPosition;
                this.basePanel = uipanel(constractParam.parent, ...
                    'Position',[0,0,availableArea(3),availableArea(4)]);
            else
                error('予期せぬ引数指定がされています')
            end



            createProcessComponents(this);

            if ~isempty(constractParam.image3D)
                this.setImg(constractParam.image3D, "setTo",'raw');
            end

        end

        function setImg(this, img3D, option)
            arguments
                this,
                img3D,
                option.setTo string = 'raw'
            end

            switch option.setTo
                case 'raw'
                    this.imgSource = img3D;
                    medianImg= medfilt3(this.imgSource);
                    this.setImg(medianImg, "setTo",'medianFiltered');
                case 'medianFiltered'
                    this.medianFiltered = img3D;
                    this.medianFilteredView.setImages(img3D);
                case 'manualROI'
                    this.manualROIImg = img3D;
                    this.manualROIView.setImages(img3D);
                case 'binaryMask'
                    this.binaryMaskImg = img3D;
                    this.binaryMaskImgView.setImages(img3D);
                case 'opticalFlow'
                    this.opticalFlowImg = img3D;
                    this.opticalflowView.setImages(img3D);
            end
        end

    end

    properties (SetAccess=private, GetAccess=public)
        medianFilteredView
        manualROIView
        binaryMaskImgView
        opticalflowView

        manualROIsetFig
        
    end

    methods (Access = private)
        function createProcessComponents(this)
            set(this.basePanel, "Scrollable", "on")

            %ぱっと見でわかるように配列にせず、それぞれ変数に格納しています
            blockWidth = 500;
            blockHeight = 500;

            medianFilteredAnchor = [10, 10 + (10 + blockHeight)*3];
            medianFilteredPanel = uipanel(this.basePanel, ...
                'Position', [medianFilteredAnchor(1),medianFilteredAnchor(2), blockWidth, blockHeight]);

            manualROIAnchor = [10, 10 + (10 + blockHeight)*2];
            manualROIPanel = uipanel(this.basePanel, ...
                'Position', [manualROIAnchor(1),manualROIAnchor(2), blockWidth, blockHeight]);

            binaryMaskImgAnchor = [10,10 + (10 + blockHeight)*1];
            binaryMaskImgPanel = uipanel(this.basePanel, ...
                'Position', [binaryMaskImgAnchor(1),binaryMaskImgAnchor(2), blockWidth, blockHeight]);

            opticalFlowAnchor = [10, 10];
            opticalflowPanel = uipanel(this.basePanel, ...
                'Position', [opticalFlowAnchor(1),opticalFlowAnchor(2),blockWidth, blockHeight]);


            this.medianFilteredView = scripts.imageViewer.guiImageViewer("figure",this.baseFigure, "parent", medianFilteredPanel);
            
            this.manualROIView = scripts.imageViewer.guiImageViewer("figure", this.baseFigure, "parent", manualROIPanel);

            this.binaryMaskImgView = scripts.imageViewer.guiImageViewer("figure", this.baseFigure, "parent", binaryMaskImgPanel);

            this.opticalflowView = scripts.imageViewer.opticalFlowViewer("figure", this.baseFigure, "parent", opticalflowPanel);

            areaWidth = 650;
            areaHeight = 500;

            manualROIsetArea = uipanel(this.basePanel, ...
                "Position",[medianFilteredAnchor(1) + blockWidth, medianFilteredAnchor(2), areaWidth, areaHeight]);
            binaryMaskImgsetArea = uipanel(this.basePanel, ...
                "Position",[manualROIAnchor(1) + blockWidth, manualROIAnchor(2), areaWidth, areaHeight]);
            opticalflowsetArea = uipanel(this.basePanel, ...
                "Position",[binaryMaskImgAnchor(1) + blockWidth, binaryMaskImgAnchor(2), areaWidth, areaHeight]);
            resultdealArea = uipanel(this.basePanel, ...
                "Position",[opticalFlowAnchor(1) + blockWidth, opticalFlowAnchor(2), areaWidth, areaHeight]);
            
            buttonWidth = 150;
            buttonHeight = 50;
            uilabel(manualROIsetArea, ...
                "Text",sprintf("ROI選択ボタンをクリックすると左の画像をもとにROI設定画面が出てきます。\n" + ...
                "ROIで選択した部分を切り取ります。"), ...
                "Position",[150, 150, 600, 300]);
            uibutton(manualROIsetArea, ...
                "Position", [250, 20, buttonWidth, buttonHeight],"Text",sprintf('ROI選択'), ...
                "ButtonPushedFcn",@(src, event)roiSetManually(this));
%             uibutton(manualROIsetArea, ...
%                 "Position", [400, 20, buttonWidth, buttonHeight],"Text",sprintf('確定'));

            uilabel(binaryMaskImgsetArea, ...
                "Text",sprintf("ヒストグラム上で閾値を設定し、よりROIを細かく設定します。\n" + ...
                "左の画像をさらにROIで切り取る場合は’ROI再設定’を押してください。\n" + ...
                "はじめからROIを設定しなおす場合はスクロールを上にあがり\n" + ...
                "’ROI選択’を再度押してください。"), ...
                "Position",[150, 150, 600, 200]);
            uibutton(binaryMaskImgsetArea, ...
                "Position", [100, 20, buttonWidth, buttonHeight], ...
                "Text",sprintf('ROI再設定'), ...
                "ButtonPushedFcn",@(src, event)roiReSetManually(this));
            uibutton(binaryMaskImgsetArea, ...
                "Position", [400, 20, buttonWidth, buttonHeight], ...
                "Text",sprintf('閾値選択'), ...
                "ButtonPushedFcn",@(src, event)makeBinaryMaskImg(this));


            uilabel(opticalflowsetArea, ...
                "Text",sprintf("Optical Flow の解析をおこないます。\n" + ...
                "左に表示されているデータで良ければ解析開始ボタンを押してください。"), ...
                "Position",[150, 150, 600, 300]);
            uibutton(opticalflowsetArea, ...
                "Position", [250, 20, buttonWidth, buttonHeight], ...
                "Text",sprintf('解析開始'), ...
                "ButtonPushedFcn",@(src, event) calcOpticalFlow(this));

            uilabel(resultdealArea, ...
                "Text",sprintf("左に表示されているものが解析結果です。\n" + ...
                "この結果を出力する場合は出力ボタンを押してください。"), ...
                "Position",[150, 150, 600, 300]);
            uibutton(resultdealArea, ...
                "Position", [250, 20, buttonWidth, buttonHeight],"Text",sprintf('出力'));
            
        end

        function roiSetManually(this)
            this.manualROI = scripts.measureTools.roiManager("image3D", this.imgSource);
            addlistener(this.manualROI, 'confirmed', @(src, event)acceptROIData(this));
            function acceptROIData(this)
                this.setImg(this.manualROI.roiResult, 'setTo', 'manualROI');
            end
        end

        function roiReSetManually(this)
            this.manualROI = scripts.measureTools.roiManager("image3D", this.manualROIImg);
            addlistener(this.manualROI, 'confirmed', @(src, event)acceptROIData(this));
            function acceptROIData(this)
                this.setImg(this.manualROI.roiResult, 'setTo', 'manualROI');
            end
        end

        function makeBinaryMaskImg(this)
            this.binaryMask = scripts.measureTools.binaryMaskManager("image3D", this.manualROIImg);
            addlistener(this.binaryMask, 'confirmed', @(src, event)acceptBinaryMaskData(this));
            function acceptBinaryMaskData(this)
                this.setImg(this.binaryMask.binaryMaskResult, 'setTo', 'binaryMask');
            end
        end

        function calcOpticalFlow(this)
            optFlowLK = opticalFlowLK("NoiseThreshold", 0.1);
            inputSize = size(this.binaryMask.binaryMaskResult);
            this.opticalFlowImg = zeros(inputSize);
            
            for i = 1:inputSize(3)
                flow = estimateFlow(optFlowLK, this.binaryMask.binaryMaskResult(:,:,i));
                this.opticalFlowImg(:,:,i) = flow.Magnitude;
            end
            f = reshape(this.opticalFlowImg(:,:,1), [1, numel(this.opticalFlowImg(:,:,1))]);
            [category, ~, ic] = unique(f);
            disp(size([category, groupcounts(ic)']))
            
            
%             categorical(reshape(this.opticalFlowImg(:,:,1), [1, numel(this.opticalFlowImg(:,:,1))]))
            this.setImg(this.opticalFlowImg, "setTo", 'opticalFlow');
        end


    end

    

end