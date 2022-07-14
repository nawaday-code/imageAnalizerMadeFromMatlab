function dst = medfilt3(src)
    function dst = loc_pad(src, leng)
        dst = padarray(src, [leng leng leng], 'replicate', 'both');
    end

    dst = src * 0;
    width = 1;
    sz_src = size(src);
    padded = loc_pad(src, width);
    
    waithdl = waitbar(0,'now applying median filter...');
    for u =1:sz_src(1)
       wtbrmssg = sprintf('progress: %d / %d',u,sz_src(1));
       waitbar(u/sz_src(1),waithdl,wtbrmssg)

        for v =1:sz_src(2)
            for f =1:sz_src(3)
                a(1, 1) = u;
                a(1, 2) = u + width*2;
                a(2, 1) = v;
                a(2, 2) = v + width*2;
                a(3, 1) = f;
                a(3, 2) = f + width*2;
                
                buff = padded(a(1,1):a(1,2), a(2,1):a(2,2), a(3,1):a(3,2));
                buff = buff(:);
                dst(u, v, f) = median(buff);
            end
        end
    end
    
    close(waithdl)
    return
end
