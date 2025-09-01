package dao;

import java.sql.Connection;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.Game1CommentDTO;

public class Game1CommentDAO {
	private static Game1CommentDAO instance;
	
	public synchronized static Game1CommentDAO getInstance() {
		if(instance == null) {
			instance = new Game1CommentDAO();
		}
		return instance;
	}
	
	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public ArrayList<Game1CommentDTO> selectAll(int seq) throws Exception {
		
	}
}
