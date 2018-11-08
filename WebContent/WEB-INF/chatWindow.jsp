<!DOCTYPE html>
<html>
<head>
<%
  String fromId = request.getParameter("fromId");
  String toId = request.getParameter("toId");
  String name = (String) request.getAttribute("name");
%>
  <title>Chat Client</title>
  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
  <style>
    html, body {
        margin: 0;
    }
    textarea {
        background: rgba(0, 0, 0, 0);
        border: none;
        padding: 0;
        margin: 0;
        resize: none;
        display: block;
    }
    #chat-wrapper {
        height: 100vh;
        
    }
    #chat-head {
        border: 1px solid black;
        height: 30px;
    }
    #chat-message-area {
        height: calc(100% - 188px);
        border: 1px solid black;
        overflow: scroll;
    }
    #chat-send-box {
        width: calc(100% - 12px);
        height: 100px;
        border: 1px solid black;
        padding: 5px;
        font-size: 2em;
        font-family: courier;
        overflow: scroll;
    }
    #chat-bottom {
        border: 1px solid black;
        height: 40px;
    }
    .bottom-btn {
        float: right;
        border: 1px solid black;
    }
    .message {
        padding: 10px;
    }
    .message-body {
        resize: none;
        width: 100%;
        height: auto;
        white-space: pre;
    }
    #clearFloat {
        clear: both;
    }
  </style>
</head>

<body onload="connectToServer();">
  <div id='chat-wrapper'>
    <div id='chat-head'>
      Chat with <%=name%>
    </div>
    
    <div id='chat-message-area'>
    </div>
    
    <textarea id='chat-send-box' placeholder='Hi!...'></textarea>
    
    <div id='chat-bottom'>
      <button class='bottom-btn' onclick='sendMessage();'>Send</button>
      <div class='clearFloat'></div>
    </div>
  </div>
  <script>
    var socket;
    let messageArea = document.getElementById('chat-message-area');
    
    function connectToServer() {
        socket = new WebSocket("ws://localhost:8080/CSCI201-Final-Project/chat-ws/<%=fromId%>/<%=toId%>");
        socket.onmessage = function(event) {
        	messageArea.innerHTML += makeHtmlBlock(event.data);
        }
    }
    
    function sendMessage() {
		let box = document.getElementById('chat-send-box');
		socket.send(box.value);
		let json = {
			message: box.value,
			time: new Date().getTime()
		}
		messageArea.innerHTML += makeThisHtmlBlock(json);
		box.value = '';
    }
    
    function makeHtmlBlock(json) {
    	let message = JSON.parse(json);
    	let time = new Date(message.time);
    	let timeStr = time.toLocaleString();
    	let html = "<div class='message'> \
          <font color='blue'><%=name%> on " + timeStr + "</font><br> \
          <div class='message-body'>" + message.message + "</div> \
          </div>"
      	return html;
    }
    function makeThisHtmlBlock(message) {
    	let time = new Date(message.time);
    	let timeStr = time.toLocaleString();
    	let html = "<div class='message'> \
          <font color='green'><%=name%> on " + timeStr + "</font><br> \
          <div class='message-body'>" + message.message + "</div> \
          </div>"
      	return html;
    }
  </script>
</body>
</html>