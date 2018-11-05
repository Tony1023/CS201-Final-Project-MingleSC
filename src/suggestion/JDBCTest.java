package suggestion;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.Scanner;


public class JDBCTest {

	public static void main(String[] args) {
		
		Connection conn = null;
		Scanner in = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs201_final_project_db?user=root&password=root&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
			Statement st = conn.createStatement();
			in = new Scanner(new File("suggestor.sql"));
			in.useDelimiter(";");
			st.execute("SET @this_id=" + 1);
			while (in.hasNext()) {
				st.execute(in.next());
			}
			ResultSet rs = st.executeQuery("SELECT * FROM suggestion ORDER BY score DESC");
			while (rs.next()) {
				System.out.println(rs.getInt(1));
			}
		} catch (SQLException sqle) {
			System.out.println(sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println(cnfe.getMessage());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null)
					conn.close();
				if (in != null)
					in.close();
			} catch (SQLException sqle) {
				System.out.println(sqle.getMessage());
			}
		}

	}

}
