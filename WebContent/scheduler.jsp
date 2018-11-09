<%
  int userID = 1;
  int targetID = 2;
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title> Scheduler </title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">
    <style>
    	table td {
    		text-align: center;
    	}
    </style>
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
		        <td id="slot_1"> </td>
		        <td id="slot_2"> </td>
		        <td id="slot_3"> </td>
		       	<td id="slot_4"> </td>
		        <td id="slot_5"> </td>
		        <td id="slot_6"> </td>
		        <td id="slot_7"> </td>
		    </tr>
		    <tr>
		    	<th> 12:30 am </th>
		        <td id="slot_8"> </td>
		        <td id="slot_9"> </td>
		        <td id="slot_10"> </td>
		       	<td id="slot_11"> </td>
		        <td id="slot_12"> </td>
		        <td id="slot_13"> </td>
		        <td id="slot_14"> </td>
		    </tr>
	      	<% for(int i=1; i<12; i++) {%>
		        <tr>
		          <th> <%= i %>:00 am </th>
		          <td id="slot_<%= 14*i + 1 %>"> </td>
		          <td id="slot_<%= 14*i + 2 %>"> </td>
		          <td id="slot_<%= 14*i + 3 %>"> </td>
		          <td id="slot_<%= 14*i + 4 %>"> </td>
		          <td id="slot_<%= 14*i + 5 %>"> </td>
		          <td id="slot_<%= 14*i + 6 %>"> </td>
		          <td id="slot_<%= 14*i + 7 %>"> </td>
		        </tr>
		        <tr>
		          <th> <%= i %>:30 am </th>
		          <td id="slot_<%= 14*i + 8 %>"> </td>
		          <td id="slot_<%= 14*i + 9 %>"> </td>
		          <td id="slot_<%= 14*i + 10%>"> </td>
		          <td id="slot_<%= 14*i + 11 %>"> </td>
		          <td id="slot_<%= 14*i + 12 %>"> </td>
		          <td id="slot_<%= 14*i + 13 %>"> </td>
		          <td id="slot_<%= 14*i + 14 %>"> </td>
		        </tr>
		    <% } %>
		    <tr>
		    	<th> 12:00 pm </th>
		        <td id="slot_169"> </td>
		        <td id="slot_170"> </td>
		        <td id="slot_171"> </td>
		       	<td id="slot_172"> </td>
		        <td id="slot_173"> </td>
		        <td id="slot_174"> </td>
		        <td id="slot_175"> </td>
		    </tr>
		    <tr>
		    	<th> 12:30 pm </th>
		        <td id="slot_176"> </td>
		        <td id="slot_177"> </td>
		        <td id="slot_178"> </td>
		       	<td id="slot_179"> </td>
		        <td id="slot_180"> </td>
		        <td id="slot_181"> </td>
		        <td id="slot_182"> </td>
		    </tr>
		    <% for(int i=1; i<12; i++) {%>
		        <tr>
		          <th> <%= i %>:00 pm </th>
		          <td id="slot_<%= 14*i + 169 %>"> </td>
		          <td id="slot_<%= 14*i + 170 %>"> </td> 
		          <td id="slot_<%= 14*i + 171 %>"> </td>
		          <td id="slot_<%= 14*i + 172 %>"> </td>
		          <td id="slot_<%= 14*i + 173 %>"> </td>
		          <td id="slot_<%= 14*i + 174 %>"> </td>
		          <td id="slot_<%= 14*i + 175 %>"> </td>
		        </tr>
		        <tr>
		          <th> <%= i %>:30 pm </th>
		          <td id="slot_<%= 14*i + 176 %>"> </td>
		          <td id="slot_<%= 14*i + 177 %>"> </td>
		          <td id="slot_<%= 14*i + 178 %>"> </td>
		          <td id="slot_<%= 14*i + 179 %>"> </td>
		          <td id="slot_<%= 14*i + 180 %>"> </td>
		          <td id="slot_<%= 14*i + 181 %>"> </td>
		          <td id="slot_<%= 14*i + 182 %>"> </td>
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
						let overlap = this.responseText;
						console.log(overlap);
						for(let i=0; i<overlap.length; i++) {
							if(overlap.charAt(i) == 1) {
								let slotID = "slot_" + i;
								document.getElementById(slotID).innerHTML = "<i class='fas fa-map-marker-alt'></i>";
							}
						}
					}
				}
			}
			xhttp.send("userID=" + <%= userID %> + "&targetID=" + <%= targetID %>);
		});
    </script>
  </body>
</html>
