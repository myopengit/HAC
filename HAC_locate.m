function [eye] = HAC_locate(X,image)

        %right eye
        length_eye_right = sqrt((X(1,20)-X(1,23))^2 + (X(2,20)-X(2,23))^2);
        lengthr = floor(length_eye_right/2+0.5);
        sdmrighteyex = floor((X(1,20)+X(1,23))/2+0.5)-lengthr;
        sdmrighteyey = floor((X(2,20)+X(2,23))/2+0.5)-lengthr;
        right_width = lengthr*2;

        h1_right=sqrt((X(1,21)-X(1,25))^2 + (X(2,21)-X(2,25))^2);
        h2_right=sqrt((X(1,22)-X(1,24))^2 + (X(2,22)-X(2,24))^2);
        open_rate_right=(h1_right+h2_right)/(2*length_eye_right);

        %left eye
        length_eye_left = sqrt((X(1,26)-X(1,29))^2 + (X(2,26)-X(2,29))^2);
        lengthr = floor(length_eye_left/2+0.5);
        sdmlefteyex = floor((X(1,26)+X(1,29))/2+0.5)-lengthr;
        sdmlefteyey = floor((X(2,26)+X(2,29))/2+0.5)-lengthr;
        left_width = lengthr*2;

        h1_left=sqrt((X(1,27)-X(1,31))^2 + (X(2,27)-X(2,31))^2);
        h2_left=sqrt((X(1,28)-X(1,30))^2 + (X(2,28)-X(2,30))^2);
        open_rate_left=(h1_left+h2_left)/(2*length_eye_left);
    
        %display eye region
        %fprintf('right %f, left %f, \n',open_rate_right,open_rate_left);
             
        [eye leftmap9 leftmap10 leftmap11 leftmap12 lefteye ...
            rightmap9 rightmap10 rightmap11 rightmap12 righteye]= hw(X,image);
     
        %use the mean value of eye lids when the eye is closed
         if(open_rate_left < 0.08)
            eye(1) = (X(1,27)+X(1,28) + X(1,30)+X(1,31))/4;
            eye(2) = (X(2,27)+X(2,28) + X(2,30)+X(2,31))/4;
            eye(3) = 1;
         end
         if(open_rate_right < 0.08)
            eye(4) = (X(1,21)+X(1,22) + X(1,24)+X(1,25))/4;
            eye(5) = (X(2,21)+X(2,22) + X(2,24)+X(2,25))/4;
            eye(6) = 1;  
         end
          
%         leftmap_mat = cell(4,1);
%         rightmap_mat = cell(4,1);
%         leftmap_mat{1} = leftmap9;
%         leftmap_mat{2} = leftmap10;
%         leftmap_mat{3} = leftmap11;
%         leftmap_mat{4} = leftmap12;
%         rightmap_mat{1} = rightmap9;
%         rightmap_mat{2} = rightmap10;
%         rightmap_mat{3} = rightmap11;
%         rightmap_mat{4} = rightmap12;
%         
%         [maxleft(1),index_left(1)] = max(leftmap_mat{1}(:));
%         [maxleft(2),index_left(2)] = max(leftmap_mat{2}(:));
%         [maxleft(3),index_left(3)] = max(leftmap_mat{3}(:));
%         [maxleft(4),index_left(4)] = max(leftmap_mat{4}(:));
%         [~,maxlefti] = max(maxleft);
%         [maxleft_sort maxleft_sort_index]= sort(maxleft);  
%         [left_ci(1),left_cj(1)]=ind2sub([50,50],index_left(1));
%         [left_ci(2),left_cj(2)]=ind2sub([50,50],index_left(2));
%         [left_ci(3),left_cj(3)]=ind2sub([50,50],index_left(3));
%         [left_ci(4),left_cj(4)]=ind2sub([50,50],index_left(4));       
%         [left_maxi,left_maxj]=ind2sub([50,50],index_left(maxlefti));
%         
%         [maxright(1),index_right(1)] = max(rightmap_mat{1}(:));
%         [maxright(2),index_right(2)] = max(rightmap_mat{2}(:));
%         [maxright(3),index_right(3)] = max(rightmap_mat{3}(:));
%         [maxright(4),index_right(4)] = max(rightmap_mat{4}(:));
%         [~,maxrighti] = max(maxright);
%         [maxright_sort maxright_sort_index]= sort(maxright);  
%         [right_ci(1),right_cj(1)]=ind2sub([50,50],index_right(1));
%         [right_ci(2),right_cj(2)]=ind2sub([50,50],index_right(2));
%         [right_ci(3),right_cj(3)]=ind2sub([50,50],index_right(3));
%         [right_ci(4),right_cj(4)]=ind2sub([50,50],index_right(4));                  
%         [right_maxi,right_maxj]=ind2sub([50,50],index_right(maxrighti));
%           
%         %we normalize the eye patch to 50*50 size in the mex file
%         cido_eye(1) = round((left_maxj)*left_width/50)+sdmlefteyex;
%         cido_eye(2) = round((left_maxi)*left_width/50)+sdmlefteyey;
%         cido_eye(3) = round((maxlefti+9)*left_width/50);
%         cido_eye(4) = round((right_maxj)*right_width/50)+sdmrighteyex;
%         cido_eye(5) = round((right_maxi)*right_width/50)+sdmrighteyey;
%         cido_eye(6) = round((maxrighti+9)*right_width/50);  
%         eye=cido_eye;
end

