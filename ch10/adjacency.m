function A = adjacency(DATA, TYPE, PARAM, DISTANCEFUNCTION);

% Compute the adjacency graph of the data set DATA
%
% A = adjacency(DATA, TYPE, PARAM, DISTANCEFUNCTION);
% 
% DATA - NxK matrix. Data points are rows. 
% TYPE - string 'nn' or string 'epsballs'.
% PARAM - integer if TYPE='nn', real number if TYPE='epsballs'.
% DISTANCEFUNCTION - function mapping a (DxM) and a (D x N) matrix
%                    to an M x N distance matrix (D:dimensionality)
% Returns: A, sparse symmetric NxN matrix of distances between the
% adjacent points. 
%
% Example: 
% 
% A = adjacency(X,'nn',6) 
%   A contains the adjacency matrix for the data
%   set X. For each point, the distances to 6 adjacent points are
%   stored. N
%
% Note: the adjacency relation is symmetrized, i.e. if
% point a is adjacent to point b, then point b is also considered to be
% adjacent to point a.
%
%
% Author: 
%
% Mikhail Belkin 
% misha@math.uchicago.edu
%
% Modified by: Vikas Sindhwani
% June 2004

%disp('Computing Adjacency Graph');

if (nargin < 3) | (strcmp(TYPE,'nn') & strcmp(TYPE,'epsballs')) | ~isreal(PARAM)
  
  disp(sprintf('ERROR: Too few arguments given or incorrect arguments.\n'));
  disp(sprintf('USAGE:\n A = laplacian(DATA, TYPE, PARAM)'));
  disp(sprintf('DATA - the data matrix. Data points are rows.'));
  disp(sprintf('Nearest neigbors: TYPE =''nn''    PARAM = number of nearest neigbors')); 
  disp(sprintf('Epsilon balls: TYPE =''epsballs''    PARAM = redius of the ball\n'));
  return;
end

n = size(DATA,1);
%disp (sprintf ('DATA: %d points in %d dimensional space.',n,size (DATA,2)));

switch TYPE
 case {'nn'}
 % disp(sprintf('Creating the adjacency matrix. Nearest neighbors, N=%d.', PARAM)); 
 case{'eps', 'epsballs'} 
  %disp(sprintf('Creating the adjacency matrix. Epsilon balls, eps=%f.', PARAM));
end;

%Matriz de adyacencias entre los puntos (todo ceros menos los conectados)  
A = sparse(n,n);
step = 100;


if (strcmp(TYPE,'nn'))   
  
  if n<PARAM+1, disp(['Pocas muestras para calcular la adjacency matrix con NN=',num2str(PARAM)]); PARAM=n-1, end
  for i1=1:step:n    
    i2 = i1+step-1;
    if (i2> n), i2=n; end;
    %analiza los datos en bloques de 100 en 100 (step puntos entre i1 e i2)
    XX= DATA(i1:i2,:);  
    
    %calcula las distancias de los 100 con todos los demas y devuelve una matriz simetrica
    %feval pq usa sus funciones('euclidean','cosine') Àson mas rapidas de verdad?
    %la verdad es que MATLAB solo tiene pdist que calcula todos con todos
    %los de una matriz pero no los de una matriz con los de otra 
    %Eso solo lo hace la de dist2() de NetLab y es muy parecida a estas
    dt = feval(DISTANCEFUNCTION, XX',DATA'); 
    %Ordena las distancias de todos los puntos a los puntos analizados
    [Z,I] = sort ( dt,2);
    
    %Solo guarda en A las distancias de los puntos que consideramos conectados en el grafo
    %en el caso de 'nn' solo guarda las de los NN puntos mas cercanos
    for i=i1:i2
      %if ( mod(i, 500) ==0), disp(sprintf('%d points processed.', i)); end;
      for j=2:PARAM+1
        A(i,I(i-i1+1,j))= Z(i-i1+1,j); 
        A(I(i-i1+1,j),i)= Z(i-i1+1,j); 
      end;    
    end
    
  
  end;

% epsilon balls
% Todo es igual, pero en lugar de guardar los NN puntos mas cercanos guarda
% solo los que esten mas cerca que una cierta distancia (bola de un radio)
else
  for i1=1:step:n
    i2 = i1+step-1;
  if (i2> n) 
        i2=n;
  end;
  
  XX= DATA(i1:i2,:);  
  dt = feval(DISTANCEFUNCTION, XX',DATA');
  [Z,I] = sort ( dt,2 );
  
  for i=i1:i2
  %  if ( mod(i, 500) ==0) disp(sprintf('%d points processed.', i)); end;
    j=2;
    while ( (Z(i-i1+1,j) < PARAM)) 
      j = j+1;
      jj = I(i-i1+1,j);
      A(i,jj)= Z(i-i1+1,j);
      A(jj,i)= Z(i-i1+1,j);
    end;    
  end

  end;

end;

 

