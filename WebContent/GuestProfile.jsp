<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.*" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Guest Log-In</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="gstyles.css">
</head>

<body>

	<h1 id="header">MingleSC</h1>

	<div id="form">
		<h2 id="header">Guest Log In Page</h2>
		<form action="GuestServlet" method="GET">
			<br>
			<h3>Please select a course:</h3>
			<br> <br>

			<select id = "select" name="course" value="course">
				<option>Select a Course -- </option>
				<option>CSCI 103: Introduction to Programming</option>
				<option>CSCI 104: Data Structures and Algorithms</option>
				<option>CSCI 170: Discrete Methods in Computer Science</option>
				<option>CSCI 201: Principles of Software Development</option>
				<option>CSCI 310: Software Engineering</option>
				<option>CSCI 356: Introduction to Computer Systems</option>

			</select> <br> <br> <br> <input type="submit" value="Submit">

			<br> <br>
		</form>
	</div>
</body>
</html>