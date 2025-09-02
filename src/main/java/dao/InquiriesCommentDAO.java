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

    // 댓글 조회 (게시글별)
    public List<InquiriesCommentDTO> selectByFbId(int fb_id) throws Exception {
        String sql = "SELECT * FROM inquries_comment WHERE fb_id=? ORDER BY inqc_seq ASC";
        try (Connection con = this.getConnection();
             PreparedStatement stat = con.prepareStatement(sql)) {
            stat.setInt(1, fb_id);
            try (ResultSet rs = stat.executeQuery()) {
                List<InquiriesCommentDTO> list = new ArrayList<>();
                while (rs.next()) {
                    InquiriesCommentDTO dto = new InquiriesCommentDTO(
                        rs.getInt("inqc_seq"),
                        rs.getInt("fb_id"),
                        rs.getString("inqc_write"),
                        rs.getTimestamp("inqc_date")
                    );
                    list.add(dto);
                }
                return list;
            }
        }
    }
}
