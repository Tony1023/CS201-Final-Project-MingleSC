<!DOCTYPE html>
<html>
<head>
<%
  String fromId = request.getParameter("fromId");
  String toId = request.getParameter("toId");
%>
  <title>Chat Client</title>
  <style>
    html, body {
        margin: 0;
    }
    body {
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
    #clearFloat {
        clear: both;
    }
  </style>
</head>

<body onload="connectToServer();">
  <div id='chat-wrapper'>
    <div id='chat-head'>
      Chat with <%=toId%>
    </div>
    
    <div id='chat-message-area'>
    </div>
    
    <div id='chat-send-box' contenteditable>
    </div>
    
    <div id='chat-bottom'>
      <button class='bottom-btn' onclick='sendMessage();'>Send</button>
      <div class='clearFloat'></div>
    </div>
  </div>
  <script>
    var socket;
    var messageArea = document.getElementById('chat-message-area');
    function connectToServer() {
        socket = new WebSocket("ws://localhost:8080/CSCI201-Final-Project/chat-ws/<%=fromId%>/<%=toId%>");
        socket.onopen = function(event) { }
        socket.onmessage = function(event) {
        	messageArea.innerHTML += (event.data + '\n');
        }
        socket.onclose = function(event) {
        }
    }
    function sendMessage() {
		let box = document.getElementById('chat-send-box');
		socket.send(box.innerHTML);
		box.innerHTML = '';
    }
  </script>
</body>
</html>