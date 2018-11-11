package chatServer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.*;

import resources.CommonResources;
import resources.Credentials;

/**
 * Servlet implementation class ChatHistoryServlet
 */
@WebServlet("/FetchChatHistoryServlet")
public class FetchChatHistoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Connection conn;
	private static String psString;
		
	static {
		psString = "SELECT * FROM ("
				+ "SELECT * FROM chat_messages "
				+ "WHERE message_time < ? AND (sending_user_id=? AND receiving_user_id=? OR receiving_user_id=? AND sending_user_id=?)"
				+ "ORDER BY message_time DESC LIMIT 10"
				+ ") AS sub ORDER BY message_time ASC";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
		} catch (ClassNotFoundException cnfe) {
			cnfe.printStackTrace();
		} catch (SQLException sqle) {
			sqle.printStackTrace();
		}
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Integer messageId;
		List<ChatMessage> resultMessages = new ArrayList<ChatMessage>();
		String error = null;
		boolean hasMore = true;
		int earliestId = 0;
		try {
			int toId = Integer.parseInt(request.getParameter("toId"));
			int fromId = Integer.parseInt(request.getParameter("fromId"));
			if (request.getParameter("lastMessageId") == null || request.getParameter("lastMessageId").equals("null")) {
				messageId = null;
			} else {
				messageId = Integer.parseInt(request.getParameter("lastMessageId"));
			}
			Timestamp time = null;
			if (messageId != null) {
				PreparedStatement timeQuery = conn.prepareStatement("SELECT * from chat_messages WHERE message_id=?");
				timeQuery.setInt(1, messageId);
				ResultSet timeRes = timeQuery.executeQuery();
				if (timeRes.next()) {
					int id1 = timeRes.getInt(2);
					int id2 = timeRes.getInt(3);
					if ((toId != id1 || fromId != id2) && (toId != id2 || fromId != id1)) {
						throw new Exception("message_id not referring to correct conversation");
					}
					time = timeRes.getTimestamp(4);
				} else {
					throw new Exception("message_id invalid");
				}
			} else {
				time = new Timestamp(System.currentTimeMillis());
			}
			
			PreparedStatement ps = conn.prepareStatement(psString);
			ps.setTimestamp(1, time);
			ps.setInt(2, fromId);
			ps.setInt(3, toId);
			ps.setInt(4, fromId);
			ps.setInt(5, toId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				earliestId = rs.getInt(1);
				resultMessages.add(new ChatMessage(rs.getString(5), rs.getInt(2), rs.getInt(3), rs.getTimestamp(4).getTime()));
			} else {
				hasMore = false;
				earliestId = 0;
			}
			while (rs.next()) {
				resultMessages.add(new ChatMessage(rs.getString(5), rs.getInt(2), rs.getInt(3), rs.getTimestamp(4).getTime()));
			}
		} catch (SQLException sqle) {
			sqle.printStackTrace();
		} catch (NumberFormatException nfe) {
			System.out.println(nfe.getMessage());
			error = "user_id invalid";
			response.setStatus(400);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			response.setStatus(400);
			error = e.getMessage();
		}
		
		int resStatus = response.getStatus();
		PrintWriter out = response.getWriter();
		if (resStatus == 400) {
			out.println(error);
		} else {
			response.setStatus(200);
			out = response.getWriter();
			Gson gson = new Gson();
			JsonObject res = new JsonObject();
			JsonElement messages = gson.toJsonTree(resultMessages);
			res.addProperty("lastId", earliestId);
			res.addProperty("hasMore", hasMore);
			res.add("messages", messages);
			System.out.println(res);
			out.println(res);
		}
		out.flush();
		out.close();
	}

}
