<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Guest Matches</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="gstyles.css">
</head>
<body>

	<h1 id="header">MingleSC</h1>

	<h3 id="start">
		To start chatting, please <a href="CreateAccount.jsp"
			style="text-decoration: underline;">create an account</a>
	</h3>
	
	<br>
	
	<%
		Map<String, ArrayList<String>> nameMajor = (Map<String, ArrayList<String>>) request.getAttribute("nameMajor");
		
	%>
	

	<script>
		var nameMajor = '${nameMajor}';
		console.log(nameMajor);
		function tableCreate1() {
			var body = document.body, tbl = document.createElement('table');
			tbl.style.width = '550px';
			tbl.style.border = '2px solid black';
			tbl.style.marginLeft  = "500px";
			<%for (Map.Entry<String, ArrayList<String>> entry: nameMajor.entrySet()) { %>
				var tr = tbl.insertRow();
				var td = tr.insertCell();
				var td1 = tr.insertCell();
				
				var tn = document.createTextNode("<%=entry.getValue().get(0)%>");
				var tn1 = document.createTextNode("<%="Major: " + entry.getValue().get(1)%>");
				
				td.appendChild(tn);
				td1.appendChild(tn1);
				
				var img = document.createElement('img');
				img.src = "https://api.adorable.io/avatars/285/" + (<%=entry.getKey()%>) + ".png";
				td.appendChild(img);
				img.style.width = "330px";
				img.style.paddingBottom  = "15px";
				img.style.paddingTop = "5px";
				
				td.style.border = '1px solid black';
				td.style.fontSize = "20px";
				td.style.fontWeight = "bold";
				td1.style.fontSize = "20px";
				td1.style.border = '1px solid black';
				td.style.textAlign = 'center';
				td1.style.textAlign = 'center';
			<%}%>
			body.appendChild(tbl);
		}
		tableCreate1();
	</script>

</body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"
	integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
	crossorigin="anonymous">
	
</script>
</html>