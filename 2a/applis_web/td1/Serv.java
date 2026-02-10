package td1;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
    Facade f;
    
    public Serv() {
        super();
        f = new Facade();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String op = request.getParameter("op");
        
        switch (op) {
            case "ajoutp":
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                f.ajoutPersonne(nom, prenom);
                break;
            case "ajouta":
                String adresse = request.getParameter("adresse");
                f.ajoutAdresse(adresse);
                break;
            case "associer":
                request.setAttribute("lp", f.listePersonnes());
                request.setAttribute("la", f.listeAdresses());
                request.getRequestDispatcher("associer.jsp").forward(request, response);
                break;
            case "lister":
                request.setAttribute("lp", f.listePersonnes());
                request.setAttribute("la", f.listeAdresses());
                request.getRequestDispatcher("lister.jsp").forward(request, response);
                break;
        }
    }
}