function fusionimg(Img,Ic)

Img = double(Img);
Ic = double(Ic);

% figure
% imagesc(Ic);
% colormap(jet);
% colorbar
% axis off

cmax = max(Ic(:));
cmin = min(Ic(:));

Ic = mat2gray(Ic,[min(Ic(:)) max(Ic(:))]);
Ic = double(Ic)*max(Img(:));

cmax = max(Ic(:));
cmin = min(Ic(:));

Img = -Img;
Img = (cmin+min(Img(:)))-Img;

If = Img;
If(Ic~=Ic(1,1)) = Ic(Ic~=Ic(1,1));
figure
imagesc(If)

map(:,1) = min(If(:)) : max(If(:));
map = abs(cmin-imresize(map,[64 1]));
map(:,2) = 1 : 64;

p = 32;

csize = 64-p+1;
gsize = 64-csize;

colormap gray
gmap = colormap;
gmap = imresize(gmap,[gsize 3]);

colormap jet
cmap = colormap;
cmap = imresize(cmap,[csize 3]);

fmap = vertcat(gmap,cmap);
fmap(fmap>1) = 1;
fmap(fmap<0) = 0;

colormap(fmap)
axis off
