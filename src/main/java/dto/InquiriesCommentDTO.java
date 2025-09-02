package dto;

import java.sql.Timestamp;

public class InquiriesCommentDTO {
    private int inqc_seq;
    private int fb_id;          // 게시글 번호
    private String inqc_write;  // 댓글 내용
    private Timestamp inqc_date;

    public InquiriesCommentDTO() {}

    public InquiriesCommentDTO(int inqc_seq, int fb_id, String inqc_write, Timestamp inqc_date) {
        this.inqc_seq = inqc_seq;
        this.fb_id = fb_id;
        this.inqc_write = inqc_write;
        this.inqc_date = inqc_date;
    }

    public int getInqc_seq() {
        return inqc_seq;
    }

    public void setInqc_seq(int inqc_seq) {
        this.inqc_seq = inqc_seq;
    }

    public int getFb_id() {
        return fb_id;
    }

    public void setFb_id(int fb_id) {
        this.fb_id = fb_id;
    }

    public String getInqc_write() {
        return inqc_write;
    }

    public void setInqc_write(String inqc_write) {
        this.inqc_write = inqc_write;
    }

    public Timestamp getInqc_date() {
        return inqc_date;
    }

    public void setInqc_date(Timestamp inqc_date) {
        this.inqc_date = inqc_date;
    }
}
