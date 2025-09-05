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
        if(instance == null) instance = new Game1BoardDAO();
        return instance;
    }

    public Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // 게시글 조회
    public GameBoardDTO selectById(int game_seq) throws Exception {
        String sql = "SELECT * FROM game_board WHERE game_seq = ?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, game_seq);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                return new GameBoardDTO(
                    rs.getInt("game_seq"),
                    rs.getInt("gameid"),
                    rs.getString("gameboardtitle"),
                    rs.getString("gamecoment"),
                    rs.getString("gamewrtier"),
                    new SimpleDateFormat("yyyy.MM.dd HH:mm").format(rs.getTimestamp("game_board_date")),
                    rs.getInt("view_count")
                );
            }
        }
        return null;
    }

    // 게시글 목록
    public ArrayList<GameBoardDTO> selectFromTo(int from, int to, int gameid) throws Exception {
        String sql = "SELECT * FROM (SELECT game_board.*, ROW_NUMBER() OVER(ORDER BY game_seq DESC) rn FROM game_board WHERE gameid = ?) sub WHERE rn BETWEEN ? AND ?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, gameid);
            ps.setInt(2, from);
            ps.setInt(3, to);
            ResultSet rs = ps.executeQuery();
            ArrayList<GameBoardDTO> list = new ArrayList<>();
            while(rs.next()) {
                list.add(new GameBoardDTO(
                    rs.getInt("game_seq"),
                    rs.getInt("gameid"),
                    rs.getString("gameboardtitle"),
                    rs.getString("gamecoment"),
                    rs.getString("gamewrtier"),
                    new SimpleDateFormat("yyyy.MM.dd HH:mm").format(rs.getTimestamp("game_board_date")),
                    rs.getInt("view_count")
                ));
            }
            return list;
        }
    }

    // 게시글 총 개수
    public int getRecordTotalCount(int gameid) throws Exception {
        String sql = "SELECT COUNT(*) FROM game_board WHERE gameid=?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, gameid);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // 게시글 작성
    public int boardInsert(GameBoardDTO dto) throws Exception {
        String sql = "INSERT INTO game_board VALUES(game_board_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, dto.getGameid());
            ps.setString(2, dto.getGameboardtitle());
            ps.setString(3, dto.getGamecoment());
            ps.setString(4, dto.getGamewrtier());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setInt(6, 0);
            return ps.executeUpdate();
        }
    }

    // 게시글 삭제
    public int deleteGameBoard(int seq) throws Exception {
        String sql = "DELETE FROM game_board WHERE game_seq=?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, seq);
            return ps.executeUpdate();
        }
    }

    // 게시글 수정
    public int update(GameBoardDTO dto) throws Exception {
        String sql = "UPDATE game_board SET gameboardtitle=?, gamecoment=? WHERE game_seq=?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dto.getGameboardtitle());
            ps.setString(2, dto.getGamecoment());
            ps.setInt(3, dto.getGame_seq());
            return ps.executeUpdate();
        }
    }

    // 조회수 업데이트
    public void incrementView(int seq) throws Exception {
        String sql = "UPDATE game_board SET view_count = view_count + 1 WHERE game_seq=?";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, seq);
            ps.executeUpdate();
        }
    }
	// (B) 제목 검색: 전체 개수
	public int getTitleSearchCount(int gameid, String keyword) throws Exception {
	    String sql =
	        "SELECT COUNT(*) " +
	        "  FROM game_board " +
	        " WHERE gameid = ? " +
	        "   AND LOWER(gameboardtitle) LIKE LOWER(?) ESCAPE '\\'";

	    try (Connection con = getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, gameid);
	        ps.setString(2, likeParam(keyword));

	        try (ResultSet rs = ps.executeQuery()) {
	            return rs.next() ? rs.getInt(1) : 0;
	        }
	    }
	}

private static String likeParam(String q) {
if (q == null) q = "";
q = q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
return "%" + q + "%";
}

}
