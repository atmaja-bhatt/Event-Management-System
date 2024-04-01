<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page
    import="javax.servlet.*, jakarta.servlet.ServletException, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
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
    max-width: 200px;
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
    filter: blur(5px); 
    z-index: -1;
}

.container > .content {
    position: relative;
    z-index: 1;
    background-color: rgba(255, 255, 255, 0.7);
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

input[type="text"], input[type="email"], input[type="password"], input[type="submit"] {
    padding: 10px 20px;
    border: 1px solid #ccc;
    border-radius: 20px;
    margin-bottom: 15px;
    width: 300px;
}

input[type="submit"], .admin-button {
    background-color: #FFD700;
    color: #fff;
    cursor: pointer;
    transition: background-color 0.3s;
    border: none;
    border-radius: 20px;
    padding: 10px 20px;
    text-decoration: none;
}

input[type="submit"]:hover, .admin-button:hover {
    background-color: #FFB800;
}

</style>
</head>
<body>
	<div class="container">
        <div class="background"></div>
        <h2>Login</h2>
        <form action="<%=request.getRequestURI()%>" method="post">
            <label for="fullname">Full Name:</label>
            <input type="text" id="fullname" name="fullname" placeholder="Enter your full name" required>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
            <input type="submit" value="Login">
        </form>
        <a class="admin-button" href="adminlogin.jsp">Admin Login</a>
		
		<%
		if ("POST".equalsIgnoreCase(request.getMethod())) {

			String fullname = request.getParameter("fullname");
			String username = request.getParameter("username");
			String email = request.getParameter("email");
			String password = request.getParameter("password");


			String url = "jdbc:mysql://localhost:3306/event_management";
			String dbUsername = "root";
			String dbPassword = "root";

			Connection connection = null;
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;

			try {				
				Class.forName("com.mysql.jdbc.Driver");
				connection = DriverManager.getConnection(url, dbUsername, dbPassword);
				
				String query = "SELECT * FROM user WHERE email=?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, email);
				resultSet = preparedStatement.executeQuery();

				if (resultSet.next()) {

					int userId = resultSet.getInt("user_id");

					response.setHeader("user_id", String.valueOf(userId));
					response.sendRedirect("eventform.jsp");
				} else {

					query = "INSERT INTO user (full_name, username, email, password) VALUES (?, ?, ?, ?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, fullname);
					preparedStatement.setString(2, username);
					preparedStatement.setString(3, email);
					preparedStatement.setString(4, password);
					preparedStatement.executeUpdate();
					query = "SELECT user_id FROM user WHERE email=?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, email);
					resultSet = preparedStatement.executeQuery();

					if (resultSet.next()) {
						int userId = resultSet.getInt("user_id");

						response.sendRedirect("eventform.jsp?user_id=" + userId);

					} else {

						response.sendRedirect("login.jsp?error=userIDError");
					}
				}
			} catch (SQLException | ClassNotFoundException e) {
				e.printStackTrace();

				response.sendRedirect("login.jsp?error=databaseError");
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
		}
		%>
	</div>
</body>
</html>
