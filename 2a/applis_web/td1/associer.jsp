<form method="get" action="Serv">
    <% 
        Collection<Personne> lp = (Collection<Personne>) request.getAttribute("lp");
        Collection<Adresse> la = (Collection<Adresse>) request.getAttribute("la");
    %>
    Choisissez une personne :
    <%
        for (Personne p : lp) {
            int id = p.getId();
            String s = p.getNom() + " " + p.getPrenom();
    %>
    <input type="radio" name="idP" value="<%= id %>"> <%= s %><br>
    <%
        }
    %>
        Choisissez une adresse :
    <%
        for (Adresse a : la) {
            int id = a.getId();
            String s = a.getAdresse();
    %>
    <input type="radio" name="idA" value="<%= id %>"> <%= s %><br>
    <%
        }
    %>
</form>