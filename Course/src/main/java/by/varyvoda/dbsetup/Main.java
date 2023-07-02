package by.varyvoda.dbsetup;

import org.apache.ibatis.jdbc.ScriptRunner;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

public class Main {

    private static final String root = "model/scripts/";

    private static final List<String> sequence =
        List.of(
            "cleanup/clear.sql",
            "creating/parameters/create_country.sql",
            "creating/parameters/create_region.sql",
            "creating/parameters/create_geo_location.sql",
            "creating/parameters/create_city.sql",
            "creating/parameters/create_interest.sql",
            "creating/parameters/create_locale.sql",
            "creating/parameters/create_marital_status.sql",
            "creating/parameters/create_programming_language.sql",
            "creating/parameters/create_sex.sql",
            "creating/create_person.sql",
            "creating/create_group.sql",
            "creating/create_objective.sql",
            "creating/create_favorite_solved.sql",
            "creating/create_achievements.sql",
            "creating/create_person_filter.sql",
            "views/person_view.sql",
            "views/city_view.sql",
            "functions/util_procedures.sql",
            "functions/person_functions.sql",
//            "granting/grant_admin_privileges.sql",
//            "granting/grant_person_privileges.sql",
            "trigger/person_trigger.sql",
            "fill/fill.sql"
        );

    public static void main(String[] args) throws SQLException, FileNotFoundException {
        String url = args[0];
        String username = args[1];
        String password = args[2];
        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            ScriptRunner scriptRunner = new ScriptRunner(connection);
            scriptRunner.setStopOnError(true);
            scriptRunner.setSendFullScript(true);
            for (String script : sequence) {
                String full = root + script;
                System.out.println(" \n\n-----------> Executing " + full + " <-----------\n\n ");
                scriptRunner.runScript(new FileReader(full));
            }
        }
    }
}
