package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int nb1 = Integer.parseInt(request.getParameter("nb1"));
        int nb2 = Integer.parseInt(request.getParameter("nb2"));

        // Etapes 3 et 4
        // response.getWriter().println("<html><body>La somme de " + nb1 + " et " + nb2 + " est " + (nb1 + nb2) + "</body></html>");

        // Etape 5
        request.setAttribute("resultat", nb1 + nb2);
        request.getRequestDispatcher("calc.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}