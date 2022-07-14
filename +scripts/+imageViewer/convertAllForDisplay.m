%namespace guiImageHandler
%依存：convertForDisplay
%クラスにしてもいいのだけれど、内容がGUIのImage表示用にしか働かないので汎用性がない
function dispCells = convertAllForDisplay(rawSignalImgCells)
    rawSignalImgNum = length(rawSignalImgCells);
    dispCells = cell(rawSignalImgNum, 1);
    parfor i = 1:rawSignalImgNum
        dispCells{i} = scripts.guiImageHandler.convertForDisplay(rawSignalImgCells{i});
    end
end