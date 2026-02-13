package pack;

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
                response.sendRedirect("ajoutp.html");
                break;
            case "ajouta":
                String adresse = request.getParameter("adresse");
                f.ajoutAdresse(adresse);
                response.sendRedirect("ajouta.html");
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idPersonne = Integer.parseInt(request.getParameter("idP"));
        int idAdresse = Integer.parseInt(request.getParameter("idA"));

        f.associer(idPersonne, idAdresse);
        response.sendRedirect("Serv?op=associer");
    }
}