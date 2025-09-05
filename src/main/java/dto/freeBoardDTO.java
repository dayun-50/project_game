package dto;

import java.sql.Timestamp;

public class freeBoardDTO {
	;private int fb_id;
	private String fb_user_name;
	private String fb_Title;
	private String fb_write;
	private Timestamp fb_date;
	private int view_count;
	// 글쓰기용 생성자
	public freeBoardDTO(String fb_user_name, String fb_Title, String fb_write, Timestamp fb_date) {
		this.fb_user_name = fb_user_name;
		this.fb_Title = fb_Title;
		this.fb_write = fb_write;
		this.fb_date = fb_date;
	}

	// 수정용 생성자
	public freeBoardDTO(int fb_id, String fb_Title, String fb_write) {
		this.fb_id = fb_id;
		this.fb_Title = fb_Title;
		this.fb_write = fb_write;
	}

	// 전체 생성자
	public freeBoardDTO(int fb_id, String fb_user_name, String fb_Title, String fb_write, Timestamp fb_date) {
		this.fb_id = fb_id;
		this.fb_user_name = fb_user_name;
		this.fb_Title = fb_Title;
		this.fb_write = fb_write;
		this.fb_date = fb_date;
	}

	// Getter / Setter
	public int getView_count() {
	    return view_count;
	}

	public void setView_count(int view_count) {
	    this.view_count = view_count;
	}
	public int getfb_id() { 
		return fb_id; 
		}
	public void setfb_id(int fb_id) { 
		this.fb_id = fb_id;
		}
	public String getFb_user_name() {
		return fb_user_name; 
		}
	public void setFb_user_name(String fb_user_name) {
		this.fb_user_name = fb_user_name; 
		}
	public String getFb_Title() { 
		return fb_Title;
		}
	public void setFb_Title(String fb_Title) {
		this.fb_Title = fb_Title;
		}
	public String getFb_write() { 
		return fb_write; 
		}
	public void setFb_write(String fb_write) {
		this.fb_write = fb_write; 
		}
	public Timestamp getFb_date() {
		return fb_date; 
		}
	public void setFb_date(Timestamp fb_date) { 
		this.fb_date = fb_date; 
		}
}
