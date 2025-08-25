package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

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
		String sql = "select user_id, user_pw from users where user_id = ? and user_pw = ?";
		try(Connection con = this.getConnection();
				PreparedStatement stat = con.prepareStatement(sql);){
				stat.setString(1, id);
				stat.setString(2, pw);
				
				return stat.executeUpdate();
		}
	}
}
