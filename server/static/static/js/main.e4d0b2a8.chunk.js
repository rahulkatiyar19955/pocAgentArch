(this["webpackJsonppoc-agent"]=this["webpackJsonppoc-agent"]||[]).push([[0],{10:function(e,n,t){},12:function(e,n,t){"use strict";t.r(n);var o=t(0),c=t.n(o),s=t(3),i=t.n(s),u=(t(9),t(4)),r=(t(10),t(1));var a=function(){var e=Object(o.useState)("Subscribe to the /logs topic"),n=Object(u.a)(e,2),t=n[0],c=n[1];return Object(o.useEffect)((function(){var e=new WebSocket("ws://localhost:9090");return e.onopen=function(){e.send(JSON.stringify({op:"subscribe",topic:"/logs",type:"std_msgs/String"})),console.log("connected")},e.onmessage=function(e){c(e.data)},e.onclose=function(){console.log("WebSocket is closed now.")},function(e){e.close()}}),[]),Object(r.jsx)("div",{className:"App",children:t})},l=function(e){e&&e instanceof Function&&t.e(3).then(t.bind(null,13)).then((function(n){var t=n.getCLS,o=n.getFID,c=n.getFCP,s=n.getLCP,i=n.getTTFB;t(e),o(e),c(e),s(e),i(e)}))};i.a.render(Object(r.jsx)(c.a.StrictMode,{children:Object(r.jsx)(a,{})}),document.getElementById("root")),l()},9:function(e,n,t){}},[[12,1,2]]]);
//# sourceMappingURL=main.e4d0b2a8.chunk.js.map