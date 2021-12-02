import './App.css';
import React, { useEffect, useState } from 'react';

function App() {
	const [message, setmessage] = useState('Subscribe to the /logs topic');
	useEffect(() => {
		const ws = new WebSocket('ws://localhost:9090');
		ws.onopen = () => {
			ws.send(
				JSON.stringify({
					op: 'subscribe',
					topic: '/logs',
					type: 'std_msgs/String',
				})
			);
			console.log('connected');
		};
		ws.onmessage = (event) => {
			// console.log(event);
			setmessage(event.data);
		};
		ws.onclose = () => {
			console.log('WebSocket is closed now.');
		};
		return (ws) => {
			ws.close();
		};
	}, []);
	return <div className="App">{message}</div>;
}

export default App;
