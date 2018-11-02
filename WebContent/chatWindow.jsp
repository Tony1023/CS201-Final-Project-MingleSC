<!DOCTYPE html>
<html>
<%
int id = 1;
%>
	<head>
		<title>Chat Client</title>
		<script>
			var socket;
			function connectToServer() {
				socket = new WebSocket("ws://localhost:8080/CSCI201-Final-Project/chat-ws/1/3");
				socket.onopen = function(event) {
					document.getElementById("mychat").innerHTML += "Connected!";
					socket.send("From here to there");
				}
				socket.onmessage = function(event) {
					document.getElementById("mychat").innerHTML += event.data + "<br />";
				}
				socket.onclose = function(event) {
					document.getElementById("mychat").innerHTML += "Disconnected!";
				}
			}
			function sendMessage() {
				socket.send("Miller: " + document.chatform.message.value);
				return false;
			}
		</script>
	</head>
	<body onload="connectToServer()">
		<form name="chatform" onsubmit="return sendMessage();">
			<input type="text" name="message" value="Type Here!" /><br />
			<input type="submit" name="submit" value="Send Message" />
            <input style='display: none' type='text' value='<%= id %>'>
		</form>
		<br />
		<div id="mychat"></div>
	</body>
</html>