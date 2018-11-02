package chatServer;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chat-ws/{from}/{to}")
public class ChatWebSocketServer {

	private static Map<Integer, ConcurrentHashMap<Integer, Session>> sessionMap = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, Session>> (); // from i to j
	private static Map<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>> unsentMessages = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>>();
	
	@OnOpen
	public void open(@PathParam("from") Integer from, @PathParam("to") Integer to, Session session) {
		System.out.println(from + " TO " + to);
		ConcurrentHashMap<Integer, Session> m = sessionMap.get(from);
		if (m == null) {
			m = new ConcurrentHashMap<Integer, Session>();
			sessionMap.put(from, m);
		}
		Session s = m.get(to);
		if (s != null && s.isOpen()) {
			try {
				s.close();
			} catch (IOException e) {
				System.out.println("OnOpen ioe: " + e.getMessage());
			}
		}
		m.put(to, session);
		
		// sending unsent messages
		
	}
	
	@OnMessage
	public void onMessage(@PathParam("from") Integer from, @PathParam("to") Integer to, String message, Session session) {
		System.out.println(message);
		
	}
	
	@OnClose
	public void close(@PathParam("from") Integer from, @PathParam("to") Integer to, Session session) {
		
	}
	
	@OnError
	public void error(Throwable error) {
		System.out.println("Error!");
	}
}