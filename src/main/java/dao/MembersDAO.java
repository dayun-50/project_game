package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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

	//회원가입 members insert
	public int insert(MembersDTO dto) throws Exception { 
		String sql = "insert into users values(?,?,?,?,?,?,?,?)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
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

	//로그인 유효한 id,pw인지 확인
	public int login(String id , String pw) throws Exception{ 
		String sql = "SELECT u.user_id, u.user_nickname FROM users u WHERE u.user_id = ? AND u.user_pw = ? AND NOT EXISTS (SELECT 1"
				+ " FROM BlackList b WHERE b.black_user_id = u.user_id)";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			stat.setString(2, pw);

			try (ResultSet rs = stat.executeQuery()) {
				if (rs.next()) { // 로그인 성공
					return 1;
				} else { // 로그인 실패
					return 0;
				}
			}
		}
	}

	//id 중복검사
	public boolean idCheck(String id) throws Exception{ 
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

	//닉네임 중복검사
	public boolean nicknameCheck(String nickname) throws Exception{ 
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

	//게임메인페이지 유저 닉네임 출력
	public String nicknameSerch(String id) throws Exception{ 
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

	//id찾기
	public ArrayList<String> idSerch(String name, String email, String phone) throws Exception { 
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

	//블랙리스트 체크
	public int blackCheck(String id) throws Exception { 
		String sql = "select black_user_id from BlackList where black_user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);

			try(ResultSet rs = stat.executeQuery()){
				if(rs.next()) {
					return 1;
				}else {
					return 0;
				}
			}
		}
	}

	//계정 존재 여부 (pw찾기)
	public int pwSerch(String id, String name, String phone) throws Exception { 
		String sql = "select user_pw from users where user_id = ? and user_name = ? and user_phone = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			stat.setString(2, name);
			stat.setString(3, phone);

			try(ResultSet rs = stat.executeQuery()){
				if(rs.next()) {
					return 1;
				}else {
					return 0;
				}
			}
		}
	}

	// 비번 변경
	public int pwUpdate(String id, String pw) throws Exception { 
		String sql = "update users set user_pw = ? where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, pw);
			stat.setString(2, id);

			return stat.executeUpdate();
		}
	}

	// 필요한 정보 골라가라고 selectAll
	public MembersDTO selectAll(String id) throws Exception { 
		String sql = "select * from users where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);

			ArrayList<MembersDTO> list = new ArrayList<>();
			try(ResultSet rs = stat.executeQuery();){
				if(rs.next()) {
					String nickname = rs.getString("user_nickname");
					String name = rs.getString("user_name");
					String phone = rs.getString("user_phone");
					String email = rs.getString("user_email");
					Timestamp date = rs.getTimestamp("user_join_date");
					String regdate = new SimpleDateFormat("yyyy년 MM월 dd일").format(date);
					String agree = rs.getString("agree");

					return new MembersDTO(id, "", nickname, name, phone, email, regdate, agree);
				}
				return null;
			}
		}
	}
	
	
	// 마이페이지 정보 수정
	public int mypageUpdate(String id, String name, String phone, String email) throws Exception{
		String sql = "update users set user_name = ?, user_phone = ?, user_email = ? where user_id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, name);
			stat.setString(2, phone);
			stat.setString(3, email);
			stat.setString(4, id);
			
			return stat.executeUpdate();
		}
	}
	
	public int membersSecession(String id) throws Exception { // 회원 탈퇴
		String sql = "delete from users where user_id = ?";
		try(Connection con = this.getConnection();
	            PreparedStatement stat = con.prepareStatement(sql);){
			stat.setString(1, id);
			
			return stat.executeUpdate();
		}
	}
}
