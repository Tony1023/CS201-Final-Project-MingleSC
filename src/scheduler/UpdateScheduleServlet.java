package scheduler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import resources.CommonResources;
import resources.Credentials;

/**
 * Servlet implementation class UpdateScheduleServlet
 */
@WebServlet("/UpdateScheduleServlet")
public class UpdateScheduleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateScheduleServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userID = request.getParameter("userID");
		String availability = request.getParameter("availability");
		
		System.out.println("User ID: " + userID);
		System.out.println("Availability: " + availability);
		
		Connection conn = null;
    	Statement st = null;
    	ResultSet rs = null;
    	PrintWriter pw = response.getWriter();
    	
    	String sqlString = "UPDATE user \n" + "SET availability_string = '" + availability + "' \n" + "WHERE user_id =" + userID;
    	System.out.println(sqlString);
    	try {		
    		Class.forName("com.mysql.cj.jdbc.Driver");
    		conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, 
    		        Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
    		st = conn.createStatement();
    		st.executeUpdate(sqlString);
    		
    		pw.print("Success");
    		pw.flush();
    		if(pw != null) {
    			pw.close();
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
	}

}
