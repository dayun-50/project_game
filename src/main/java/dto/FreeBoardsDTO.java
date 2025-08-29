package dto;

import java.sql.Timestamp;

public class FreeBoardsDTO {

	private int fb_id; 
	private String fb_user_name;
	private String fb_Title;
	private String fb_write;
	private Timestamp fb_date;
	
	public FreeBoardsDTO(){
		
	}
	
	public FreeBoardsDTO(String fb_user_name, String fb_Title, String fb_write, Timestamp fb_date) {
		super();
		this.fb_user_name = fb_user_name;
		this.fb_Title = fb_Title;
		this.fb_write = fb_write;
		this.fb_date = fb_date;
	}
	public int getFb_id() {
		return fb_id;
	}
	public void setFb_id(int fb_id) {
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
