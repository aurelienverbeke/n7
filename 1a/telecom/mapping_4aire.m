function symbole = mapping_4aire(bits)
    if bits == [0  0]
        symbole = -3;
    elseif bits == [0  1]
        symbole = -1;
    elseif bits == [1  0]
        symbole = 1;
    else
        symbole = 3;
    end
end

