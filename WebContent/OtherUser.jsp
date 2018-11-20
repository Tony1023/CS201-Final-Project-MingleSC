<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<% 

int current = (Integer) session.getAttribute("currentUserID");

int other= (Integer) session.getAttribute("otherUser");
// int other = 2;

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<link rel="stylesheet" type="text/css" href="OtherUser.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<title> Other User</title>
<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
<script src='javascript/chatWindowLib.js'></script>
</head>
<body>
<h1 id = "header"> USC Mingle </h1>
<p id="name"> </p>
<img id="picture" src='<%= session.getAttribute("picture") %>' height="200" width="200" >
<div id="informationbox"> 
 <h1 id="info"> Information</h1>
 
 <h2> Major </h2>
 <p id="major">  </p>

<h2> Housing</h2>
<p id="housing"> </p>

<h2> Courses</h2>
<p id="courses" > </p>

<h2> Extracurriculars</h2>
<p id="extracurricular"> </p>
<h2> Interests </h2>
<p id="interests" > </p>


<button id='btn' type="button" class="btn btn-warning" onclick='popChat(<%= current %>,<%=other%>)'>Chat Now!</button>
</div>

  

<script>
     var name= "<%=session.getAttribute("name") %>";
     document.getElementById("name").innerHTML= name;
      
	 var major= "<%=session.getAttribute("major") %>";
	 document.getElementById("major").innerHTML= major;
	 
	 var housing= "<%=session.getAttribute("housing") %>";
	 document.getElementById("housing").innerHTML= housing;
	 
	
	 <%! @SuppressWarnings("unchecked") %>
	 var c="";
	 var size=0;
	   <% ArrayList <String> courses= (ArrayList<String>) session.getAttribute("courses");
	  
	   for(int i=0; i<courses.size(); i++) 
	     { %>
	        <%if(i==(courses.size()-1))
	        { %>
	          c+= "<%= courses.get(i) %>";
	        <%} 
	        else{ %>
	       c+= "<%= courses.get(i) %>";
	    	 c+=", ";	
	       <% } %>
	    	 
	   <%   } %>
	 
	   
	  
	    console.log(c);
	    document.getElementById("courses").innerHTML=c;

	
	    var e="";
		
		   <% ArrayList <String> extracurricular= (ArrayList<String>) session.getAttribute("extracurricular");
		  
		   for(int i=0; i<extracurricular.size(); i++) 
		     { %>
		        <%if(i==(extracurricular.size()-1))
		        { %>
		          e+= "<%= extracurricular.get(i) %>";
		        <%} 
		        else{ %>
		       e+= "<%= extracurricular.get(i) %>";
		    	 e+=", ";	
		       <% } %>
		    	 
		   <%   } %>
		 
		   
		  
		    console.log(e);
		    document.getElementById("extracurricular").innerHTML=e;
		    
		    var i="";
			
			   <% ArrayList <String> interests= (ArrayList<String>) session.getAttribute("interest");
			  
			   for(int j=0; j<interests.size(); j++) 
			     { %>
			        <%if(j==(interests.size()-1))
			        { %>
			          i+= "<%= interests.get(j) %>";
			        <%} 
			        else{ %>
			       i+= "<%= interests.get(j) %>";
			    	 i+=", ";	
			       <% } %>
			    	 
			   <%   } %>
			 
			   
			  
			    console.log(i);
			    document.getElementById("interests").innerHTML=i;
	    
	  

</script>
</body>
</html>