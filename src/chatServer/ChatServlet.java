package chatServer;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 * Servlet implementation class ChatServlet
 */
@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Connection conn;
	private static final String SQL_CONNECTION = "jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=root&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

	
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(SQL_CONNECTION);
		} catch (SQLException sqle) {
			System.out.println(sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println(cnfe.getMessage());
		}
	}
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("name", "Foo"); // fetch from database
		getServletContext().getRequestDispatcher("/WEB-INF/chatWindow.jsp").forward(request, response);
	}

}
