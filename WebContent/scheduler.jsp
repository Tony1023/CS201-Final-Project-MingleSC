<%
  int userID = 1;
  int targetID = 2;
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title> Scheduler </title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">
  </head>
  <body>
    <div id="tableContainer">
	    <table class="table is-bordered is-fullwidth is-striped is-hoverable">
	      <thead>
	        <tr>
	          <th> Times </th>
	          <th><abbr title="Monday"> Mon </abbr></th>
	          <th><abbr title="Tuesday"> Tue </abbr></th>
	          <th><abbr title="Wednesday"> Wed </abbr></th>
	          <th><abbr title="Thursday"> Thu </abbr></th>
	          <th><abbr title="Friday"> Fri </abbr></th>
	          <th><abbr title="Saturday"> Sat </abbr></th>
	          <th><abbr title="Sunday"> Sun </abbr></th>
	        </tr>
	      </thead>
	      <tbody>
	      	<tr>
		    	<th> 12:00 am </th>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		       	<td> x </td>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		    </tr>
		    <tr>
		    	<th> 12:30 am </th>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		       	<td> x </td>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		    </tr>
	      	<% for(int i=1; i<12; i++) {%>
		        <tr>
		          <th> <%= i %>:00 am </th>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		        </tr>
		        <tr>
		          <th> <%= i %>:30 am </th>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		        </tr>
		    <% } %>
		    <tr>
		    	<th> 12:00 pm </th>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		       	<td> x </td>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		    </tr>
		    <tr>
		    	<th> 12:30 pm </th>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		       	<td> x </td>
		        <td> x </td>
		        <td> x </td>
		        <td> x </td>
		    </tr>
		    <% for(int i=1; i<12; i++) {%>
		        <tr>
		          <th> <%= i %>:00 pm </th>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		        </tr>
		        <tr>
		          <th> <%= i %>:30 pm </th>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		          <td> x </td>
		        </tr>
		    <% } %>
	      </tbody>
	    </table>
    </div>
    
    <script>
	    document.addEventListener("DOMContentLoaded", function() {
			let xhttp = new XMLHttpRequest();
			xhttp.open("POST", "SchedulerServlet", true);
			xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			xhttp.onreadystatechange = function() {
				if(xhttp.readyState == 4 && xhttp.status == 200) {
					if(this.responseText != null && this.responseText != "") {
						console.log("AJAX Successful!");
					}
				}
			}
			xhttp.send("userID=" + <%= userID %> + "&targetID=" + <%= targetID %>);
		});
    </script>
  </body>
</html>
