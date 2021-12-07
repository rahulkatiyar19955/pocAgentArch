const express = require('express');
var tool = require('./websocket/index.js');
const app = express();
var expressWs = require('express-ws')(app);
const WebSocket = require('ws');

const wss = new WebSocket('ws://localhost:9090');

wss.on('open', function open() {
	//   wss.send('something');
	console.log('connected');
});

wss.on('message', function incoming(data) {
	console.log(data);
});

// port
const port = 3050;

app.get('/', (req, res) => {
	res.send('Webserver is running');
});

app.ws('/', function (ws, req) {
	ws.on('message', function (msg) {
		console.log(msg);
		try {
			recMsg = JSON.parse(msg);
			if (
				recMsg.token != undefined &&
				recMsg.token != null &&
				recMsg.token === 'secret'
			) {
				wss.send(msg);
				ws.send('received: ' + msg);
			} else {
				ws.send('invalid token');
			}
		} catch (e) {
			console.log('invalid json');
		}
	});
	// console.log('socket', req);
});

tool(app);

app.listen(port, () => {
	console.log(`Example app listening at http://localhost:${port}`);
});
