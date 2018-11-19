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
	<link rel="stylesheet" href="userProfileStyles.css">

	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
ArrayList<Integer> receivingScreenNames = (ArrayList<Integer>) session.getAttribute("receivingScreenNames");
ArrayList<Integer> receivingEmails = (ArrayList<Integer>) session.getAttribute("receivingEmails");

ArrayList<Integer> blockedUserIDs = (ArrayList<Integer>) session.getAttribute("blockedUserIDs");
ArrayList<Integer> blockedScreenNames = (ArrayList<Integer>) session.getAttribute("blockedScreenNames");
ArrayList<Integer> blockedEmails = (ArrayList<Integer>) session.getAttribute("blockedEmails");

ArrayList<Integer> matchUserIDs = (ArrayList<Integer>) session.getAttribute("matchUserIDs");
ArrayList<Integer> matchScreenNames = (ArrayList<Integer>) session.getAttribute("matchScreenNames");
ArrayList<Integer> matchEmails = (ArrayList<Integer>) session.getAttribute("matchEmails");

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
%>

<body>

	<!-- <ul id="menu">
		<div class='menu-logo'>
			<li><a href="logged_in.jsp">Sycamore Calendar</a></li>
		</div>


		<div class='searchbar'>
		    <form id="userSearch" name = "userSearch" action="SigninServlet" method="GET">
		      	<input type="text" id="searchbar" name="searchTerm" placeholder="Search Friends">
		      	<input type="image" id="searchIcon" src="search-small.png" name="submit" value="submit">
  		    </form>
      	</div>
	

	    <div class='menu-items'>
			<li><a href="homepage.jsp">Home</a></li>
			<li><a href="profile.jsp">Profile</a></li>
		</div>
 
	</ul>

	<div class="matchTable" style="overflow-y:auto;">

	</div> -->


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



int currentUserID = (Integer) session.getAttribute("currentUserID");
String screenName = (String) session.getAttribute("screenName");
String majorName = (String) session.getAttribute("majorName");
String housingName = (String) session.getAttribute("housingName");
String availabilityString = (String) session.getAttribute("availabilityString");
String imgURL = (String) session.getAttribute("imgURL");


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