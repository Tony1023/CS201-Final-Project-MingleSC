package suggestion;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class Tester {

	public static void main(String[] args) {
		String resource = "suggestion/mybatis-config.xml";
		SqlSession session = null;
		InputStream inputStream;
		try {
			inputStream = Resources.getResourceAsStream(resource);
			SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
			session = sqlSessionFactory.openSession();
			Map<String, Integer> query = new HashMap<String, Integer>();
			query.put("this_id", 1);
			List<Integer> res = session.selectList("suggestion.suggestionMapper.computeSuggestions", 1);
			for (Integer i: res)
				System.out.println(i);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (session != null) 
				session.close();
		}

	}

}
