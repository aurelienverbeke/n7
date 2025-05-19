function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Newton(Hess_f_C14, beta0, option)
%************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/Newton_ref.m *
% Novembre 2020                                             *
% Université de Toulouse, INP-ENSEEIHT                      *
%************************************************************
%
% Newton r�sout par l'algorithme de Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in R^p
%
% Parametres en entrees
% --------------------
% Hess_f_C14 : fonction qui code la hessiennne de f
%              Hess_f_C14 : R^p --> matrice (p,p)
%              (la fonction retourne aussi le residu et la jacobienne)
% beta0  : point de départ
%          real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : nitimax, nombre d'itérations maximum
%             integer
%
% Parametres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta    : f(beta)
%             real
% res       : r(beta)
%             real(n)
% norm_delta : ||delta||
%              real
% nbit       : nombre d'itérations
%              integer
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

    [H_f, residu, J_residu] = Hess_f_C14(beta);
    max0 = max(option(2)*norm(transpose(J_residu)*residu), option(1));
    f_beta = 0.5*(norm(residu)^2);

    for nb_it = 1:option(3)
        ancien_beta = beta;
        f_ancien_beta = f_beta;

        jacobienneT = transpose(J_residu);
        beta = beta - H_f\(jacobienneT*residu);

        norm_delta = norm(beta - ancien_beta);
        norm_grad_f_beta = norm(jacobienneT*residu);

        [H_f, residu, J_residu] = Hess_f_C14(beta);
        f_beta = 0.5*(norm(residu)^2);

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
