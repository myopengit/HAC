% HAC code for live camera
close all
clc
clear

% for face alignment
[Models,option] = xx_initialize;
cap = cv.VideoCapture(0);
output.pred = [];

while true
    im = cap.read;
    output = xx_track_detect(Models,im,output.pred,option);
    
    if ~isempty(output.pred)
        X = output.pred';
        
        if(ndims(im)==3)
            image = rgb2gray(im);
        else
            image = im;
        end
        
        eye = HAC_locate(X,image);
        
        imshow(im)
        hold on
        plot(eye(1),eye(2),'r.');
        plot(eye(4),eye(5),'r.');
        plot(X(1,:),X(2,:),'g.')
        hold off
        pause(0.02)
            
    end   
end



