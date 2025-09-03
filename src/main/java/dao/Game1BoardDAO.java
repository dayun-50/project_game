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
	
	public GameBoardDTO selectById(int game_seq) {
	    GameBoardDTO dto = null;
	    String sql = "SELECT * FROM game_board WHERE game_seq = ?";
	    
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, game_seq);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            dto = new GameBoardDTO(
	                rs.getInt("game_seq"),
	                rs.getInt("gameid"),
	                rs.getString("gameboardtitle"),
	                rs.getString("gamecoment"),
	                rs.getString("gamewrtier"),
	                rs.getString("game_board_date"),
	                rs.getInt("view_count")
	            );
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return dto;
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
		String sql = "select * from game_board where gameid = ? order by game_board_date desc";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, 1); // 게임 1만 출력하게끔
			
			try(ResultSet rs = stat.executeQuery()){
				ArrayList<GameBoardDTO> list = new ArrayList<>();
				while(rs.next()) {
					int seq = rs.getInt("game_seq");
					String title = rs.getString("gameboardtitle");
					String wrtier = rs.getString("gamewrtier");
					Timestamp date = rs.getTimestamp("game_board_date"); 
					String regdate = new SimpleDateFormat("yyyy.MM.dd").format(date);
					int count = rs.getInt("view_count");
					
					list.add(new GameBoardDTO(seq, 1, title, "", wrtier, regdate, count));
				}
				return list;
			}
		}
	}
	
	//게임1 게시판 내용 출력
	public ArrayList<GameBoardDTO> listCheck(int seq) throws Exception {
		String sql = "select * from game_board where game_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, seq);
			
			try(ResultSet rs = stat.executeQuery()){
				ArrayList<GameBoardDTO> list = new ArrayList<>();
				while(rs.next()) {
					String title = rs.getString("gameboardtitle");
					String coment = rs.getString("gamecoment");
					String wrtier = rs.getString("gamewrtier");
					Timestamp date = rs.getTimestamp("game_board_date"); 
					String regdate = new SimpleDateFormat("yyyy.MM.dd HH:mm").format(date);
					int count = rs.getInt("view_count");
					
					list.add(new GameBoardDTO(seq, 1, title, coment, wrtier, regdate, count));
				}
				return list;
			}
		}
	}
	
	//게시판 view카운트
	public void count(int count, int seq) throws Exception {
		String sql = "update game_board set view_count = ? where game_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setInt(1, count);
			stat.setInt(2, seq);
			stat.executeUpdate();
		}
	}
	
	//네비사용 게임게시판 목록출력
	public ArrayList<GameBoardDTO> selectFromTo(int from, int to, String gameid) throws Exception{
		String sql="SELECT  * FROM (select game_board.*,  ROW_NUMBER() OVER (ORDER BY game_seq DESC) rn  FROM game_board where gameid = ?) sub WHERE rn BETWEEN ? AND ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, gameid);
			stat.setInt(2, from);
			stat.setInt(3, to);
			
			try(ResultSet rs = stat.executeQuery();){
				ArrayList<GameBoardDTO> list = new ArrayList<>();
				while(rs.next()) {
					int seq = rs.getInt("game_seq");
					int gameId = rs.getInt("gameid");
					String title = rs.getString("gameboardtitle");
					String coment = rs.getString("gamecoment");
					String wrtier = rs.getString("gamewrtier");
					Timestamp date = rs.getTimestamp("game_board_date"); 
					String regdate = new SimpleDateFormat("yyyy.MM.dd HH:mm").format(date);
					int count = rs.getInt("view_count");
					
					list.add(new GameBoardDTO(seq, gameId, title, coment, wrtier, regdate, count));	
				}
				return list;
			}
		}
	}
	
	//네비사용시 필요한 게시물갯수
	public int getRecordTotalCount() throws Exception{
		String sql = "select count(*) from game_board";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);
				ResultSet rs = stat.executeQuery();){
					rs.next();
					return rs.getInt(1);
				}
	}
	
	//게시물 삭제
	public int deleteGameBoard(String seq) throws Exception{
		String sql = "delete from game_board where game_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql)){
			stat.setString(1, seq);
			
			return stat.executeUpdate();
		}
	}
	
	//게시물 수정
	public int updateGameBoard(String seq, String text) throws Exception  {
		String sql = "update game_board set gamecoment = ? where game_seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql)){
			stat.setString(1, text);
			stat.setString(2, seq);
			
			return stat.executeUpdate();
		}
	}
}
