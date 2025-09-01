package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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
	
	//댓글 출력
	public ArrayList<Game1CommentDTO> selectAll(int parent_seq) throws Exception {
		 String sql = "select * from Game_Coment where game_parent_seq = ? ORDER BY game_coment_seq DESC";
		 try(Connection con = this.getConnection();
					PreparedStatement stat = con.prepareStatement(sql);){
			 stat.setInt(1, parent_seq);
			 
			 try(ResultSet rs = stat.executeQuery()){
				 ArrayList<Game1CommentDTO> list = new ArrayList<>();
				 while(rs.next()) {
					 int seq = rs.getInt("game_coment_seq");
					 String writer = rs.getString("game_coment_writer");
					 String coment = rs.getString("game_coment");
					 Timestamp date = rs.getTimestamp("game_coment_date"); 
					 String regdate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(date);
					 
					 list.add(new Game1CommentDTO(seq, parent_seq, 0, writer, coment, regdate));
				 }
				 return list;
			 }
		 }
	}
	
	//댓글 갯수 카운트
	public int countComent(int parent_seq) throws Exception {
		String sql = "SELECT COUNT(*) AS cnt FROM Game_Coment WHERE game_parent_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, parent_seq);
			
			try(ResultSet rs = stat.executeQuery()){
				if(rs.next()) {
					int result = rs.getInt("cnt");
					return result;
				}else {
					return 0;
				}
			}
		}
	}
	
	//댓글 입력
	public int comentInsert(Game1CommentDTO dto) throws Exception {
		String sql = "insert into Game_Coment values(Game_Coment_seq.NEXTVAL,?,?,?,?,?)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, dto.getGame_parent_seq());
			stat.setInt(2, 0);
			stat.setString(3, dto.getGame_coment_writer());
			stat.setString(4, dto.getGame_coment());
			stat.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
			
			return stat.executeUpdate();
		}
	}
	
	//댓글 삭제
	public int comentDelete(String seq) throws Exception {
		String sql = "delete from Game_Coment where game_coment_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, seq);
			
			return stat.executeUpdate();
		}
	}
	
	//댓글 수정
	public int comentUpdate(String seq, String text) throws Exception {
		String sql = "update Game_Coment set game_coment = ? where game_coment_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, text);
			stat.setString(2, seq);
			
			return stat.executeUpdate();
		}
	}
}
