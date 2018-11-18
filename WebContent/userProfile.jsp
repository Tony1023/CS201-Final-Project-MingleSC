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
	<link rel="stylesheet" type="text/css" href="gstyles.css">

	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
			$(document).on("click", ".profileImage", function(e) {
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

String currentUserId = (String) session.getAttribute("currentUserId");
String screenName = (String) session.getAttribute("screenName");
String majorName = (String) session.getAttribute("majorName");
String housingName = (String) session.getAttribute("housingName");
String availabilityString = (String) session.getAttribute("availabilityString");
String imgURL = (String) session.getAttribute("imgURL");

ArrayList<Integer> chatUserIDs = (ArrayList<Integer>) session.getAttribute("chatUserIDs");
// gonna need to get more than the chat IDs...

ArrayList<Integer> blockedUserIDs = (ArrayList<Integer>) session.getAttribute("blockedUserIDs");
ArrayList<Integer> blockedScreenNames = (ArrayList<Integer>) session.getAttribute("blockedScreenNames");

String userHTML = screenName + "\n" + majorName + "\n" + housingName + "\n" + availabilityString + "\n";
String blocksHTML = "";

System.out.println(blockedUserIDs.size());
if (blockedUserIDs.size() == 0) {
	blocksHTML += "No blocked users found.";
}
else {
	blocksHTML = "<tr>" +
				"<td> Name </td>" + 
				"<td> Image </td>" + 
			"</tr>";
	for(int i = 0; i < blockedUserIDs.size(); i++) {
		String blockImgURL = "https://api.adorable.io/avatars/285/" + blockedUserIDs.get(i) + ".png";
		blocksHTML += "<tr>" +
				      "<td class=\"blockUser\">" + blockedScreenNames.get(i) + "</td>" +
				      "<td><img class=\"profileImage\" src=\"" + blockImgURL + "\"></img></td>" +
				      "</tr>";
	}
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

		// on form submit
		$("#userSearch").submit(function(event) {
		    event.preventDefault();
		    $.ajax({
				url: "OtherUsers",
				type: "GET",
				data: {
					search: "yes",
					userEmail: $("#userEmail").val()
				},
				success: function(result) {
					$('#searchResult').html(result);
					window.location.href = "UserInformation.jsp";
				}
			});
		});
	</script>

    <h1 id="header">MingleSC</h1>

    <div id="matchContainer">
    	<table> 
	    	<div id="userInfo"> <%=userHTML%> </div>
	    	<div id="woah"> <img src=<%=imgURL%> > </div>
	    	<div id="blocks">
	    		<div id="blocksInfo"> <%=blocksHTML%> </div>
	    	</div>

	    	<div id="chat form">
	    		<form id="chatSearch" name = "userSearch" action="ChatPopup" method="GET">
			      	<input type="text" id="chatSearchTerm" name="searchTerm" placeholder="chat someone">
			      	<input type="submit" name="submit" value="submit">
	  		    </form>
	  		</div>
	  		<div id="user form">
	  			<form id="userSearch" name ="userSearch" action="UserInfoPage" method="GET">
			      	<input type="text" id="userEmail"name="searchTerm" placeholder="go to user info page">
			      	<input type="submit" name="submit" value="submit">
	  		    </form>
	  		</div>
	    </table>
	</div>

	<!-- <div class="bottomBar"></div> -->

    

</body>
</html>