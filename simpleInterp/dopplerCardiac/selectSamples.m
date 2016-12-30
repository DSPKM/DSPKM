function [Xtrain,Ytrain,Xtest,Ytest] = selectSamples(I,Ntrain,typeSample)

switch typeSample
    case 'random'
        [Xtrain,Ytrain,Xtest,Ytest]=randomSelection(I,Ntrain);
    case 'edges'
        [Xtrain,Ytrain,Xtest,Ytest]=edgesSelection(I,Ntrain);
    case 'amplitude'
        [Xtrain,Ytrain,Xtest,Ytest]=amplitudeSelection(I,Ntrain);
    case 'gradient'
        [Xtrain,Ytrain,Xtest,Ytest]=seleccionGradiante(I,Ntrain);
    case 'secondDerivative'
        [Xtrain,Ytrain,Xtest,Ytest]=seleccionDerivada(I,Ntrain);
end


function [in_entrenamiento,out_entrenamiento,in_test,out_test]=randomSelection(...
          imagen,Num_muestras_entrenamiento)
dim_imagen=size(imagen);
longitud_imagen=dim_imagen(1)*dim_imagen(2);
posiciones = randperm(longitud_imagen);
pos_entrenamiento = posiciones(1:Num_muestras_entrenamiento);
[Cord_x_e,Cord_y_e] = ind2sub(size(imagen),pos_entrenamiento);
in_entrenamiento = [Cord_x_e; Cord_y_e];
out_entrenamiento = imagen(pos_entrenamiento);
pos_test = posiciones(Num_muestras_entrenamiento+1:end);
[Cord_x_t,Cord_y_t]=ind2sub(size(imagen),pos_test);
in_test=[Cord_x_t;Cord_y_t];
out_test=imagen(pos_test);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION PARA OBTENCION DE MUESTRAS BORDES    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [in_entrenamiento,out_entrenamiento,in_test,out_test]=edgesSelection(...
          imagen,Num_muestras_entrenamiento)
% Funcion de obtencion de muestras aplicando un filtro de bordes
dim_imagen=size(imagen);
longitud_imagen=dim_imagen(1)*dim_imagen(2);

% Sobel
VSobel = [1 0 -1;
          2 0 -2;
          1 0 -1];
HSobel = [1  2  1;
          0  0  0;
         -1 -2 -1];
% Se aplica un filtro de sobel vertical a la imagen
A = abs(filter2(VSobel,imagen));
minimo = min(min(A));
maximo = max(max(A));
imagen_VSobel = ((A - minimo)./(maximo-minimo)); % normalizacion
% Se aplica un filtro de sobel horizontal a la imagen
A = abs(filter2(HSobel,imagen));
minimo = min(min(A));
maximo = max(max(A));
imagen_HSobel = ((A - minimo)./(maximo-minimo)); % normalizacion
% Se aplica un threshold a la imagen
imagen_Threshold = im2bw(imagen,0.05);
% Se reduce la probabilidad de estos puntos de 1 a 0.25
imagen_Threshold = (1 - imagen_Threshold)*0.25;

% Se suman las im?genes
imagen_Final = (imagen_HSobel + imagen_VSobel + imagen_Threshold)/3;

M_Aleatoria = rand(size(imagen_Final));

% Genera un vector de posicion desordenado
posicionesO = randperm(longitud_imagen);

 muestrasE = 1;
 muestrasT = 1;
 for n=1: size(posicionesO,2)
     [i,j] = ind2sub(size(imagen),posicionesO(n));
     if imagen_Final(i,j) > M_Aleatoria(i,j)
         Coord_x_e(muestrasE) = j;
         Coord_y_e(muestrasE) = i;
         muestrasE = muestrasE+1;
     else
         Coord_x_t(muestrasT) = j;
         Coord_y_t(muestrasT) = i;
         muestrasT = muestrasT+1;
     end
 end
muestrasE = muestrasE -1;
muestrasT = muestrasT -1;
if muestrasE > Num_muestras_entrenamiento
   for k=(Num_muestras_entrenamiento+1):muestrasE
       muestrasT = muestrasT+1;
       Coord_x_t(muestrasT) = Coord_x_e(k);
       Coord_y_t(muestrasT) = Coord_y_e(k);
   end
 else
    for k=muestrasE:Num_muestras_entrenamiento
        Coord_x_e(k) = Coord_x_t(muestrasT-1);
        Coord_y_e(k) = Coord_y_t(muestrasT-1);
        muestrasT = muestrasT-1;
    end
 end

% Coordenadas de entrada y salida a la maquina para entrenamiento
for i=1:Num_muestras_entrenamiento;
  in_entrenamiento(1,i) = Coord_y_e(i);
  in_entrenamiento(2,i) = Coord_x_e(i);
end
pos_entrenamiento = sub2ind(size(imagen),in_entrenamiento(1,:),in_entrenamiento(2,:));
out_entrenamiento = imagen(pos_entrenamiento);

% Coordenadas de entrada y salida a la maquina para test
in_test=[Coord_y_t;Coord_x_t];
pos_test = sub2ind(size(imagen),in_test(1,:), in_test(2,:));
out_test = imagen(pos_test);

%Obtencion de la imagen de entrenamiento y test
imagen_entrenamiento = zeros(size(imagen));
imagen_entrenamiento(pos_entrenamiento) = out_entrenamiento;

imagen_test = zeros(size(imagen));
imagen_test(pos_test) = out_test;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION PARA OBTENCION DE MUESTRAS AMPLITUD  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function [in_entrenamiento,out_entrenamiento,in_test,out_test]=amplitudeSelection(...
           imagen,Num_muestras_entrenamiento)

%         randn('seed',0);
%         rand('seed',0);
       
dim_imagen=size(imagen);
longitud_imagen=dim_imagen(1)*dim_imagen(2);
       
miimagen = imagen;
x = miimagen(:);

[xx,ind] = sort(abs(x),'descend');

m = max(abs(x));
aux = zeros(Num_muestras_entrenamiento,1);
cont = 1;
while cont-1<Num_muestras_entrenamiento; 
    mirnd = 50*randn(1,1)+m;
    mevale = (mirnd>0) & (mirnd<m);
    if mevale
        [kk,indsel] = min(abs(mirnd-xx));
        indsel=find(abs(mirnd-xx)==kk);
        if length(indsel)>1
            vv = randperm(length(indsel));
            indsel = indsel(vv(1));
        end
        if not(any(aux==indsel))
            aux(cont) = (indsel);
            cont = cont+1;
        end
    end
end


aux=ind(aux);
pos_entrenamiento = aux;

% para el conjunto entrenamiento
[Cord_x_e,Cord_y_e] = ind2sub(size(imagen),aux);
in_entrenamiento = [Cord_x_e,Cord_y_e];
in_entrenamiento = in_entrenamiento';
out_entrenamiento = imagen(aux);
out_entrenamiento = out_entrenamiento';

% para el conjunto test
 auxtest = setdiff(1:prod(dim_imagen),aux);

[Cord_x_t,Cord_y_t]=ind2sub(size(imagen),auxtest);
in_test=[Cord_x_t;Cord_y_t];
out_test=imagen(auxtest);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION PARA OBTENCION DE MUESTRAS GRADIENTE  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function [in_entrenamiento,out_entrenamiento,in_test,out_test]=seleccionGradiante(...
           imagen,Num_muestras_entrenamiento)

       
dim_imagen=size(imagen);

longitud_imagen=dim_imagen(1)*dim_imagen(2);
       
miimagen = imagen;

%%OPERACIONES PARA GRADIANTE%%
[XmiimagenX, YmiimagenY] = gradient (miimagen);

%%ELEVAMOS TODOS LOS VALORES AL CUADRADO EN AMBAS MATRICES%%
XmiimagenX = XmiimagenX .^ (2);
YmiimagenY = YmiimagenY .^ (2);

%%SUMAMOS LAS MATRICES VALOR A VALOR%%
SumaGrdn = XmiimagenX + YmiimagenY;

%%HACEMOS LA RAIZ DE LOS VALORES QUE HAY EN LA MATRIZ SUMA%%
Grad = SumaGrdn .^ (0.5);

%%COLOCA TODO EN UNA COLUMNA%%
x = Grad(:);

%%ORDENA LOS VALORES%%
[xx,ind] = sort(abs(x),'descend');

m = max(abs(x));
disp(m)
aux = zeros(Num_muestras_entrenamiento,1);
cont = 1;
while cont-1<Num_muestras_entrenamiento; 
    mirnd = 50*randn(1,1)+m;
    mevale = (mirnd>0) & (mirnd<m);
    if mevale
        [kk,indsel] = min(abs(mirnd-xx));
        indsel=find(abs(mirnd-xx)==kk);
        if length(indsel)>1
            vv = randperm(length(indsel));
            indsel = indsel(vv(1));
        end
        if not(any(aux==indsel))
            aux(cont) = (indsel);
            cont = cont+1;
        end
    end
end
aux=ind(aux);
pos_entrenamiento = aux;

% para el conjunto entrenamiento
[Cord_x_e,Cord_y_e] = ind2sub(size(imagen),aux);
in_entrenamiento = [Cord_x_e,Cord_y_e];
in_entrenamiento = in_entrenamiento';
out_entrenamiento = imagen(aux);
out_entrenamiento = out_entrenamiento';

% para el conjunto test
 auxtest = setdiff(1:prod(dim_imagen),aux);

[Cord_x_t,Cord_y_t]=ind2sub(size(imagen),auxtest);
in_test=[Cord_x_t;Cord_y_t];
out_test=imagen(auxtest);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION PARA OBTENCION DE MUESTRAS MEDIANTE LA SEGUNDA DERIVADA  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function [in_entrenamiento,out_entrenamiento,in_test,out_test]=seleccionDerivada(...
           imagen,Num_muestras_entrenamiento)

       
dim_imagen=size(imagen);

longitud_imagen=dim_imagen(1)*dim_imagen(2);
       
miimagen = imagen;


%%OPERACIONES PARA GRADIANTE%%

%%OBTENCION DE GRADIANTE EN HORIZONTAL Y VERTICAL%%
[XmiimagenX, YmiimagenY] = gradient (miimagen);

%%ELEVAMOS TODOS LOS VALORES AL CUADRADO EN AMBAS MATRICES%%
XmiimagenX = XmiimagenX .^ (2);
YmiimagenY = YmiimagenY .^ (2);

%%SUMAMOS LAS MATRICES VALOR A VALOR%%
SumaGrdn = XmiimagenX + YmiimagenY;

%%HACEMOS LA RAIZ DE LOS VALORES QUE HAY EN LA MATRIZ SUMA%%
Grad = SumaGrdn .^ (0.5);

%%OPERACIONES PARA EL SEGUNDO GRADIANTE%%

%%OBTENCION DE GRADIANTE EN HORIZONTAL Y VERTICAL%%
[XXmiimagen, YYmiimagen] = gradient (Grad);

%%ELEVAMOS TODOS LOS VALORES AL CUADRADO EN AMBAS MATRICES%%
XXmiimagen = XXmiimagen .^ (2);
YYmiimagen = YYmiimagen .^ (2);

%%SUMAMOS LAS MATRICES VALOR A VALOR%%
SumaGrdnGrdn = XXmiimagen + YYmiimagen;

%%HACEMOS LA RAIZ DE LOS VALORES QUE HAY EN LA MATRIZ SUMA%%
GradGrad = SumaGrdnGrdn .^ (0.5);

%%COLOCA TODO EN UNA COLUMNA%%
x = GradGrad(:);

%%ORDENA LOS VALORES%%
[xx,ind] = sort(abs(x),'descend');

m = max(abs(x));
disp(m)
aux = zeros(Num_muestras_entrenamiento,1);
cont = 1;
while cont-1<Num_muestras_entrenamiento; 
    mirnd = 50*randn(1,1)+m;
    mevale = (mirnd>0) & (mirnd<m);
    if mevale
        [kk,indsel] = min(abs(mirnd-xx));
        indsel=find(abs(mirnd-xx)==kk);
        if length(indsel)>1
            vv = randperm(length(indsel));
            indsel = indsel(vv(1));
        end
        if not(any(aux==indsel))
            aux(cont) = (indsel);
            cont = cont+1;
        end
    end
end
aux=ind(aux);
pos_entrenamiento = aux;

% para el conjunto entrenamiento
[Cord_x_e,Cord_y_e] = ind2sub(size(imagen),aux);
in_entrenamiento = [Cord_x_e,Cord_y_e];
in_entrenamiento = in_entrenamiento';
out_entrenamiento = imagen(aux);
out_entrenamiento = out_entrenamiento';

% para el conjunto test
 auxtest = setdiff(1:prod(dim_imagen),aux);

[Cord_x_t,Cord_y_t]=ind2sub(size(imagen),auxtest);
in_test=[Cord_x_t;Cord_y_t];
out_test=imagen(auxtest);

%Obtencion de la imagen de entrenamiento y test
imagen_entrenamiento = zeros(size(imagen));
imagen_entrenamiento(aux) = out_entrenamiento;

imagen_test = zeros(size(imagen));
imagen_test(auxtest) = out_test;

