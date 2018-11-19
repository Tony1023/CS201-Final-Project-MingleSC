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

<script>
		$(document).ready(function() { 
			$(document).on("click", ".followUser", function(e) {
			 	e.preventDefault();
			    $.ajax({
			    	type: "GET",
			    	url: "SigninServlet", // TODO: change to whatever the user info page serlvet is
			    	data: {
			    		loadUser: "yes",
			    		emailToLoad: $(this).closest('tr').children('td').find('span:first').text()
			    	},
			    	success: function(result){
			        	// alert('Successful user load!')
						window.location.href = "userFollow.jsp"; // change to whatever user info page is
			 	   }
				});

	   		});
   		});

   		$(document).ready(function() { 
			$(document).on("click", ".img-thumbnail", function(e) {
			 	e.preventDefault();
			    $.ajax({
			    	type: "GET",
			    	url: "SigninServlet", // TODO: Change to whatever the user info page servlet is 
			    	data: {
			    		loadUser: "yes",
			    		// emailToLoad: $(".followUserEmail").text(),
			    		emailToLoad: $(this).closest('tr').children('td').find('span:first').text()
			    	},
			    	success: function(result){
			        	// alert('Successful user load!')
						window.location.href = "userFollow.jsp"; // change to whtatever user info page is
			 	   }
				});

	   		});
   		});
		    	
</script>

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


String userHTML = screenName + "\n" + majorName + "\n" + housingName + "\n" + availabilityString + "\n";


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
	extraHTML += "<span class=\"badge badge-pill badge-danger\"> No extracurriculars found! </span>";
}
else {
	for(int i = 0; i < extracurricularNames.size(); i++) {
		extraHTML += "<span class=\"badge badge-pill badge-primary\">" + extracurricularNames.get(i) + "</span>";
	}
	System.out.println(extraHTML);
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

    

    <div id="matchContainer">
	    	<div id="userInfo"> <%=userHTML%> </div>
	    	
			
	    	<div class="row">
	    		<div class="col-md-4">
		    		<div class="thumbnail">
				      <a href="https://www.w3schools.com/w3images/lights.jpg">
				        <img class="img-thumbnail" src="https://www.w3schools.com/w3images/lights.jpg" alt="Lights" style="width:100%">
				        <div class="caption">
				          <p>Lorem ipsum...</p>
				        </div>
				      </a>
			    	</div>
		    	</div>

		    	<div class="col-md-4">
		    		<div class="thumbnail">
				      <a href="https://www.w3schools.com/w3images/lights.jpg">
				        <img src="https://www.w3schools.com/w3images/lights.jpg" alt="Lights" style="width:100%">
				        <div class="caption">
				          <p>Lorem ipsum...</p>
				        </div>
				      </a>
			    	</div>
		    	</div>
	    	</div>
	    	
	    	
					    	
	    	<a href="#" class="badge badge-dark badge-pill">html5</a>


	    	<div> <img class="img-thumbnail" src=<%=imgURL%> > </div>
	    	
	    	

	    	<div class="card" style="width: 18rem;">
		    	<h4 class="card-header">Extracurriculars</h5>
		    	<div class="card-body">
			  		 <h4> 
		    			<%=extraHTML%>
			    	</h4> 
		    	</div>
			  
			</div>
	    	

	    	<div id="chat form">

	    		<button onclick="popChat(<%=currentUserID%>, 2)">Chat now!</button>

	    		<form id="chatSearch" name = "userSearch" action="ChatPopup" method="GET">
			      	<input type="text" id="chatSearchTerm" name="searchTerm" placeholder="chat someone">
			      	<input type="submit" name="submit" value="submit">
	  		    </form>
	  		</div>
	  		<div id="user info form">
	  			<form id="userSearch" name ="userSearch" action="OtherUsers" method="GET">
			      	<input type="text" id="userEmail" name="userEmail" placeholder="go to user info page">
			      	<input type="submit" name="submit" value="submit">
	  		    </form>
	  		</div>

	  		<div id="chats">

	  			<div class="card" style="width: 18rem;">
				  <img class="card-img-top" src="https://www.w3schools.com/w3images/lights.jpg" alt="Card image cap">
				  <div class="card-body">
				  	<h5 class="card-title">Card title</h5>
				    <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
				  	
				  	<form action="OtherUsers" name="userSearch" method="GET">
			  			  <input type="hidden" id="custId" name="userEmail" value="zhehaolu2@usc.edu">
			  			  <button type="submit" class="btn btn-primary mb-2">View Profile</button>
				  	</form>
					
					<button class="btn btn-primary mb-2" onclick="popChat(<%=currentUserID%>, 2)" >Chat now!</button>

				  </div>
				  
				  
				  

				</div>

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