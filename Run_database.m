% HAC code for fast and accurate eye center localization
close all
clc
clear

options.dataset = 0 %(0,1) -- bioid, gi4e, talkface
options.write_result = 0; %save the localization result
options.display = 1; %1 show the localization result

switch options.dataset
    case 0
        load('BioID_label.mat')
        BioIDpath = 'D:\dataset\BioID\';
        filepath = BioIDpath;
        framenumber = BioID.number;
        filename = BioID.filename;
        label = BioID.label;
        if(options.write_result)
            v = VideoWriter('BioID_dataset.mp4','MPEG-4');
            v.FrameRate = 10;
            open(v)
        end
    case 1
        load('GI4E_label.mat')
        GI4Epath = 'D:\dataset\gi4e_database\images\';
        filepath = GI4Epath;
        framenumber = GI4E.number;
        filename = GI4E.filename;
        label = GI4E.label;
        if(options.write_result)
            v = VideoWriter('GI4E_dataset.mp4','MPEG-4');
            v.FrameRate = 5;
            open(v)
        end
end

% the current version use the sdm for landmark localization
[Models,option] = xx_initialize;

error = zeros(framenumber,1);
count = zeros(11,1);
validface = 0;

for framei = 1:framenumber
    disp([num2str(framei) ', Processing ' filename{framei}])
    im = imread([filepath filename{framei}]);
    
    faces = Models.DM{1}.fd_h.detect(im,'MinNeighbors',option.min_neighbors,...
        'ScaleFactor',1.2,'MinSize',[50 50]);
    if(isempty(faces))
        error(framei) = 1000;
        continue;
    end
    
    facewidth = zeros(1,size(faces,2));
    for i = 1:size(faces,2)
        facewidth(i)=faces{i}(3); %face width
    end
    [~,maxfacei]= max(facewidth);
    output = xx_track_detect(Models,im,faces{maxfacei},option);
    
    if ~isempty(output.pred)
        validface = validface +1;
        X = output.pred';
        
        if(ndims(im)==3)
            image = rgb2gray(im);
        else
            image = im;
        end
        
%         tic
            eye = HAC_locate(X,image);
%         toc
        
        %error measure
        D = sqrt((label(framei,1)-label(framei,3))^2-(label(framei,2)-label(framei,4))^2);      
        DL = sqrt((eye(1) - label(framei,1))^2+(eye(2) - label(framei,2))^2);
        DR = sqrt((eye(4) - label(framei,3))^2+(eye(5) - label(framei,4))^2);
        if DL>DR
            hac_error = DL;
        else
            hac_error = DR;
        end
        hac_error = hac_error/D
       
        error(framei) = hac_error;
        
        for ej = 1:11
            if(error(framei) <= (ej-1)*0.025)
                count(ej)=count(ej)+1;
            end
        end
        
        if(options.display)
            
            imshow(im)
            if(options.write_result)
                set(gcf, 'Position', get(0,'Screensize'));
            end
            hold on
            
            plot(label(framei,1),label(framei,2),'g.','markersize',10);
            plot(label(framei,3),label(framei,4),'g.','markersize',10);
            plot(eye(1),eye(2),'r.','markersize',10);
            plot(eye(4),eye(5),'r.','markersize',10);   
            plot(X(1,:),X(2,:),'y.')
        
            hold off
            title(['e ' num2str(error(framei))])
            
            pause(0.02)
        end    
    else
        error(framei) = 1000; %means this frame is not considered due to invalid face detection or landmark localization result
    end

    if(options.write_result)
        text(10,10,['Error ' num2str(error(framei))],'Color','red')
        text(10,size(image,1)-20,['Green points are Backgound'],'Color','green')
        text(10,size(image,1)-40,['Red points are estimated by HAC'],'Color','Red')
        F = getframe;
        writeVideo(v,F.cdata);
    end
    
end

if(options.write_result)
    close(v)
end

count=count/validface


