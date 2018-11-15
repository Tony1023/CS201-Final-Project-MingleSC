<%
  String userID = request.getParameter("userID");
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title> Scheduler </title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">
    <style>
    	#mainContainer {
    		width: 50%;
    		height: 50%;
    		margin-top: 30px;
    	}
    	
    	#errorBlock {
    		display: none;
    	}
    	
    	#tableContainer {
    		width: 100%;
    		height: 500px;
    		overflow-y: scroll;
    	}
    	
    	table td {
    		text-align: center;
    	}
    	
		#title {
		    margin-top: auto;
		    margin-bottom: auto;
		}
    	
    	#headContainer {
    		width: 100%;
    		display: flex;
    		justify-content: space-between;
    		padding-top: 10px;
    		padding-bottom: 10px;
    	}
    	
    	.slot_selected {
    		color: green;
    	}
    	
    	#successBlock {
    		display: none;
    	}
    </style>
  </head>
  <body>
  	<div id="mainContainer" class="container">
  		<div id="headContainer">
  			<h1 id="title" class="title"> Scheduler </h1>
  			<div>
  				<a id="submitButton" class="button is-info is-outlined"> Submit </a>
  				<a id="toLoadUser" class="button is-info is-outlined" href="SchedulerToLoadUser?userID=<%= userID %>"> Profile </a>
  			</div>
  		</div>
  		<div id="successBlock" class="notification is-success">
		  <button id="closeSuccess" class="delete"></button>
		  Successfully updated availability preferences.
		</div>
	    <div id="tableContainer">
		    <table class="table is-bordered is-fullwidth is-striped is-hoverable">
		      <thead id="tableHeaders">
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
			        <td id="slot_1"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_2"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_3"> <i class="far fa-check-circle"></i> </td>
			       	<td id="slot_4"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_5"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_6"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_7"> <i class="far fa-check-circle"></i> </td>
			    </tr>
			    <tr>
			    	<th> 12:30 am </th>
			        <td id="slot_8"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_9"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_10"> <i class="far fa-check-circle"></i> </td>
			       	<td id="slot_11"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_12"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_13"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_14"> <i class="far fa-check-circle"></i> </td>
			    </tr>
		      	<% for(int i=1; i<12; i++) {%>
			        <tr>
			          <th> <%= i %>:00 am </th>
			          <td id="slot_<%= 14*i + 1 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 2 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 3 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 4 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 5 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 6 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 7 %>"> <i class="far fa-check-circle"></i> </td>
			        </tr>
			        <tr>
			          <th> <%= i %>:30 am </th>
			          <td id="slot_<%= 14*i + 8 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 9 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 10%>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 11 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 12 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 13 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 14 %>"> <i class="far fa-check-circle"></i> </td>
			        </tr>
			    <% } %>
			    <tr>
			    	<th> 12:00 pm </th>
			        <td id="slot_169"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_170"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_171"> <i class="far fa-check-circle"></i> </td>
			       	<td id="slot_172"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_173"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_174"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_175"> <i class="far fa-check-circle"></i> </td>
			    </tr>
			    <tr>
			    	<th> 12:30 pm </th>
			        <td id="slot_176"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_177"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_178"> <i class="far fa-check-circle"></i> </td>
			       	<td id="slot_179"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_180"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_181"> <i class="far fa-check-circle"></i> </td>
			        <td id="slot_182"> <i class="far fa-check-circle"></i> </td>
			    </tr>
			    <% for(int i=1; i<12; i++) {%>
			        <tr>
			          <th> <%= i %>:00 pm </th>
			          <td id="slot_<%= 14*i + 169 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 170 %>"> <i class="far fa-check-circle"></i> </td> 
			          <td id="slot_<%= 14*i + 171 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 172 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 173 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 174 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 175 %>"> <i class="far fa-check-circle"></i> </td>
			        </tr>
			        <tr>
			          <th> <%= i %>:30 pm </th>
			          <td id="slot_<%= 14*i + 176 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 177 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 178 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 179 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 180 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 181 %>"> <i class="far fa-check-circle"></i> </td>
			          <td id="slot_<%= 14*i + 182 %>"> <i class="far fa-check-circle"></i> </td>
			        </tr>
			    <% } %>
		      </tbody>
		    </table>
	    </div>
  	</div>
    
    <script>
	   for(let i=1; i<=336; i++) {
		   document.getElementById("slot_"+i).onclick = function () {
			 console.log("Slot " + i + " clicked!");
			 document.getElementById("slot_"+i).classList.toggle("slot_selected");
		   };
	   }
	   
	   document.getElementById("submitButton").onclick = function() {
		   let availability = "";
		   for(let i=1; i<=336; i++) {
			 if(document.getElementById("slot_"+i).classList.contains("slot_selected")) {
				 availability += "1";
			 } else {
				 availability += "0";
			 }
		   }
		   
		   console.log(availability);
		   console.log(availability.length);
		   
		   let xhttp = new XMLHttpRequest();
			xhttp.open("POST", "UpdateScheduleServlet", true);
			xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			xhttp.onreadystatechange = function() {
				if(xhttp.readyState == 4 && xhttp.status == 200) {
					if(this.responseText != null && this.responseText != "") {
						let res = this.responseText;
						if(res == "Success") {
							document.getElementById("successBlock").style.display = "block";
						}
					}
				}
			}
			xhttp.send("userID=" + <%= userID %> + "&availability=" + availability);
	   }
	   
	   document.getElementById("closeSuccess").onclick = function() {
	    	console.log("Close Success");
	    	document.getElementById("successBlock").style.display = "none";
	    }
    </script>
  </body>
</html>
