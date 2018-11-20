
package user;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import resources.*;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Servlet implementation class BlockUser
 */
@WebServlet("/BlockUser")
public class BlockUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BlockUser() {
        super();
        System.out.println("in constructor");
        // TODO Auto-generated constructor stub
    }


    public void init(ServletConfig config) throws ServletException {
    	super.init(config);
    	System.out.println("in init");
    }


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	// Retrieve the user
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("in GET...");

		
		if (request.getParameter("userToBlockID") != null) {
			HttpSession session = request.getSession();
			PrintWriter pw = response.getWriter();


			Integer userID = (Integer) session.getAttribute("currentUserID"); // TODO: change when Adam passes me this... Adam's 
			System.out.println("id: " + userID);

			Integer userToBlockID = Integer.parseInt(request.getParameter("userToBlockID"));
			System.out.println("userToBlock: " + userToBlockID);


			// Also need to add the event to the database...
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			// thisEmailID for current session

			String updateString = "UPDATE blocks SET block_status=1 WHERE blocking_user_id=" + userID + " AND blocked_user_id=" + userToBlockID + "";

			String secondaryUpdateString = "INSERT INTO blocks(blocking_user_id, blocked_user_id, block_status) values(" + userID + ", " + userToBlockID + ", " + 1 + ");";
			
			System.out.println(updateString);

			try {
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);

				System.out.println(updateString);
				ps = conn.prepareStatement(updateString);
				int result = ps.executeUpdate();
				if (result == 0) {
					ps = conn.prepareStatement(secondaryUpdateString);
					result = ps.executeUpdate();
				}
				
			} catch (SQLException sqle) {
				System.out.println (sqle.getMessage());
			} catch (ClassNotFoundException cnfe) {
				System.out.println (cnfe.getMessage());
			} finally {
				try {
					System.out.println("successful addition of block");
					if (rs != null) { rs.close(); }
					if (ps != null) { ps.close(); }
					if (conn != null) { conn.close(); }
				} catch (SQLException sqle) {
					System.out.println(sqle.getMessage());
				}
			}

			response.sendRedirect("/CSCI201-Final-Project/LoadUser");
			pw.flush();
			pw.close();

		}
		

		if (request.getParameter("userToUnblockID") != null) {
			HttpSession session = request.getSession();
			PrintWriter pw = response.getWriter();


			Integer userID = (Integer) session.getAttribute("currentUserID"); // TODO: change when Adam passes me this... Adam's 
			System.out.println("id: " + userID);

			Integer userToUnblockID = Integer.parseInt(request.getParameter("userToUnblockID"));
			System.out.println("userToUnblock: " + userToUnblockID);


			// Also need to add the event to the database...
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			// thisEmailID for current session

			String updateString = "UPDATE blocks SET block_status=0" + " WHERE blocking_user_id=" + userID + " AND blocked_user_id=" + userToUnblockID;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);

				System.out.println(updateString);
				ps = conn.prepareStatement(updateString);
					int result = ps.executeUpdate();
				
			} catch (SQLException sqle) {
				System.out.println (sqle.getMessage());
			} catch (ClassNotFoundException cnfe) {
				System.out.println (cnfe.getMessage());
			} finally {
				try {
					System.out.println("successful addition of block");
					if (rs != null) { rs.close(); }
					if (ps != null) { ps.close(); }
					if (conn != null) { conn.close(); }
				} catch (SQLException sqle) {
					System.out.println(sqle.getMessage());
				}
			}

			response.sendRedirect("/CSCI201-Final-Project/LoadUser");
			pw.flush();
			pw.close();

		}


	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
