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

import dto.GameBoardDTO;

public class Game1BoardDAO {
	private static Game1BoardDAO instance;
	
	public synchronized static Game1BoardDAO getInstance() {
		if(instance == null) {
			instance = new Game1BoardDAO();
		}
		return instance;
	}
	
	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	//게임 1 게시글 insert
	public int boardInsert(GameBoardDTO dto) throws Exception {
		String sql = "insert into game_board values(game_board_seq.NEXTVAL,?,?,?,?,?,?)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, dto.getGameid());
			stat.setString(2, dto.getGameboardtitle());
			stat.setString(3, dto.getGamecoment());
			stat.setString(4, dto.getGamewrtier());
			stat.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
			stat.setInt(6, 0);
		
			return stat.executeUpdate();
		}
	}
	
	//게임1 게시판 목록 출력
	public ArrayList<GameBoardDTO> game1SelectAll() throws Exception {
		String sql = "select * from game_board where gameid = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, 1); // 게임 1만 출력하게끔
			
			ArrayList<GameBoardDTO> list = new ArrayList<>();
			try(ResultSet rs = stat.executeQuery()){
				while(rs.next()) {
					int seq = rs.getInt("game_seq");
					String title = rs.getString("gameboardtitle");
					String coment = rs.getString("gamecoment");
					String wrtier = rs.getString("gamewrtier");
					Timestamp date = rs.getTimestamp("game_board_date"); 
					String regdate = new SimpleDateFormat("yyyy.MM.dd").format(date);
					int count = rs.getInt("view_count");
					
					list.add(new GameBoardDTO(seq, 1, title, coment, wrtier, regdate, count));
				}
				return list;
			}
		}
	}
}
