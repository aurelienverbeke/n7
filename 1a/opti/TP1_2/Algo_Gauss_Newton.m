function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Gauss_Newton(residu, J_residu, beta0, option)
%*****************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/TP-ref/GN_ref.m   *
% Novembre 2020                                                  *
% Université de Toulouse, INP-ENSEEIHT                           *
%*****************************************************************
%
% GN resout par l'algorithme de Gauss-Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in \IR^p
%
% Paramètres en entrés
% --------------------
% residu : fonction qui code les résidus
%          r : \IR^p --> \IR^n
% J_residu : fonction qui code la matrice jacobienne
%            Jr : \IR^p --> real(n,p)
% beta0 : point de départ
%         real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : n_itmax, nombre d'itérations maximum
%             integer
%
% Paramètres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta : f(beta)
%          real
% r_beta : r(beta)
%          real(n)
% norm_delta : ||delta||
%              real
% nb_it : nombre d'itérations
%        integer
% exitflag   : indicateur de sortie
%              integer entre 1 et 4
% exitflag = 1 : ||gradient f(beta)|| < max(Tol_rel||gradient f(beta0)||,Tol_abs)
% exitflag = 2 : |f(beta^{k+1})-f(beta^k)| < max(Tol_rel|f(beta^k)|,Tol_abs)
% exitflag = 3 : ||delta)|| < max(Tol_rel delta^k),Tol_abs)
% exitflag = 4 : nombre maximum d'itérations atteint
%      
% ---------------------------------------------------------------------------------

% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    beta = beta0;
    exitflag = 4;

    max0 = max(option(2)*norm(transpose(J_residu(beta))*residu(beta)), option(1));
    
    f_beta = 0.5*(norm(residu(beta))^2);

    for nb_it = 1:option(3)
        ancien_beta = beta;
        f_ancien_beta = f_beta;

        jacobienne = J_residu(beta);
        jacobienneT = transpose(jacobienne);
        beta = beta - (jacobienneT*jacobienne)\(jacobienneT*residu(beta));

        norm_delta = norm(beta - ancien_beta);
        norm_grad_f_beta = norm(jacobienneT*residu(beta));
        f_beta = 0.5*(norm(residu(beta))^2);

        if norm_grad_f_beta <= max0
            exitflag = 1;
            break;
        end

        if abs(f_beta-f_ancien_beta) <= max(option(2)*abs(f_ancien_beta), option(1))
            exitflag = 2;
            break;
        end

        if norm_delta <= max(option(2)*norm(ancien_beta), option(1))
            exitflag = 3;
            break;
        end
    end
end
