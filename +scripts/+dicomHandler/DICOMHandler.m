%{
handle classにすることが超重要
他言語でいうclassがmatlabでは handle class すなわち参照渡しであるということ
他言語でいうstructがmatlabでは class すなわち値渡しであるということ
matlabのstructはデータ型のこと

handle class にしないとインスタンス化したpropatyの値が更新されない
もしclassで作成すると、インスタンスには値そのものが保持される
しかしながらmethodによるpropatyの更新は値の参照を変更している
%}
classdef DICOMHandler < handle
    
    properties (SetAccess = public)
        dcmdirDirectory
        dcmdirPath
        dcmPaths 
        dcmFileNum
%         dcmInfoCells = {} %データベースとして外部保存しておくのがいいかもしれない
%         imageCells = {}
        dcmInfoBook = [];
        image3D = [];
    end

    methods (Access = public)
        

        function this = DICOMHandler(~)
            try
                if nargin == 0
                    %%%%%%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%%%%%%%%%
                    %現在はDICOMDIRファイルにしか対応していません
                    [fileName,dcmdir] = uigetfile({'*.*'});
                    dicomdirPath = strcat(dcmdir, fileName);
                    if strcmp(fileName, 'DICOMDIR') || strcmp(filename, 'dicomdir')
                        this.dcmdirDirectory = dcmdir;
                        this.dcmdirPath = dicomdirPath;
                    end
                end
                %コンストラクタに引数がある場合を後々実装
            catch
                return
            end
        end

        
        function selectedFilePaths = readDICOMDIR(this)
            if isempty(this.dcmdirPath)
                return
            end

            %%%%%%%%%%%%%%%%%%%%%%%% GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%
            dcmSelectWindow = uifigure('Name', 'DICOMDIR Reader', ...
                                       'Position', [360, 180, 700, 400]);
        
            root = uitree(dcmSelectWindow, 'checkbox', ...
                                           'Position', [10, 30, 350, 350], ...
                                           'CheckedNodesChangedFcn',@(src, event) selectFiles(src, event));
        
            preview = uiimage(dcmSelectWindow,'Position',[400, 130, 250, 250], ...
                                              'Enable','off');
        
            decide = uibutton(dcmSelectWindow, 'Text','ReadDICOM', ...
                                               'Position',[425, 50, 200, 50],...
                                               'Enable','off',...
                                               'ButtonPushedFcn',@(btn, event) sendDecideFiles(btn, event));
        
            %%%%%%%%%%%%%%%%%%%%% Make Tree %%%%%%%%%%%%%%%%%%%%%%%%
            %Patientsが複数の場合動作しない恐れがあります。
            %複数PatientsのDICOMDIRで検証する必要あり。

            rawDcmdir = images.dicom.parseDICOMDIR(this.dcmdirPath);
        
            patientField = rawDcmdir.Patients;
            patientNode = uitreenode(root, ...
                'Text', strcat('PatientName:',patientField.Payload.PatientName), ...
                'NodeData',patientField.Payload.DirectoryRecordType);
            
            studyNum = size(patientField);
        
            for i = 1:studyNum(2)
                studyField = patientField(i).Studies;
                studyNode = uitreenode(patientNode, ...
                    'Text', strcat('StudyDate:',studyField.Payload.StudyDate), ...
                    'NodeData',studyField.Payload.DirectoryRecordType);
        
                seriesNum = size(studyField.Series);
        
                for j = 1:seriesNum(2)
                    seriesField = studyField.Series(j);
                    seriesNode = uitreenode(studyNode, ...
                        'Text', strcat('SeriesDescription:', seriesField.Payload.SeriesDescription), ...
                        'NodeData',seriesField.Payload.DirectoryRecordType);
        
                    imageNum = size(seriesField.Images);
                    
                    for k = 1:imageNum(2)
                        imageField = seriesField.Images(k);
                       %imageNode = 
                        uitreenode(seriesNode, ...
                            'Text', imageField.Payload.ReferencedFileID, ...
                            'NodeData', imageField.Payload.DirectoryRecordType);
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%% Call Back %%%%%%%%%%%%%%%%%%%%%%%%
        
            function selectFiles(~, event)
                try
                    selectedNodes = struct();
                    nodes = event.CheckedNodes;
                    if ~isempty(nodes)
                        nodesNum = length(nodes);
                        page = 1;
                        for l = 1:nodesNum
                            if strcmp(nodes(l).NodeData, 'IMAGE')
                                selectedNodes.(strcat('page', string(page)))= strcat(this.dcmdirDirectory, nodes(l).Text);
                                page = page + 1;
                            end
                        end
        
                        pages = fieldnames(selectedNodes);
                        pageNum = length(pages);
                        this.dcmPaths = string(zeros(1, pageNum));
                        for m = 1:pageNum
                            this.dcmPaths(m) = selectedNodes.(pages{m});
                        end
        
                        preview.Enable = true;
                        previewDcm = imadjust(rescale(dicomread(this.dcmPaths(1))));
                        preview.ImageSource = cat(3, previewDcm, previewDcm, previewDcm);
                        drawnow;
        
                        decide.Enable = true;
                    end
                    
                    
                catch
                    %DICOMファイルが選ばれていない等の警告ダイアログ
                    return
                end
                
            end
        
            function sendDecideFiles(~, ~)
                selectedFilePaths = this.dcmPaths;
                this.dcmFileNum = length(this.dcmPaths);
                close(dcmSelectWindow);
            end

            %ウィンドウが閉じられるまで値を返さない
            waitfor(dcmSelectWindow);
        end

        function [dcmInfoPreview, dcmImgPreview] = getPreview(this)
            dcmInfoPreview = dicominfo(this.dcmPaths(1));
            dcmImgPreview = scripts.dicomHandler.scaling(dcmInfoPreview);
        end
        
        function dcminfos = readAllDcmInfo(this)
            paths = this.dcmPaths;
            parfor (i = 1:this.dcmFileNum)% M=〇でスレッド数を設定できる
                dcminfos(:,:,i)= dicominfo(paths(i));
            end
%             this.dcmInfoCells = dcminfos;
            this.dcmInfoBook = dcminfos;
        end
        
        function imgs = readAllImage(this)
%             if isempty(this.dcmInfoCells)
%                 readAllDcmInfo(this);
%             end
%             infoCells = this.dcmInfoCells;
%             parfor (i = 1:this.dcmFileNum)
%                 imgs{i} = scripts.dicomHandler.scaling(infoCells{i});
%             end
%             this.imageCells = imgs;

            if isempty(this.dcmInfoBook)
                readAllDcmInfo(this);
            end
            infoBook = this.dcmInfoBook;
            parfor (i = 1:this.dcmFileNum)
                imgs(:,:,i) = scripts.dicomHandler.scaling(infoBook(:,:,i));
            end
            this.image3D = imgs;
        end


    end
end