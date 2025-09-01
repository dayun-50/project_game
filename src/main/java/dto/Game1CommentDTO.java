package dto;

public class Game1CommentDTO {
	private int game_comet_seq;
	private int game_parent_seq;
	private int gameid;
	private String game_coment_writer; //댓글 작성자
	private String game_coment; //댓글 내용
	private String game_coment_date; //작성날짜
	
	public Game1CommentDTO() {}

	public Game1CommentDTO(int game_comet_seq, int game_parent_seq, int gameid, String game_coment_writer,
			String game_coment, String game_coment_date) {
		super();
		this.game_comet_seq = game_comet_seq;
		this.game_parent_seq = game_parent_seq;
		this.gameid = gameid;
		this.game_coment_writer = game_coment_writer;
		this.game_coment = game_coment;
		this.game_coment_date = game_coment_date;
	}

	public int getGame_comet_seq() {
		return game_comet_seq;
	}

	public void setGame_comet_seq(int game_comet_seq) {
		this.game_comet_seq = game_comet_seq;
	}

	public int getGame_parent_seq() {
		return game_parent_seq;
	}

	public void setGame_parent_seq(int game_parent_seq) {
		this.game_parent_seq = game_parent_seq;
	}

	public int getGameid() {
		return gameid;
	}

	public void setGameid(int gameid) {
		this.gameid = gameid;
	}

	public String getGame_coment_writer() {
		return game_coment_writer;
	}

	public void setGame_coment_writer(String game_coment_writer) {
		this.game_coment_writer = game_coment_writer;
	}

	public String getGame_coment() {
		return game_coment;
	}

	public void setGame_coment(String game_coment) {
		this.game_coment = game_coment;
	}

	public String getGame_coment_date() {
		return game_coment_date;
	}

	public void setGame_coment_date(String game_coment_date) {
		this.game_coment_date = game_coment_date;
	}
	



}
