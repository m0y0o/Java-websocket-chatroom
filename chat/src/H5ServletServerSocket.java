import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;



@ServerEndpoint("/websocket")
public class H5ServletServerSocket {
 private static int onlineCount = 0;

 private static CopyOnWriteArraySet<H5ServletServerSocket> webSocketSet = new CopyOnWriteArraySet<H5ServletServerSocket>();

 private Session session;


 @OnOpen
 public void onOpen(Session session) {
  this.session = session;
  webSocketSet.add(this);
  addOnlineCount();
  System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
 }

 @OnClose
 public void onClose() {
  webSocketSet.remove(this);
  subOnlineCount();
  System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
 }

 /**
 * 收到客户端消息后调用的方法
 * 
 * @param message
 *   客户端发送过来的消息
 * @param session
 *   可选的参数
 */
 @OnMessage
 public void onMessage(String message, Session session) {
  System.out.println("来自客户端的消息:" + message);
  for (H5ServletServerSocket item : webSocketSet) {
   try {
    item.sendMessage(message);
   } catch (IOException e) {
    e.printStackTrace();
    continue;
   }
  }
 }

 /**
 * 发生错误时调用
 * 
 * @param session
 * @param error
 */
 @OnError
 public void onError(Session session, Throwable error) {
  System.out.println("发生错误");
  error.printStackTrace();
 }

 /**
 * 这个方法与上面几个方法不一样。没有用注解，是根据自己需要添加的方法。
 * 
 * @param message
 * @throws IOException
 */
 public void sendMessage(String message) throws IOException {
 this.session.getBasicRemote().sendText(message);
 // this.session.getAsyncRemote().sendText(message);
 }

 public static synchronized int getOnlineCount() {
 return onlineCount;
 }

 public static synchronized void addOnlineCount() {
 H5ServletServerSocket.onlineCount++;
 }

 public static synchronized void subOnlineCount() {
 H5ServletServerSocket.onlineCount--;
 }
}
