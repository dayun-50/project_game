package controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MembersDAO;
import dto.MembersDTO;

@WebServlet("*.MembersController")
public class MembersController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		MembersDAO dao = MembersDAO.getInstance();
		try {
			if(cmd.equals("/signuppage.MembersController")) { //회원가입 페이지 이동
				response.sendRedirect("/members/singup.jsp");
			
			}else if(cmd.equals("/loginpgae.MembersController")) { //로그인 페이지 이동
				response.sendRedirect("/members/login.jsp");
			
			}else if(cmd.equals("/indexpage.MembersController")) { //메인 페이지 이동
				response.sendRedirect("/index.jsp");
				
			}else if(cmd.equals("/signup.MembersController")) { //회원가입 데이터 저장
				response.setContentType("text/html; charset=UTF-8");
				String id = request.getParameter("id");
				String password = request.getParameter("pw");
				String pw = dao.encrypt(password); //비번 암호화
				String nickname = request.getParameter("nickname");
				String name = request.getParameter("name");
				String phone = request.getParameter("phone");
				String email = request.getParameter("email");
				String agree = request.getParameter("agree"); //동의여부 value값으로 설정한 값이 넘어옴(Y or N)
				
				dao.insert(new MembersDTO(id,pw,nickname,name,phone,email,"",agree));
				request.setAttribute("nickname", nickname);
				request.getRequestDispatcher("/members/logincomplete.jsp").forward(request, response);
			
			}else if(cmd.equals("/idCheck.MembersController")) { //id 중복검사
				String id = request.getParameter("id");
				
				boolean result = dao.idCheck(id);
				response.getWriter().write(String.valueOf(result));
				
			}else if(cmd.equals("/nicknameCheck.MembersController")) { //닉네임 중복검사
				String nickname = request.getParameter("nickname");
				
				boolean result = dao.nicknameCheck(nickname);
				response.getWriter().write(String.valueOf(result));
				
			}else if(cmd.equals("/login.MembersController")) { //로그인 유효한 id,pw인지 확인
				String id = request.getParameter("id");
				String password = request.getParameter("pw");
				String pw = dao.encrypt(password);
				
				int result = dao.login(id, pw);
				if(result > 0) {
					request.setAttribute("id", id);
					request.getRequestDispatcher("").forward(request, response);
					//여기 로그인 완료 이동 좌표찍어라
				}else {
					response.sendRedirect("");
					//로그인 실패 이동좌표?
				}
				
			}
		}catch(Exception e ) {
			e.printStackTrace();
			System.out.println("이동중 오류발생");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8"); 
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

}
