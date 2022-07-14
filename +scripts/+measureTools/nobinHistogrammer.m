%{
##########追加予定機能###########
・コントラスト自動調整のためのstretchClim ヒストグラムの上位と下位で指定%を求める機能。例えば上位下位１％
・validateXAreaの実装　xMin xMax の条件指定

#################################

############改善予定#############


#################################
%}




classdef nobinHistogrammer < handle
    properties(Access = public)
        sourceArray = []
        sourceCategoryArray = []
        histX %=categories(sourceArray)
        histY
        baseXrange = []
        xMin
        xMax
        threshold
%         selectX
%         select2D
        
        dataisdouble

        baseFig
        parent
    end

    events
        changeArea
        changeThreshold
    end

    methods(Access = public)
        function this = nobinHistogrammer(constractParam)
            arguments
                constractParam.parent = []
                %parentGObjが指定されていない場合はbaseFigは指定できないようにする。
                %Figureがわかっていてもparentがわからないとどこに埋め込むかわからないため。
                %引数の検証関数では実装が難しそうだったので実行部に実装。
                constractParam.baseFig = [] 
                constractParam.Position = []
            end

            try
                
                %本当はswitch case で書きたかったが、ぱっと思いつかなかった
                if ~isempty(constractParam.parent) && ~isempty(constractParam.baseFig)
                    this.baseFig = constractParam.baseFig;
                    this.parent = constractParam.parent;
                elseif isempty(constractParam.parent) && isempty(constractParam.baseFig)
                    this.baseFig = figure();
                    this.parent = this.baseFig;
                elseif ~isempty(constractParam.parent) && isempty(constractParam.baseFig)
                    error(sprintf(['コンストラクタの引数指定が不正です。以下の不具合が考えられます。\n' ...
                        'parent のみを指定することはできません。']))
                elseif isempty(constractParam.parent) && ~isempty(constractParam.baseFig)
                    this.baseFig = constractParam.baseFig;
                    this.parent = this.baseFig;
                else
                    error('コンストラクタ引数に予期せぬ値が入っています');
                    
                end

                if isempty(constractParam.Position)
                    this.Position = [10,10,100,100];
                else
                    this.Position = constractParam.Position;
                end

            catch
                return
            end

            this.createEmptyHistAx(this.parent);
        end

        function setData(this, array2D)
            this.sourceArray = array2D;
            this.dataisdouble = isfloat(this.sourceArray);
            this.sourceCategoryArray = categorical(reshape(array2D, [1, numel(array2D)]));
            category = categories(this.sourceCategoryArray);
            this.histX = str2double(category);
            this.histY = reshape(countcats(this.sourceCategoryArray), [numel(category), 1]);

            %どういうわけか、boundsをつかうとうまくいかない
%             [this.xMin, this.xMax] = bounds(this.histX);
%             this.baseXrange = [min(this.histX), max(this.histX)];
            this.baseXrange(1) = min(this.histX);
            this.baseXrange(2) = max(this.histX);
            this.xMin = this.baseXrange(1);
            this.xMax = this.baseXrange(2);

            this.threshold = mean(this.histX);

            createHistogram(this);
%             createBoundsSetLine(this);
        end


        %xMin~xMax間のデータを返す
        %実装するならHistDataを返すようにするべき?
        %やめておいたほうがいいかも。配列の長さがかなり変化する
%         function areaXData = getSelectXArray(this)
%             if isempty(this.sourceArray)
%                 return
%             end
%             xCategoryData= this.histX;
%             this.selectX = xCategoryData( ...
%                 xCategoryData >= this.xMin & xCategoryData <= this.xMax);
%             areaXData = this.selectX;
%         end
% 
% %         function areaData = getSelect2DArray(this)
% %             
% %             this.select2D = this.sourceArray( ...
% %                 this.sourceArray >= this.xMin & this.sourceArray <= this.xMax);
% %             areaData = this.select2D;
% % 
% %         end

        function createThresholdLine(this)
%             try
                if isempty(this.sourceArray)
                    error('ヒストグラムデータがセットされていません');
                end
    
                this.thresholdLine = xline(this.histAx, this.threshold, ...
                    'LineWidth', 2);
%                     'ButtonDownFcn',@(src, event) grabThreshLine(src, this));
                set(this.histAx, "ButtonDownFcn", @(src, event) grabThreshLine(this));
%             catch
%                 msgbox('thresholdLineが作成出来ませんでした\n')
%                 
%                 return
%             end

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

        function createBoundsSetLine(this)
            try
                if isempty(this.sourceArray)
                    error('ヒストグラムデータがセットされていません');
                    
                end

            this.maxLine = xline(this.histAx, this.xMax, ...
                    'LineWidth',2,...
                    'ButtonDownFcn',@(src, evevnt) grabMinMaxLine(src, this));
            this.minLine = xline(this.histAx, this.xMin, ...   
                    'LineWidth',2,...
                    'ButtonDownFcn',@(src, evevnt) grabMinMaxLine(src, this));
            catch
                msgbox(sprintf('boundsLineが作成出来ませんでした\n'))
                return
            end
            function grabMinMaxLine(src, ~)
                
                try
                    this.isMaxLine = (src == this.maxLine);
                    iptaddcallback(this.baseFig, ...
                        "WindowButtonMotionFcn", @(src, event)moveMinMaxLine(this));
                    iptaddcallback(this.baseFig, ...
                        "WindowButtonUpFcn", @(src, event)releaseMinMaxLine(this));
                    iptPointerManager(this.baseFig, "disable");
                catch
%                     disp(this.baseFig)
%                     findobj('type', 'figure')
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
                    
                end
    
                function releaseMinMaxLine(~,~)
                    set(this.baseFig, "WindowButtonMotionFcn", "", "WindowButtonUpFcn", "")
                end
            end
        end
    end

    properties(Access = private)
        Position
        histAx

        thresholdLine

        minLine
        maxLine
        isMaxLine = false
        

    end

    methods(Access = private)

        function createEmptyHistAx(this, parentGObj)
            this.histAx = uiaxes(parentGObj, 'Position',[this.Position(1),this.Position(2),this.Position(3),this.Position(4)]);
            set(this.histAx, "ButtonDownFcn", "");
        end

        function createHistogram(this)
            bar(this.histAx, this.histX, this.histY)
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