<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page
    import="javax.servlet.*, jakarta.servlet.ServletException, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login</title>
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
    max-width: 200px;
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

input[type="email"],
input[type="password"],
input[type="submit"] {
    padding: 10px 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin-bottom: 15px;
    width: 300px;
}

input[type="submit"] {
    background-color: rgb(128, 64, 64);
    color: #fff;
    cursor: pointer;
    transition: background-color 0.3s;
}

input[type="submit"]:hover {
    background-color: rgb(128, 64, 64);
}

</style>
</head>
<body>
    <div class="container">
        <h2>Admin Login</h2>
        <form action="<%=request.getRequestURI()%>" method="post">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Login">
        </form>        
        <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            String url = "jdbc:mysql://localhost:3306/event_management";
            String username = "root";
            String dbPassword = "root"; 

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                connection = DriverManager.getConnection(url, username, dbPassword);

                String query = "SELECT * FROM admin WHERE admin_email=? AND admin_password=?";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, email);
                preparedStatement.setString(2, password);
                resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {                    
                    response.sendRedirect("eventlist.jsp");
                } else {                    
                    out.println("Invalid email or password");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.sendRedirect("adminlogin.jsp?error=databaseError");
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
        }
        %>
    </div>
</body>
</html>

