<!DOCTYPE html>
<html>
<head>
<%
  String fromId = request.getParameter("fromId");
  String toId = request.getParameter("toId");
  String name = (String) request.getAttribute("name");
  String thisName = (String) request.getAttribute("thisName");
%>
  <title>Chat Client</title>
  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
  <style>
    html, body {
        margin: 0;
        background-color: white;
    }
    textarea {
        background: rgba(0, 0, 0, 0);
        border: none;
        padding: 0;
        margin: 0;
        resize: none;
        display: block;
    }
    #chat-wrapper, #history-wrapper {
        height: 100vh;
    }
    .chat-head {
        border: 1px solid black;
        height: 40px;
        cursor: move;
    }
    #chat-message-area {
        height: calc(100% - 148px);
        border: 1px solid black;
        overflow: scroll;
    }
    #chat-history-area {
        height: calc(100% - 86px);
        border: 1px solid black;
        overflow: scroll;
    }
    #chat-send-box {
        width: calc(100% - 12px);
        height: 50px;
        border: 1px solid black;
        padding: 5px;
        font-size: 1em;
        font-family: courier;
        overflow: scroll;
    }
    .chat-bottom {
        border: 1px solid black;
        height: 40px;
    }
    .bottom-btn {
        width: 65px;
        height: 20px;
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
    .clearFloat {
        clear: both;
    }
    #close-btn {
        cursor: pointer;
        width: 30px;
        float: right;
        display: block;
        z-index: 5;
    }
  </style>
</head>

<body onload="connectToServer();">
  <div id='chat-wrapper'>
    <div class='chat-head'>
      <div style='margin-top: 10px; display: inline-block;'>Chat with <%=name %></div>
      <img id='close-btn' src='close.png'>
    </div>
    
    <div id='chat-message-area'>
    </div>
    
    <textarea id='chat-send-box' placeholder='Press Enter to send; press Shift+Enter to insert line break...'></textarea>
    
    <div class='chat-bottom'>
      <button class='bottom-btn' onclick='sendMessage();'>Send</button>
      <button class='bottom-btn' onclick='showHistory();'>History</button>
      <button id='schedule-btn' class='bottom-btn'>Schedule</button>
      <div class='clearFloat'></div>
    </div>
  </div>
  
  <div id='history-wrapper' style='display: none;'>
    <div class='chat-head'>
      <div style='margin-top: 10px; display: inline-block;'>Chat with <%=name %></div>
    </div>
    <div id='chat-history-area'></div>
    <div class='chat-bottom'>
      <button class='bottom-btn' onclick='showChat();'>Go Back</button>
    </div>
  </div>
  <script>
  	let shiftPressed = false;
  	$('#chat-send-box').on('keydown', function(e) {
  		if (e.key === 'Enter') {
  			if (!shiftPressed) {
    			e.preventDefault();
    			sendMessage();
  			}
  		}
  		if (e.key === 'Shift') {
  			shiftPressed = true;
  		}
  	});
  	$('#chat-send-box').on('keyup', function(e) {
  		if (e.key === 'Shift') {
  			shiftPressed = false;
  		}
  	});
    var socket;
    let messageArea = document.getElementById('chat-message-area');
    
    function connectToServer() {
        socket = new WebSocket("ws://localhost:8080/MingleSC/chat-ws/<%=fromId%>/<%=toId%>");
        socket.onmessage = function(event) {
        	messageArea.innerHTML += makeHtmlBlock(JSON.parse(event.data));
        	updateScroll();
        }
    }
    
    function sendMessage() {
		let box = document.getElementById('chat-send-box');
		if (box.value === '') {
			// add alerts
			return false;
		}
		socket.send(box.value);
		let json = {
			message: box.value,
			time: new Date().getTime()
		}
		messageArea.innerHTML += makeThisHtmlBlock(json);
		box.value = '';
		updateScroll();
    }
    
    function makeHtmlBlock(message) {
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
          <font color='green'><%=thisName%> on " + timeStr + "</font><br> \
          <div class='message-body'>" + message.message + "</div> \
          </div>"
      	return html;
    }
    
    function updateScroll() {
    	let page = document.getElementById("chat-message-area");
    	page.scrollTop = page.scrollHeight;
    }
    
    function showHistory() {
    	$('#chat-wrapper').css('display', 'none');
    	$('#history-wrapper').css('display', 'block');
    	if (messageId === undefined) {
    		fetchHistory();
    	}
    }
    
    function showChat() {
    	$('#chat-wrapper').css('display', 'block');
    	$('#history-wrapper').css('display', 'none');
    }
    
    let messageId = undefined;
    let hasMore = true;
	let $area = $('#chat-history-area');
    
    function fetchHistory(id) {
    	$.post('FetchChatHistoryServlet', {
    		toId: <%= toId %>,
    		fromId: <%= fromId %>,
            lastMessageId: id
    	}, function(res) {
			let data = JSON.parse(res);
			messageId = data.lastId;
			hasMore = data.hasMore;
			let messages = data.messages;
			// record scroll
			let first = $('#chat-history-area .message:first');
			for (let i = messages.length - 1; i >= 0; --i) {
				if (messages[i].fromId === <%= fromId %>) {
					$area.prepend(makeThisHtmlBlock(messages[i]));
				} else {
					$area.prepend(makeHtmlBlock(messages[i]));
				}
			}
			
			// reset scroll
			if (first.offset() !== undefined) {
				$area.scrollTop(first.offset().top);
			} else if (id === undefined) {// first load
				let page = document.getElementById('chat-history-area');
				page.scrollTop = page.scrollHeight;
			}
		});
    }
    
    $area.on('wheel', function() {
		if ($area.scrollTop() === 0 || $area.scrollTop() === undefined) { // reached top
			if (hasMore) {
				fetchHistory(messageId);
			}
		}
    });
    
    $(document).ajaxError(function(e, err) { console.log(err.responseText) });
  </script>
</body>
</html>