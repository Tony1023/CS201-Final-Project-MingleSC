<html>

<head>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
</head>


<body>
  <button onclick='popChat(1,2)'>Click to add!</button>
  <!-- <iframe id='1' src='http://localhost:8080/CSCI201-Final-Project/ChatServlet?fromId=1&toId=2'></iframe> -->
</body>

<script>
	function popChat(from, to) {
		let iframe = document.createElement('iframe');
		iframe.src = 'http://localhost:8080/CSCI201-Final-Project/ChatServlet?fromId=' + from + '&toId=' + to;
		iframe.height = '400';
		iframe.width = '400';
		iframe.zIndex = 99;
		iframe.style.position = 'absolute';
		$(iframe).on('load', function() {
			let closeButton = iframe.contentWindow.document.getElementById('close-btn');
			let scheduleButton = iframe.contentWindow.document.getElementById('schedule-btn');
			console.log(closeButton);
			$(closeButton).on('click', function() {
				iframe.parentNode.removeChild(iframe);
			});
			$(scheduleButton).on('click', function() {
				let schedule = document.createElement('iframe');
				schedule.id = 'schedule-popup';
				schedule.src = 'http://localhost:8080/CSCI201-Final-Project/scheduler.jsp?userID=' + from + '&targetID=' + to;
				schedule.zIndex = 999;
				schedule.style = 'height: 80%; width: 80%;';
				schedule.style.position = 'absolute';
				schedule.align = 'middle';
				$(document).on('click', function() {
					let schedule = document.getElementById('schedule-popup');
					schedule.parentNode.removeChild(schedule);
				});
				document.body.appendChild(schedule);
			});
			dragElement(iframe);
		});
		document.body.appendChild(iframe);
	}
	
	function dragElement(elmnt) {
	  const document2 = elmnt.contentWindow.document;
	  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
	  let inLeft = 0, inTop = 0;
	  document2.getElementsByClassName('chat-head')[0].onmousedown = dragMouseDown;
	  document2.getElementsByClassName('chat-head')[1].onmousedown = dragMouseDown;
	  function dragMouseDown(e) {
	    e = e || window.event;
	    e.preventDefault();
	    // get the mouse cursor position at startup:
	    pos3 = e.clientX + elmnt.offsetLeft;
	    pos4 = e.clientY + elmnt.offsetTop;
	    document2.onmouseup = closeDragElement;
	    // call a function whenever the cursor moves:
	    document2.onmousemove = elementDrag;
	  }

	  function elementDrag(e) {
  	    e = e || window.event;
  	    e.preventDefault();
  	    // calculate the new cursor position
  	    pos1 = pos3 - (e.clientX + elmnt.offsetLeft);
  	    pos2 = pos4 - (e.clientY + elmnt.offsetTop);
  	    pos3 = e.clientX + elmnt.offsetLeft;
  	    pos4 = e.clientY + elmnt.offsetTop;
  	    // set the element's new position:
  	    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  	    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
	  }

	  function closeDragElement() {
	    /* stop moving when mouse button is released:*/
	    document2.onmouseup = null;
	    document2.onmousemove = null;
	  }
	}

</script>

</html>