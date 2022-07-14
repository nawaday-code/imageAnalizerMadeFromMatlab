function autoDicomExport(datanames,savedir,settings)
% 
% 
% autoDicomExport(datanames,savedir,settings)
% 
% %%%%   説明   %%%% 
% datanames: 保存する変数名 or 変数名リスト (char or cell) 
% settings： 保存の設定値。下記のテンプレートを使用のこと。
% savedir： 保存ディレクトリ。入力のない場合はpwdにフォルダを作ります。
% 
% ・入力した変数をそれなりの設定でDICOMに書き出します。
% ・1変数 = 1seriesとして保存
% ・datanamesが複数の場合、それらを1studyとして保存
% 
% %%%% settings テンプレート %%%% 
% settings.StudyDescription = '******';
% settings.FamilyName = '******';
% settings.RepetitionTime = 99;
% settings.EchoTime = 9;
% settings.SequenceName = 'simulation';
% settings.SliceThickness = 1;
% settings.SpacingBetweenSlices = 1;
% settings.PatientID = '';
% settings.PatientBirthDate = '19000101';
% settings.PercentPhaseFieldOfView = 100;
% settings.NumberOfPhaseEncodingStep = 999999;
% settings.ProtocolName = '******';
% settings.StudyID = datestr(floor(now),'yyyy-mmdd-HHMM');
% settings.PixelSpacing = [1,1];
% settings.ManufacturerModelName = '********';
% settings.viewMsgBox = 1;
% settings.maximum = 300;
% 
% %%%% フォルダ作成 テンプレート %%%% 
% head = 'dir';
% savedir = datestr(now,'yyyy-mmdd-HHMM');
% savedir = strcat(head,'\',savedir,'-DICOM_export');
% mkdir(savedir);
% 
%       2014-0222 written by T.Saito
% 
% 
% 
% 吾輩はやれば出来る子である。 
% 　　　　∩∩
% 　　　（´･ω･）
% 　　 ＿|　⊃／(＿＿_
% 　／　└-(＿＿＿_／
% 　￣￣￣￣￣￣￣
% 　やる気はまだない
% 
% 　　 ⊂⌒／ヽ-、＿_
% 　／⊂_/＿＿＿＿ ／
% 　￣￣￣￣￣￣￣

disp('DICOM書き出しを準備中...');


disp(' 吾輩はやれば出来る子である。 ');
dispneko(1);


www = waitbar(0,'DICOM書き出しを準備中...','Name','autoDicomExport');
%% 引数のチェック
if iscell(datanames)
    indmax = numel(datanames);
elseif ischar(datanames)
    indmax = 1;
    datanames = cellstr(datanames);
else
    hoge = whos('datanames');
    hoge = hoge.class;
    error(strcat('datanamesになんか変な値が入ってます(クラス：',hoge,'）'));
end

if nargin < 3
% default settings  
settings.StudyDescription = '******';
settings.FamilyName = '******';
settings.RepetitionTime = 99;
settings.EchoTime = 9;
settings.SequenceName = 'simulation';
settings.SliceThickness = 1;
settings.SpacingBetweenSlices = 1;
settings.PatientID = '';
settings.PatientBirthDate = '19000101';
settings.PercentPhaseFieldOfView = 100;
settings.NumberOfPhaseEncodingStep = 999999;
settings.ProtocolName = '******';
settings.StudyID = datestr(floor(now),'yyyy-mmdd-HHMM');
settings.PixelSpacing = [1,1];
settings.ManufacturerModelName = '********';
settings.viewMsgBox = 1;

end
if nargin <2
% default save directory  
hoge = datestr(now,'yyyy-mmdd-HHMM');
hogedir = strcat(hoge,'-DICOM_export');
mkdir(hogedir);
hogedir = strcat(pwd,'\',hogedir);
savedir = hogedir;
end

% window周り
savedata = evalin('base',datanames{1});

if not(isfield(settings,'maximum'));
settings.maximum = abs(max(savedata(:)));
end
if not(isfield(settings,'minimum'));
settings.minimum = abs(min(savedata(:)));
end

if not(isfield(settings,'flip4sliice'));
settings.flip4sliice = 0;
end

maximum = settings.maximum;
minimum = settings.minimum;
RRRR = floor(log10(65535/maximum));
RRRR = 10^RRRR;



for hogehoge = 1:1 % キュッキュッキュッ ニャー　のところ (まったく不要な部分)
T = 60/110; % １拍の長さ(sec)
B = 4; % 拍子
nyflag = (rand(1,1)>=0.9);
if nyflag
    nyaa = '(」・ω・)」うー！';    
    T = 60/60; % １拍の長さ(sec)
else
    nyaa = '(乂’ω’) きゅっ';
end

mTime = T;
T_count = 0;
end

for hogehoge = 1:1  % 共通DICOMヘッダーの生成

Info = InitiDicomInfo; % 自作。
Info.InstanceCreationDate = datestr(floor(now),'yyyymmdd');
Info.InstanceCreationTime = datestr(floor(now),'HHMMSS');
Info.StudyDate = datestr(floor(now),'yyyymmdd');
Info.SeriesDate = Info.StudyDate;
Info.AcquisitionDate = Info.StudyDate;
Info.StudyTime = datestr(floor(now),'HHMMSS');
% Info.AccessionNumber = strcat(datestr(now,'mmdd-HHMM'),sprintf('-x%d',RRRR));
RRRRR = round(log10(RRRR));
Info.AccessionNumber = strcat(datestr(now,'mmdd-HHMM'),sprintf('-x10^%d',RRRRR));
Info.StudyDescription = settings.StudyDescription;
Info.PatientName.FamilyName  = settings.FamilyName;
Info.RepetitionTime = settings.RepetitionTime;
Info.EchoTime = settings.EchoTime;
Info.SequenceName = settings.SequenceName;
Info.SliceThickness = settings.SliceThickness;
Info.SpacingBetweenSlices = settings.SpacingBetweenSlices;
Info.PatientID = settings.PatientID;
Info.PatientBirthDate = settings.PatientBirthDate;
Info.InPlanePhaseEncodingDirection = 'ROW';
Info.FlipAngle = 90;
Info.SAR = 0;
Info.ImageOrientationPatient = [1;0;0;0;1;0];
Info.PercentPhaseFieldOfView = settings.PercentPhaseFieldOfView;
Info.NumberOfPhaseEncodingSteps = settings.NumberOfPhaseEncodingStep;
Info.ReconstructionDiameter = 102.4;
Info.PixelBandwidth = 999;
Info.EchoNumber = 1;
Info.NumberOfAverages = 1;
Info.ProtocolName = settings.ProtocolName;
Info.StudyID = settings.StudyID;
Info.PixelSpacing = settings.PixelSpacing;
Info.ManufacturerModelName = settings.ManufacturerModelName;
% Info.StudyInstanceUID = '1.2.392.200036.9116.4.2.7090.1467.20131025083820238.2.35';
Info.StudyInstanceUID = dicomuid; % 
Info.SmallestImagePixelValue = minimum*RRRR;
Info.LargestImagePixelValue = maximum*RRRR;
minimum = Info.SmallestImagePixelValue;
maximum = Info.LargestImagePixelValue;
end

disp(' 　やる気はまだない');
dispneko(2);


% fprintf('保存ディレクトリ：%s\n',savedir);
% pause(1)

tic
for indx = 1:indmax
    tmpdataname = datanames{indx};
    hogestr = strrep(tmpdataname,'_',' ');
    savedata = abs(evalin('base',tmpdataname))*RRRR;
    N = size(savedata);
    fprintf('\nNo.%d : %s を書き出し中...\n',indx,tmpdataname);

    for hogehoge = 1:1 % DICOMタグの編集
    Info.SeriesTime = datestr(floor(now),'HHMMSS');
    Info.AcquisitionTime = datestr(floor(now),'HHMMSS');
    Info.SeriesDescription = tmpdataname;
    Info.SeriesNumber = indx;
    Info.AcquisitionNumber = indx;
    Info.InstanceNumber = indx;
    Info.SeriesID = indx ;% 任意？
    Info.StackID = indx;
    % Info.SeriesInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1002';
    Info.SeriesInstanceUID = dicomuid;

    Info.Rows = N(2);
    Info.Columns = N(1);

    %{
    Info.SmallestImagePixelValue = abs(min(savedata(:)));
    Info.LargestImagePixelValue = abs(max(savedata(:)));
    Info.SmallestImagePixelValue = minimum*RRRR;
    Info.LargestImagePixelValue = maximum*RRRR;
    minimum = Info.SmallestImagePixelValue;
    maximum = Info.LargestImagePixelValue;
    %}
    
    Info.RescaleSlope = (maximum-minimum);
    Info.RescaleIntercept = minimum;
    Info.RescaleType = 'normalized';
    Info.WindowCenter = (maximum+minimum)/2;
    Info.WindowWidth = maximum-minimum;

if settings.flip4sliice
    savedata = flipdim(uint16(abs(savedata)),3);
else
    savedata = uint16(abs(savedata));
end
    refuid = dicomuid;
    Info.FrameOfReferenceUID = refuid;        
    end
    for hogehoge = 1:1 % いらない部分(クソネミ表示)
    if rand(1,1) <= 0.2;
    dispneko(1);
    else
    dispneko(2);
    end
    end

    sz3 = size(savedata,3);
    
        for n = 1:sz3
            if n == 1
                Info.SOPinstanceUID = refuid;
            else     
                Info.SOPinstanceUID = dicomuid;        
            end
            Info.ImagePositionPatient = [0;0;Info.SpacingBetweenSlices * (n-1)];
            Info.SliceLocation = Info.SpacingBetweenSlices * (n-1);


        %% 書き込み！
            dicomwrite(abs(savedata(:,:,n)),strcat(savedir,'\',sprintf('%s_%d',tmpdataname,n),'.dcm'),Info);

                    for hogehoge = 1:1 % アイルー更新(不要）
    ttiimmee = toc;
    dTime = ttiimmee - mTime;

    if dTime > T; 
        mTime = ttiimmee;
        T_count = T_count+1;
        B_count = mod(T_count,B);
    if nyflag
        switch B_count
            case 0
                nyaa = '(」・ω・)」うー！';
            case 1
                nyaa = ' (/・ω・)/にゃー！';
            case 2
                nyaa = '(」・ω・)」うー！';
            case 3
                nyaa = ' (/・ω・)/にゃー！';
        end
    else 
        switch B_count
            case 0
                nyaa = '(乂’ω’) きゅっ';
            case 1
                nyaa = '(’ω’乂) きゅっ';
            case 2
                nyaa = '(乂’ω’) きゅっ';
            case 3
                nyaa = '( ’ω’) ニャア';
        end
    end
    end
                    end
                    for hogehoge = 1:1 % waitbar更新
    waitbar(n/sz3,www,sprintf(...
        'Writing " %s " (x10^%d, %d/%d, rem %d)\n %s  %s'...
        ,hogestr,RRRRR,n,sz3,(indmax-indx+1),nyaa,nyaa...
        ));
                    end

        end
end

close(www)

if settings.viewMsgBox
 msgbox('DICOMへの書き出しが終了しました。','autoDicomExport');
 disp('completed.')
else
 disp('DICOM書き出し完了。');
end


function ret = InitiDicomInfo



ret.Format = 'DICOM';
ret.BitDepth = 16;
ret.ColorType = 'grayscale';
ret.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.4'; % 
ret.MediaStorageSOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
% ret.FileMetaInformationVersion = '要引用';
% ret.TransferSyntaxUID = '1.2.840.10008.1.2.1'; % エンディアンを指定？いや他にもいろいろあるらしいけど。値は'Implicit'
ret.mplementationClassUID =  '1.2.392.200036.9116.4.2.10'; % 東芝MRIのUIDを借用。→くらいの意味らしい。ISO.経済産業省.日本工業標準調査会.東芝メディカルシステムズ.(ベンダー定義)
ret.ImplementationVersionName = 'TM_MR_DCM_V3.0'; % 不明
ret.ImageType = 'ORIGINAL\PRIMARY\GDC';
ret.InstanceCreatorUID = '1.2.392.200036.9116.4.2.7090';
ret.SOPClassUID = '1.2.840.10008.5.1.4.1.1.4';
ret.SOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
ret.Modality = 'MR';
ret.Manufacturer = '*******'; % これどうなんだろうね…
ret.InstitutionName = 'Tohoku University School of Medicine';
ret.ManufacturerModelName = '******';
ret.PatientBirthDate = '19000101'; % 本当は違います。
ret.PatientSex = 'M';
ret.BodyPartExamined = 'HEAD'; % とりあえず頭部固定で。
ret.ScanningSequence = 'GR'; % 必要に応じて改変
ret.SequenceVariant = 'NONE';
ret.MRAcquisitionType = '3D';
ret.ImagingFrequency = 123.1975; % 要改変
ret.MagneticFieldStrength = 3; % 要改変
ret.DeviceSerialNumber = '7090'; % 借用
ret.SoftwareVersion = 'V2.21*R001'; % 借用
ret.ReceiveCoilName = 'Atlas Head'; % しばらくこれでいいだろう
ret.PatientPosition = 'HFS'; % しばらくこれでいいだろう
% Private_0019_100b: [258x1 uint8] % なんだろう

function dispneko(f)
switch f
    case 1
disp(' 　　　　∩∩');
disp(' 　　　（´･ω･）');
disp(' 　　 ＿|　⊃／(＿＿_');
disp(' 　／　└-(＿＿＿_／');
disp(' 　￣￣￣￣￣￣￣');
    case 2
disp(' ');
disp(' 　　 ⊂⌒／ヽ-、＿_');
disp(' 　／⊂_/＿＿＿＿ ／');
disp(' 　￣￣￣￣￣￣￣');
end



