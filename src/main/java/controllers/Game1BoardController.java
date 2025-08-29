package controllers;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import dao.Game1BoardDAO;
import dao.MembersDAO;
import dto.GameBoardDTO;

@WebServlet("*.Game1Controller")
public class Game1BoardController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		HttpSession session = request.getSession();
		MembersDAO mdao = MembersDAO.getInstance();
		Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
		
		try {
			if(cmd.equals("/game1BoradInsert.Game1Controller")) { //게임 1 게시판 글작성
				response.setContentType("text/html; charset=UTF-8");
				String id = (String) session.getAttribute("loginId");
				String title = request.getParameter("title");
//				String wrtier = mdao.nicknameSerch(id);
				String wrtier = "asdf";
				String coment = request.getParameter("coment");
				String reComent = Jsoup.clean(coment, Safelist.basicWithImages());
				
				gbdao.boardInsert(new GameBoardDTO(0,1,title,reComent,wrtier,"",0));
				response.sendRedirect("/game1borad.Game1Controller");
				
			}else if(cmd.equals("/game1borad.Game1Controller")){ //게임 1 게시판 목록 출력
				ArrayList<GameBoardDTO> list = gbdao.game1SelectAll();
				
				request.setAttribute("list", list);
				request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("게임 1 게시판 컨트롤러 에러");
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
