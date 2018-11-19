package OtherUser;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class OtherUsers
 */
@WebServlet("/OtherUsers")
public class OtherUsers extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OtherUsers() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
         //HttpSession session = request.getSession(true);
            Connection conn = null; //create the connection to database
			Statement st = null; //executes any sql command
			PreparedStatement ps = null;
			ResultSet rs = null; //retrieve data that comes back (from select statement), a table
			HttpSession session = request.getSession(true);
			String myEmail = request.getParameter ("userEmail");
			 //int receivingid= Integer.parseInt(request.getParameter("currentId"));
			//String myEmail= "zhehaolu@usc.edu";
			String name="";
			int userid=0;
			int majorid=0 ;
			int housingid=0;
			int courseid;
			int extracurricularid;
			int interestid;
			String major="";
			String housing="";
			ArrayList<String> courses= new ArrayList <String>();
			ArrayList<String> ec= new ArrayList <String>();
			ArrayList<String> interest= new ArrayList <String>();
			
		
		try {
			
			
	   		//String dbURL ="jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=kickman&useSSL=false";
	   		
			
			Class.forName("com.mysql.jdbc.Driver");
		    conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db", "root", "kickman");
			System.out.println("Successfully connected");
			//String myEmail = request.getParameter ("useremail");
			
			
			st=conn.createStatement();
			rs=st.executeQuery("SELECT * FROM user where email='"+myEmail+"' ");
			
			while(rs.next())
			{
				
				name= rs.getString("screen_name");
				System.out.println(name);
				userid=rs.getInt("user_id");
				majorid=rs.getInt("major_id");
				housingid=rs.getInt("housing_id");
			}
			
			rs=st.executeQuery("Select * From major where major_id= '"+majorid+"'");
			while(rs.next())
			{
				major=rs.getString("major_name");
				System.out.println(major);
			}
			
			rs=st.executeQuery("Select * From housing where housing_id= '"+housingid+"'");
			while(rs.next())
			{
				housing=rs.getString("housing_name");
				System.out.println(housing);
			}
			
			rs=st.executeQuery("Select * From user_courses where user_id= '"+userid+"'");
			while(rs.next())
			{
				courseid= rs.getInt("course_id");
				System.out.println(courseid);
				
				Statement s = conn.createStatement(); //executes any sql command
				ResultSet r=s.executeQuery("Select * FROM courses where course_id= '"+courseid+"'");
			
				if(r.next())
				{
				
					
					
					String course="";
					String coursepre=r.getString("course_prefix");
					int coursenum=r.getInt("course_number");
					
					course= coursepre + " " + coursenum;
					System.out.println(course);
					courses.add(course);
					
				}
				
			} 
			
			rs=st.executeQuery("Select * From user_extracurriculars where user_id= '"+userid+"'");
			while(rs.next())
			{
				extracurricularid= rs.getInt("extracurricular_id");
				Statement s = null; //executes any sql command
				ResultSet r = null;
				s=conn.createStatement();
				r=s.executeQuery("Select * From extracurriculars where extracurricular_id= '"+extracurricularid+"'");
				if(r.next())
				{
					String extracurricular="";
					extracurricular=r.getString("extracurricular_name");
					System.out.println(extracurricular);
					ec.add(extracurricular);
				
				}
				
			}
			
			rs=st.executeQuery("Select * From user_interests where user_id= '"+userid+"'");
			while(rs.next())
			{
				interestid= rs.getInt("interest_id");
				Statement s = null; //executes any sql command
				ResultSet r = null;
				s=conn.createStatement();
				r=s.executeQuery("Select * From gen_interests where interest_id= '"+interestid+"'");
				if(r.next())
				{
					String i="";
					i=r.getString("interest_name");
					System.out.println(i);
					interest.add(i);
				
				}
				
			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (ClassNotFoundException cnfe){	
			System.out.println("AU cnfe: " + cnfe.getMessage()); }
		
		finally {
			try {
				
				if(rs!=null) {
					rs.close();
				}
				if(st!=null) {
					st.close();
				}
				if(conn!=null) {
					conn.close();
				}
				
			}
			catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		String url="https://api.adorable.io/avatars/285/" + userid+ ".png";
		System.out.println(url);
		session.setAttribute("name", name);
		session.setAttribute("major", major);
		session.setAttribute("housing", housing);
		session.setAttribute("courses", courses);
		session.setAttribute("extracurricular", ec);
		session.setAttribute("interest", interest);
		session.setAttribute("picture", url);
		
		//sending user ID's
		//session.setAttribute("currentUser", receivingID);
		session.setAttribute("otherUser", userid);
	String next="/UserInformation.jsp";
RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		
    	try {
    		dispatch.forward(request,response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

}
}
