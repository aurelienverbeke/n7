import jakarta.ws.rs.GET;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.Path;

@Path("/")
public interface ServiceInterface {
  @GET
  @Path("/getstudent")
  @Produces({"application/json"})
  public Student getStudent(@QueryParam("firstname") String firstName, @QueryParam("lastname") String lastName);

  @GET
  @Path("/getrecord")
  @Produces({"application/json"})
  public Record getRecord(@QueryParam("ine") String ine);
}
