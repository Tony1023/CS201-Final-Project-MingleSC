package chatServer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
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
import resources.CommonResources;
import resources.Credentials;

@ServerEndpoint(value = "/chat-ws/{from}/{to}")
public class ChatWebSocketServer
{
	private static Map<Integer, ConcurrentHashMap<Integer, Session>> sessionMap = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, Session>> (); // from i to j
	private static Map<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>> unsentMessages = new ConcurrentHashMap<Integer, ConcurrentHashMap<Integer, ConcurrentLinkedQueue<ChatMessage>>>();
	private static Map<Integer, PreparedStatement> statements = new ConcurrentHashMap<Integer, PreparedStatement>();
	private static Connection conn;
	
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
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
		
		try {
			if (statements.get(from) == null) {
				PreparedStatement ps = conn.prepareStatement("INSERT INTO chat_messages(sending_user_id, receiving_user_id, message_time, message_body) VALUE (?,?,?,?)");
				ps.setInt(1, from);
				statements.put(from, ps);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
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
		ChatMessage cm = new ChatMessage(message, from, to, System.currentTimeMillis());
		// put into database
		PreparedStatement ps = statements.get(from);
		try {
			ps.setInt(2, to);
			ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			ps.setString(4, message);
			ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Map<Integer, Session> m = sessionMap.get(to);
		if (m != null && m.get(from) != null && m.get(from).isOpen()) {
			Session s = m.get(from);
			s.getAsyncRemote().sendText(cm.jsonStringify());
		} else { // the other connection not open, store it to send in the future
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
		try {
			throw error;
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}