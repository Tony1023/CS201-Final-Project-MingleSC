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
	
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"  crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>

	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>


	<link rel="stylesheet" href="userProfileStyles.css">

	<script src="https://apis.google.com/js/platform.js" async defer></script>
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
String blockedCardsHTML = "";
String chatCardsHTML = "";
String matchCardsHTML = "";

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


if (blockedUserIDs.size() == 0) {
	blockedCardsHTML += "No blocked users found.";
}
else {

	// shouldn't be able to chat with users you've blocked
	for(int i = 0; i < blockedUserIDs.size(); i++) {
		String blockedImgURL = "https://s3.amazonaws.com/pix.iemoji.com/images/emoji/apple/ios-11/256/man-gesturing-no-medium-light-skin-tone.png";
		blockedCardsHTML += "<div class=\"card border-primary m-3\" style=\"width: 12rem;\">" + 
							"<img class=\"card-img-top\" src=\"" + blockedImgURL +  "\" alt=\"Profile image\">" + 
							"<div class=\"card-body\">" + 
								"<h5 class=\"card-title\">" + blockedScreenNames.get(i) + "</h5>" + 
								"<form action=\"OtherUsers\" name=\"userSearch\" method=\"GET\">" + 
									"<input type=\"hidden\" id=\"custId\" name=\"userEmail\" value=\"" + blockedEmails.get(i) + "\">" + 
									"<button type=\"submit\" class=\"btn btn-success mb-2\">View Profile</button>" + 
							  	"</form>" + 
							  	"<form action=\"BlockUser\" name=\"userSearch\" method=\"GET\">" + 
									"<input type=\"hidden\" id=\"custId\" name=\"userToUnblockID\" value=\"" + blockedUserIDs.get(i) + "\">" + 
									"<button type=\"submit\" class=\"btn btn-primary mb-2\">Unblock to chat!</button>" + 
							  	"</form>" + 
					  		"</div>" + 
					  	 "</div>";
	}


	System.out.println(blockedCardsHTML);
}




if (receivingUserIDs.size() == 0) {
	chatCardsHTML += "No chats found.";
}
else {
	for(int i = 0; i < receivingUserIDs.size(); i++) {
		String chatImgURL = "https://api.adorable.io/avatars/285/" + receivingUserIDs.get(i) + ".png";
		chatCardsHTML += "<div class=\"card border-primary m-3\" style=\"width: 12rem;\">" + 
							"<img class=\"card-img-top\" src=\"" + chatImgURL +  "\" alt=\"Profile image\">" + 
							"<div class=\"card-body\">" + 
								"<h5 class=\"card-title\">" + receivingScreenNames.get(i) + "</h5>" + 
								"<form action=\"OtherUsers\" name=\"userSearch\" method=\"GET\">" + 
									"<input type=\"hidden\" id=\"custId\" name=\"userEmail\" value=\"" + receivingEmails.get(i) + "\">" + 
									"<button type=\"submit\" class=\"btn btn-success mb-2\">View Profile</button>" + 
							  	"</form>" + 
						  		"<button class=\"btn btn-primary mb-2\" onclick=\"popChat(" + currentUserID + ", " + receivingUserIDs.get(i) + ")\" >Chat now!</button>" + 
					  		"</div>" + 
					  	 "</div>";
	}


	System.out.println(chatCardsHTML);
}


if (matchUserIDs.size() == 0) {
	matchCardsHTML += "No matches found.";
}
else {
	for(int i = 0; i < matchUserIDs.size(); i++) {
		String matchImgURL = "https://api.adorable.io/avatars/285/" + matchUserIDs.get(i) + ".png";
		matchCardsHTML += "<div class=\"card border-primary m-3\" style=\"width: 12rem;\">" + 
							"<img class=\"card-img-top\" src=\"" + matchImgURL +  "\" alt=\"Profile image\">" + 
							"<div class=\"card-body\">" + 
								"<h5 class=\"card-title\">" + matchScreenNames.get(i) + "</h5>" + 
								"<form action=\"OtherUsers\" name=\"userSearch\" method=\"GET\">" + 
									"<input type=\"hidden\" id=\"custId\" name=\"userEmail\" value=\"" + matchEmails.get(i) + "\">" + 
									"<button type=\"submit\" class=\"btn btn-success mb-2\">View Profile</button>" + 
							  	"</form>" + 
						  		"<button class=\"btn btn-primary mb-2\" onclick=\"popChat(" + currentUserID + ", " + matchUserIDs.get(i) + ")\" >Chat now!</button>" + 
						  		"<form action=\"BlockUser\" name=\"userSearch\" method=\"GET\">" + 
									"<input type=\"hidden\" id=\"custId\" name=\"userToBlockID\" value=\"" + matchUserIDs.get(i) + "\">" + 
									"<button type=\"submit\" class=\"btn btn-danger mb-2\">Block User</button>" + 
							  	"</form>" + 
					  		"</div>" + 
					  	 "</div>";
	}


	System.out.println(matchCardsHTML);
}


String extraHTML = "";
if (extracurricularNames.size() == 0) {
	extraHTML += "<span class=\"badge badge-pill badge-danger\"> No extracurriculars found! </span>\n";
}
else {
	for(int i = 0; i < extracurricularNames.size(); i++) {
		extraHTML += "<span class=\"badge badge-pill badge-danger\">" + extracurricularNames.get(i) + "</span>\n";
	}
	System.out.println(extraHTML);
}

String interestHTML = "";
if (interestNames.size() == 0) {
	interestHTML += "<span class=\"badge badge-pill badge-danger\"> No interests found! </span>\n";
}
else {
	for(int i = 0; i < interestNames.size(); i++) {
		interestHTML += "<span class=\"badge badge-pill badge-danger\">" + interestNames.get(i) + "</span>\n";
	}
	System.out.println(interestHTML);
}

String courseHTML = "";
if (coursePrefixes.size() == 0) {
	courseHTML += "<span class=\"badge badge-pill badge-danger\"> No coursess found! </span>\n";
}
else {
	for(int i = 0; i < coursePrefixes.size(); i++) {
		courseHTML += "<span class=\"badge badge-pill badge-danger\">" + coursePrefixes.get(i) + " " + courseNumbers.get(i) + "</span>\n";
	}
	System.out.println(courseHTML);
}


%>

<body>
    
	<h1 id="header">MingleSC</h1>

	</div>


	<div class="row">
		<div class="card border-secondary m-1 ml-4" style="width: 20rem;">
		  <img class="card-img-top" src=<%=imgURL%> alt="Card image cap">
		  <ul class="list-group list-group-flush">
		     <li class="list-group-item float-left"><strong>Name: </strong><%=screenName%></li>
			 <li class="list-group-item"><strong>Major: </strong><%=majorName%></li>
			 <li class="list-group-item"><strong>Housing: </strong><%=housingName%></li>
		  </ul>
		  <!-- Edit this to hit the scheduler backend-->
		  <div class="card-body">
  			  <a href="scheduler_v2.jsp" class="btn btn-success mb-2" role="button"> Edit Availability</a>
		  </div>
		</div>

		<div class="card-column" name="user-info">
  			<div class="col">
  				<div class="card center-block m-1 mx-auto mb-3" style="width: 18rem;">
			    	<h5 class="card-header">Interests</h5>
			    	<div class="card-body">
				  		 <h5> 
			    			<%=interestHTML%>
				    	</h5> 
			    	</div>
				  
				</div>
  			</div>

  			<div class="col">
  				<div class="card center-block m-1 mx-auto mb-3" style="width: 18rem;">
			    	<h5 class="card-header">Extracurriculars</h5>
			    	<div class="card-body">
				  		 <h5> 
			    			<%=extraHTML%>
				    	</h5> 
			    	</div>
				</div>

  			</div>

  			<div class="col">
  				<div class="card center-block m-1 mx-auto mb-3" style="width: 18rem;">
			    	<h5 class="card-header">Courses</h5>
			    	<div class="card-body">
				  		 <h5> 
			    			<%=courseHTML%>
				    	</h5> 
			    	</div>
				  
				</div>
  			</div>

  		</div>

	</div>
	

  		<div class="row" name="chats">
  			<div class="col-1 text-label">
  				<h5> CHATS</h5>
  			</div>
  			<%=chatCardsHTML%>
    	</div>

    	<div class="row" name="matches">
    		<div class="col-1 text-label">
  				<h5> MATCHES</h5>
  			</div>
    		<%=matchCardsHTML%>
    	</div>

    	<div class="row" id="blocks">
    		<div class="col-1 text-label">
  				<h5> BLOCKS</h5>
  			</div>
    		<%=blockedCardsHTML%>
    	</div>

<script>
let id = <%= currentUserID %>;
function checkMessages() {
	$.post('GetUnreadServlet', {
		thisId: id
	}, function(res) {
		console.log(res);
		if (res !== '') {
			let ids = res.split(',');
    		for (let i = 0; i < ids.length; ++i) {
    			popChat(id, ids[i]);
    		}
		}
		setTimeout(checkMessages, 5000);
	});
}
$(document).ready(function() {
	checkMessages();
});
</script>
</body>
</html>