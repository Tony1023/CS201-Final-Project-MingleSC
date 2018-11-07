package chatServer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.*;
import java.util.Map;
import java.util.Queue;
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
public class ChatWebSocketServer
{
	private static final String SQL_CONNECTION = "jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=root&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
	private static Map<Integer, ConcurrentHashMap<Integer, Session>> sessionMap = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, Session>> (); // from i to j
	private static Map<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>> unsentMessages = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>>();
	private static Connection conn;
	private static PreparedStatement recordMessage;
	
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(SQL_CONNECTION);
			recordMessage = conn.prepareStatement("INSERT INTO chat_messages(sending_user_id, receiving_user_id, message_time, message_body) VALUE (?,?,?,?)");
		} catch (SQLException sqle) {
			System.out.println(sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println(cnfe.getMessage());
		}
	}
	
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
		try {
			Queue<ChatMessage> queue = unsentMessages.get(to).get(from);
			while (!queue.isEmpty()) {
				session.getBasicRemote().sendText(queue.poll().jsonStringify());
			}
		} catch (NullPointerException npe) {
			System.out.println("No messages waiting to be sent");
		} catch (IOException ioe) {
			System.out.println("ioe in onopen: " + ioe.getMessage());
		}
	}
	
	@OnMessage
	public void onMessage(@PathParam("from") Integer from, @PathParam("to") Integer to, String message, Session session) {
		System.out.println(message);
		ChatMessage cm = new ChatMessage(message, from, to, System.currentTimeMillis());
		// put into database
		Map<Integer, Session> m = sessionMap.get(to);
		Session s = m.get(from);
		if (s != null && s.isOpen()) {
			s.getAsyncRemote().sendText(cm.jsonStringify());
		} else {
			ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>> targetMap = unsentMessages.get(from);
			ConcurrentLinkedQueue<ChatMessage> targetQueue = null;
			if (targetMap == null) {
				targetMap = new ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>();
				targetQueue = new ConcurrentLinkedQueue<ChatMessage>();
			} else {
				targetQueue = targetMap.get(to);
				if (targetQueue == null) {
					targetQueue = new ConcurrentLinkedQueue<ChatMessage>();
				}
			}
			unsentMessages.putIfAbsent(from, targetMap);
			targetMap.putIfAbsent(to, targetQueue);
			targetQueue.add(cm);
		}
	}
	
	@OnClose
	public void close(@PathParam("from") Integer from, @PathParam("to") Integer to, Session session) {
		System.out.println(from + " TO " + to + " shut down.");
	}
	
	@OnError
	public void error(Throwable error) {
		System.out.println("Error!");
	}
}