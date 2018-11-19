
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

import resources.CommonResources;
import resources.Credentials;

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

		Integer userID = (Integer) session.getAttribute("currentUserID"); // TODO: change when Adam passes me this... Adam's 
		System.out.println("id: " + userID);
		
		String screenName = "";
		String email = "";
		String password = "";
		String interests = ""; // TODO: This might need to get more involved...
		String availabilityString = "";
		String majorName = "";
		String housingName = "";

		// TODO: Retrieve the user
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
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
			String imgURL = "https://api.adorable.io/avatars/285/" + userID + ".png";
			System.out.println(imgURL);
			session.setAttribute("imgURL", imgURL);
			

			// GET COURSES 

			// get course IDs
			queryString = "SELECT * FROM user_courses WHERE user_id=" + userID;
			ps = conn.prepareStatement(queryString);
			rs = ps.executeQuery();
			String courseID = null;
			ArrayList<String> coursePrefixes = new ArrayList<String>();
			ArrayList<String> courseNumbers = new ArrayList<String>();
			ArrayList<String> courseNames = new ArrayList<String>();


			while (rs.next()) {
				courseID = rs.getString("course_id");
				String coursePrefix = null;
				String courseNumber = null;
				String courseName = null;

				// Get course info
				Statement s = conn.createStatement();
				ResultSet r = s.executeQuery("SELECT * FROM courses WHERE course_id=" + courseID);
				while (r.next()) {
					coursePrefix = r.getString("course_prefix");
					courseNumber = r.getString("course_number");
					courseName = r.getString("course_name");

					System.out.println("coursePrefix: "  + coursePrefix);
					System.out.println("courseNumber: "  + courseNumber);
					System.out.println("courseName: "  + courseName);
					
					coursePrefixes.add(coursePrefix);
					courseNumbers.add(courseNumber);
					courseNames.add(courseName);
				}
			}

			session.setAttribute("coursePrefixes", coursePrefixes);
			session.setAttribute("courseNumbers", courseNumbers);
			session.setAttribute("courseNames", courseNames);

			

			// GET INTERESTS
			
			String interestID = null;
			ArrayList<String> interestNames = new ArrayList<String>();

			queryString = "SELECT * FROM user_interests WHERE user_id=" + userID;
			ps = conn.prepareStatement(queryString);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				interestID = rs.getString("interest_id");
				String interestName = null;

				// Get course info
				Statement s = conn.createStatement();
				ResultSet r = s.executeQuery("SELECT * FROM gen_interests WHERE interest_id=" + interestID);
				while (r.next()) {
					interestName = r.getString("interest_name");

					System.out.println("interestName: "  + interestName);
					interestNames.add(interestName);
				}
			}

			session.setAttribute("interestNames", interestNames);



			// GET EXTRACURRICULARS
			String extracurricularID = null;
			ArrayList<String> extracurricularNames = new ArrayList<String>();

			queryString = "SELECT * FROM user_extracurriculars WHERE user_id=" + userID;
			ps = conn.prepareStatement(queryString);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				extracurricularID = rs.getString("extracurricular_id");
				String extracurricularName = null;

				// Get course info
				Statement s = conn.createStatement();
				ResultSet r = s.executeQuery("SELECT * FROM extracurriculars WHERE extracurricular_id=" + extracurricularID);
				while (r.next()) {
					extracurricularName = r.getString("extracurricular_name");

					System.out.println("extracurricularName: "  + extracurricularName);
					extracurricularNames.add(extracurricularName);
				}
			}

			session.setAttribute("extarcurricularNames", extracurricularNames);


			// GET BLOCKED USERS
			
			int blockedUserID = 0;
			ArrayList<Integer> blockedUserIDs = new ArrayList<Integer>();
			ArrayList<String> blockedScreenNames = new ArrayList<String>();
			ArrayList<String> blockedEmails = new ArrayList<String>();
			 
			System.out.println("BLOCKS:");
			String blockQueryString = "SELECT blocked_user_id FROM blocks WHERE blocking_user_id=" + userID;

			ps = conn.prepareStatement(blockQueryString);
			rs = ps.executeQuery();

			while (rs.next()) {
				// TODO: add screen name retrieval here as well...
				blockedUserID = rs.getInt("blocked_user_id");
				System.out.println("blockedUserID= " + blockedUserID);

				Statement s = conn.createStatement();
				ResultSet r = s.executeQuery("SELECT email, screen_name FROM user WHERE user_id=" + blockedUserID);
				
				String blockedScreenName = "";
				String blockedEmail = "";

				while (r.next()) {
					blockedEmail = r.getString("email");
					blockedScreenName = r.getString("screen_name");

					System.out.println("blockedScreenName= " + blockedScreenName);
					System.out.println("blockedEmail= " + blockedEmail);

					blockedEmails.add(blockedEmail);
					blockedScreenNames.add(blockedScreenName);
				}
				
				blockedUserIDs.add(blockedUserID);
			}

			session.setAttribute("blockedUserIDs", blockedUserIDs);
			session.setAttribute("blockedScreenNames", blockedScreenNames);
			session.setAttribute("blockedEmails", blockedEmails);

			// GET CHATS
			int receivingUserID = 0;
			ArrayList<Integer> receivingUserIDs = new ArrayList<Integer>();
			ArrayList<String> receivingScreenNames = new ArrayList<String>();
			ArrayList<String> receivingEmails = new ArrayList<String>();

			String chatQueryString = "SELECT receiving_user_id from chat_messages where sending_user_id=" + userID + " GROUP BY receiving_user_id"; // boil this down to IDs only...
			ps = conn.prepareStatement(chatQueryString);
			rs = ps.executeQuery();

			System.out.println("EXISTING CHATS:");

			while (rs.next()) {
				// TODO: add screen name retrieval here as well...
				receivingUserID = rs.getInt("receiving_user_id");
				System.out.println("receiving_user_id= " + receivingUserID);

				Statement s = conn.createStatement();
				ResultSet r = s.executeQuery("SELECT email, screen_name FROM user WHERE user_id=" + receivingUserID);
				
				String receivingScreenName = "";
				String receivingEmail = "";

				while (r.next()) {
					receivingEmail = r.getString("email");
					receivingScreenName = r.getString("screen_name");

					System.out.println("receivingScreenName= " + receivingScreenName);
					System.out.println("receivingEmail= " + receivingEmail);

					receivingEmails.add(receivingEmail);
					receivingScreenNames.add(receivingScreenName);
				}
				
				receivingUserIDs.add(receivingUserID);
			}

			session.setAttribute("receivingUserIDs", receivingUserIDs);
			session.setAttribute("receivingScreenNames", receivingScreenNames);
			session.setAttribute("receivingEmails", receivingEmails);


			// GET MATCHES
			System.out.println("MATCHES:");
 			
 			
			ArrayList<Integer> matchUserIDs = new ArrayList<Integer>();
			ArrayList<String> matchScreenNames = new ArrayList<String>();
			ArrayList<String> matchEmails = new ArrayList<String>();


			// TODO: REMOVE HARD-CODED WHEN WORKING

			matchUserIDs.add(2);
			matchUserIDs.add(7);
			matchUserIDs.add(3);
			matchUserIDs.add(4);
			matchUserIDs.add(8);

			matchScreenNames.add("Tony Lyu2");
			matchScreenNames.add("Sophia Hu");
			matchScreenNames.add("Wayne Yu");
			matchScreenNames.add("Patrick Kong");
			matchScreenNames.add("Jeffrey Miller");

			matchEmails.add("zhehaolu2@usc.edu");
			matchEmails.add("husophia@usc.edu");
			matchEmails.add("weiyuyu@usc.edu");
			matchEmails.add("kongp@usc.edu");
			matchEmails.add("jeffrey.miller@usc.edu");

			// TODO: REMOVE HARD-CODED WHEN WORKING


			// // TODO: Fix this later... rip
			// for (int i: SuggesterUtil.getRank(1)) {
			// 	System.out.println(i);
			// }

			// ArrayList<String> matchScreenNames = new ArrayList<String>();
			// ArrayList<String> matchEmails = new ArrayList<String>();

 		// 	for (int i = 0; i < matchUserIDs.size(); i++) {

 		// 		Statement s = conn.createStatement();
 		// 		ResultSet r = s.executeQuery("SELECT email, screen_name FROM user WHERE user_id=" + matchUserIDs.get(i));
				
			// 	String matchScreenName = "";
			// 	String matchEmail = "";

			// 	while (r.next()) {
			// 		matchEmail = r.getString("email");
			// 		matchScreenName = r.getString("screen_name");

			// 		System.out.println("matchScreenName= " + matchScreenName);
			// 		System.out.println("matchEmail= " + matchEmail);

			// 		matchEmails.add(matchEmail);
			// 		matchScreenNames.add(matchScreenName);
			// 	}
 		// 	}

			session.setAttribute("matchUserIDs", matchUserIDs);
			session.setAttribute("matchScreenNames", matchScreenNames);
			session.setAttribute("matchEmails", matchEmails);


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
