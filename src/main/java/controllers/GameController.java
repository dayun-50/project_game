package controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MembersDAO;

@WebServlet("*.GameController")
public class GameController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		MembersDAO dao = MembersDAO.getInstance();
		HttpSession session = request.getSession();
		
		try {
			if(cmd.equals("/gamapage.GameController")) { //게임 메인홈페이지 이동
				String id = (String) session.getAttribute("loginId");
				String nickname = dao.nicknameSerch(id);
				response.setContentType("text/html; charset=UTF-8");
				if(nickname!=null) { 
					request.setAttribute("id", id);
					request.setAttribute("nickname", nickname);
					request.getRequestDispatcher("/game/gameMain.jsp").forward(request, response);
				} 
			}else if(cmd.equals("/gameboard.GameController")) { //게임게시판 이동메뉴
				response.sendRedirect("/game1borad.Game1Controller");
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("이동중 오류발생//game");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
