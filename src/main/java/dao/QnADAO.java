package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.QnADTO;

public class QnADAO {

    private static QnADAO instance = new QnADAO();
    public static QnADAO getInstance() { return instance; }

    private QnADAO() {}

    private Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // 글 작성
    public void insert(QnADTO dto) throws Exception {
        String sql = "INSERT INTO inquries (inqu_seq, inqu_pw, inqu_write, inqu_title, inqu_user_name, inqu_date) "
                   + "VALUES (inquries_seq.NEXTVAL,?, ?, ?, ?, ?)";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dto.getInqu_pw());
            ps.setString(2, dto.getInqu_write());
            ps.setString(3, dto.getInqu_Title()); // ✅ title 포함
            ps.setString(4, dto.getInqu_user_name());
            ps.setTimestamp(5, dto.getInqu_date());
            ps.executeUpdate();
        }
    }

    // 페이징 조회
    public List<QnADTO> selectPage(int start, int end) throws Exception {
        List<QnADTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                   + "  SELECT a.*, ROW_NUMBER() OVER (ORDER BY inqu_date DESC) rnum "
                   + "  FROM inquries a"
                   + ") WHERE rnum BETWEEN ? AND ?";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QnADTO dto = new QnADTO();
                dto.setInqu_pw(rs.getInt("inqu_pw"));
                dto.setInqu_Title(rs.getString("inqu_title")); // ✅ 추가
                dto.setInqu_write(rs.getString("inqu_write"));
                dto.setInqu_user_name(rs.getString("inqu_user_name"));
                dto.setInqu_date(rs.getTimestamp("inqu_date"));
                list.add(dto);
            }
        }
        return list;
    }

    // 전체 글 개수
    public int getTotalCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM inquries";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // 특정 글 조회 (닉네임 조회)
    public QnADTO selectById(String inqu_user_name) throws Exception {
        String sql = "SELECT * FROM inquries WHERE inqu_user_name = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inqu_user_name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                QnADTO dto = new QnADTO();
                dto.setInqu_pw(rs.getInt("inqu_pw"));
                dto.setInqu_Title(rs.getString("inqu_title")); // ✅ 추가
                dto.setInqu_write(rs.getString("inqu_write"));
                dto.setInqu_user_name(rs.getString("inqu_user_name"));
                dto.setInqu_date(rs.getTimestamp("inqu_date"));
                return dto;
            }
        }
        return null;
    }

    // 글 수정
    public void update(QnADTO dto) throws Exception {
        String sql = "UPDATE inquries SET inqu_write=?, inqu_title=?, inqu_user_name=? WHERE inqu_pw=?";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getInqu_write());
            ps.setString(2, dto.getInqu_Title()); // ✅ title 업데이트
            ps.setString(3, dto.getInqu_user_name());
            ps.setInt(4, dto.getInqu_pw());
            ps.executeUpdate();
        }
    }

    // 글 삭제
    public void delete(int inqu_pw) throws Exception {
        String sql = "DELETE FROM inquries WHERE inqu_pw=?";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_pw);
            ps.executeUpdate();
        }
    }
}
