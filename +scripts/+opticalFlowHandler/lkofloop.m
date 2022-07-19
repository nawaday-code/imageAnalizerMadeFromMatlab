%前後イメージを比較するためにlkopticalflowのz(定義ではp)にイテレーションしてるみたい
%mode = 'd'では1枚目を基準に比較　mode= 'v'では前後で比較
%もともとあったプログラムではmode=dで使ってる
%↑これってあってる？要確認
function [u,v] = lkofloop(Input_3D,mode)

    zsize= size(Input_3D, 3);
        parfor z = 1:round(zsize-1)
            
        %     z
            [u(:,:,z),v(:,:,z)] = scripts.opticalFlowHandler.lkopticalflow(Input_3D,z,mode);
            
        end

end