// Partie commune

public class Record {
    String INE;    String mathematics;    String middleware;    String networks;
    String systems;    String architecture;    String programming;

    public Record() {}

    public Record(String INE, String mathematics, String middleware, String networks,
                    String systems, String architecture, String programming) {
        super();
        this.INE = INE;
        this.mathematics = mathematics;
        this.middleware = middleware;
        this.networks = networks;
        this.systems = systems;
        this.architecture = architecture;
        this.programming = programming;
    }

    public String getINE() { return INE; }
    public void setINE(String INE) { this.INE = INE; }
    public String getMathematics() { return mathematics; }
    public void setMathematics(String mathematics) { this.mathematics = mathematics; }
    public String getMiddleware() { return middleware; }
    public void setMiddleware(String middleware) { this.middleware = middleware; }
    public String getNetworks() { return networks; }
    public void setNetworks(String networks) { this.networks = networks; }
    public String getSystems() { return systems; }
    public void setSystems(String systems) { this.systems = systems; }
    public String getArchitecture() { return architecture; }
    public void setArchitecture(String architecture) { this.architecture = architecture; }
    public String getProgramming() { return programming; }
    public void setProgramming(String programming) { this.programming = programming; }
}

public class Student {
    String INE;    String firstname;    String lastname;    String birthdate;
    String sex;    String address;    String city;    String zip;
    String country;    String phone;    String email;

    public Student() {}

    public Student(String INE, String firstname, String lastname,
            String birthdate, String sex, String address, String city,
            String zip, String country, String phone, String email) {
        super();
        this.INE = INE;
        this.firstname = firstname;
        this.lastname = lastname;
        this.birthdate = birthdate;
        this.sex = sex;
        this.address = address;
        this.city = city;
        this.zip = zip;
        this.country = country;
        this.phone = phone;
        this.email = email;
    }

    public String getINE() { return INE; }
    public void setINE(String INE) { this.INE = INE; }
    public String getFirstname() { return firstname; }
    public void setFirstname(String firstname) { this.firstname = firstname; }
    public String getLastname() { return lastname; }
    public void setLastname(String lastname) { this.lastname = lastname; }
    public String getBirthdate() { return birthdate; }
    public void setBirthdate(String birthdate) { this.birthdate = birthdate; }
    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getZip() { return zip; }
    public void setZip(String zip) { this.zip = zip; }
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

// Partie client

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.Path;

@Path("/")
public interface ServiceInterface {
    @GET
    @Path("/getstudent")
    @Produces({"application/json"})
    public Student getStudent(@QueryParam("firstname") String firstName,
                                @QueryParam("lastname") String lastName);

    @GET
    @Path("/getrecord")
    @Produces({"application/json"})
    public Record getRecord(@QueryParam("ine") String ine);
}

import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.UriBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyClient;
import org.jboss.resteasy.client.jaxrs.ResteasyClientBuilder;
import org.jboss.resteasy.client.jaxrs.ResteasyWebTarget;
import org.jboss.resteasy.client.jaxrs.internal.ResteasyClientBuilderImpl;

public class TestClient {
    public static final String url = "http://localhost:8080";
    private static final String studFirstname = "Alain";
    private static final String studName = "Tchana";

    public static void main(String[] args) {
        ResteasyClient client = new ResteasyClientBuilderImpl().build();
        ResteasyWebTarget target = client.target(UriBuilder.fromPath(url));
        ServiceInterface proxy = target.proxy(ServiceInterface.class);
        Student student = proxy.getStudent(studFirstname, studName);
        Record record = proxy.getRecord(student.getINE());
        System.out.println("middleware grade of " + studFirstname + " "
                            + studName + " = " + record.getMiddleware());
    }
}

// Partie serveur

package n7.students_server;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(StudentsServerApplication.class);
    }
}

package n7.students_server;
import java.util.Hashtable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StudentsController {
    static Hashtable<String, Student> students = new Hashtable<String, Student>();
    static Hashtable<String, Record> records = new Hashtable<String, Record>();

    static void addStudent(Student s) {
        students.put(s.getFirstname() + "-" + s.getLastname(), s);
    }

    static void addRecord(Record r) {
        records.put(r.getINE(), r);
    }

    @GetMapping("/getstudent")
    public Student getStudent(@RequestParam("firstname") String firstname,
                                @RequestParam("lastname") String lastname) {
        String key = firstname + "-" + lastname;
        System.out.println("access student: " + key);
        return students.get(key);
    }

    @GetMapping("/getrecord")
    public Record getRecord(@RequestParam("ine") String ine) {
        System.out.println("access record: " + ine);
        return records.get(ine);
    }

    // Static initializer : bloc run une seule fois avant que le main soit appelé
    static {
        addStudent(new Student(...));
        // Plusieurs addStudent ici avec des données fictives
        addRecord(new Record(...));
        // Plusieurs addRecord ici avec des données fictives
    }
}

package n7.students_server;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StudentsServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(StudentsServerApplication.class, args);
    }
}