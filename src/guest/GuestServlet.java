package guest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GuestServlet
 */
@WebServlet("/GuestServlet")
public class GuestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GuestServlet() {
        super();
    }

 protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		Statement st = null;
		Statement st2 = null;
		Statement st3 = null;
		Statement st4 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		
		String course = request.getParameter("course");
		String[] prefix = course.split(": ");
		
		Map<String,ArrayList<String>> nameMajor = new HashMap<String,ArrayList<String>>();
 		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=root&allowPublicKeyRetrieval=true&useSSL=false");
			
			st = conn.createStatement();
			rs1 = st.executeQuery("SELECT course_id FROM courses WHERE course_name ='" + prefix[1] + "';");
			
			//parse for the course_id
			ArrayList<String> course_id = new ArrayList<>();
			while (rs1.next()) { 
				String s = rs1.getString("course_id");
				course_id.add(s);
			//	System.out.println("s " + s);
			}
			
			System.out.println("prefix[1] " + prefix[1]);
			System.out.println("course_id.size " + course_id.size());
			System.out.println(course_id.get(0));
			
			//use rs1 to find other users' user_id
			st2 = conn.createStatement();
			rs2 = st2.executeQuery("SELECT user_id FROM user_courses WHERE course_id ='" + course_id.get(0) + "';");
			
			//parse for the user_id, will be multiple
			ArrayList<String> user_id = new ArrayList<>();
			while (rs2.next()) { 
				String s = rs2.getString("user_id");
				user_id.add(s);
			//	System.out.println("user id " + s);
			}
			
			//System.out.println("user id size" + user_id.size());
			
			//use rs2 (user_id) to find other users' info
			ArrayList<String> userinfo = new ArrayList<>();
			ArrayList<String> major_ids = new ArrayList<>();
			for (int i = 0; i < user_id.size(); i++) {
				st3 = conn.createStatement();
				rs3 = st3.executeQuery("SELECT screen_name, major_id FROM user WHERE user_id ='" + user_id.get(i) + "';");
				
				while (rs3.next()) { 
					String name = rs3.getString("screen_name");
					String major_id = rs3.getString("major_id");
					userinfo.add(name);
					major_ids.add(major_id);
//					System.out.println("name " + name + " major id" + major_id);
				}
				
//				System.out.println("name " + userinfo.get(0));
//				System.out.println("userinfo size" + userinfo.size());
//				System.out.println("major_id size" + major_ids.size());
			}
			
			//get major names from major id
			ArrayList<String> majors = new ArrayList<>();
			for (int i = 0; i < major_ids.size(); i++) {
				st4 = conn.createStatement();
				rs4 = st3.executeQuery("SELECT major_name FROM major WHERE major_id ='" + major_ids.get(i) + "';");
				
				while (rs4.next()) { 
					String major = rs4.getString("major_name");
					majors.add(major);
					System.out.println("major " + major);
				}
			}
			System.out.println("majors size" + userinfo.size());
			
			//create array with name and user_id	
			//PUT each matched users' name, major INTO nameMajor map 
			for (int i = 0; i <userinfo.size(); i++) {
				ArrayList<String> nm = new ArrayList<>();
				nm.add(userinfo.get(i));
				nm.add(majors.get(i));
				nameMajor.put(user_id.get(i),nm);
			}
			
			for (Entry<String, ArrayList<String>> entry : nameMajor.entrySet()) {
				System.out.println(entry.getKey());
				System.out.println(entry.getValue());
			}
			
//			System.out.println("nameMajor.size() " + nameMajor.size());
//			System.out.println("name majorsize " + nameMajor.size());
//			System.out.println("user_id " + user_id.size());
			
//			request.setAttribute("user_id", user_id);
//			RequestDispatcher view = request.getRequestDispatcher("GuestMatches.jsp");
//			view.forward(request, response);
			
			request.setAttribute("nameMajor", nameMajor);
			RequestDispatcher view1 = request.getRequestDispatcher("GuestMatches.jsp");
			view1.forward(request, response);
			
		} catch (SQLException sqle) {
			System.out.println("sqle " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe " + cnfe.getMessage());
		} finally { 
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing statement " + sqle.getErrorCode());
			}
		}

	}
}
