import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.UriBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;
import org.jboss.resteasy.client.jaxrs.internal.ResteasyClientBuilderImpl;

public class TestClient {

  /** The url of the students_server backend */
  public static final String url = "http://localhost:8080";

  private static final String studFirstname = "Alain";
  private static final String studName = "Tchana";

  public static void main(String[] args) {

    /*
    * You have to write a RESTEasy client that call the students_server REST API to
    * get the grade of a student in middleware
    *
    * You can create any file you think is missing
    */

    ResteasyClient client = new ResteasyClientBuilderImpl().build();
    ResteasyWebTarget target = client.target(UriBuilder.fromPath(url));
    ServiceInterface proxy = target.proxy(ServiceInterface.class);

    Student student = proxy.getStudent(studFirstname, studName);
    Record record = proxy.getRecord(student.getINE());


    System.out.println("middleware grade of " + studFirstname + " " + studName + " = " + record.getMiddleware());
  }
}
