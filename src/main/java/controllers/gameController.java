package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("*.gameController")
public class gameController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		try {
			if(cmd.equals("/gamapage.gameController")) { //게임 메인홈페이지 이동
				response.sendRedirect("/game/gameMain.jsp");
				
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
