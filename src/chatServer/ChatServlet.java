package chatServer;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import resources.*;

import java.sql.*;

/**
 * Servlet implementation class ChatServlet
 */
@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {
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
		Integer id = Integer.parseInt(request.getParameter("toId"));
		Integer thisId = (Integer) request.getSession().getAttribute("currentUserID");
		String name = null;
		String thisName = null;
		try {
			PreparedStatement ps = conn.prepareStatement("SELECT screen_name FROM user WHERE user_id=?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {				
				name = rs.getString(1);
			}
			ps.setInt(1, thisId);
			rs = ps.executeQuery();
			while (rs.next()) {
				thisName = rs.getString(1);
			}
		} catch (SQLException sqle) {
			sqle.printStackTrace();
			name = "USCer";
		}
		request.setAttribute("name", name);
		request.setAttribute("thisName", thisName);
		getServletContext().getRequestDispatcher("/WEB-INF/chatWindow.jsp").forward(request, response);
	}

}
