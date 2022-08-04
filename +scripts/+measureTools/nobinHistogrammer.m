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
        sourceShape = []

        histX 
        histY

        sortedIndex4source = []
        sourceValuePosition = []

        baseXMin = []
        baseXMax = []

        baseFig
        parent
    end



    methods(Access = public)
        function this = nobinHistogrammer(constructParam)
            arguments
                constructParam.parent = []
                %parentGObjが指定されていない場合はbaseFigは指定できないようにする。
                %Figureがわかっていてもparentがわからないとどこに埋め込むかわからないため。
                %引数の検証関数では実装が難しそうだったので実行部に実装。
                constructParam.baseFig = [] 
                constructParam.Position = []
            end

            try
                
                %本当はswitch case で書きたかったが、ぱっと思いつかなかった
                if ~isempty(constructParam.parent) && ~isempty(constructParam.baseFig)
                    this.baseFig = constructParam.baseFig;
                    this.parent = constructParam.parent;
                elseif isempty(constructParam.parent) && isempty(constructParam.baseFig)
                    this.baseFig = figure();
                    this.parent = this.baseFig;
                elseif ~isempty(constructParam.parent) && isempty(constructParam.baseFig)
                    error(sprintf(['コンストラクタの引数指定が不正です。以下の不具合が考えられます。\n' ...
                        'parent のみを指定することはできません。']))
                elseif isempty(constructParam.parent) && ~isempty(constructParam.baseFig)
                    this.baseFig = constructParam.baseFig;
                    this.parent = this.baseFig;
                else
                    error('コンストラクタ引数に予期せぬ値が入っています');
                    
                end

                if isempty(constructParam.Position)
                    this.Position = [10,10,100,100];
                else
                    this.Position = constructParam.Position;
                end

            catch
                return
            end

            this.createEmptyHistAx(this.parent);
        end

        function setData(this, array2D)

            this.sourceArray = array2D;
            this.sourceShape = size(array2D);
            
            [this.histX, this.sortedIndex4source, this.sourceValuePosition] = unique(this.sourceArray);
            this.histY = accumarray(this.sourceValuePosition, 1);

            [this.baseXMin, this.baseXMax]= bounds(this.histX);

            createHistogram(this);

        end

    end

    properties(SetAccess = private, GetAccess = public)
        Position
        histAx

    end

    methods(Access = private)

        function createEmptyHistAx(this, parentGObj)
            this.histAx = uiaxes(parentGObj, 'Position',[this.Position(1),this.Position(2),this.Position(3),this.Position(4)]);
            set(this.histAx, "ButtonDownFcn", "");
        end

        function createHistogram(this)
            bar(this.histAx, this.histX, this.histY)
        end

    end
    
end