package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class AdminDAO {
	private static AdminDAO instance;
	
	public synchronized static AdminDAO getInstance() {
		if(instance == null) {
			instance = new AdminDAO();
		}
		return instance;
	}
	
	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public int idAdminSerch(String id) throws Exception { // 관리자 id 검사
		String sql = "select admin_id from admin where admin_id = ?";
		try(Connection con = this.getConnection();
	            PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			
			try(ResultSet rs = stat.executeQuery();){
				if(rs.next()) {
					return 1;
				}else {
					return 0;
				}
			}
		}
	}
	
	
	
}
