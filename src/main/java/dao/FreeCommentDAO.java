package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.FreeCommentDTO;

public class FreeCommentDAO {
    private static FreeCommentDAO instance;

    public synchronized static FreeCommentDAO getInstance() {
        if (instance == null) {
            instance = new FreeCommentDAO();
        }
        return instance;
    }

   
    private Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // Create
    public boolean insert(FreeCommentDTO dto) throws Exception {
        String sql = "insert into freeComment(fc_id, fb_id, fc_user_name, fc_write, fc_date) "
                   + "values(freeComment_seq.NEXTVAL, ?, ?, ?, ?)";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, dto.getfb_id());
            stat.setString(2, dto.getfc_user_name());
            stat.setString(3, dto.getFc_write());
            stat.setTimestamp(4, dto.getFc_date());

            return stat.executeUpdate() > 0;
        }
    }

    // Read - 특정 게시글의 댓글 목록
    public List<FreeCommentDTO> selectByBoardId(int fb_id) throws Exception {
        String sql = "select * from freeComment where fb_id=? order by fc_id asc";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fb_id);
            try (ResultSet rs = stat.executeQuery()) {
                List<FreeCommentDTO> list = new ArrayList<>();
                while (rs.next()) {
                    FreeCommentDTO dto = new FreeCommentDTO(
                            rs.getInt("fc_id"),
                            rs.getInt("fb_id"),
                            rs.getString("fc_user_name"),
                            rs.getString("fc_write"),
                            rs.getTimestamp("fc_date")
                    );
                    list.add(dto);
                }
                return list;
            }
        }
    }

    // Update
    public boolean update(FreeCommentDTO dto) throws Exception {
        String sql = "update freeComment set fc_write=? where fc_id=?";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, dto.getFc_write());
            stat.setInt(2, dto.getFc_id());
            return stat.executeUpdate() > 0;
        }
    }

    // Delete
    public boolean delete(int fc_id) throws Exception {
        String sql = "delete from freeComment where fc_id=?";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fc_id);
            return stat.executeUpdate() > 0;
        }
    }
    
    public boolean update(int fc_id, String write) throws Exception {
        String sql = "UPDATE freeComment SET fc_write=? WHERE fc_id=?";
        try(Connection con = this.getConnection();
            PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, write);
            stat.setInt(2, fc_id);
            return stat.executeUpdate() > 0;
        }
    }

    
}
