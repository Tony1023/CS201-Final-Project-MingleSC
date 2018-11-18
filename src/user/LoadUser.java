
package user;

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

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Servlet implementation class LoadUser
 */
@WebServlet("/LoadUser")
public class LoadUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoadUser() {
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

		HttpSession session = request.getSession();
		PrintWriter pw = response.getWriter();


		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String userID = "1"; // TODO: Remove this when I figure out how things are getting passed to me...
		// userID = session.getAttribute("currentUserID"); // TODO: change when Adam passes me this... Adam's 
		
		String screenName = "";
		String email = "";
		String password = "";
		String interests = ""; // TODO: This might need to get more involved...
		String availabilityString = "";
		String majorName = "";
		String housingName = "";

		// TODO: Retrieve the user
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=!Gemskull2&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC");
			String queryString = "SELECT u.email, u.screen_name, u.password, u.availability_string, m.major_name, h.housing_name FROM user u, major m, housing h WHERE " + 
									" user_id=" + userID + " AND u.major_id=m.major_id AND u.housing_id=h.housing_id;";
			
			ps = conn.prepareStatement(queryString);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				email = rs.getString("email");
				screenName = rs.getString("screen_name");
				password = rs.getString("password");
				majorName = rs.getString("major_name");
				housingName = rs.getString("housing_name");
				availabilityString = rs.getString("availability_string");
				
				System.out.println("email = " + email);
				System.out.println ("password = " + password);
				System.out.println ("majorName = " + majorName);
				System.out.println("housingName = " + housingName);
				System.out.println("availability string = " + availabilityString);
			}

			session.setAttribute("screenName", screenName);
			session.setAttribute("userID", userID);
			session.setAttribute("password", password);
			session.setAttribute("majorName", majorName);
			session.setAttribute("housingName", housingName);
			session.setAttribute("availabilityString", availabilityString);	
			String imgURL = "https://api.adorable.io/avatars/285/" + (Integer.parseInt(userID)) + ".png";
			System.out.println(imgURL);
			session.setAttribute("imgURL", imgURL);
			
			
			// GET BLOCKED USERS
			
			int blockedUserID = 0;
			String blockedScreenName = "";
			ArrayList<Integer> blockedUserIDs = new ArrayList<Integer>();
			ArrayList<String> blockedScreenNames = new ArrayList<String>();
			
			String blockQueryString = "SELECT b.blocked_user_id, u.screen_name from blocks b, user u where b.blocking_user_id=" + userID;
			ps = conn.prepareStatement(blockQueryString);
			rs = ps.executeQuery();

			System.out.println("BLOCKS:");

			while (rs.next()) {
				// TODO: add screen name retrieval here as well...
				blockedUserID = rs.getInt("blocked_user_id");
				blockedScreenName = rs.getString("screen_name");
				
				System.out.println("blockedUserID= " + blockedUserID);
				System.out.println("blockedScreenName= " + blockedUserID);
				blockedUserIDs.add(blockedUserID);
				blockedScreenNames.add(blockedScreenName);
			}

			session.setAttribute("blockedUserIDs", blockedUserIDs);
			session.setAttribute("blockedScreenNames", blockedScreenNames);

			// GET CHATS
			int chatUserID = 0;
			String chatScreenName = "";
			ArrayList<Integer> chatUserIDs = new ArrayList<Integer>();
			ArrayList<String> chatScreeNames = new ArrayList<String>();

			String chatQueryString = "SELECT * from chat_messages where sending_user_id=" + userID; // boil this down to IDs only...
			ps = conn.prepareStatement(blockQueryString);
			rs = ps.executeQuery();

			System.out.println("EXISTING CHATS:");

			while (rs.next()) {
				// TODO: add screen name retrieval here as well...
				chatUserID = rs.getInt("receiving_user_id");
				
				System.out.println("chatUserID = " + chatUserID);
				chatUserIDs.add(chatUserID);
			}

			session.setAttribute("chatUserIDs", chatUserIDs);
			session.setAttribute("chatScreenNames", chatScreenNames);


		} catch (SQLException sqle) {
			System.out.println (sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println (cnfe.getMessage());
		} finally {
			try {
				System.out.println("ssuccssfully retrieved a user");
				if (rs != null) { rs.close(); }
				if (ps != null) { ps.close(); }
				if (conn != null) { conn.close(); }
			} catch (SQLException sqle) {
				System.out.println(sqle.getMessage());
			}
		}

		

		pw.println("Nice job mate!");
		RequestDispatcher view = request.getRequestDispatcher("userProfile.jsp");
		view.forward(request, response);
		pw.flush();
		pw.close();


		// // TODO: Retrieve all blocked users
		// try {
		// 	Class.forName("com.mysql.jdbc.Driver");
		// 	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Assignment4?user=root&password=!Gemskull2&useSSL=false");
		// 	String queryString = "SELECT * FROM User WHERE (";

		// 	for (int i  = 0; i < splitSearchTerms.length; i++) {
		// 		queryString += "LOWER(CONCAT(fname, '', lname)) LIKE " + "LOWER(\"%" + splitSearchTerms[i] + "%\") ";	
				
		// 		if (i != splitSearchTerms.length-1) {
		// 			queryString += "OR ";	
		// 		}
		// 	}
		// 	queryString += ")";

		// 	System.out.println(queryString);
		// 	ps = conn.prepareStatement(queryString);
		// 	rs = ps.executeQuery();

		// 		ArrayList<Integer> userIDs = new ArrayList<Integer>();
		// 		ArrayList<String> fnames = new ArrayList<String>();
		// 	ArrayList<String> lnames = new ArrayList<String>();
		// 	ArrayList<String> imgURLs = new ArrayList<String>();
		// 	ArrayList<String> emails = new ArrayList<String>();
			
		// 	while (rs.next()) {
		// 		int userID = rs.getInt("userID");
		// 		String fname = rs.getString("fname");
		// 		String lname = rs.getString("lname");
		// 		String imgURL = rs.getString("imgURL");
		// 		String emailID = rs.getString("emailID");
				
		// 		System.out.println ("userID = " + userID);
		// 		System.out.println("email = " + emailID);
		// 		System.out.println ("fname = " + fname);
		// 		System.out.println ("lname = " + lname);
		// 		System.out.println("imgURL = " + imgURL);
		// 		System.out.println();
				
		// 		if (!thisEmailID.equals(emailID)) {
		// 			fnames.add(fname);
		// 			lnames.add(lname);
		// 			userIDs.add(userID);
		// 			imgURLs.add(imgURL);
		// 			emails.add(emailID); 
		// 		}
		// 		else {
		// 			System.out.println("ignoring current email: " + thisEmailID);
		// 		}
		// 	}
			
		// 	session.setAttribute("userIDs", userIDs);
		// 	System.out.println(session.getAttribute("userIDs"));
		// 	session.setAttribute("fnames", fnames);
		// 	session.setAttribute("lnames", lnames);
		// 	session.setAttribute("imgURLs", imgURLs);
		// 	session.setAttribute("emails", emails);

		// 	pw.println("Nice job mate!");
		// 	pw.flush();
		// 	pw.close();

		// } catch (SQLException sqle) {
		// 	System.out.println (sqle.getMessage());
		// } catch (ClassNotFoundException cnfe) {
		// 	System.out.println (cnfe.getMessage());
		// } finally {
		// 	try {
		// 		System.out.println("successful completion");
		// 		if (rs != null) { rs.close(); }
		// 		if (ps != null) { ps.close(); }
		// 		if (conn != null) { conn.close(); }
		// 	} catch (SQLException sqle) {
		// 		System.out.println(sqle.getMessage());
		// 	}
		// }

		// // TODO: Retrieve all chats!
		// try {
		// 	Class.forName("com.mysql.jdbc.Driver");
		// 	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Assignment4?user=root&password=!Gemskull2&useSSL=false");
		// 	String queryString = "SELECT * FROM User WHERE (";

		// 	for (int i  = 0; i < splitSearchTerms.length; i++) {
		// 		queryString += "LOWER(CONCAT(fname, '', lname)) LIKE " + "LOWER(\"%" + splitSearchTerms[i] + "%\") ";	
				
		// 		if (i != splitSearchTerms.length-1) {
		// 			queryString += "OR ";	
		// 		}
		// 	}
		// 	queryString += ")";

		// 	System.out.println(queryString);
		// 	ps = conn.prepareStatement(queryString);
		// 	rs = ps.executeQuery();

		// 		ArrayList<Integer> userIDs = new ArrayList<Integer>();
		// 		ArrayList<String> fnames = new ArrayList<String>();
		// 	ArrayList<String> lnames = new ArrayList<String>();
		// 	ArrayList<String> imgURLs = new ArrayList<String>();
		// 	ArrayList<String> emails = new ArrayList<String>();
			
		// 	while (rs.next()) {
		// 		int userID = rs.getInt("userID");
		// 		String fname = rs.getString("fname");
		// 		String lname = rs.getString("lname");
		// 		String imgURL = rs.getString("imgURL");
		// 		String emailID = rs.getString("emailID");
				
		// 		System.out.println ("userID = " + userID);
		// 		System.out.println("email = " + emailID);
		// 		System.out.println ("fname = " + fname);
		// 		System.out.println ("lname = " + lname);
		// 		System.out.println("imgURL = " + imgURL);
		// 		System.out.println();
				
		// 		if (!thisEmailID.equals(emailID)) {
		// 			fnames.add(fname);
		// 			lnames.add(lname);
		// 			userIDs.add(userID);
		// 			imgURLs.add(imgURL);
		// 			emails.add(emailID); 
		// 		}
		// 		else {
		// 			System.out.println("ignoring current email: " + thisEmailID);
		// 		}
		// 	}
			
		// 	session.setAttribute("userIDs", userIDs);
		// 	System.out.println(session.getAttribute("userIDs"));
		// 	session.setAttribute("fnames", fnames);
		// 	session.setAttribute("lnames", lnames);
		// 	session.setAttribute("imgURLs", imgURLs);
		// 	session.setAttribute("emails", emails);

		// 	pw.println("Nice job mate!");
		// 	pw.flush();
		// 	pw.close();

		// } catch (SQLException sqle) {
		// 	System.out.println (sqle.getMessage());
		// } catch (ClassNotFoundException cnfe) {
		// 	System.out.println (cnfe.getMessage());
		// } finally {
		// 	try {
		// 		System.out.println("successful completion");
		// 		if (rs != null) { rs.close(); }
		// 		if (ps != null) { ps.close(); }
		// 		if (conn != null) { conn.close(); }
		// 	} catch (SQLException sqle) {
		// 		System.out.println(sqle.getMessage());
		// 	}
		// }

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
