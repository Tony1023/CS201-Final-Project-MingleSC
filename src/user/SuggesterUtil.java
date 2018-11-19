package user;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import resources.*;

/*
 * Usage:
 * List<Integer> rank = SuggestorUtil.getRank(1);
 */
public class SuggesterUtil {
	
	private static List<String> sqlStatements = null;
	private static Connection conn = null;
	
	private static void setUp(String path) {
		if (sqlStatements != null) {
			return;
		}
		sqlStatements = new ArrayList<String>();
		Scanner in = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
			in = new Scanner(new File(path + "/WEB-INF/suggester.sql"));
			in.useDelimiter(";");
			sqlStatements.add("SET @this_id=");
			while (in.hasNext()) {
				sqlStatements.add(in.next());
			}
		} catch (SQLException sqle) {
			System.out.println(sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println(cnfe.getMessage());
		} catch (FileNotFoundException e) {
			System.out.println("SuggesterUtil: " + e.getMessage());
		} finally {
			if (in != null) { in.close(); }
		}
	}
	
	public static List<Integer> getRank(int id, String path) {
		setUp(path);
		List<Integer> result = new ArrayList<Integer>();
		try {
			Statement st = conn.createStatement();
			st.execute(sqlStatements.get(0) + id);
			int size = sqlStatements.size();
			for (int i = 1; i < size - 1; ++i) {
				st.execute(sqlStatements.get(i));
			}
			ResultSet rs = st.executeQuery(sqlStatements.get(size - 1));
			while (rs.next()) {
				result.add(rs.getInt(1));
			}
			st.execute("DROP TABLE suggestion, temp, this_user");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}

}
