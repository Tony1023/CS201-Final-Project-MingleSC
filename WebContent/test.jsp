<html>

<head>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
  <style>
    iframe {
        width: 400px;
        height: 600px;
    }
  </style>
</head>


<body>
  <button onclick='addiframe()'>Click to add!</button>
  <!-- <iframe id='1' src='http://localhost:8080/CSCI201-Final-Project/ChatServlet?fromId=1&toId=2'></iframe> -->
</body>

<script>
	function addiframe() {
		let iframe = document.createElement('iframe');
		iframe.src = 'http://localhost:8080/CSCI201-Final-Project/ChatServlet?fromId=1&toId=2';
		$(iframe).on('load', () => {
			console.log(iframe);
			let element = iframe.contentWindow.document.getElementById('schedule-btn');
			console.log(element);
			$(element).on('click', () => {
				console.log('clicked');
			});
		});
		document.body.appendChild(iframe);
	}
</script>

</html>