<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page
    import="javax.servlet.*, jakarta.servlet.ServletException, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Event Booked!</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-image: url('bg.jpg');
    background-size: cover;
    background-position: center;
}

.container {
    text-align: center;
    padding: 100px;
    border-radius: 10px;
    position: relative;
    margin: 100px auto;
    max-width: 400px; /* Adjust max-width as needed */
}

.container::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('bg.jpg');
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
</style>
</head>
<body> 
    <div class="container">
        <h1>Congratulations!!</h1>
        <p>Your event has been booked successfully.<br>       
        Our Team will reach out to you soon with further details!</p>
        <h3>Booking Details:</h3>
        <%
        int userId = Integer.parseInt(request.getParameter("user_id"));

        String url = "jdbc:mysql://localhost:3306/event_management";
        String username = "root";
        String dbPassword = "root";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(url, username, dbPassword);

            String query = "SELECT * FROM event_details WHERE user_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, userId);
            resultSet = preparedStatement.executeQuery();

            out.println("<table>");
            out.println("<tr><th>Event Name</th><th>Event Day</th><th>Event Type</th><th>Number of people</th><th>Location</th></tr>");
            while (resultSet.next()) {
                String eventName = resultSet.getString("event_name");
                String eventDay = resultSet.getString("event_day");
                String eventType = resultSet.getString("event_type");
                int footfall = resultSet.getInt("footfall");
                String location = resultSet.getString("location");

                out.println("<tr>");
                out.println("<td>" + eventName + "</td>");
                out.println("<td>" + eventDay + "</td>");
                out.println("<td>" + eventType + "</td>");
                out.println("<td>" + footfall + "</td>");
                out.println("<td>" + location + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<p>Error occurred while retrieving event details.</p>");
        } finally {            
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        %>
    </div>
</body>
</html>

