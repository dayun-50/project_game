package dto;

public class GameBoardDTO {
    private int game_seq;
    private int gameid;
    private String gameboardtitle;
    private String gamecoment;
    private String gamewrtier;
    private String game_board_date;
    private int view_count;

    public GameBoardDTO() {}
    
    public GameBoardDTO(int game_seq, int gameid, String gameboardtitle, String gamecoment, String gamewrtier, String game_board_date, int view_count) {
        this.game_seq = game_seq;
        this.gameid = gameid;
        this.gameboardtitle = gameboardtitle;
        this.gamecoment = gamecoment;
        this.gamewrtier = gamewrtier;
        this.game_board_date = game_board_date;
        this.view_count = view_count;
    }

    public int getGame_seq() { return game_seq; }
    public void setGame_seq(int game_seq) { this.game_seq = game_seq; }

    public int getGameid() { return gameid; }
    public void setGameid(int gameid) { this.gameid = gameid; }

    public String getGameboardtitle() { return gameboardtitle; }
    public void setGameboardtitle(String gameboardtitle) { this.gameboardtitle = gameboardtitle; }

    public String getGamecoment() { return gamecoment; }
    public void setGamecoment(String gamecoment) { this.gamecoment = gamecoment; }

    public String getGamewrtier() { return gamewrtier; }
    public void setGamewrtier(String gamewrtier) { this.gamewrtier = gamewrtier; }

    public String getGame_board_date() { return game_board_date; }
    public void setGame_board_date(String game_board_date) { this.game_board_date = game_board_date; }

    public int getView_count() { return view_count; }
    public void setView_count(int view_count) { this.view_count = view_count; }
}
