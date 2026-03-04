<%@ page language="java"  import="pack.*, java.util.*"  contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<a href="index.html">Retour</a><br>
<%
    Collection<Personne> personnes = (Collection<Personne>) request.getAttribute("lp");
%>
<%
    for (Personne p : personnes) {
        String s = p.getNom() + " " + p.getPrenom();
        out.println(s);
%>
        <ul>
<%
        for (Adresse a : p.getAdresses()) {
%>
        <li>
<%
            out.println(a.getAdresse());
%>
        </li>
<%
        }
%>
</ul>
<%
    }
%>