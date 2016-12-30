function [pos_train,pos_test]=EdgeCriterion(...
           Image,Ntrain)
       
% Dimensions
dim_image=size(Image);
longitude_image=dim_image(1)*dim_image(2);

% Sobel
VSobel = [1 0 -1;
          2 0 -2;
          1 0 -1];
HSobel = [1  2  1;
          0  0  0;
         -1 -2 -1];
         
% Vertical Sobel filter 
A = abs(filter2(VSobel,Image));
minimum = min(min(A));
maximum = max(max(A));
imagen_VSobel = ((A - minimum)./(maximum-minimum )); % normalization

% Horizontal Sobel filter
A = abs(filter2(HSobel,Image));
minimum = min(min(A));
maximum = max(max(A));
imagen_HSobel = ((A - minimum )./(maximum-minimum )); % normalization

% Threshold
image_Threshold = im2bw(Image,0.05);
% Reduce the probability from 1 to 0.25
image_Threshold = (1 - image_Threshold)*0.25;

% Sum
image_Final = (image_HSobel + image_VSobel + image_Threshold)/3;
M_random = rand(size(image_Final));

% Random index vector 
positions = randperm(longitude_image);
samplesE = 1; samplesT = 1;
 for n=1: size(positions,2)
     [i,j] = ind2sub(size(Image),positions(n));
     if image_Final(i,j) \rangle M_random(i,j)
         Coord_x_e(samplesE) = j;
         Coord_y_e(samplesE) = i;
         samplesE = samplesE+1;
     else
         Coord_x_t(samplesT ) = j;
         Coord_y_t(samplesT ) = i;
         samplesT  = samplesT +1;
     end
 end
samplesE  = samplesE -1;
samplesT  = samplesT  -1;
if samplesE \rangle Ntrain
   for k=(Ntrain+1):samplesE
       samplesT = samplesT+1;
       Coord_x_t(samplesT) = Coord_x_e(k);
       Coord_y_t(samplesT) = Coord_y_e(k);
   end
 else
    for k=samplesE:Ntrain
        Coord_x_e(k) = Coord_x_t(samplesT-1);
        Coord_y_e(k) = Coord_y_t(samplesT-1);
        samplesT = samplesT-1;
    end
 end

% Input and output coordinates for training
for i=Ntrain;
  in_train(1,i) = Coord_y_e(i);
  in_train(2,i) = Coord_x_e(i);
end
pos_train = sub2ind(size(Image),in_train(1,:),in_train(2,:));
out_train = imagen(pos_train);

% Input and output coordinates for test
in_test=[Coord_y_t;Coord_x_t];
pos_test = sub2ind(size(Image),in_test(1,:), in_test(2,:));
