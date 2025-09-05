package dto;

import java.sql.Timestamp;

public class FreeCommentDTO {
    private int fc_id;           // 댓글 PK
    private int fb_id;           // 어떤 게시글에 달린 댓글인지 (FK)
    private String fc_user_name;   // 작성자
    private String fc_write;     // 내용
    private Timestamp fc_date;   // 작성일자
    
    // 전체 생성자
    public FreeCommentDTO(int fc_id, int fb_id, String fc_user_name, String fc_write, Timestamp fc_date) {
        this.fc_id = fc_id;
        this.fb_id = fb_id;
        this.fc_user_name = fc_user_name;
        this.fc_write = fc_write;
        this.fc_date = fc_date;
    }

    // 댓글 등록용 생성자
    public FreeCommentDTO(int fb_id, String fc_user_name, String fc_write, Timestamp fc_date) {
        this.fb_id = fb_id;
        this.fc_user_name = fc_user_name;
        this.fc_write = fc_write;
        this.fc_date = fc_date;
    }

    // Getter / Setter
    public int getFc_id() { return fc_id; }
    public void setFc_id(int fc_id) { this.fc_id = fc_id; }
    public int getfb_id() { return fb_id; }
    public void setfb_id(int fb_id) { this.fb_id = fb_id; }
    public String getfc_user_name() { return fc_user_name; }
    public void setfc_user_name(String fc_user_name) { this.fc_user_name = fc_user_name; }
    public String getFc_write() { return fc_write; }
    public void setFc_write(String fc_write) { this.fc_write = fc_write; }
    public Timestamp getFc_date() { return fc_date; }
    public void setFc_date(Timestamp fc_date) { this.fc_date = fc_date; }
}
