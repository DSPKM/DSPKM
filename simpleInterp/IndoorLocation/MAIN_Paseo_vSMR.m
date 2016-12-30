% function prueba_tiempo_real()
addpath(genpath('functions'))

% PRUEBA LOCALIZACI?N EN TIEMPO REAL EN PASEO DE 2 MINUTOS
% Para respuesta a la revisi?n de Mayo de 2011

%% Par?metros de la simulaci?n
MACs = {'0020a659bae6',...
       '0020a65a3de9',...
       '0020a65a21ff'};
Naps = 3;

%% Cargamos los datos de entrenamiento
ent_file =  'EXP5_PORTATIL_xml.mat';
umbral = -89;
datos_ent = leeLocalizaciones_v2(-150, umbral, MACs, ent_file);
%Ordenamos los datos de entrenamiento seg?n su RSS
[datos_ent.RSS, datos_ent.Xcoord, datos_ent.Ycoord] = ordenarPorRSS(datos_ent.RSS,datos_ent.Xcoord,datos_ent.Ycoord);
    
%% Cargamos y generamos los datos de test
test_file = 'PASEO_2mins_PORTATIL_xml.mat';
umbral = -89;
datos_aux = leeLocalizaciones_v2(-150, umbral, MACs, test_file);
 
% Convertimos los datos instant?neos en datos promedio cada Nm medidas
Nm = 60; %Unos 6 segundos;
iv = [];
for n = 1:Naps,
    iv = [iv datos_aux.InstantValues{1}{n}];
end
 RSStest = zeros((size(iv,1)-1)/Nm, Naps);
for n = 1:(size(iv,1)-1)/Nm,
    RSStest(n,:) = median(iv((n-1)*Nm+1:n*Nm ,:));
end
datos_test.RSS = RSStest;
datos_test.Xcoord = zeros(size(RSStest,1),1);
datos_test.Ycoord = zeros(size(RSStest,1),1);

%Ordenamos los datos de entrenamiento seg?n su RSS
[datos_test.RSS, datos_test.Xcoord, datos_test.Ycoord] = ordenarPorRSS(datos_test.RSS,datos_test.Xcoord,datos_test.Ycoord);
loctest = datos_test.Xcoord + 1i * datos_test.Ycoord;
[datos_test.RSS, loctest, ~] = ordenarPorRSS(datos_test.RSS, loctest, zeros(size(loctest)));


%% Selecci?n de par?metros de los algoritmos
[paramsX, paramsY] = calcularParametrosSVMCorr_tiempo_real(datos_ent.RSS, datos_ent.Xcoord, datos_ent.Ycoord,...
                                                datos_test.RSS);                                            
                                            
%% Ejecuci?n de KNN
Kopt = 2;
for n = 1:size(RSStest,1),
     tic
     [xest_knn(n),yest_knn(n)] = mykNN(datos_ent.Xcoord, datos_ent.Ycoord, datos_ent.RSS, RSStest(n,:), Kopt);
     toc
end


My = max(datos_ent.Ycoord); %(Y(:,1));
Mx = max(datos_ent.Xcoord); %(Y(:,2));
% % Dibujamos el mapa
I = imread('Planta1.jpg');
II(:,:,1) = I(end:-1:1,end:-1:1,1)';
II(:,:,2) = I(end:-1:1,end:-1:1,2)';
II(:,:,3) = I(end:-1:1,end:-1:1,3)';
I = II;

imshow(I,'XData',[-.8 My+1.2+10.5],...
    'YData',[ Mx+1.6 -.8]);
hold on;
plot(yest_knn,xest_knn); axis on;

%% EJECUCI?N DE SVM-CORR

% N?cleos
% Hx.H_ent = calcularNucleoCorr3(datos_ent.RSS, datos_ent.RSS, paramsX.ac, paramsX.eje1, paramsX.eje2, paramsX.eje3);
% Hx.H_test = calcularNucleoCorr3(datos_ent.RSS, datos_test.RSS, paramsX.ac, paramsX.eje1, paramsX.eje2, paramsX.eje3);
% Hy.H_ent = calcularNucleoCorr3(datos_ent.RSS, datos_ent.RSS, paramsY.ac, paramsY.eje1, paramsY.eje2, paramsX.eje3);
% Hy.H_test = calcularNucleoCorr3(datos_ent.RSS, datos_test.RSS, paramsY.ac, paramsY.eje1, paramsY.eje2, paramsX.eje3);

% % Entrenamiento para Xcoord
% libsvm_options = ['-s 3 -t 4 -g ' num2str(paramsX.ggamma) ' -c ' num2str(paramsX.C) ' -p ' num2str(paramsX.epsilon) ' -j 1'];
% model = svmtrain(datos_ent.Xcoord, Hx.H_ent, libsvm_options);
% % Validacion para Xcoord
% xest = svmpredict(datos_test.Xcoord, Hx.H_test, model);
% 
% % Entrenamiento para Ycoord
% libsvm_options = ['-s 3 -t 4 -g ' num2str(paramsY.ggamma) ' -c ' num2str(paramsY.C) ' -p ' num2str(paramsY.epsilon) ' -j 1'];
% model = svmtrain(datos_ent.Ycoord, Hy.H_ent, libsvm_options);
% % Validacion para Ycoord
% yest = svmpredict(datos_test.Ycoord, Hy.H_test, model);

locent = datos_ent.Xcoord + 1i * datos_ent.Ycoord;
[datos_ent.RSS, locent, ~] = ordenarPorRSS(datos_ent.RSS, locent, zeros(size(locent)));
[ac, eje1, eje2, eje3] = calcularCorrelacion3D(datos_ent.RSS,locent, 2);
H.H_ent = calcularNucleoCorr3(datos_ent.RSS, datos_ent.RSS, ac, eje1, eje2, eje3);
H.H_test = calcularNucleoCorr3(datos_ent.RSS, datos_test.RSS, ac, eje1, eje2, eje3);

ceros_ent = zeros(size(H.H_ent));
ceros_test = zeros(size(H.H_test));
Hs.H_ent = [H.H_ent ceros_ent; ceros_ent H.H_ent];
Hs.H_test = [H.H_test ceros_test; ceros_test H.H_test];
%% Entrenamiento
params.ggamma=1e-1; params.epsilon=1e-6; params.C=100;
Yent = [real(locent); -imag(locent)];
libsvm_options = ['-s 3 -t 4 -g ' num2str(params.ggamma) ' -c ' num2str(params.C) ' -p ' num2str(params.epsilon) ' -j 1'];
model = svmtrain(Yent, Hs.H_ent, libsvm_options);

% Validacion
Ntest = size(datos_test.RSS,1);
Ypred = svmpredict(zeros(2*Ntest,1), Hs.H_test, model);
Ytestpred = Ypred(1:Ntest) - 1i*Ypred(Ntest+1:end);
xest = real(Ytestpred);
yest = imag(Ytestpred);

% Resultados
My = max(datos_ent.Ycoord); %(Y(:,1));
Mx = max(datos_ent.Xcoord); %(Y(:,2));
I = imread('floorPlan.jpg');
II(:,:,1) = I(end:-1:1,end:-1:1,1)';
II(:,:,2) = I(end:-1:1,end:-1:1,2)';
II(:,:,3) = I(end:-1:1,end:-1:1,3)';
I = II;

imshow(I,'XData',[-.8 My+1.2+10.5],...
    'YData',[ Mx+1.6 -.8]);
hold on;
plot(yest,xest,'-om')


%%
% Ntest = size(RSStest,1);
% H_ent = mysvrkernel_Rn('rbf', datos_ent.RSS, datos_ent.RSS, 1e1);
% H_test = mysvrkernel_Rn('rbf', datos_ent.RSS, datos_test.RSS, 1e1);
% ceros_ent = zeros(size(H_ent));
% ceros_test = zeros(size(H_test));
% H.H_ent = [H_ent ceros_ent; ceros_ent H_ent];
% H.H_test = [H_test ceros_test; ceros_test H_test];
% 
% % Entrenamiento
% Yent = [real(locent); -imag(locent)];
% libsvm_options = ['-s 3 -t 4 -g ' num2str(params.ggamma) ' -c ' num2str(params.C) ' -p ' num2str(params.epsilon) ' -j 1'];
% model = svmtrain(Yent, Xent, libsvm_options);
% 
% % Validacion
% Ypred = svmpredict(zeros(2*Ntest,1), Xtest, model);
% Ytestpred = Ypred(1:Ntest) - 1i*Ypred(Ntest+1:end);
% xest = real(Ytestpred);
% yest = imag(Ytestpred);
% 
% % Displaying map
% My = max(datos_ent.Ycoord); %(Y(:,1));
% Mx = max(datos_ent.Xcoord); %(Y(:,2));
% I = imread('Planta1.jpg');
% II(:,:,1) = I(end:-1:1,end:-1:1,1)';
% II(:,:,2) = I(end:-1:1,end:-1:1,2)';
% II(:,:,3) = I(end:-1:1,end:-1:1,3)';
% I = II;
% 
% figure
% imshow(I,'XData',[-.8 My+1.2+10.5],...
%     'YData',[ Mx+1.6 -.8]);
% hold on;
% plot(yest,xest,'-om')
