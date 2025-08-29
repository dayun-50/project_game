package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.FreeBoardsDTO;

public class FreeBoardsDAO {
	private static FreeBoardsDAO instance;

	public synchronized static FreeBoardsDAO getInstance() { //dao 인스턴스
		if(instance == null) {
			instance = new FreeBoardsDAO();
		}
		return instance;
	}

	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public boolean insert(FreeBoardsDTO dto) throws Exception{
		String sql = "insert into freeBoards(fb_id, fb_user_name,fb_Title,fb_write,fb_date)"+
					 "values(freeBoards_seq.NEXTVAL,?,?,?,)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){

			stat.setString(1, dto.getFb_Title());
			stat.setString(2, dto.getFb_write());
			stat.setTimestamp(3, dto.getFb_date());
			
			return stat.executeUpdate() > 0;
		}

	}

	public boolean update(FreeBoardsDTO dto) throws Exception{
		String sql = "update freeBoards set fb_Title=?, fb_write=?, fb_id=?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, dto.getFb_Title());
			stat.setString(2, dto.getFb_write());
			stat.setInt(3, dto.getFb_id());
			return stat.executeUpdate() > 0;
		}
	}


}
