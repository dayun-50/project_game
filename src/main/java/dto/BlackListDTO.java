package dto;

public class BlackListDTO {
	private int black_id;
	private String black_user_id;
	private String black_comment;
	
	public BlackListDTO() {}
	public BlackListDTO(int black_id, String black_user_id, String black_comment) {
		super();
		this.black_id = black_id;
		this.black_user_id = black_user_id;
		this.black_comment = black_comment;
	}
	public int getBlack_id() {
		return black_id;
	}
	public void setBlack_id(int black_id) {
		this.black_id = black_id;
	}
	public String getBlack_user_id() {
		return black_user_id;
	}
	public void setBlack_user_id(String black_user_id) {
		this.black_user_id = black_user_id;
	}
	public String getBlack_comment() {
		return black_comment;
	}
	public void setBlack_comment(String black_comment) {
		this.black_comment = black_comment;
	}
	
	
}
