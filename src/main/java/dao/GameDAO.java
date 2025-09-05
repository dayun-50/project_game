package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.Rankdto;

public class GameDAO {
	private static GameDAO instance;
	
	public synchronized static GameDAO getInstance() {
		if(instance == null) {
			instance = new GameDAO();
		}
		return instance;
	}
	
	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	
	public int insertScore(Rankdto dto) throws Exception {
	    String sql = "INSERT INTO score (score_id, game_id, s_user_name, score) " +
	                 "VALUES (score_seq.NEXTVAL, ?, ?, ?)";
	    try (Connection con = this.getConnection();
	         PreparedStatement stat = con.prepareStatement(sql)) {
	         
	        stat.setInt(1, dto.getGame_id());
	        stat.setString(2, dto.getUser_name());
	        stat.setInt(3, dto.getScore());
	        
	        return stat.executeUpdate();
	    }
	}
	
	
	
	public ArrayList<Rankdto> getoneRanks(String s_user_name)throws Exception{ //내가 플레이한 게임별 최고 기록
		String sql = "SELECT g.game_id, g.game_name, s.s_user_name, COALESCE(max(s.score),0) as top_score " +
                "FROM game g " +
                "left JOIN score s ON s.game_id = g.game_id " +
                "and s.s_user_name = ? " +
                "GROUP BY g.game_id, g.game_name, s.s_user_name " +
                "ORDER BY g.game_id";
		
		ArrayList<Rankdto> list=new ArrayList<>();
		try(Connection con =this.getConnection()){
			PreparedStatement stat=con.prepareStatement(sql);{
				stat.setString(1, s_user_name);
				
				try(ResultSet rs =stat.executeQuery()){
					while(rs.next()) {
						Rankdto dto=new Rankdto();
						dto.setGame_id(rs.getInt("game_id"));
						dto.setGameName(rs.getString("game_name"));
						dto.setUser_name(rs.getString("s_user_name"));
						dto.setScore(rs.getInt("top_score"));	
						list.add(dto);
					}
				}
			}
		}
		return list;
	}
	
	public ArrayList<Rankdto> getAllRanks() throws Exception { //모든 게임 유저 랭킹별로 
	    String sql = "SELECT g.game_id, g.game_name, s.s_user_name, s.score " +
	                 "FROM score s " +
	                 "JOIN game g ON s.game_id = g.game_id " +
	                 "ORDER BY g.game_id, s.score DESC";

	    ArrayList<Rankdto> list = new ArrayList<>();
	    try (Connection con = this.getConnection();
	         PreparedStatement stat = con.prepareStatement(sql);
	         ResultSet rs = stat.executeQuery()) {
	        
	        while (rs.next()) {
	            Rankdto dto = new Rankdto();
	            dto.setGame_id(rs.getInt("game_id"));
	            dto.setGameName(rs.getString("game_name"));
	            dto.setUser_name(rs.getString("s_user_name"));
	            dto.setScore(rs.getInt("score"));
	            list.add(dto);
	        }
	    }
	    return list;
	}
	
}
