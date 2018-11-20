<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Matches Page</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>

	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>


	<link rel="stylesheet" href="userProfileStyles.css">

	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> -->
	<script src="javascript/chatWindowLib.js"></script>
</head>

<%

HttpSession session = request.getSession(false);

int currentUserID = (Integer) session.getAttribute("currentUserID");
String screenName = (String) session.getAttribute("screenName");
String majorName = (String) session.getAttribute("majorName");
String housingName = (String) session.getAttribute("housingName");
String availabilityString = (String) session.getAttribute("availabilityString");
String imgURL = (String) session.getAttribute("imgURL");

ArrayList<Integer> receivingUserIDs = (ArrayList<Integer>) session.getAttribute("receivingUserIDs");
ArrayList<String> receivingScreenNames = (ArrayList<String>) session.getAttribute("receivingScreenNames");
ArrayList<String> receivingEmails = (ArrayList<String>) session.getAttribute("receivingEmails");

ArrayList<Integer> blockedUserIDs = (ArrayList<Integer>) session.getAttribute("blockedUserIDs");
ArrayList<String> blockedScreenNames = (ArrayList<String>) session.getAttribute("blockedScreenNames");
ArrayList<String> blockedEmails = (ArrayList<String>) session.getAttribute("blockedEmails");

ArrayList<Integer> matchUserIDs = (ArrayList<Integer>) session.getAttribute("matchUserIDs");
ArrayList<String> matchScreenNames = (ArrayList<String>) session.getAttribute("matchScreenNames");
ArrayList<String> matchEmails = (ArrayList<String>) session.getAttribute("matchEmails");

ArrayList<String> extracurricularNames = (ArrayList<String>) session.getAttribute("extracurricularNames");
ArrayList<String> interestNames = (ArrayList<String>) session.getAttribute("interestNames");
ArrayList<String> coursePrefixes = (ArrayList<String>) session.getAttribute("coursePrefixes");
ArrayList<String> courseNumbers = (ArrayList<String>) session.getAttribute("courseNumbers");
ArrayList<String> courseNames = (ArrayList<String>) session.getAttribute("courseNames");


String userHTML = screenName + "\n" + majorName + "\n" + housingName + "\n";


String blocksHTML = "";
String chatsHTML = "";
String matchHTML = "";

System.out.println(blockedUserIDs.size());
if (blockedUserIDs.size() == 0) {
	blocksHTML += "No blocked users found.";
}
else {
	blocksHTML = "<table> <tr>" +
				"<td> Name </td>" + 
				"<td> Image </td>" + 
			"</tr>";
	for(int i = 0; i < blockedUserIDs.size(); i++) {
		String blockImgURL = "https://api.adorable.io/avatars/285/" + blockedUserIDs.get(i) + ".png";
		blocksHTML += "<tr>" +
				      "<td class=\"blockUser\">" + blockedScreenNames.get(i) + "</td>" +
				      "<td><img class=\"img-thumbnail\" src=\"" + blockImgURL + "\"></img></td>" +
				      "</tr> </table>";
	}
	System.out.println(blocksHTML);
}

String chatCardsHTML = "";
if (receivingUserIDs.size() == 0) {
	chatsHTML += "No chats found.";
}
else {
	chatsHTML = "<table> <tr>" +
				"<td> Name </td>" + 
				"<td> Image </td>" + 
			"</tr>";
	for(int i = 0; i < receivingUserIDs.size(); i++) {
		String chatImgURL = "https://api.adorable.io/avatars/285/" + receivingUserIDs.get(i) + ".png";
		chatsHTML += "<tr>" +
				      "<td class=\"chatUser\">" + receivingScreenNames.get(i) + "</td>" +
				      "<td><img class=\"img-thumbnail\" src=\"" + chatImgURL + "\"></img></td>" +
				      "</tr> </table>";
	}

	for(int i = 0; i < receivingUserIDs.size(); i++) {
		chatCardsHTML += "<div class=\"card border-primary m-3\" style=\"width: 12rem;\">" + 
							"<img class=\"card-img-top\" src=\"https://api.adorable.io/avatars/285/" + i + ".png\" alt=\"Profile image\">" + 
							"<div class=\"card-body\">" + 
								"<h5 class=\"card-title\">" + receivingScreenNames.get(i) + "</h5>" + 
									"<form action=\"OtherUsers\" name=\"userSearch\" method=\"GET\">" + 
										"<input type=\"hidden\" id=\"custId\" name=\"userEmail\" value=\"" + receivingEmails.get(i) + "\">" + 
										"<button type=\"submit\" class=\"btn btn-primary mb-2\">View Profile</button>" + 
								  	"</form>" + 
							  		"<button class=\"btn btn-primary mb-2\" onclick=\"popChat(" + currentUserID + ", " + receivingUserIDs.get(i) + ")\" >Chat now!</button>" + 
					  		"</div>" + 
					  	 "</div>";
	}


		
		


	  













	System.out.println(chatsHTML);
}















if (matchUserIDs.size() == 0) {
	matchHTML += "No match users found.";
}
else {
	matchHTML = "<table> <tr>" +
				"<td> Name </td>" + 
				"<td> Image </td>" + 
			"</tr> </table>";
	for(int i = 0; i < matchUserIDs.size(); i++) {
		String matchImgURL = "https://api.adorable.io/avatars/285/" + matchUserIDs.get(i) + ".png";
		matchHTML += "<tr>" +
				      "<td class=\"matchUser\">" + matchScreenNames.get(i) + "</td>" +
				      "<td><img class=\"img-thumbnail\" src=\"" + matchImgURL + "\"></img></td>" +
				      "</tr> </table>";
	}

	System.out.println(matchHTML);
}


String extraHTML = "";
if (extracurricularNames.size() == 0) {
	extraHTML += "<span class=\"badge badge-pill badge-danger\"> No extracurriculars found! </span>\n";
}
else {
	for(int i = 0; i < extracurricularNames.size(); i++) {
		extraHTML += "<span class=\"badge badge-pill badge-primary\">" + extracurricularNames.get(i) + "</span>\n";
	}
	System.out.println(extraHTML);
}

String interestHTML = "";
if (interestNames.size() == 0) {
	interestHTML += "<span class=\"badge badge-pill badge-danger\"> No interests found! </span>\n";
}
else {
	for(int i = 0; i < interestNames.size(); i++) {
		interestHTML += "<span class=\"badge badge-pill badge-primary\">" + interestNames.get(i) + "</span>\n";
	}
	System.out.println(interestHTML);
}

String courseHTML = "";
if (coursePrefixes.size() == 0) {
	courseHTML += "<span class=\"badge badge-pill badge-danger\"> No coursess found! </span>\n";
}
else {
	for(int i = 0; i < coursePrefixes.size(); i++) {
		courseHTML += "<span class=\"badge badge-pill badge-primary\">" + coursePrefixes.get(i) + " " + courseNumbers.get(i) + "</span>\n";
	}
	System.out.println(courseHTML);
}


%>



<body>

	<script> 
		// on form submit
		$("#ChatPopup").submit(function(event) {
		    event.preventDefault();
		    $.ajax({
				url: "ChatServlet",
				type: "GET",
				data: {
					search: "yes",
					searchTerm: $("#chatSearchTerm").val()
				},
				success: function(result) {
					$('#searchResult').html(result);
					window.location.href = "chatpopup.jsp";
				}
			});
		});

	
	</script>

    

    
	<h1 id="header">MingleSC</h1>

   <!--  <div name="user-bio"> 
		<div class="text-center" name="imgContainer">
			<img class="img-thumbnail" src=<%=imgURL%> >
		</div>
		<br></br>
		<ul class="list-group" style="width: 18rem;">
		  <li class="list-group-item float-left"><strong>Name: </strong><%=screenName%></li>
		  <li class="list-group-item"><strong>Major: </strong><%=majorName%></li>
		  <li class="list-group-item"><strong>Housing: </strong><%=housingName%></li>
		  <li class="list-group-item"><strong>Availability: </strong>Edit Availability</li>
		</ul> -->
	</div>


	<div class="card" style="width: 20rem;">
	  <img class="card-img-top" src=<%=imgURL%> alt="Card image cap">
	  <ul class="list-group list-group-flush">
	     <li class="list-group-item float-left"><strong>Name: </strong><%=screenName%></li>
		 <li class="list-group-item"><strong>Major: </strong><%=majorName%></li>
		 <li class="list-group-item"><strong>Housing: </strong><%=housingName%></li>
		 <li class="list-group-item"><strong>Availability: </strong>Edit Availability</li>
	  </ul>
	  <!-- Edit this to hit the scheduler backend-->
	  <div class="card-body">
	    <form action="OtherUsers" name="userSearch" method="GET">
  			  <input type="hidden" id="custId" name="userEmail" value="">
  			  <button type="submit" class="btn btn-primary mb-2">Edit Availability</button>
	  	</form>
		
		<button class="btn btn-primary mb-2" onclick="popChat(<%=currentUserID%>, 2)" >Chat now!</button>
	  </div>
	</div>

    <div id="matchContainer">
	    	
	    	
	    	
	    	<!-- <div class="text-center"> 
	    		
	    	</div>
	    	 -->

	  		<div class="row" name="user-info">
	  			<div class="col">
	  				<div class="card center-block m-1 mx-auto" style="width: 18rem;">
				    	<h5 class="card-header">Interests</h5>
				    	<div class="card-body">
					  		 <h5> 
				    			<%=interestHTML%>
					    	</h5> 
				    	</div>
					  
					</div>
	  			</div>

	  			<div class="col">
	  				<div class="card center-block m-1 mx-auto" style="width: 18rem;">
				    	<h5 class="card-header">Extracurriculars</h5>
				    	<div class="card-body">
					  		 <h5> 
				    			<%=extraHTML%>
					    	</h5> 
				    	</div>
					</div>

	  			</div>

	  			<div class="col">
	  				<div class="card center-block m-1 mx-auto" style="width: 18rem;">
				    	<h5 class="card-header">Courses</h5>
				    	<div class="card-body">
					  		 <h5> 
				    			<%=courseHTML%>
					    	</h5> 
				    	</div>
					  
					</div>
	  			</div>

	  		</div>

	  		<div id="chats">
	  			<%=chatCardsHTML%>

	    		<div id="chatsInfo"> CHATS <%=chatsHTML%> </div>
	    	</div>

	    	<div id="blocks">
	    		<div id="blocksInfo"> BLOCKS <%=blocksHTML%> </div>
	    	</div>

	    	<div id="matches">
	    		<div id="matchesInfo"> Matches <%=matchHTML%> </div>
	    	</div>

	    	
	</div>

	<!-- <div class="bottomBar"></div> -->

    

</body>
</html>