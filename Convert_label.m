% Convert the label of BioID to mat format
   
BioIDpath = 'D:\dataset\BioID\';
BioIDimages = dir('D:\dataset\BioID\*.pgm');

BioID.number = size(BioIDimages,1);
BioID.filename = cell(BioID.number,1);
for i = 1:BioID.number
    BioID.filename{i} = BioIDimages(i).name;
end

BioID.label = zeros(BioID.number,4);
for i = 1:BioID.number
fid = fopen([BioIDpath BioID.filename{i}(1:11) 'eye']);
tline = fgetl(fid);
ttime=fscanf(fid,'%d');
BioID.label(i,:) = ttime';
fclose(fid);
end

save BioID_label BioID

disp('done')