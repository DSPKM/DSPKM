function L = geometric_Laplacian(vertex,faces)

n = length(vertex);
L=zeros(n,n);

for i=1:n
    vi=vertex(i,:);
    
    % Search the faces which share the vertex vi
    ind_vi=[find(faces(:,1)==i); find(faces(:,2)==i); find(faces(:,3)==i)];
    faces_vi = faces(ind_vi,:);
    % vi neighborgs
    Ni=setdiff(faces_vi,i);
    
    % For each neighborg of vi
    for j=1:length(Ni)
        vj=vertex(Ni(j),:);
        % Search the two faces shared by the edge vi-vj
        ind_vj=[find(faces_vi(:,1)==Ni(j)); ...
        	find(faces_vi(:,2)==Ni(j)); find(faces_vi(:,3)==Ni(j))];
        % Search the third vertex in the face
        for k = 1: length(ind_vj)
            ind_vk=setdiff(faces_vi(ind_vj(k),:),[i Ni(j)]);
            % Compute the angle opposite to the edge vi-vj
            va = vi - vertex(ind_vk,:);
            vb = vj - vertex(ind_vk,:);
            % Angles alpha and beta
            opp_angle = acos(dot(va,vb)/(norm(va)*norm(vb))); 
            L(i,Ni(j))= L(i,Ni(j)) + cot(opp_angle);
            L(Ni(j),i)= L(Ni(j),i) + cot(opp_angle);
        end
        L(Ni(j),i) = L(Ni(j),i)/2;
        L(i,Ni(j)) = L(i,Ni(j))/2;
    end
end

L= diag(sum(L,2)) - L;