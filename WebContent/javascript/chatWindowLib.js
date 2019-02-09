let maxZ = 99;

let windows = {};


$(document).ready(function() {

});

function popChat(from, to) {
	let windowId = from + '-' + to;
	let win = windows[windowId];
	if (win !== undefined) {
		if (win.style.zIndex < maxZ) {
			win.style.zIndex = ++maxZ;
		}
		return false;
	}
	let iframe = document.createElement('iframe');
	iframe.src = 'http://localhost:8080/MingleSC/ChatServlet?fromId=' + from + '&toId=' + to;
	iframe.height = '400';
	iframe.width = '400';
	iframe.style.zIndex = ++maxZ;
	iframe.style.position = 'fixed';
	iframe.style.top = 20 + Object.keys(windows).length * 20 + 'px';
	iframe.style.left = 20 + Object.keys(windows).length * 20 + 'px';
	$(iframe).on('load', function() {
		let closeButton = iframe.contentWindow.document.getElementById('close-btn');
		let scheduleButton = iframe.contentWindow.document.getElementById('schedule-btn');
		let bodyTag = iframe.contentWindow.document.getElementsByTagName('body')[0];
		$(bodyTag).on('mousedown', function() {
			if (iframe.style.zIndex < maxZ) {
				iframe.style.zIndex = ++maxZ;
			}
		});
		$(closeButton).on('click', function() {
			iframe.parentNode.removeChild(iframe);
			delete windows[windowId];
		});
		$(scheduleButton).on('click', function() {
			let schedule = document.createElement('iframe');
			schedule.id = 'schedule-popup';
			schedule.src = 'http://localhost:8080/MingleSC/scheduler.jsp?userID=' + from + '&targetID=' + to;
			schedule.style.zIndex = 99999;
			schedule.style.position = 'fixed';
			schedule.style.top = '20px';
			schedule.style.left = '10%';
			schedule.width = '80%';
			schedule.height = '80%';
			schedule.align = 'middle';
			document.body.appendChild(schedule);
		});
		dragElement(iframe);
	});
	document.body.appendChild(iframe);
	windows[windowId] = iframe;
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

$(document).on('click', function() {
	let schedule = document.getElementById('schedule-popup');
	if (schedule !== null) {
		schedule.parentNode.removeChild(schedule);
	}
});
