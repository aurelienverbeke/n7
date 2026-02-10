<%
    Collection<Personne> personnes = (Collection<Personne>) request.getAttribute("lp");
%>
<%
    for (Personne p : personnes) {
        String s = p.getNom() + " " + p.getPrenom();
        out.println(s);
        for (Adresse a : p.getAdresses()) {
            out.println(a.getAdresse());
        }
    }
