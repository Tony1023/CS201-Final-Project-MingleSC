<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "
java.io.IOException,
java.io.InputStream,
java.io.InputStreamReader,
java.security.GeneralSecurityException,
java.util.Collections,
java.util.List,
java.time.format.DateTimeFormatter,
java.util.Date,
java.time.ZoneId,
java.sql.Connection,
java.sql.DriverManager,
java.sql.PreparedStatement,
java.sql.ResultSet,
java.sql.SQLException,
java.util.ArrayList,
resources.*"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="FinalProject.css">
	<link href="https://fonts.googleapis.com/css?family=Oxygen" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.min.css">
	<meta charset="UTF-8">
	<title>Create An Account</title>
</head>
<body>
	
	<%
		String errorMessage = "";
		if(null != session.getAttribute("errorMessage")){
			errorMessage = (String)session.getAttribute("errorMessage");	
		}
		session.removeAttribute("errorMessage");
	%>
	<%
	ArrayList<String> majors = new ArrayList<String>();
	ArrayList<String> courses = new ArrayList<>();
	ArrayList<String> housing = new ArrayList<String>();
	ArrayList<String> extracurriculars = new ArrayList<String>();
	ArrayList<String> interests = new ArrayList<String>();
	
	Connection conn = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;
    ResultSet rs4 = null;
    ResultSet rs5 = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;
    PreparedStatement ps3 = null;
    PreparedStatement ps4 = null;
    PreparedStatement ps5 = null;
    
    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
    	conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
    	ps = conn.prepareStatement("SELECT * FROM major");
    	rs = ps.executeQuery();
    	while(rs.next()){
    		String major_name = rs.getString("major_name");
    		majors.add(major_name);
    	}
    	ps2 = conn.prepareStatement("SELECT * FROM housing");
    	rs2 = ps2.executeQuery();
    	while(rs2.next()){
    		String housing_name = rs2.getString("housing_name");
    		housing.add(housing_name);
    	}
    	ps3 = conn.prepareStatement("SELECT * FROM courses");
    	rs3 = ps3.executeQuery();
    	while(rs3.next()){
    		String prefix = rs3.getString("course_prefix");
    		int number = rs3.getInt("course_number");
    		String course = prefix +  " " + Integer.toString(number);
    		courses.add(course);
    	}
    	ps4 = conn.prepareStatement("SELECT * FROM gen_interests");
    	rs4 = ps4.executeQuery();
    	while(rs4.next()){
    		String interest = rs4.getString("interest_name");
    		interests.add(interest);
    	}
    	ps5 = conn.prepareStatement("SELECT * FROM extracurriculars");
    	rs5 = ps5.executeQuery();
    	while(rs5.next()){
    		String extracurricular = rs5.getString("extracurricular_name");
    		extracurriculars.add(extracurricular);
    	}
    } catch (SQLException sqle) {
    	System.out.println("sqle: " + sqle.getMessage());
    } catch (ClassNotFoundException cnfe) {
    	System.out.println("cnfe: " + cnfe.getMessage());
    } finally {
    	try {
    		if (rs != null) {
    			rs.close();
    		}
    		if (rs2 != null) {
    			rs2.close();
    		}
    		if (rs3 != null) {
    			rs3.close();
    		}
    		if (rs4 != null) {
    			rs4.close();
    		}
    		if (rs5 != null) {
    			rs5.close();
    		}
    		if (ps != null) {
    			ps.close();
    		}
    		if (ps2 != null) {
    			ps.close();
    		}
    		if (ps3 != null) {
    			ps.close();
    		}
    		if (ps4 != null) {
    			ps.close();
    		}
    		if (ps5 != null) {
    			ps.close();
    		}
    		if (conn != null) {
    			conn.close();
    		}
    	} catch(SQLException sqle) {
    		System.out.println("sqle closing conn: " + sqle.getMessage());
    	}

    }
    session.setAttribute("majorsArrayList", majors);
    session.setAttribute("housingArrayList", housing);
    session.setAttribute("coursesArrayList", courses);
    session.setAttribute("extracurricularsArrayList", extracurriculars);
    session.setAttribute("interestsArrayList", interests);
	%>
		
	<h1 id = "header"> MingleSC </h1>
		<ul class="info" style="list-style-type:none">
		  <li style = "text-align:center;font-size:35px;">Connect with Your Classmates</li>
		  <li style="text-align:center;margin-left: 15%;margin-right: 15%;font-size: 70%;">You do not currently have an account. Please proceed as a guest to see current users with the same courses.</li>
		  <img style = "margin-top:10px" src="Capture.PNG">
		</ul>
	
	<div id = form>
		<h2 style = "font-weight: bold;">Create an Account</h2>
	
		<p id = "err_message" style="color: red; font-weight: bold"><%=errorMessage%></p>
		<form id = "CreateAccount" name = "CreateAccountForm" method = "POST" action = "CreateAccount">
			<br>
			<h3>Please enter the following:</h3>
			
			Name:<br><input type = "text" name = "name"><br>
			Email:<br><input type = "text" name = "email"><br>
			Password:<br><input type = "password" name = "password"><br>
			Major:<br><select name ="major">
					<%
				for(int i = 0; i < majors.size(); i++){%>
					<option value = "<%=i%>"><%=majors.get(i)%></option> 	
					<% 	
					}
					%>
					</select><br>
			Housing:<br><select name="housing">
					<%
				for(int i = 0; i < housing.size(); i++){%>
					<option value = "<%=i%>"><%=housing.get(i)%></option> 	
					<% 	
					}
					%>
					</select><br>
			Courses:<br><select name="courses" class = "chosen-select" style="width: 30%" multiple>
					<%
				for(int i = 0; i < courses.size(); i++){%>
					<option value = "<%=i%>"><%=courses.get(i)%></option> 	
					<% 	
					}
					%>
					</select><br>
			
			Extracurriculars:<br><select name="extracurriculars" class = "chosen-select" style="width: 30%" multiple>
					<%
				for(int i = 0; i < extracurriculars.size(); i++){%>
					<option value = "<%=i%>"><%=extracurriculars.get(i)%></option> 	
					<% 	
					}
					%>
					</select><br>
			Interests:<br><select name="interests" class = "chosen-select" style="width: 30%" multiple>
					<%
				for(int i = 0; i < interests.size(); i++){%>
					<option value = "<%=i%>"><%=interests.get(i)%></option> 	
					<% 	
					}
					%>
					</select><br><br>	
					<input style = "background-color: #00B488; color: white;" type="submit" value="Register"><br><br>
		</form>
	</div>	
	
	<%errorMessage ="";%>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>

	<script src="docsupport/chosen.jquery.min.js"></script>
	<script src="docsupport/chosen.proto.min.js"></script>
	<script>
		$(".chosen-select").chosen()
	</script>
	
</body>
</html>