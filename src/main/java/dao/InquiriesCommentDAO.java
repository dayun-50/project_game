package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.InquiriesCommentDTO;

public class InquiriesCommentDAO {
    private static InquiriesCommentDAO instance;

    public synchronized static InquiriesCommentDAO getInstance() {
        if (instance == null) {
            instance = new InquiriesCommentDAO();
        }
        return instance;
    }

    private Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // Create
    public boolean insert(InquiriesCommentDTO dto) throws Exception {
        String sql = "INSERT INTO inquries_comment(inqc_seq, inqc_write) " +
                     "VALUES(inquries_comment_seq.NEXTVAL, ?)";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, dto.getInqc_write());
            return stat.executeUpdate() > 0;
        }
    }

    // Read all comments
    public List<InquiriesCommentDTO> selectAll() throws Exception {
        String sql = "SELECT * FROM inquries_comment ORDER BY inqc_seq ASC";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql);
             ResultSet rs = stat.executeQuery()) {

            List<InquiriesCommentDTO> list = new ArrayList<>();
            while (rs.next()) {
                InquiriesCommentDTO dto = new InquiriesCommentDTO(
                        rs.getInt("inqc_seq"),
                        rs.getString("inqc_write"),
                        rs.getTimestamp("inqc_date")
                );
                list.add(dto);
            }
            return list;
        }
    }

    // Update
    public boolean update(int inqc_seq, String write) throws Exception {
        String sql = "UPDATE inquries_comment SET inqc_write=? WHERE inqc_seq=?";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setString(1, write);
            stat.setInt(2, inqc_seq);
            return stat.executeUpdate() > 0;
        }
    }

    // Delete
    public boolean delete(int inqc_seq) throws Exception {
        String sql = "DELETE FROM inquries_comment WHERE inqc_seq=?";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, inqc_seq);
            return stat.executeUpdate() > 0;
        }
    }
}
