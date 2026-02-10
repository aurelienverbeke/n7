<body>
    <%
        Integer resultat = (Integer) request.getAttribute("resultat");
    %>
    <form method="get" action="Serv">
        nb1 : <input type="number" name="nb1"/><br/>
        nb2 : <input type="number" name="nb2"/><br/>
        <input type="submit" value="Calculer"/>
    </form>
    <p>Le r&eacute;sultat de l'addition est : <% if (resultat != null) { %><%= resultat %><% }%></p>
</body>