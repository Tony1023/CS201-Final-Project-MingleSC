package guest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

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
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		
		String course = request.getParameter("course");
		String[] prefix = course.split(": ");
		System.out.println(prefix[0] + "courses " + prefix[1]);
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=root&allowPublicKeyRetrieval=true&useSSL=false");
			
			st = conn.createStatement();
			rs1 = st.executeQuery("SELECT course_id FROM courses WHERE course_name ='" + prefix[1] + "';");
			
			//parse for the course_id
			ArrayList<String> course_id = new ArrayList<>();
			while (rs1.next()) { 
				String s = "";
				s = rs1.getString("course_id");
				course_id.add(s);
			}
		//	System.out.println("arraylist element " + course_id.get(0));
			
			//use rs1 to find other users
			st2 = conn.createStatement();
			rs2 = st2.executeQuery("SELECT user_id FROM user_courses WHERE course_id ='" + course_id.get(0) + "';");
			
			//parse for the user_id
			ArrayList<String> user_id = new ArrayList<>();
			while (rs2.next()) { 
				String s = rs2.getString("user_id");
				user_id.add(s);
				System.out.println("element " + s);
			}
			
			System.out.println("arraylist element " + user_id.get(0));
			System.out.println("arraylist size" + user_id.size());
			
			
			
		//	request.setAttribute("allusers",a);
		//	request.getRequestDispatcher("user.jsp").forward(request, response); 
			
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
