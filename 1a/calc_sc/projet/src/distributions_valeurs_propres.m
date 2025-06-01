close all;
clear all;

n = 100;

figure;

for imat = 1:4
    [A, D, info] = matgen_csad(imat, n);
    
    subplot(2, 2, imat);
    plot(1:n, D, ".");
    title(['Type ', num2str(imat)]);
    xlabel('Indice');
    ylabel('Valeur propre');
end

saveas(gcf, "distributions.png")