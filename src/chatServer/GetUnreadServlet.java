package chatServer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import resources.CommonResources;
import resources.Credentials;

/**
 * Servlet implementation class GetUnreadServlet
 */
@WebServlet("/GetUnreadServlet")
public class GetUnreadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Connection conn;
	private static String psString;
    
    static {
    	psString = "SELECT DISTINCT sending_user_id "
    				+ "FROM chat_messages "
    				+ "WHERE receiving_user_id=? AND message_read=0";
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
		Integer id = Integer.parseInt(request.getParameter("thisId"));
		List<String> ids = new ArrayList<String>();
		try {
			PreparedStatement ps = conn.prepareStatement(psString);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				ids.add(new Integer(rs.getInt(1)).toString());
				System.out.println(rs.getInt(1));
			}
		} catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		String res = String.join(",", ids);
		PrintWriter pw = response.getWriter();
		pw.write(res);
		pw.flush();
	}

}
