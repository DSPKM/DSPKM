function L = graph_Laplacian(n,faces)

% Firstly, the edges and their indices are obtained from the face matrix
edges = [faces(:,1) faces(:,2); faces(:,1) faces(:,3); 
		 faces(:,2) faces(:,3); faces(:,2) faces(:,1); 
    	 faces(:,3) faces(:,1); faces(:,3) faces(:,2)];     
indices = (edges(:,2)-1)*n + edges(:,1);

% Adjacency matrix
W = zeros(n,n);
W(indices) = 1;

% Degree matrix
D = diag(sum(W,2));

% Graph Laplacian 
L = D - W;