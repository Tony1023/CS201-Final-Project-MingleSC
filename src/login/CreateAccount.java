package login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import resources.*;

/**
 * Servlet implementation class CreateAccount
 */
@WebServlet("/CreateAccount")
public class CreateAccount extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateAccount() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		HttpSession session = request.getSession(); 
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		
		
		
		
		int major_id = -1;
		int housing_id = -1;
		int user_id = -1;
		
		ArrayList<Integer> course_ids = new ArrayList<Integer>();
		ArrayList<Integer> extracurricular_ids = new ArrayList<Integer>();
		ArrayList<Integer> interest_ids = new ArrayList<Integer>();

		
		
		boolean inputError = false;
		boolean errorMessageAdded = false;
		
		
		
		if(name.isEmpty() | email.isEmpty() | password.isEmpty()) {
			inputError = true;
			session.setAttribute("errorMessage", "Please fill in all fields.");
			errorMessageAdded = true;
			
		}
		else {
			if(!(email.contains("@usc.edu"))) {
				inputError = true;
				session.setAttribute("errorMessage", "Pleae enter a USC email.");
				errorMessageAdded = true;
			}
		}
		
		if(!inputError) {
			int majorIndex = Integer.parseInt(request.getParameter("major"));
			ArrayList<String> majors = (ArrayList<String>)session.getAttribute("majorsArrayList");
			String major = majors.get(majorIndex);
		
			int housingIndex = Integer.parseInt(request.getParameter("housing"));
			ArrayList<String> house = (ArrayList<String>)session.getAttribute("housingArrayList");
			String housing = house.get(housingIndex);
			
			String[] coursesPicked = request.getParameterValues("courses");
			int[] coursesPickedInt = new int[coursesPicked.length];
			for(int i = 0; i < coursesPicked.length; i++) {
				coursesPickedInt[i] = Integer.parseInt(coursesPicked[i]);	
			}
			ArrayList<String> course = (ArrayList<String>)session.getAttribute("coursesArrayList");
			String[] courses = new String[coursesPicked.length];
			for(int i = 0; i < coursesPickedInt.length; i++) {
				courses[i] = course.get(coursesPickedInt[i]);
			}
			
			
			String[] extracurricularsPicked = request.getParameterValues("extracurriculars");
			int[] extracurricularsPickedInt = new int[extracurricularsPicked.length];
			for(int i = 0; i < extracurricularsPicked.length; i++) {
				extracurricularsPickedInt[i] = Integer.parseInt(extracurricularsPicked[i]);
			}
			ArrayList<String> extracurricular = (ArrayList<String>)session.getAttribute("extracurricularsArrayList");
			String[] extracurriculars = new String[extracurricularsPicked.length];
			for(int i = 0; i < extracurricularsPickedInt.length; i++) {
				extracurriculars[i] = extracurricular.get(extracurricularsPickedInt[i]);
			}
		
			
			String[] interestsPicked = request.getParameterValues("interests");
			int[] interestsPickedInt = new int[interestsPicked.length];
			for(int i = 0; i < interestsPicked.length; i++) {
				interestsPickedInt[i] = Integer.parseInt(interestsPicked[i]);
			}
			ArrayList<String> interest = (ArrayList<String>)session.getAttribute("interestsArrayList");
			String[] interests = new String[extracurricularsPicked.length];
			for(int i = 0; i < interestsPickedInt.length; i++) {
				interests[i] = interest.get(interestsPickedInt[i]);
			}
			
			
			Connection conn = null;
			ResultSet rsFirst = null;
	        ResultSet rs = null;
	        ResultSet rs2 = null;
	        ResultSet rs3 = null;
	        ResultSet rs4 = null;
	        ResultSet rs5 = null;
	        ResultSet rs6 = null;
	        PreparedStatement psFirst = null;
	        PreparedStatement ps = null;
	        PreparedStatement ps2 = null;
	        PreparedStatement ps3 = null; 
	        PreparedStatement ps4 = null;
	        PreparedStatement ps5 = null;
	        PreparedStatement ps6 = null;
	        PreparedStatement ps7 = null;
	        PreparedStatement ps8 = null;
	        PreparedStatement ps9 = null;
	        PreparedStatement ps10 = null;
	        
	        try {
	        	Class.forName("com.mysql.cj.jdbc.Driver");
	        	conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
	        	
	        	psFirst = conn.prepareStatement("SELECT * FROM user WHERE email=?");
	        	psFirst.setString(1, email);
	        	rsFirst = psFirst.executeQuery();
	        	if(rsFirst.next()) {
	        		session.setAttribute("errorMessage", "Email already used for an account.");
					errorMessageAdded = true;
	        	}
	        	else {
		        	ps = conn.prepareStatement("SELECT * FROM major WHERE major_name=?");
		        	ps.setString(1, major);
		        	rs = ps.executeQuery();
		        	if(rs.next()) {
		        		major_id = rs.getInt("major_id");	
		        	}
	
		        	ps2 = conn.prepareStatement("SELECT * FROM housing WHERE housing_name=?");
		        	ps2.setString(1, housing);
		        	rs2 = ps2.executeQuery();
		        	if(rs2.next()) {
		        		housing_id = rs2.getInt("housing_id");
		        	}
		        	
		        	ps3 = conn.prepareStatement("INSERT INTO user (email, screen_name, password, major_id, housing_id) Values (?, ?, ?, ?, ?)");
		        	ps3.setString(1, email);
		        	ps3.setString(2, name);
		        	ps3.setString(3, password);
		        	ps3.setInt(4, major_id);
		        	ps3.setInt(5, housing_id);
		        	ps3.executeUpdate();
		        	
		        	ps4 = conn.prepareStatement("SELECT * FROM user WHERE email=?");
		        	ps4.setString(1, email);
		        	rs3 = ps4.executeQuery();
		        	if(rs3.next()) {
		        		user_id = rs3.getInt("user_id");
		        	}
		        	
		        	for(int i = 0; i < courses.length; i++) {
		        		String[] course1 = courses[i].split(" ");
		        		String prefix = course1[0];
		        		String number = course1[1];
		        		
		        		ps5 = conn.prepareStatement("SELECT * FROM courses WHERE course_prefix=? AND course_number=?");
		        		ps5.setString(1, prefix);
		        		ps5.setString(2, number);
		        		rs4 = ps5.executeQuery();
		        		if(rs4.next()) {
		        			int id = rs4.getInt("course_id");
		        			course_ids.add(id);
		        		}	
		        	}
		        	for(int i = 0; i < course_ids.size(); i++) {
		        		ps6 = conn.prepareStatement("INSERT INTO user_courses (user_id, course_id) Values (?,?)");
		        		ps6.setInt(1, user_id);
		        		ps6.setInt(2, course_ids.get(i));
		        		ps6.executeUpdate();
		        	}
		        	
		        	for(int i = 0; i < extracurriculars.length; i++) {
		        		ps7 = conn.prepareStatement("SELECT * FROM extracurriculars WHERE extracurricular_name=?");
		        		ps7.setString(1, extracurriculars[i]);
		        		rs5 = ps7.executeQuery();
		        		if(rs5.next()) {
		        			int id = rs5.getInt("extracurricular_id");
		        			extracurricular_ids.add(id);
		        		}
		        	}
		        	for(int i = 0; i < extracurricular_ids.size(); i++) {
		        		ps8 = conn.prepareStatement("INSERT INTO user_extracurriculars (user_id, extracurricular_id) Values (?,?)");
		        		ps8.setInt(1, user_id);
		        		ps8.setInt(2, extracurricular_ids.get(i));	
		        		ps8.executeUpdate();
		        	}
		        	
		        	for(int i = 0; i < interests.length; i++) {
		        		ps9 = conn.prepareStatement("SELECT * FROM gen_interests WHERE interest_name=?");
		        		ps9.setString(1, interests[i]);
		        		rs6 = ps9.executeQuery();
		        		if(rs6.next()) {
		        			int id = rs6.getInt("interest_id");
		        			interest_ids.add(id);
		        		}
		        	}
		        	for(int i = 0; i < interest_ids.size(); i++) {
		        		ps10 = conn.prepareStatement("INSERT INTO user_interests (user_id, interest_id) Values (?,?)");
		        		ps10.setInt(1, user_id);
		        		ps10.setInt(2, interest_ids.get(i));
		        		ps10.executeUpdate();
		        	}
	        	}
	        } catch (SQLException sqle) {
	        	System.out.println("sqle: " + sqle.getMessage());
	        } catch (ClassNotFoundException cnfe) {
	        	System.out.println("cnfe: " + cnfe.getMessage());
	        } finally {
	        	try {
	        		if (rs != null) {
	        			rs.close();
	        		}
	        		if (rs2 != null) {
	        			rs2.close();
	        		}
	        		if (rs3 != null) {
	        			rs3.close();
	        		}
	        		if (rs4 != null) {
	        			rs4.close();
	        		}
	        		if (rs5 != null) {
	        			rs5.close();
	        		}
	        		if (rs6 != null) {
	        			rs6.close();
	        		}
	        		if (ps != null) {
	        			ps.close();
	        		}
	        		if (ps2 != null) {
	        			ps2.close();
	        		}
	        		if (ps3 != null) {
	        			ps3.close();
	        		}
	        		if (ps4 != null) {
	        			ps4.close();
	        		}
	        		if (ps5 != null) {
	        			ps5.close();
	        		}
	        		if (ps6 != null) {
	        			ps6.close();
	        		}
	        		if (ps7 != null) {
	        			ps7.close();
	        		}
	        		if (ps8 != null) {
	        			ps8.close();
	        		}
	        		if (ps9 != null) {
	        			ps9.close();
	        		}
	        		if (ps10 != null) {
	        			ps10.close();
	        		}
	        		if (conn != null) {
	        			conn.close();
	        		}
	        	} catch(SQLException sqle) {
	        		System.out.println("sqle closing conn: " + sqle.getMessage());
	        	}

	        }	
			
		}
		
		if(errorMessageAdded) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/CreateAccount.jsp");
	        dispatcher.forward(request, response);
		}
		else {
			session.setAttribute("currentUserId", user_id);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/scheduler.jsp");
	        dispatcher.forward(request, response);	
			
		}		
	}
}
