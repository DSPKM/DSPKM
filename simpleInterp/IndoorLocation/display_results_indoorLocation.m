function solution_summary = display_results_indoorLocation(solution,conf)

% Initialize
algs=fields(solution);
Ytrain=solution.(algs{1})(end).Ytrain;
colors={'r','b'};
% Figure
%Ytrain = [real(Ytrain), imag(Ytrain)];
Mx = max(Ytrain(:,1));
My = max(Ytrain(:,2));
I = imread('floorPlan.jpg');
II(:,:,1) = I(end:-1:1,end:-1:1,1)';
II(:,:,2) = I(end:-1:1,end:-1:1,2)';
II(:,:,3) = I(end:-1:1,end:-1:1,3)';
I = II;
imshow(I,'XData',[-.8 My+1.2+10.5],...
    'YData',[ Mx+1.6 -.8]);
hold on;
for ia=1:length(algs)
    Ypred=solution.(algs{ia})(end).Ytestpred;
    plot(Ypred(:,2),Ypred(:,1)); axis on;
end
% Performance summary
solution_summary = results_summary(solution,conf);
