% Fonction estim_param_F (exercice_1.m)

function [rho_F,theta_F,ecart_moyen] = estim_param_F(rho,theta)

    A = [cos(theta) sin(theta)];

    X = A\rho;

    rho_F = sqrt(X(1)*X(1)+X(2)*X(2));
    theta_F = atan2(X(2), X(1));

    ecart_moyen = sum(abs(A*X-rho)) / length(rho);
end