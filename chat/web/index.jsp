<%--
  Created by IntelliJ IDEA.
  User: moyoo
  Date: 2021/1/14
  Time: 8:04 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
  <base href="<%=basePath%>">
  <title>按头小分队</title>
  <link rel="stylesheet" type="text/css" href="style.css"/>
  <link rel="shortcut icon" href="images/logo.ico" type="image/x-icon" />
</head>

<body>
<div class="bg" style="text-align:center;">
  <main>
    <h2><font style="color:#59957A;">按头小分队</font></h2>
    <div id="message" style="color:#59957A;">【状态】</div>
    <p>
      <br /> 昵称
      <input id="username" type="text" required="required"/>
      <br> 内容
      <input id="text" type="text" />
      <br />
    </p>

    <p class="btn">
      <button onclick="send()" >发送</button>
      <button onclick="closeWebSocket()" >关闭</button>
    </p>
  </main>
</div>
</body>

<script type="text/javascript">
  var websocket = null;

  //判断当前浏览器是否支持WebSocket
  if ('WebSocket' in window) {
    websocket = new WebSocket("ws://10.1.1.106:8080/Socket/websocket");
  } else {
    alert('不支持WebSocket!')
  }

  //连接发生错误的回调方法
  websocket.onerror = function() {
    setMessageInnerHTML("error");
  };

  //连接成功建立的回调方法
  websocket.onopen = function(event) {
    setMessageInnerHTML("聊天室开启");
  }

  //接收到消息的回调方法
  websocket.onmessage = function() {
    setMessageInnerHTML(event.data);
  }

  //连接关闭的回调方法
  websocket.onclose = function() {
    setMessageInnerHTML("聊天室关闭");
  }

  //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
  window.onbeforeunload = function() {
    websocket.close();
  }

  //将消息显示在网页上
  function setMessageInnerHTML(innerHTML) {
    document.getElementById('message').innerHTML += innerHTML + '<br/>';
  }

  //关闭连接
  function closeWebSocket() {
    websocket.close();
  }

  //发送消息
  function send() {
    var username = document.getElementById('username').value;
    var message = document.getElementById('text').value;
    var msg = "【" + username + "】发言:" + message
    websocket.send(msg);
  }
</script>
</html>

