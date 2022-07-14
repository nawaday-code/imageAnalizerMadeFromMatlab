function ret = loc_getDCMdata(fullpath)
ret.tag = dicominfo(fullpath);
ret.image = double(dicomread(fullpath)); 