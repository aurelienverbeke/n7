% fonction generation_aleatoire_courbe (pour exercice_3.m)

function [y_inf,y_sup] = generation_aleatoire_courbe(x,moyennes,ecarts_types,beta_0,gamma_0)

d = (length(moyennes)+1)/2;

vect = vecteur_bernstein(x, d, 0);
y_inf = beta_0 * vect;
y_sup = gamma_0 * vect;

betas = randn(2*d-1).*ecarts_types + moyennes;

for k=1:d-1
    vect = vecteur_bernstein(x, d, k);
    y_inf = y_inf + betas(k)*vect;
    y_sup = y_sup + betas(k+d-1)*vect;
end

end
