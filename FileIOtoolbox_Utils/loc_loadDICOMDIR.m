function ret = loc_loadDICOMDIR(path)

try DirName = path;catch; DirName = uigetdir; end

DCMinfo = loc_getDCMinfofromdir(DirName);
ptinfo = DCMinfo.dcmPatient;

waithdl = waitbar(0,'now loading DICOM files...');
disp('now loading DICOM files...')
for indPT = 1:size(ptinfo,1) % Patientのループ
   crr_pt = ptinfo(indPT,1);
   ptname = crr_pt.PatientName;
    studynum = size(crr_pt.Study,1);
    fprintf('  Current Patient : %s\n',ptname);
    ret.Patient(indPT,1).PatientName = ptname;       
    
    for indSTD = 1:studynum % Studyのループ
       crr_std = crr_pt.Study(indSTD,1);
       stdname = crr_std.StudyDescription;
       seriesnum = size(crr_std.Series,1);
       fprintf('      > %s\n',stdname);
       ret.Patient(indPT,1).Study(indSTD,1).StudyDescription = stdname;     
       
       wtbrmssg = sprintf('loading: %s / %s / %s',ptname,stdname,'');
       waitbar(0/seriesnum,waithdl,wtbrmssg)
       
       for indSRS = 1:seriesnum % Seriesのループ
           crr_srs = crr_std.Series(indSRS,1);
           ImagePath = crr_srs.ImagePath;
           
           try
           crr_TOPimgname = crr_srs.ImageNames{1,1};
           crr_TOPimgpath = fullfile(path,ImagePath,crr_TOPimgname);
           try crr_imginfo = (dicominfo(crr_TOPimgpath)); crr_imginfo.states = 'Success'; catch; crr_imginfo.states = 'Not Found'; end
           srsname = crr_imginfo.SeriesDescription;           

           catch
           srsname = crr_srs.SeriesDescription;
           end
           
           
           if isempty(srsname); srsname = sprintf('No Name %d',indSRS);end;           
           imagenum = size(crr_srs.ImageNames,1);
           fprintf('        >> %s\n',srsname);
           ret.Patient(indPT,1).Study(indSTD,1).Series(indSRS,1).SeriesDescription = srsname;
       
           for indIMG = 1:imagenum
               wtbrmssg = sprintf('loading: %s / %s / %s / %d of %d slice',ptname,stdname,srsname,indIMG,imagenum);
               waitbar(indSRS/seriesnum,waithdl,wtbrmssg)
               crr_imgname = crr_srs.ImageNames{indIMG,1};
               crr_imgpath = fullfile(path,ImagePath,crr_imgname);
               try tmp_img = double(dicomread(crr_imgpath)); catch; tmp_img = tmp_img*0;end
               crr_imgdata(:,:,indIMG) = tmp_img; 
%                hogefun(tmp_img,100);
           end
           try crr_imginfo = (dicominfo(crr_imgpath)); crr_imginfo.states = 'Success'; catch; crr_imginfo.states = 'Not Found'; end
           
           ret.Patient(indPT,1).Study(indSTD,1).Series(indSRS,1).SeriesDescription = srsname;
           try  ret.Patient(indPT,1).Study(indSTD,1).Series(indSRS,1).ReconstructionDiameter = crr_imginfo.ReconstructionDiameter;
           catch;end;

           try  ret.Patient(indPT,1).Study(indSTD,1).Series(indSRS,1).DCMtags = crr_imginfo;
           catch;end;
           
           if exist('crr_imgdata','var')
           ret.Patient(indPT,1).Study(indSTD,1).Series(indSRS,1).Image = crr_imgdata;
           clear crr_imgdata
           end
       end
    end
end
close(waithdl);
disp('finished.')
