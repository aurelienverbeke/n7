% Fonction parametres_correlation (exercice_1.m)

function [r,a,b] = parametres_correlation(Vd,Vg)

    xMoy = mean(Vd);
    yMoy = mean(Vg)

    sigmaXY = (1/length(Vd)) * sum(Vd.*Vg) - xMoy*yMoy;
    sigmaX2 = (1/length(Vd)) * sum(Vd.*Vd) - xMoy^2;
    sigmaY = sqrt((1/length(Vd)) * sum(Vd.*Vd) - xMoy^2);
    
    a = sigmaXY/sigmaX2;
    b = yMoy - a*xMoy;
    r = sigmaXY / (sqrt(sigmaX2) * sigmaY)
end