package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.freeBoardDTO;

public class freeBoardDAO {
	private static freeBoardDAO instance;

	public synchronized static freeBoardDAO getInstance() {
		if(instance == null) {
			instance = new freeBoardDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	//  Create
	public boolean insert(freeBoardDTO dto) throws Exception{
		String sql = "insert into freeBoard(fb_id, fb_user_name, fb_Title, fb_write, fb_date) "
				   + "values(freeBoard_seq.NEXTVAL, ?, ?, ?, ?)";
		try(Connection con = this.getConnection();
			PreparedStatement stat = con.prepareStatement(sql)){
			System.out.println(dto.getFb_Title());
			System.out.println(dto.getFb_user_name());
			System.out.println(dto.getFb_write());
			stat.setString(1, dto.getFb_user_name());
			stat.setString(2, dto.getFb_Title());
			stat.setString(3, dto.getFb_write());
			stat.setTimestamp(4, dto.getFb_date());
			
			return stat.executeUpdate() > 0;
		}
	}
	
	//  Read - 전체 목록
	public List<freeBoardDTO> selectAll() throws Exception {
		String sql = "select * from freeBoard order by fb_id desc";
		try(Connection con = this.getConnection();
			PreparedStatement stat = con.prepareStatement(sql);
			ResultSet rs = stat.executeQuery()){
			
			List<freeBoardDTO> list = new ArrayList<>();
			while(rs.next()) {
				freeBoardDTO dto = new freeBoardDTO(
						rs.getInt("fb_id"),
						rs.getString("fb_user_name"),
						rs.getString("fb_Title"),
						rs.getString("fb_write"),
						rs.getTimestamp("fb_date")
				);
				list.add(dto);
			}
			return list;
		}
	}
	
	//  Read - 단일 조회
	public freeBoardDTO selectById(int fb_id) throws Exception {
		String sql = "select * from freeBoard where fb_id=?";
		try(Connection con = this.getConnection();
			PreparedStatement stat = con.prepareStatement(sql)){
			
			stat.setInt(1, fb_id);
			try(ResultSet rs = stat.executeQuery()){
				if(rs.next()) {
					return new freeBoardDTO(
							rs.getInt("fb_id"),
							rs.getString("fb_user_name"),
							rs.getString("fb_Title"),
							rs.getString("fb_write"),
							rs.getTimestamp("fb_date")
					);
				}
				return null;
			}
		}
	}
	
	//  Update
	public boolean update(freeBoardDTO dto) throws Exception{
		String sql = "update freeBoard set fb_Title=?, fb_write=? where fb_id=?";
		try(Connection con = this.getConnection();
			PreparedStatement stat = con.prepareStatement(sql)){
			
			stat.setString(1, dto.getFb_Title());
			stat.setString(2, dto.getFb_write());
			stat.setInt(3, dto.getfb_id());
			
			return stat.executeUpdate() > 0;
		}
	}
	
	//  Delete
	public boolean delete(int fb_id) throws Exception {
		String sql = "delete from freeBoard where fb_id=?";
		try(Connection con = this.getConnection();
			PreparedStatement stat = con.prepareStatement(sql)){
			
			stat.setInt(1, fb_id);
			return stat.executeUpdate() > 0;
		}
	}
}
