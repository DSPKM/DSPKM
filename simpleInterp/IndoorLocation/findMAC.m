function posicion = findMAC(MACs, in)

aux = strrep(in, ':', '');

if isempty(find(strcmpi(MACs,aux), 1)),
    posicion = 0;
else
    posicion = find(strcmpi(MACs,aux));
end