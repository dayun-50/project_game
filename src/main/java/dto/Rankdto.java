package dto;



public class Rankdto {
	
	private int game_id;
	private String gameName;
	private String user_name;
	private int score;
	
	public Rankdto() {
		
	}
	
	public Rankdto(int game_id, String gameName, String user_name, int score) {
		super();
		this.game_id = game_id;
		this.gameName = gameName;
		this.user_name = user_name;
		this.score = score;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	

	
	public int getGame_id() {
		return game_id;
	}
	public void setGame_id(int game_id) {
		this.game_id = game_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}

	
}
