function autoDicomExport(datanames,savedir,settings)
% 
% 
% autoDicomExport(datanames,savedir,settings)
% 
% %%%%   ����   %%%% 
% datanames: �ۑ�����ϐ��� or �ϐ������X�g (char or cell) 
% settings�F �ۑ��̐ݒ�l�B���L�̃e���v���[�g���g�p�̂��ƁB
% savedir�F �ۑ��f�B���N�g���B���͂̂Ȃ��ꍇ��pwd�Ƀt�H���_�����܂��B
% 
% �E���͂����ϐ�������Ȃ�̐ݒ��DICOM�ɏ����o���܂��B
% �E1�ϐ� = 1series�Ƃ��ĕۑ�
% �Edatanames�������̏ꍇ�A������1study�Ƃ��ĕۑ�
% 
% %%%% settings �e���v���[�g %%%% 
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
% %%%% �t�H���_�쐬 �e���v���[�g %%%% 
% head = 'dir';
% savedir = datestr(now,'yyyy-mmdd-HHMM');
% savedir = strcat(head,'\',savedir,'-DICOM_export');
% mkdir(savedir);
% 
%       2014-0222 written by T.Saito
% 
% 
% 
% ��y�͂��Ώo����q�ł���B 
% �@�@�@�@����
% �@�@�@�i�L��֥�j
% �@�@ �Q|�@���^(�Q�Q_
% �@�^�@��-(�Q�Q�Q_�^
% �@�P�P�P�P�P�P�P
% �@���C�͂܂��Ȃ�
% 
% �@�@ ���܁^�R-�A�Q_
% �@�^��_/�Q�Q�Q�Q �^
% �@�P�P�P�P�P�P�P

disp('DICOM�����o����������...');


disp(' ��y�͂��Ώo����q�ł���B ');
dispneko(1);


www = waitbar(0,'DICOM�����o����������...','Name','autoDicomExport');
%% �����̃`�F�b�N
if iscell(datanames)
    indmax = numel(datanames);
elseif ischar(datanames)
    indmax = 1;
    datanames = cellstr(datanames);
else
    hoge = whos('datanames');
    hoge = hoge.class;
    error(strcat('datanames�ɂȂ񂩕ςȒl�������Ă܂�(�N���X�F',hoge,'�j'));
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

% window����
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



for hogehoge = 1:1 % �L���b�L���b�L���b �j���[�@�̂Ƃ��� (�܂������s�v�ȕ���)
T = 60/110; % �P���̒���(sec)
B = 4; % ���q
nyflag = (rand(1,1)>=0.9);
if nyflag
    nyaa = '(�v�E�ցE)�v���[�I';    
    T = 60/60; % �P���̒���(sec)
else
    nyaa = '(���f�ցf) �����';
end

mTime = T;
T_count = 0;
end

for hogehoge = 1:1  % ����DICOM�w�b�_�[�̐���

Info = InitiDicomInfo; % ����B
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

disp(' �@���C�͂܂��Ȃ�');
dispneko(2);


% fprintf('�ۑ��f�B���N�g���F%s\n',savedir);
% pause(1)

tic
for indx = 1:indmax
    tmpdataname = datanames{indx};
    hogestr = strrep(tmpdataname,'_',' ');
    savedata = abs(evalin('base',tmpdataname))*RRRR;
    N = size(savedata);
    fprintf('\nNo.%d : %s �������o����...\n',indx,tmpdataname);

    for hogehoge = 1:1 % DICOM�^�O�̕ҏW
    Info.SeriesTime = datestr(floor(now),'HHMMSS');
    Info.AcquisitionTime = datestr(floor(now),'HHMMSS');
    Info.SeriesDescription = tmpdataname;
    Info.SeriesNumber = indx;
    Info.AcquisitionNumber = indx;
    Info.InstanceNumber = indx;
    Info.SeriesID = indx ;% �C�ӁH
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
    for hogehoge = 1:1 % ����Ȃ�����(�N�\�l�~�\��)
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


        %% �������݁I
            dicomwrite(abs(savedata(:,:,n)),strcat(savedir,'\',sprintf('%s_%d',tmpdataname,n),'.dcm'),Info);

                    for hogehoge = 1:1 % �A�C���[�X�V(�s�v�j
    ttiimmee = toc;
    dTime = ttiimmee - mTime;

    if dTime > T; 
        mTime = ttiimmee;
        T_count = T_count+1;
        B_count = mod(T_count,B);
    if nyflag
        switch B_count
            case 0
                nyaa = '(�v�E�ցE)�v���[�I';
            case 1
                nyaa = ' (/�E�ցE)/�ɂ�[�I';
            case 2
                nyaa = '(�v�E�ցE)�v���[�I';
            case 3
                nyaa = ' (/�E�ցE)/�ɂ�[�I';
        end
    else 
        switch B_count
            case 0
                nyaa = '(���f�ցf) �����';
            case 1
                nyaa = '(�f�ցf��) �����';
            case 2
                nyaa = '(���f�ցf) �����';
            case 3
                nyaa = '( �f�ցf) �j���A';
        end
    end
    end
                    end
                    for hogehoge = 1:1 % waitbar�X�V
    waitbar(n/sz3,www,sprintf(...
        'Writing " %s " (x10^%d, %d/%d, rem %d)\n %s  %s'...
        ,hogestr,RRRRR,n,sz3,(indmax-indx+1),nyaa,nyaa...
        ));
                    end

        end
end

close(www)

if settings.viewMsgBox
 msgbox('DICOM�ւ̏����o�����I�����܂����B','autoDicomExport');
 disp('completed.')
else
 disp('DICOM�����o�������B');
end


function ret = InitiDicomInfo



ret.Format = 'DICOM';
ret.BitDepth = 16;
ret.ColorType = 'grayscale';
ret.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.4'; % 
ret.MediaStorageSOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
% ret.FileMetaInformationVersion = '�v���p';
% ret.TransferSyntaxUID = '1.2.840.10008.1.2.1'; % �G���f�B�A�����w��H���⑼�ɂ����낢�날��炵�����ǁB�l��'Implicit'
ret.mplementationClassUID =  '1.2.392.200036.9116.4.2.10'; % ����MRI��UID���ؗp�B�����炢�̈Ӗ��炵���BISO.�o�ώY�Ə�.���{�H�ƕW��������.���Ń��f�B�J���V�X�e���Y.(�x���_�[��`)
ret.ImplementationVersionName = 'TM_MR_DCM_V3.0'; % �s��
ret.ImageType = 'ORIGINAL\PRIMARY\GDC';
ret.InstanceCreatorUID = '1.2.392.200036.9116.4.2.7090';
ret.SOPClassUID = '1.2.840.10008.5.1.4.1.1.4';
ret.SOPInstanceUID = '1.2.392.200036.9116.4.2.7090.4096.1.2001.3';
ret.Modality = 'MR';
ret.Manufacturer = '*******'; % ����ǂ��Ȃ񂾂낤�ˁc
ret.InstitutionName = 'Tohoku University School of Medicine';
ret.ManufacturerModelName = '******';
ret.PatientBirthDate = '19000101'; % �{���͈Ⴂ�܂��B
ret.PatientSex = 'M';
ret.BodyPartExamined = 'HEAD'; % �Ƃ肠���������Œ�ŁB
ret.ScanningSequence = 'GR'; % �K�v�ɉ����ĉ���
ret.SequenceVariant = 'NONE';
ret.MRAcquisitionType = '3D';
ret.ImagingFrequency = 123.1975; % �v����
ret.MagneticFieldStrength = 3; % �v����
ret.DeviceSerialNumber = '7090'; % �ؗp
ret.SoftwareVersion = 'V2.21*R001'; % �ؗp
ret.ReceiveCoilName = 'Atlas Head'; % ���΂炭����ł������낤
ret.PatientPosition = 'HFS'; % ���΂炭����ł������낤
% Private_0019_100b: [258x1 uint8] % �Ȃ񂾂낤

function dispneko(f)
switch f
    case 1
disp(' �@�@�@�@����');
disp(' �@�@�@�i�L��֥�j');
disp(' �@�@ �Q|�@���^(�Q�Q_');
disp(' �@�^�@��-(�Q�Q�Q_�^');
disp(' �@�P�P�P�P�P�P�P');
    case 2
disp(' ');
disp(' �@�@ ���܁^�R-�A�Q_');
disp(' �@�^��_/�Q�Q�Q�Q �^');
disp(' �@�P�P�P�P�P�P�P');
end



