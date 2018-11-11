package chatServer;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import resources.*;

/**
 * Servlet implementation class ChatHistoryServlet
 */
@WebServlet("/ChatHistoryServlet")
public class ChatHistoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Connection conn;
	
	static {
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
		// TODO Auto-generated method stub
	}

}
