<%@ page import="java.io.*, java.util.*, java.sql.*, java.sql.Date"%>
<%@ page
    import="javax.servlet.*, jakarta.servlet.ServletException, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Event History</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-image: url('admin.jpg');
    background-size: cover;
    background-position: center;
}

.container {
    text-align: center;
    padding: 100px;
    border-radius: 10px;
    position: relative;
    margin: 100px auto;
    max-width: 800px; /* Adjust max-width as needed */
}

.container::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('admin.jpg');
    background-size: cover;
    background-position: center;
    filter: blur(5px); /* Adjust the blur value as needed */
    z-index: -1;
}

.container > .content {
    position: relative;
    z-index: 1;
    background-color: rgba(255, 255, 255, 0.7); /* Adjust the opacity as needed */
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
}

h2 {
    color: #333;
    margin-bottom: 20px;
}

table {
    margin: 0 auto; /* Center the table */
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

table, th, td {
    border: 1px solid #ddd;
    padding: 8px;
}

th {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #f5f5f5;
}

.link {
    color: blue;
    text-decoration: underline;
    cursor: pointer;
}

</style>
</head>
<body>   
    <div class="container">
        <h2>Event History</h2>
        <table>
            <tr>
                <th>Event ID</th>
                <th>Event Name</th>
                <th>Event Day</th>
                <th>Event Type</th>
                <th>Number of people</th>
                <th>Location</th>
            </tr>
            <%

            String url = "jdbc:mysql://localhost:3306/event_management";
            String username = "root";
            String dbPassword = "root";

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            try {

                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection(url, username, dbPassword);

                String query = "SELECT * FROM event_details";
                preparedStatement = connection.prepareStatement(query);
                resultSet = preparedStatement.executeQuery();

                while(resultSet.next()) {
                    int eventId = resultSet.getInt("event_id");
                    String eventName = resultSet.getString("event_name");
                    Date eventDay = resultSet.getDate("event_day");
                    String eventType = resultSet.getString("event_type");
                    int footfall = resultSet.getInt("footfall");
                    String location = resultSet.getString("location");

                    out.println("<tr>");
                    out.println("<td>" + eventId + "</td>");
                    out.println("<td>" + eventName + "</td>");
                    out.println("<td>" + eventDay + "</td>");
                    out.println("<td>" + eventType + "</td>");
                    out.println("<td>" + footfall + "</td>");
                    out.println("<td>" + location + "</td>");
                    out.println("</tr>");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                
                out.println("<tr><td colspan=\"6\">Error occurred while retrieving events.</td></tr>");
            } finally {              
                if (resultSet != null) {
                    try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                if (preparedStatement != null) {
                    try { preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                if (connection != null) {
                    try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
            %>
        </table>
    </div>

</body>
</html>

