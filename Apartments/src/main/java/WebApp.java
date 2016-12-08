/**
 * Created by michael on 08.12.16.
 */

import org.dalesbred.Database;
import org.postgresql.ds.PGPoolingDataSource;
import spark.Request;
import spark.Response;
import spark.Route;

import java.io.IOException;
import java.sql.SQLException;
import java.util.stream.Collectors;

import static spark.Spark.get;
import static spark.Spark.port;

public class WebApp {
    private static PGPoolingDataSource dataSource;

    private static void initDataSource() {
        dataSource = new PGPoolingDataSource();
        dataSource.setDataSourceName("[v]pIskA");
        dataSource.setServerName("localhost");
        dataSource.setDatabaseName("postgres");
        dataSource.setUser("postgres");
        dataSource.setPassword("foobar");
    }

    private static Object getAllApartments(Request req, Response resp) throws IOException, SQLException {
        final Database database = Database.forDataSource(dataSource);
        resp.type("text/plain");
        String readQuery = "SELECT  H.house_name AS name, C.name AS country, H.rooms_number AS roomsCnt,"
                + "H.beds_number AS bedsCnt, H.max_residents AS guestsCnt "
                + "FROM House H JOIN CountryFee C ON H.country_id = C.country_id;";
        return database.findAll(Apartment.class, readQuery).stream().map(Object::toString).collect(Collectors.joining("\n"));
    }

    private static Object newApartment(Request req, Response resp) throws IOException, SQLException {
        final Database database = Database.forDataSource(dataSource);
        Apartment apartment = new Apartment(
                req.queryMap("name").value(),
                Apartment.countryIdToStr(req.queryMap("country").value()),
                req.queryMap("rooms").integerValue(),
                req.queryMap("beds").integerValue(),
                req.queryMap("guests").integerValue()
        );
        boolean cascade = req.queryMap("cascade").booleanValue();
        try {
            database.withVoidTransaction(tx -> {
                String addCountryQuery = "INSERT INTO CountryFee (name, fee_percent) VALUES (?, 0) "
                        + "ON CONFLICT DO NOTHING;";
                String getCountryIdQuery = "SELECT country_id FROM CountryFee WHERE name = ?";
                String insertApartmentQuery =
                        "INSERT INTO House (country_id, house_name, rooms_number, beds_number, max_residents) " +
                                "VALUES (?, ?, ?, ?, ?);";
                if (cascade) {
                    database.update(addCountryQuery, apartment.country);
                }
                int id = database.findAll(Integer.class, getCountryIdQuery, apartment.country).get(0);
                database.update(insertApartmentQuery, id, apartment.name, apartment.roomsCnt, apartment.bedsCnt, apartment.guestsCnt);

            });
        } catch (IndexOutOfBoundsException iex) {
            iex.printStackTrace();
            resp.status(500);
            return "Transaction failed";
        }
        resp.redirect("/apartment/all");
        return null;
    }

    public static void main(String[] args) {
        port(8000);
        initDataSource();
        get("/apartment/all", WebApp.withTry(WebApp::getAllApartments));
        get("/apartment/new", WebApp.withTry(WebApp::newApartment));
    }

    private static Route withTry(Route route) {
        return (req, resp) -> {
            try {
                return route.handle(req, resp);
            } catch (Throwable e) {
                e.printStackTrace();
                resp.status(500);
                return e.getMessage();
            }
        };
    }
}