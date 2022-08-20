classdef gradationProcessor < scripts.measureTools.nobinHistogrammer
    % 階調処理をするためのヒストグラム操作プログラム
    % 

    events
        changeArea
    end

    properties (Access = public)
        xMin = []
        xMax = []
        gradated
    end

    methods(Access = public)
        function this = gradationProcessor(constructParam)
            arguments
                constructParam.parent = []
                constructParam.baseFig = [] 
                constructParam.Position = []
            end
            %   詳細説明をここに記述
            this@scripts.measureTools.nobinHistogrammer( ...
                "parent", constructParam.parent, ...
                "baseFig", constructParam.baseFig, ...
                "Position",constructParam.Position)
        end


        %setDataとcalculation部分は分離したい
        function setData(this, array2D)
            setData@scripts.measureTools.nobinHistogrammer(this, array2D);
            if isempty(this.xMin) && isempty(this.xMax)
                this.xMin = this.baseXMin;
                this.xMax = this.baseXMax;
                this.applyToneCurve();
            end
            createBoundsSetLine(this);
        end

        function set3DData(this, array3D)
            set3DData@scripts.measureTools.nobinHistogrammer(this, array3D);
            if isempty(this.xMin) && isempty(this.xMax)
                this.xMin = this.baseXMin;
                this.xMax = this.baseXMax;
                this.applyToneCurve();
            end
            createBoundsSetLine(this);
        end



        %rescaleやimadjustを使わずにわざわざ作成しました。理由は強度イメージデータが扱いにくいと感じたためです。
        %imadjustを仕様する場合、doubleの強度イメージデータをuint8に変更すれば
        %contrast stretchも効かせられて良いかもしれませんが、変換が無駄だと考えています。
        %categoryのみに階調処理をかけて計算速度を向上させる予定。
        function convertedData = applyToneCurve(this, option)
            arguments
                this
                option.brightness = 0
                option.gamma = 1
            end
            
            %arrayfunよりもベクトル化を採用
            convertedByGOGToneCurve = this.gogToneCurveFunc(this.histX, this.xMin, this.xMax, option.brightness, option.gamma);
            
            %下限上限を一定値で飽和
            saturated = max(0, min(255, convertedByGOGToneCurve));

            %元データの数値を入れ替える
            this.gradated = uint8(round(reshape(saturated(this.sourceValuePosition), this.sourceShape)));
            convertedData = this.gradated;
        end

        function converted = gogToneCurveFunc(~, rawData, wMin, wMax, brightness, gamma)
            delta = 255 / (wMax - wMin);
            intercept = brightness - wMin*delta;
            converted = (rawData*delta + intercept).^gamma;
        end

        %contrast Stretch 機能（ウィンドウ自動調整機能）は後々実装します。
 


    end

    properties(SetAccess=private, GetAccess=public)
        minLine
        maxLine
        isMaxLine = false
    end

    methods(Access = private)
        function createBoundsSetLine(this)
%             try
                if isempty(this.sourceArray3D)
                    error('ヒストグラムデータがセットされていません');
                    
                end

                this.maxLine = xline(this.histAx, this.xMax, ...
                    'LineWidth',2,...
                    'ButtonDownFcn',@(src, evevnt) grabMinMaxLine(src, this));
                this.minLine = xline(this.histAx, this.xMin, ...   
                    'LineWidth',2,...
                    'ButtonDownFcn',@(src, evevnt) grabMinMaxLine(src, this));
%             catch
%                 msgbox(sprintf('boundsLineが作成出来ませんでした\n'))
%                 return
%             end
            function grabMinMaxLine(src, ~)
                
                try
                    this.isMaxLine = (src == this.maxLine);
                    iptaddcallback(this.baseFig, ...
                        "WindowButtonMotionFcn", @(src, event)moveMinMaxLine(this));
                    iptaddcallback(this.baseFig, ...
                        "WindowButtonUpFcn", @(src, event)releaseMinMaxLine(this));
                    iptPointerManager(this.baseFig, "disable");
                catch
                end
        
                function moveMinMaxLine(~,~)
                    xpos = this.histAx.CurrentPoint(1,1);
                    
                    if this.isMaxLine
                        newXMin = this.minLine.Value;
                        newXMax = xpos;
                        [this.xMin, this.xMax] = this.validateXArea(newXMin, newXMax);
                        set(this.maxLine, 'Value', this.xMax)
                        notify(this, 'changeArea')
                    else
                        newXMin = xpos;
                        newXMax = this.maxLine.Value;
                        [this.xMin, this.xMax] = this.validateXArea(newXMin, newXMax);
                        set(this.minLine, 'Value', this.xMin)
                        notify(this, 'changeArea')
                    end
                    %update
                    
                    this.applyToneCurve();
                end
    
                function releaseMinMaxLine(~,~)
                    set(this.baseFig, "WindowButtonMotionFcn", "", "WindowButtonUpFcn", "")
                end
            end
        end

        function validated = validateThreshold(this, xpos)
            validated = min(this.xMax, xpos);
            validated = max(this.xMin, validated);
        end

        
        function [xMin, xMax] = validateXArea(this, newXMin, newXMax)
                xMin = newXMin;
                xMax = newXMax;
%                 validateMin = max(newXMin, this.baseXrange(1));
%                 validateMax = min(newXMax, this.baseXrange(2));
%                 
%                 if this.dataisdouble
%                 end


%                 validateMin = max(newMin, this.xMin);
%                 validateMax = min(newMax, this.xMax);
% 
%                 if validateMax <= validateMin
%                     
%                 end
% 
%                 xMin = validateMin;
%                 xMax = validateMax;
        end
    end
end