# CS201-Final-Project

## Setting up the Database
 - The database builder script (with some dummy data) are in data/
 - To set up the database correctly, run the SQL scripts in the following order:
 	1. db-builder.sql
	2. courses.sql
	3. major.sql
	4. add-other-data.sql
 - Now the database will be populated with all applicable majors and courses (at least as of Spring 2019)

## Credentials
 - Please put your SQL connection credentials into src/resources/Credentials.java
 - This file has been .gitignore-d so you won't see it on Github
 - To do so, create an interface named Credentials in that package:
```java
package resources;

public interface Credentials {
	public static final String SQL_USERNAME = "<Your SQL Username>";
	public static final String SQL_PASSWORD	= "<Your SQL Password>";
}
```
 - The address for our connection is in another file in the same package called "CommonResources.java".
 - When establishing an SQL connection, do the following:
```java
import resources.*;

// start of method
Connection conn = null;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(CommonResources.SQL_CONNECTION, 
        Credentials.SQL_USERNAME, Credentials.SQL_PASSWORD);
} catch (ClassNotFoundException cnfe) {
    // handle exception
} catch (SQLException sqle) {
    // handle exception
}
```
 - This makes changing SQL server address easier across different servlets and lets the program adapt to different SQL usernames and passwords.

## Notes
1. Please make sure to work on your own branch when making changes to your part.
2. I'd suggest grouping servlets and classes by packages. Naming is up to you guys.
3. If a jsp file is not going to be visited directly (i.e. visiting "login.jsp" directly) but instead being dispatched to (i.e. getRequestDispatcher("/login.jsp").forward), it would be better to put that into WEB-INF to prevent users from accessing them directly.

## Cloning
1. Clone the repo into your workspace (as another directory in your workspace).
2. Open Eclipse to your workspace.
3. Go to File->Import
4. Choose from General->Existing Project into Workspace
5. Choose "Select Root Directory" and navigate to the top level of the project
6. Uncheck all "options" and select the appropriate one under "Projects"
7. "Finish"
8. If getting an error like "System cannot be resolved":
9. Go to Package Explorer -> Select your Project -> Right click on your project -> go to Properties
10. Click on Java build path -> select your JRE file (mostly it will display error) and click on edit button which is on right side
11. A new dialog box will get displayed as “JRE System Library” in this window select radio button i.e"Workspace default JRE(jre6)" or whichever you have installed. Then click on finish.
12. Install these packages on your local tomcat as shown on this page: http://software.dzhuvinov.com/cors-filter-installation.html