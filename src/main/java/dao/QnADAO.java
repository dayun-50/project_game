package dao;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;
import dto.QnADTO;

public class QnADAO {

    private static QnADAO instance = new QnADAO();
    public static QnADAO getInstance() { return instance; }
    private QnADAO() {}

    // DB 연결
    private Connection getConnection() throws Exception {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
        return ds.getConnection();
    }

    // 글 작성
    public void insert(QnADTO dto) throws Exception {
        String sql = "INSERT INTO inquries (inqu_seq, inqu_id, inqu_pw, inqu_write, inqu_title, inqu_user_name, inqu_date) "
                   + "VALUES (inquries_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dto.getInqu_id());
            ps.setInt(2, dto.getInqu_pw());
            ps.setString(3, dto.getInqu_write());
            ps.setString(4, dto.getInqu_Title());
            ps.setString(5, dto.getInqu_user_name());
            ps.setTimestamp(6, dto.getInqu_date());
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                QnADTO dto = new QnADTO();
                dto.setInqu_id(rs.getInt("inqu_id"));
                dto.setInqu_pw(rs.getInt("inqu_pw"));
                dto.setInqu_Title(rs.getString("inqu_title"));
                dto.setInqu_write(rs.getString("inqu_write"));
                dto.setInqu_user_name(rs.getString("inqu_user_name"));
                dto.setInqu_date(rs.getTimestamp("inqu_date"));
                list.add(dto);
            }
        }
        return list;
    }

    // 전체 글 수
    public int getTotalCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM inquries";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if(rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // 글 상세 조회
    public QnADTO selectById(int inqu_id) throws Exception {
        String sql = "SELECT * FROM inquries WHERE inqu_id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                QnADTO dto = new QnADTO();
                dto.setInqu_id(rs.getInt("inqu_id"));
                dto.setInqu_pw(rs.getInt("inqu_pw"));
                dto.setInqu_Title(rs.getString("inqu_title"));
                dto.setInqu_write(rs.getString("inqu_write"));
                dto.setInqu_user_name(rs.getString("inqu_user_name"));
                dto.setInqu_date(rs.getTimestamp("inqu_date"));
                return dto;
            }
        }
        return null;
    }

    // 글 수정 (비밀번호 조건 제거)
    public void update(QnADTO dto) throws Exception {
        String sql = "UPDATE inquries SET inqu_write=?, inqu_title=? WHERE inqu_id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getInqu_write());
            ps.setString(2, dto.getInqu_Title());
            ps.setInt(3, dto.getInqu_id());
            ps.executeUpdate();
        }
    }

    // 글 삭제 (비밀번호 조건 제거)
    public void delete(int inqu_id) throws Exception {
        String sql = "DELETE FROM inquries WHERE inqu_id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            ps.executeUpdate();
        }
    }
}
