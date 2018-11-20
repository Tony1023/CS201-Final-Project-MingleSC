package user;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import resources.CommonResources;
import resources.Credentials;

/**
 * Servlet implementation class LoadCurrentData
 */
@WebServlet("/LoadCurrentData")
public class LoadCurrentData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoadCurrentData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		PrintWriter pw = response.getWriter();


		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		Integer userID = (Integer) session.getAttribute("currentUserID"); // TODO: change when Adam passes me this... Adam's 
		// userID = 1;
		// session.setAttribute("currentUserID", 1);
		System.out.println("id: " + userID);
		
		String screenName = "";
		String email = "";
		String password = "";
		String majorID = "";
		String housingID = "";

		// TODO: Retrieve the user
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
			String queryString = "SELECT u.email, u.screen_name, u.email, u.password, u.major_id, u.housing_id FROM user u, major m, housing h WHERE " + 
									" user_id=" + userID;
			
			ps = conn.prepareStatement(queryString);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				email = rs.getString("email");
				screenName = rs.getString("screen_name");
				password = rs.getString("password");
				majorID = rs.getString("major_id");
				housingID = rs.getString("housing_id");
				
				System.out.println("email = " + email);
				System.out.println ("password = " + password);
				System.out.println ("majorID = " + majorID);
				System.out.println("housingID = " + housingID);
			}

			session.setAttribute("email", email);
			session.setAttribute("screenName", screenName);
			session.setAttribute("userID", userID);
			session.setAttribute("password", password);
			session.setAttribute("majorID", majorID);
			session.setAttribute("housingID", housingID);

		} catch (SQLException sqle) {
			System.out.println (sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println (cnfe.getMessage());
		} finally {
			try {
				System.out.println("successfully retrieved a user");
				if (rs != null) { rs.close(); }
				if (ps != null) { ps.close(); }
				if (conn != null) { conn.close(); }
			} catch (SQLException sqle) {
				System.out.println(sqle.getMessage());
			}
		}
		
		RequestDispatcher dispatch = request.getRequestDispatcher("EditUserData.jsp");
		dispatch.forward(request, response);
	}
}
