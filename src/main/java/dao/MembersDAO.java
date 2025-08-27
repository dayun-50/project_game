package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.MembersDTO;



public class MembersDAO {
	private static MembersDAO instance;
	
	public synchronized static MembersDAO getInstance() { //dao 인스턴스
		if(instance == null) {
			instance = new MembersDAO();
		}
		return instance;
	}
	
	public Connection getConnection() throws Exception{ //tomcat db연결
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	

	public static String encrypt(String text) { //SHA 암호화
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			byte[] bytes = text.getBytes(StandardCharsets.UTF_8);
			byte[] digest = md.digest(bytes);

			StringBuilder builder = new StringBuilder();
			for (byte b : digest) {
				builder.append(String.format("%02x", b));
			}
			return builder.toString();

		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-512 암호화 실패", e);
		}
	}
	
	public int insert(MembersDTO dto) throws Exception { //회원가입 members insert
		String sql = "insert into users values(?,?,?,?,?,?,?,?)";
		try(PreparedStatement stat = getConnection().prepareStatement(sql);
				){
			stat.setString(1, dto.getUser_id());
			stat.setString(2, dto.getUser_pw());
			stat.setString(3, dto.getUser_nickname());
			stat.setString(4, dto.getUser_name());
			stat.setString(5, dto.getUser_phone());
			stat.setString(6, dto.getUser_email());
			stat.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
			stat.setString(8, dto.getAgree());
			return stat.executeUpdate();
		}
	}
	
	public int login(String id , String pw) throws Exception{ //로그인 유효한 id,pw인지 확인
		String sql = "SELECT u.user_id, u.user_nickname FROM users u WHERE u.user_id = ? AND u.user_pw = ? AND NOT EXISTS (SELECT 1"
				+ " FROM BlackList b WHERE b.black_user_id = u.user_id)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
				stat.setString(1, id);
				stat.setString(2, pw);
				
				return stat.executeUpdate();
		}
	}
	
	public boolean idCheck(String id) throws Exception{ //id 중복검사
		String sql = "select user_id from users where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			int result = stat.executeUpdate();
			if(result > 0) {
				return true;
			}else {
				return false;
			}
		}
	}
	
	public boolean nicknameCheck(String nickname) throws Exception{ //닉네임 중복검사
		String sql = "select user_nickname from users where user_nickname = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, nickname);
			int result = stat.executeUpdate();
			if(result > 0) {
				return true;
			}else {
				return false;
			}
		}
	}
	
	public String nicknameSerch(String id) throws Exception{ //게임메인페이지 유저 닉네임 출력
		String sql = "select user_nickname from users where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			
			try(ResultSet rs = stat.executeQuery()){
				if(rs.next()) {
					return rs.getString("user_nickname");
				}else {
					return null;
				}
			}
		}
	}
	
	public ArrayList<String> idSerch(String name, String email, String phone) throws Exception { //id찾기
		String sql = "select user_id from users where user_name = ? and user_email = ? and user_phone = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, name);
			stat.setString(2, email);
			stat.setString(3, phone);
			ArrayList<String> list = new ArrayList<>();
			
			try(ResultSet rs = stat.executeQuery()){
				while(rs.next()) {
					list.add(rs.getString("user_id"));
				}
				return list;
			}
		}
	}
	
	public int blackCheck(String id) throws Exception { //블랙리스트 체크
		String sql = "select black_user_id from BlackList where black_user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			
			return stat.executeUpdate();
		}
	}
	
	public int pwSerch(String id, String name, String phone) throws Exception { //계정 존재 여부 (pw찾기)
		String sql = "select user_pw from users where user_id = ? and user_name = ? and user_phone = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			stat.setString(2, name);
			stat.setString(3, phone);
			
			return stat.executeUpdate();
		}
	}
	
	public int pwUpdate(String id, String pw) throws Exception { // 비번 변경
		String sql = "update users set user_pw = ? where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, pw);
			stat.setString(2, id);
			
			return stat.executeUpdate();
		}
	}
}
