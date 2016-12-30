% Load two fuzzy versions of an original image
load cathe_1; X1 = X;
load cathe_2; X2 = X;

% Merge two images from wavelet decompositions at level 5
% using sym4 by taking the maximum of absolute value of the
% coefficients for both approximations and details
XFUS = wfusimg(X1,X2,'sym4',5,'max','max');

% Plot original and synthesized images
figure, imshow(X1,[]), axis square off, title('Catherine 1')
figure, imshow(X2,[]), axis square off, title('Catherine 2')
figure, imshow(XFUS,[]), axis square off, title('Synthesized image')