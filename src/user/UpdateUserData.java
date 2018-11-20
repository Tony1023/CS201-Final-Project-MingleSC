package user;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import resources.CommonResources;
import resources.Credentials;

/**
 * Servlet implementation class UpdateUserData
 */
@WebServlet("/UpdateUserData")
public class UpdateUserData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateUserData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		int userID = (Integer) request.getSession().getAttribute("currentUserID");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		int major = Integer.parseInt(request.getParameter("major")) + 1;
		int housing = Integer.parseInt(request.getParameter("housing")) + 1;
		String[] courses = request.getParameterValues("courses");
		String[] interests = request.getParameterValues("interests");
		String[] extracurriculars = request.getParameterValues("extracurriculars");
		
		System.out.println("UPDATING USER PROFILE");
		System.out.println("Name: " + name);
		System.out.println("Email: " + email);
		System.out.println("Password: " + password);
		System.out.println("Major: " + major);
		System.out.println("Housing: " + housing);
		
		Connection conn = null;
    	Statement st = null;
    	ResultSet rs = null;
    	
    	String sqlString = "UPDATE user \n" + "SET email = '" + email + "', screen_name = '" + name + "', password = '" + password + "', major_id = " + major + ", housing_id = " + housing + "\n" + "WHERE user_id = " + userID;
    	System.out.println(sqlString);
    	try {		
    		Class.forName("com.mysql.cj.jdbc.Driver");
    		conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, 
    		        Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
    		st = conn.createStatement();
    		st.executeUpdate(sqlString);
    		
    		// Update Courses
    		sqlString = "DELETE FROM user_courses WHERE user_id = " + userID;
    		st = conn.createStatement();
    		st.executeUpdate(sqlString);
    		
    		if(courses != null) {
    			for(int i=0; i<courses.length; i++) {
    				sqlString = "INSERT INTO user_courses (user_id, course_id) VALUES (" + userID + ", " + Integer.toString(Integer.parseInt(courses[i]) + 1) + ")";
    				st = conn.createStatement();
    	    		st.executeUpdate(sqlString);
    			}
    		}
    		
    		// Update Interests
    		sqlString = "DELETE FROM user_interests WHERE user_id = " + userID;
    		st = conn.createStatement();
    		st.executeUpdate(sqlString);
    		
    		if(interests != null) {
    			for(int i=0; i<interests.length; i++) {
    				sqlString = "INSERT INTO user_interests (user_id, interest_id) VALUES (" + userID + ", " + Integer.toString(Integer.parseInt(interests[i]) + 1) + ")";
    				st = conn.createStatement();
    	    		st.executeUpdate(sqlString);
    			}
    		}
    		
    		// Update Courses
    		sqlString = "DELETE FROM user_extracurriculars WHERE user_id = " + userID;
    		st = conn.createStatement();
    		st.executeUpdate(sqlString);
    		
    		if(extracurriculars != null) {
    			for(int i=0; i<extracurriculars.length; i++) {
    				sqlString = "INSERT INTO user_extracurriculars (user_id, extracurricular_id) VALUES (" + userID + ", " + Integer.toString(Integer.parseInt(extracurriculars[i]) + 1) + ")";
    				st = conn.createStatement();
    	    		st.executeUpdate(sqlString);
    			}
    		}
    		
    	} catch(ClassNotFoundException cnfe) {
    		System.out.println("cnfe: " + cnfe.getMessage());
    	} catch (SQLException sqle) {
    		System.out.println("sqle: " + sqle.getMessage());
		} finally {
			try {
				if(rs != null) {
					rs.close();
				}
				
				if(st != null) {
					st.close();
				}
				
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
    	
    	RequestDispatcher dispatch = request.getRequestDispatcher("LoadUser");
    	dispatch.forward(request, response);
	}

}
