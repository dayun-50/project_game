package dto;

public class BlackListDTO {
	private int black_id;
	private String black_user_id;
	private String black_Comment;
	
	public BlackListDTO() {}
	public BlackListDTO(int black_id, String black_user_id, String black_Comment) {
		super();
		this.black_id = black_id;
		this.black_user_id = black_user_id;
		this.black_Comment = black_Comment;
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
	public String getBlack_Comment() {
		return black_Comment;
	}
	public void setBlack_Comment(String black_Comment) {
		this.black_Comment = black_Comment;
	}
	
	
}
