function [SD,MEAN,ROI,N,map,objdata,b_data2] = getSD(image,settings) 
% function [ROI] = getSD(image,settings) % デバッグ


% 設定値の取得
cfg = loc_getDefaultCfg;
try cfg.ROItype = settings.ROItype; catch;end;
try cfg.SliceRange = settings.SliceRange; catch;end;
try cfg.ROIsize = settings.ROIsize; catch;end;
try cfg.ROIoffset = -(settings.ROIoffset); catch;end;

% ROI中心からのmapを作る
l_roisize = cfg.ROIsize/2; % 直径→半径に変更
sz = size(image);
sz_hf = sz/2;
offset = cfg.ROIoffset;

i1 = linspace(-sz_hf(1),sz_hf(1),sz(1)) - offset(1);
i2 = linspace(-sz_hf(2),sz_hf(2),sz(2)) + offset(2);
[i1,i2] = meshgrid(i1,i2);
i1 = abs(i1);
i2 = abs(i2);

switch cfg.ROItype
    case 'circle'
        map = sqrt(i1.^2 + i2.^2);
    case 'square'
        map = max(i1,i2);
    case 'diamond'
        map = i1+i2;
end

% ROI作成
ROI = map<l_roisize;
ROI = repmat(ROI,[1,1,cfg.SliceRange]);
N = sum(ROI(:));

% ROIの適用
l_slicenter = ceil(sz(3)/2);
l_slirangeUP = ceil((cfg.SliceRange-1)/2);
l_slirangeDW = floor((cfg.SliceRange-1)/2);

slis = l_slicenter-l_slirangeDW : l_slicenter+l_slirangeUP ;
objdata = image(:,:,slis) .*ROI;

% いらない部分を消す
b_roi = ROI(:);
b_data = objdata(:);

ix = 1;
b_data2 = zeros(N,1);
for i0 = 1:(size(b_roi,1))
    if b_roi(i0,1)
        b_data2(ix,1) = b_data(i0,1);
        ix = ix+1;
    end
end

% 計算する
SD = std(b_data2);
MEAN = mean(b_data2);


function cfg = loc_getDefaultCfg
cfg.ROItype = 'circle';
cfg.ROIsize = 96;
cfg.ROIoffset = [0,0];
cfg.SliceRange = 15;


