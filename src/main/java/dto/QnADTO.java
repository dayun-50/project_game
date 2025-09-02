package dto;

import java.sql.Timestamp;

public class QnADTO {

    private int inqu_pw;
    private String inqu_Title;
    private String inqu_write;
    private String inqu_user_name;
    private Timestamp inqu_date;

    public QnADTO() {}

    public QnADTO(int inqu_pw, String inqu_Title, String inqu_write, String inqu_user_name, Timestamp inqu_date) {
        super();
        this.inqu_pw = inqu_pw;
        this.inqu_Title = inqu_Title;
        this.inqu_write = inqu_write;
        this.inqu_user_name = inqu_user_name;
        this.inqu_date = inqu_date;
    }

    public int getInqu_pw() { return inqu_pw; }
    public void setInqu_pw(int inqu_pw) { this.inqu_pw = inqu_pw; }

    public String getInqu_Title() { return inqu_Title; }
    public void setInqu_Title(String inqu_Title) { this.inqu_Title = inqu_Title; }

    public String getInqu_write() { return inqu_write; }
    public void setInqu_write(String inqu_write) { this.inqu_write = inqu_write; }

    public String getInqu_user_name() { return inqu_user_name; }
    public void setInqu_user_name(String inqu_user_name) { this.inqu_user_name = inqu_user_name; }

    public Timestamp getInqu_date() { return inqu_date; }
    public void setInqu_date(Timestamp inqu_date) { this.inqu_date = inqu_date; }
}
