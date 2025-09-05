package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.FreeBoardDTO;

public class FreeBoardDAO {
    private static FreeBoardDAO instance;

    public synchronized static FreeBoardDAO getInstance() {
        if(instance == null) instance = new FreeBoardDAO();
        return instance;
    }

    private Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // Create
    public boolean insert(FreeBoardDTO dto) throws Exception {
        String sql = "insert into freeBoard(fb_id, fb_user_name, fb_Title, fb_write, fb_date) "
                   + "values(freeBoard_seq.NEXTVAL, ?, ?, ?, ?)";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, dto.getFb_user_name());
            stat.setString(2, dto.getFb_Title());
            stat.setString(3, dto.getFb_write()); // Base64 포함 HTML
            stat.setTimestamp(4, dto.getFb_date());
            return stat.executeUpdate() > 0;
        }
    }

    // Read - 단일 조회
    public FreeBoardDTO selectById(int fb_id) throws Exception {
        String sql = "select * from freeBoard where fb_id=?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fb_id);
            try(ResultSet rs = stat.executeQuery()) {
                if(rs.next()) {
                    FreeBoardDTO dto = new FreeBoardDTO(
                        rs.getInt("fb_id"),
                        rs.getString("fb_user_name"),
                        rs.getString("fb_Title"),
                        rs.getString("fb_write"),
                        rs.getTimestamp("fb_date")
                    );
                    dto.setView_count(rs.getInt("view_count"));
                    return dto;
                }
                return null;
            }
        }
    }
    

    // Update
    public boolean update(FreeBoardDTO dto) throws Exception {
        String sql = "update freeBoard set fb_Title=?, fb_write=? where fb_id=?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, dto.getFb_Title());
            stat.setString(2, dto.getFb_write());
            stat.setInt(3, dto.getfb_id());
            return stat.executeUpdate() > 0;
        }
    }

    // Delete
    public boolean delete(int fb_id) throws Exception {
        String sql = "delete from freeBoard where fb_id=?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fb_id);
            return stat.executeUpdate() > 0;
        }
    }

    // 조회수 증가
    public void incrementViewCount(int fb_id) throws Exception {
        String sql = "update freeBoard set view_count = view_count + 1 where fb_id = ?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fb_id);
            stat.executeUpdate();
        }
    }

    // 페이지 단위 조회
    public List<FreeBoardDTO> selectPage(int start, int end) throws Exception {
        String sql = "SELECT * FROM (" +
                     " SELECT ROWNUM rnum, a.* FROM (" +
                     "  SELECT * FROM freeBoard ORDER BY fb_id DESC" +
                     " ) a WHERE ROWNUM <= ?" +
                     ") WHERE rnum >= ?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, end);
            stat.setInt(2, start);
            try(ResultSet rs = stat.executeQuery()) {
                List<FreeBoardDTO> list = new ArrayList<>();
                while(rs.next()) {
                    FreeBoardDTO dto = new FreeBoardDTO(
                        rs.getInt("fb_id"),
                        rs.getString("fb_user_name"),
                        rs.getString("fb_Title"),
                        rs.getString("fb_write"),
                        rs.getTimestamp("fb_date")
                    );
                    dto.setView_count(rs.getInt("view_count"));
                    list.add(dto);
                }
                return list;
            }
        }
    }

    // 총 게시글 수
    public int getTotalCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM freeBoard";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql);
            ResultSet rs = stat.executeQuery()) {
            if(rs.next()) return rs.getInt(1);
            return 0;
        }
    }
}
