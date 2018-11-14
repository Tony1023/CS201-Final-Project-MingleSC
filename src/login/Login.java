package login;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		PrintWriter pw = response.getWriter();
		
		boolean inputError = false;
		if(email.isEmpty() | password.isEmpty()) {
			pw.println("Please fill in all fields.<br>");
			inputError = true;
			
		}
		else {
			if(!(email.contains("@usc.edu"))) {
				pw.println("Please enter a USC email.<br>");
				inputError = true;
			}
		}
	
		
		if(!inputError) {
			Connection conn = null;
	        ResultSet rs = null;
	        PreparedStatement ps = null;
	        try {
	        	Class.forName("com.mysql.jdbc.Driver");
	        	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=Wildcats1&useSSL=false");
	        	ps = conn.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
	        	ps.setString(1, email);
	        	ps.setString(2, password);
	        	rs = ps.executeQuery();
	        	if(!(rs.next())) {
	        		pw.println("Incorrect email or password. <br>");
	        		
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
	        		if (ps != null) {
	        			ps.close();
	        		}
	        		if (conn != null) {
	        			conn.close();
	        		}
	        	} catch(SQLException sqle) {
	        		System.out.println("sqle closing conn: " + sqle.getMessage());
	        	}

	        }
			
		}
		pw.flush();
		pw.close();	
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
