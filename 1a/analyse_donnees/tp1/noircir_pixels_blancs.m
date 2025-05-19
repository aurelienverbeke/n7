% function noircir_pixels_blancs (pour exercice_3.m)

function I_sans_blanc = noircir_pixels_blancs(I)
    
    R = double(I(:,:,1));
    V = double(I(:,:,2));
    B = double(I(:,:,3));

    I_sans_blanc = [R(:) V(:) B(:)];
    %indices_pixels_blancs = find(ismember(I_sans_blanc, [255 255 255], "rows"));
    indices_pixels_blancs = find(mean(I_sans_blanc, 2) >= 200);
    I_sans_blanc(indices_pixels_blancs, :) = zeros(size(indices_pixels_blancs, 1), 3);

    I_sans_blanc = reshape(I_sans_blanc, size(I, 1), size(I, 2), 3);
    
end
