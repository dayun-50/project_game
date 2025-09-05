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

    // 글 작성 (시퀀스 사용)
    public void insert(QnADTO dto) throws Exception {
        String sql = "INSERT INTO inquries (inqu_seq, inqu_id, inqu_pw, inqu_write, inqu_title, inqu_user_name, inqu_date) "
                   + "VALUES (inquries_seq.NEXTVAL, inqu_id_seq.NEXTVAL, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getInqu_pw());          // 비밀번호 String 처리
            ps.setString(2, dto.getInqu_write());
            ps.setString(3, dto.getInqu_Title());
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    QnADTO dto = new QnADTO();
                    dto.setInqu_id(rs.getInt("inqu_id"));
                    dto.setInqu_pw(rs.getString("inqu_pw"));
                    dto.setInqu_Title(rs.getString("inqu_title"));
                    dto.setInqu_write(rs.getString("inqu_write"));
                    dto.setInqu_user_name(rs.getString("inqu_user_name"));
                    dto.setInqu_date(rs.getTimestamp("inqu_date"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    public int getTotalCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM inquries";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if(rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // 글 ID로 DTO 조회 (상세페이지 및 비밀번호 체크용)
    public QnADTO selectById(int inqu_id) throws Exception {
        String sql = "SELECT * FROM inquries WHERE inqu_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    QnADTO dto = new QnADTO();
                   
                    dto.setInqu_id(rs.getInt("inqu_id"));
                    dto.setInqu_pw(rs.getString("inqu_pw")); // String
                    dto.setInqu_Title(rs.getString("inqu_title"));
                    dto.setInqu_write(rs.getString("inqu_write"));
                    dto.setInqu_user_name(rs.getString("inqu_user_name"));
                    dto.setInqu_date(rs.getTimestamp("inqu_date"));
                    return dto;
                }
            }
        }
        return null;
    }

    // 글 수정
    public void update(QnADTO dto) throws Exception {
        String sql = "UPDATE inquries SET inqu_write=?, inqu_title=? WHERE inqu_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dto.getInqu_write());
            ps.setString(2, dto.getInqu_Title());
            ps.setInt(3, dto.getInqu_id());
            ps.executeUpdate();
        }
    }

    // 글 삭제
    public void delete(int inqu_id) throws Exception {
        String sql = "DELETE FROM inquries WHERE inqu_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            ps.executeUpdate();
        }
    }

    // 비밀번호 일치 여부 확인
    public boolean checkPassword(int inqu_id, String inputPw) throws Exception {
        String sql = "SELECT inqu_pw FROM inquries WHERE inqu_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    String dbPw = rs.getString("inqu_pw");
                    return dbPw.equals(inputPw);
                }
            }
        }
        return false;
    }

    // 관리자 댓글 조회 (선택)
    public List<InquiriesCommentDTO> selectComments(int inqu_id) throws Exception {
        List<InquiriesCommentDTO> comments = new ArrayList<>();
        String sql = "SELECT * FROM inquries_comment WHERE inqu_id=? ORDER BY inqc_date ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inqu_id);
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                	InquiriesCommentDTO comment = new InquiriesCommentDTO();
                    comment.setInqu_id(rs.getInt("inqu_id"));
                    comment.setInqc_write(rs.getString("inqc_write"));
                    comment.setInqc_date(rs.getTimestamp("inqc_date"));
                    comments.add(comment);
                }
            }
        }
        return comments;
    }
    
 // LIKE 파라미터 유틸
    private static String likeParam(String q) {
        if(q == null) q = "";
        q = q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
        return "%" + q + "%";
    }

    // (A) 제목 검색: 페이지 단위 조회
    public List<QnADTO> searchTitlePage(String keyword, int start, int end) throws Exception {
        String sql =
            "SELECT * FROM (" +
            "  SELECT ROW_NUMBER() OVER (ORDER BY inqu_date DESC) rnum," +
            "         inqu_id, inqu_pw, inqu_title, inqu_write, inqu_user_name, inqu_date " +
            "  FROM inquries " +
            "  WHERE LOWER(inqu_title) LIKE LOWER(?) ESCAPE '\\'" +
            ") WHERE rnum BETWEEN ? AND ?";

        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, likeParam(keyword));
            ps.setInt(2, start);
            ps.setInt(3, end);

            try(ResultSet rs = ps.executeQuery()) {
                List<QnADTO> list = new ArrayList<>();
                while(rs.next()) {
                    QnADTO dto = new QnADTO(
                        rs.getInt("inqu_id"),
                        rs.getString("inqu_pw"),
                        rs.getString("inqu_title"),
                        rs.getString("inqu_write"),
                        rs.getString("inqu_user_name"),
                        rs.getTimestamp("inqu_date")
                    );
                    list.add(dto);
                }
                return list;
            }
        }
    }

    // (B) 제목 검색: 전체 개수
    public int getTitleSearchCount(String keyword) throws Exception {
        String sql = "SELECT COUNT(*) FROM inquries " +
                     "WHERE LOWER(inqu_title) LIKE LOWER(?) ESCAPE '\\'";
        try(Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, likeParam(keyword));
            try(ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    
}
