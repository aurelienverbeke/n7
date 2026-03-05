
package pack;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.QueryParam;
import javax.ws.rs.Produces;
import java.util.Collection;
import javax.ws.rs.Path;

@Path("/")
public interface Facade {
    @POST
    @Path("/ajouterpersonne")
    @Consumes("application/json")
    void ajoutPersonne(@QueryParam("nom") String nom, @QueryParam("prenom") String prenom);

    @POST
    @Path("/ajouteradresse")
    @Consumes("application/json")
    void ajoutAdresse(@QueryParam("adresse") String adresse);

    @GET
    @Path("/listerpersonnes")
    @Produces("application/json")
    Collection<Personne> listePersonnes();

    @GET
    @Path("/listeradresses")
    @Produces("application/json")
    Collection<Adresse> listeAdresses();

    @POST
    @Path("/associer")
    @Consumes("application/json")
    void associer(@QueryParam("idp") int idP, @QueryParam("ida") int idA);
}