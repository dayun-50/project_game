package controllers;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MembersDAO;
import dto.MembersDTO;

@WebServlet("*.MembersController")
public class MembersController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		MembersDAO dao = MembersDAO.getInstance();
		HttpSession session = request.getSession(); 
		try {
			if(cmd.equals("/signuppage.MembersController")) { //회원가입 페이지 이동
				response.sendRedirect("/members/singup.jsp");

			}else if(cmd.equals("/loginpgae.MembersController")) { //로그인 페이지 이동
				response.sendRedirect("/members/login.jsp");

			}else if(cmd.equals("/indexpage.MembersController")) { //메인 페이지 이동
				response.sendRedirect("/index.jsp");

			}else if(cmd.equals("/idSerchpage.MembersController")) { //아이디찾기 페이지 이동
				response.sendRedirect("/members/idSerch.jsp");

			}else if(cmd.equals("/pwSerchpage.MembersController")) { // 비밀번호 찾기 페이지 이동
				response.sendRedirect("/members/pwSerch.jsp");

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
				if(result == 1) {
					
					 // 1️⃣ 로그인 성공 → 세션 먼저 설정
				    session.setAttribute("loginId", id); // ID 세션 저장
				    String nickname = dao.nicknameSerch(id); // 닉네임 조회
				    session.setAttribute("nickname", nickname); // 닉네임 세션 저장

				    // 2️⃣ 클라이언트에게 성공 결과 전달
				    response.getWriter().write(String.valueOf(result)); // 1
					
				}else {
					response.getWriter().write(String.valueOf(result));
				}

			}else if(cmd.equals("/idSerch.MembersController")) { //id 찾기 
				String name = request.getParameter("name");
				String email = request.getParameter("email");
				String phone = request.getParameter("phone");

				ArrayList<String> idList = dao.idSerch(name, email, phone);
				if(idList != null) {//id존재 경우
					ArrayList<String> result = new ArrayList<>();
					for(String id : idList) {
						int blackCheck = dao.blackCheck(id);
						if(blackCheck > 0) { //블랙리스트 id인 경우 사용 불가 계정 표기
							result.add(id+"  ( 사용 불가 계정 )");
						}else {
							result.add(id);
						}
					}
					request.setAttribute("name", name);
					request.setAttribute("id", result);
					request.getRequestDispatcher("/members/idSerchResult.jsp").forward(request, response);
					
				}else { // 검색한 정보에 해당되는 id가 없을경우
					request.setAttribute("name", "null");
					request.getRequestDispatcher("/members/idSerchResult.jsp").forward(request, response);
				}

			}else if(cmd.equals("/pwSerch.MembersController")) { // 비번 찾기
				String id = request.getParameter("id");
				String name = request.getParameter("name");
				String phone = request.getParameter("phone");

				int result = dao.pwSerch(id, name, phone);
				request.setAttribute("result", result);
				request.setAttribute("id", id);
				request.getRequestDispatcher("/members/pwSerchResult.jsp").forward(request, response);

			}else if(cmd.equals("/pwUpdate.MembersController")) { // 비번 변경
				String id = request.getParameter("id");
				String password = request.getParameter("pw");
				String pw = dao.encrypt(password);

				dao.pwUpdate(id, pw);
				request.setAttribute("id", id);
				request.getRequestDispatcher("/members/pwUpdateComplete.jsp").forward(request, response);

			}else if(cmd.equals("/mypage.MembersController")) { // 마이페이지 출력
				String id = (String) session.getAttribute("loginId");
					MembersDTO list = dao.selectAll(id);
					
					request.setAttribute("nickname", list.getUser_nickname());
					request.setAttribute("date", list.getUser_date());
					request.setAttribute("id", id);
					request.setAttribute("name", list.getUser_name());
					request.setAttribute("phone", list.getUser_phone());
					request.setAttribute("email", list.getUser_email());
					request.getRequestDispatcher("/members/mypage.jsp").forward(request, response);
				
			}else if(cmd.equals("/update.MembersController")){ // 마이페이지 정보수정
				String id = (String) session.getAttribute("loginId");
				String name = request.getParameter("name");
				String phone = request.getParameter("phone");
				String email = request.getParameter("email");
				
				int result = dao.mypageUpdate(id, name, phone, email);
				response.getWriter().write(String.valueOf(result));
				
			}else if(cmd.equals("/secession.MembersController")) { //마이페이지 회원탈퇴
				String id = (String) session.getAttribute("loginId");
				
				int result = dao.membersSecession(id);
				response.getWriter().write(String.valueOf(result));
				
			}
		}catch(Exception e ) {
			e.printStackTrace();
			System.out.println("이동중 오류발생//members");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8"); 
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

}
