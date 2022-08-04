classdef binaryMaskHistogrammer < scripts.measureTools.nobinHistogrammer
    %閾値差分処理をするプログラム
    %   詳細説明をここに記述
    events
        changeThreshold
    end

    properties(Access = public)
        threshold = []
    end

    methods (Access = public)
        function this = binaryMaskHistogrammer(constructParam)
            %   詳細説明をここに記述
            arguments
                constructParam.parent = []
                constructParam.baseFig = [] 
                constructParam.Position = []
            end
            this@scripts.measureTools.nobinHistogrammer( ...
                "parent", constructParam.parent, ...
                "baseFig", constructParam.baseFig, ...
                "Position",constructParam.Position)
        end

        function setData(this, array2D)
            setData@scripts.measureTools.nobinHistogrammer(this, array2D);
            if isempty(this.threshold)
                this.threshold = mean(this.histX);
            end
            createThresholdLine(this);
        end
    end

    properties(SetAccess=private, GetAccess=public)
        thresholdLine
    end

    methods(Access = private)
        function createThresholdLine(this)
            try
                if isempty(this.sourceArray)
                    error('ヒストグラムデータがセットされていません');
                end
    
                this.thresholdLine = xline(this.histAx, this.threshold, ...
                    'LineWidth', 2);
                set(this.histAx, "ButtonDownFcn", @(src, event) grabThreshLine(this));
            catch
                msgbox('thresholdLineが作成出来ませんでした\n')
                
                return
            end

            function grabThreshLine(this)
                iptaddcallback(this.baseFig, ...
                    "WindowButtonMotionFcn", @(src, event)moveThresholdLine(this));
                iptaddcallback(this.baseFig, ...
                    "WindowButtonUpFcn", @(src, event)releaseThresholdLine(this));

                function moveThresholdLine(this)
                    xpos = this.histAx.CurrentPoint(1,1);
                    newThresh = this.validateThreshold(xpos);
                    set(this.thresholdLine, "Value", newThresh);
                    this.threshold = newThresh;
                    notify(this, 'changeThreshold')
                end

                function releaseThresholdLine(this)
                    set(this.baseFig, "WindowButtonMotionFcn", "", "WindowButtonUpFcn", "")
                end

            end
            
        end

        function validated = validateThreshold(this, newValue)
            validated = max(this.baseXMin, min(this.baseXMax, newValue));
        end

    end
end