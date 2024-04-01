<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page import="javax.servlet.*, jakarta.servlet.ServletException, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String userIdParam = request.getParameter("user_id");
int userId = -1;

if (userIdParam != null && !userIdParam.isEmpty()) {
    userId = Integer.parseInt(userIdParam);
}

if ("POST".equalsIgnoreCase(request.getMethod())) {  
    String eventName = request.getParameter("event_name");
    String eventDay = request.getParameter("event_day");
    String eventType = request.getParameter("event_type");
    int footfall = Integer.parseInt(request.getParameter("footfall"));
    String location = request.getParameter("location");

    String url = "jdbc:mysql://localhost:3306/event_management";
    String username = "root";
    String dbPassword = "root";

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, dbPassword);

        String query = "INSERT INTO event_details (event_name, event_day, event_type, footfall, location, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, eventName);
        preparedStatement.setString(2, eventDay);
        preparedStatement.setString(3, eventType);
        preparedStatement.setInt(4, footfall);
        preparedStatement.setString(5, location);
        preparedStatement.setInt(6, userId);
        preparedStatement.executeUpdate();

        response.sendRedirect("success.jsp?user_id=" + userId);
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    } finally {

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
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Event form</title>
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

form {
    display: flex;
    flex-direction: column;
    align-items: center;
}

label {
    margin-bottom: 10px;
    font-weight: bold;
    color: #333;
    text-align: left;
    width: 300px;
}

input[type="text"], input[type="date"], input[type="number"], textarea, input[type="submit"] {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 20px; /* Rounded corners */
    margin-bottom: 15px;
    width: 300px;
}

input[type="submit"] {
    background-color: #007bff;
    color: #fff;
    cursor: pointer;
    transition: background-color 0.3s;
    border: none;
    text-align: center;
}

input[type="submit"]:hover {
    background-color: #0056b3;
}

</style>
</head>
<body> 
    <div class="container">
        <h2>Book an event!</h2>
        <form action="<%= request.getRequestURI() %>?user_id=<%= userId %>"
            method="post">
            <label for="event_name">Event Name:</label>
            <input type="text" id="event_name" name="event_name" required><br>
            <label for="event_day">Event Day:</label>
            <input type="date" id="event_day" name="event_day" required><br>
            <label for="event_type">Event Type:</label>
            <input type="text" id="event_type" name="event_type" required><br>
            <label for="footfall">Number of People:</label>
            <input type="number" id="footfall" name="footfall" required><br>
            <label for="location">Location:</label>
            <input type="text" id="location" name="location" required><br>
            <input type="submit" value="Submit">
        </form>
    </div>   
</body>
</html>

