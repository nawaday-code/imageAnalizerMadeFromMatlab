clc
dcmHandler = scripts.dicomHandler.DICOMHandler();
dcmHandler.readDICOMDIR();
[dcmInfo, dcmImg] = dcmHandler.getPreview();
dcmImgs = dcmHandler.readAllImage();
wl = dcmInfo.WindowCenter;
ww = dcmInfo.WindowWidth;
% imt = imtool3D(dcmImgs);



imtN = scripts.imtool3D.imtool3D_nawaMod("I",dcmImgs);
imtN.setWindowLevel(ww, wl)