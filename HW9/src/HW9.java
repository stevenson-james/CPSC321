import java.io.FileInputStream;
import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

public class HW9 {

    public static void main(String[] args) {
        Scanner reader = new Scanner(System.in);
        try {
            Connection con = connectDatabase();
            boolean isContinuing = true;
            int menuIn;

            while (isContinuing) {
                displayMenu();
                menuIn = reader.nextInt();
                System.out.println();
                switch (menuIn) {
                    case 1:
                        //create and execute query
                        displayCountries(con);
                        break;
                    case 2:
                        addCountry(con, reader);
                        break;
                    case 3:
                        displayFromGdpAndInflation(con, reader);
                        break;
                    case 4:
                        updateCountry(con, reader);
                        break;
                    case 5:
                        isContinuing = false;
                        break;
                }
            }

            // release resources
            con.close();
        } catch(Exception err) {
            err.printStackTrace();
        }
    }

    public static Connection connectDatabase() throws Exception{
        // connection info
        Properties prop = new Properties();
        FileInputStream fileIn = new FileInputStream("resources/config.properties");
        prop.load(fileIn);
        fileIn.close();

        // connect to database
        String hst = prop.getProperty("host");
        String usr = prop.getProperty("user");
        String pwd = prop.getProperty("password");
        String dab = "cpsc321";
        String url = "jdbc:mysql://" + hst + "/" + dab;
        System.out.println(url);
        // load and register JDBC driver for MySQL
        return DriverManager.getConnection(url, usr, pwd);
    }

    public static void displayMenu(){
        System.out.println("1. List countries");
        System.out.println("2. Add country");
        System.out.println("3. Find countries based on gdp and inflation");
        System.out.println("4. Update country’s gdp and inflation");
        System.out.println("5. Exit");
        System.out.print("Enter your choice (1-5): ");
    }

    public static void displayCountries(Connection con) throws Exception{
        Statement stmt = con.createStatement();
        String q = "SELECT country_name, country_code FROM Country";
        ResultSet rs = stmt.executeQuery(q);

        // print results
        while(rs.next()) {
            String countryName = rs.getString("country_name");
            String countryCode = rs.getString("country_code");
            System.out.println(countryName + " (" +countryCode + ")");
        }
        System.out.println();

        //release resources
        rs.close();
        stmt.close();
    }

    public static boolean isAlreadyCountryCode(Connection con, String code) throws Exception{
        String q = "SELECT COUNT(*)FROM Country WHERE country_code = ?";
        PreparedStatement stmt = con.prepareStatement(q);
        stmt.setString(1, code);
        ResultSet rs = stmt.executeQuery();

        rs.next();
        int exists = rs.getInt(1);
        rs.close();
        stmt.close();
        if (exists == 0)
            return false;
        return true;
    }

    public static void addCountry (Connection con, Scanner reader) throws Exception{

        System.out.print("Country code................: ");
        String code = reader.next();
        System.out.print("Country name................: ");
        String name = reader.next();
        System.out.print("Country per capita gdp (USD): ");
        String gdp = reader.next();
        System.out.print("Country inflation (pct).....: ");
        String inflation = reader.next();

        if (isAlreadyCountryCode(con, code))
            System.out.println("Country \"" + code + "\" already exists");
        else {
            String q = "INSERT INTO Country(country_code, country_name, gdp, inflation) " +
                    "VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(q);
            stmt.setString(1, code);
            stmt.setString(2, name);
            stmt.setString(3, gdp);
            stmt.setString(4, inflation);
            stmt.execute();
            stmt.close();
        }
        System.out.println();
    }

    public static void displayFromGdpAndInflation (Connection con, Scanner reader) throws Exception {
        System.out.print("Number of countries to display: ");
        int countryNumber = reader.nextInt();
        System.out.print("Minimum per capita gdp (USD)..: ");
        String minGDP = reader.next();
        System.out.print("Maximum inflation (pct).......: ");
        String maxInflation = reader.next();

        String q = "SELECT country_name, country_code, gdp, inflation FROM Country " +
                "WHERE gdp > ? AND inflation < ? ORDER BY gdp LIMIT ?";
        PreparedStatement stmt = con.prepareStatement(q);
        stmt.setString(1, minGDP);
        stmt.setString(2, maxInflation);
        stmt.setInt(3, countryNumber);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String countryName = rs.getString("country_name");
            String countryCode = rs.getString("country_code");
            String gdp = rs.getString("gdp");
            String inflation = rs.getString("inflation");
            System.out.println(countryName + " (" + countryCode + "), " + gdp + ", " + inflation);
        }
        System.out.println();
        rs.close();
        stmt.close();
    }

    public static void updateCountry (Connection con, Scanner reader) throws Exception {
        System.out.print("Country code................: ");
        String code = reader.next();
        System.out.print("Country per capita gdp (USD): ");
        String gdp = reader.next();
        System.out.print("Country inflation (pct).....: ");
        String inflation = reader.next();

        if (isAlreadyCountryCode(con, code)) {
            String q = "UPDATE Country SET gdp = ?, inflation = ? WHERE country_code = ?";
            PreparedStatement stmt = con.prepareStatement(q);
            stmt.setString(1, gdp);
            stmt.setString(2, inflation);
            stmt.setString(3, code);
            stmt.execute();
            stmt.close();
        }
        else
            System.out.println("Country \"" + code + "\" does not exist");
        System.out.println();
    }
}