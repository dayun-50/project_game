package controllers;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.GameDAO;
import dao.MembersDAO;
import dto.Rankdto;

@WebServlet("*.GameController")
public class GameController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		MembersDAO dao = MembersDAO.getInstance();
		GameDAO gamedao=GameDAO.getInstance();
		HttpSession session = request.getSession();
		response.setContentType("application/json; charset=UTF-8");
	       request.setCharacterEncoding("UTF-8");
		
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
			
			}else if(cmd.equals("/gamerang.GameController")) { //게임랭크 이동메뉴
				//response.sendRedirect("/game/gamerank.jsp");
			String id=(String) session.getAttribute("loginId");	
			String nickname=dao.nicknameSerch(id);
			response.setContentType("text/html; charset=UTF-8");
			if(nickname!=null) { 
				
				 ArrayList<Rankdto> ranklist = gamedao.getAllRanks();
				 ArrayList<Rankdto> rankshow=gamedao.getoneRanks(nickname);
				request.setAttribute("id", id);
				request.setAttribute("nickname", nickname);
				request.setAttribute("ranklist", ranklist);
				request.setAttribute("rankshow", rankshow);
				
				request.getRequestDispatcher("/game/gamerank.jsp").forward(request, response);
				
				
				System.out.println("ranklist size = " + ranklist.size());
				request.setAttribute("ranklist", ranklist);
			}
			
			
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("이동중 오류발생//game");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		GameDAO gamedao = new GameDAO();
		MembersDAO dao = MembersDAO.getInstance();
		response.setContentType("application/json; charset=UTF-8");
	    request.setCharacterEncoding("UTF-8");
		try {
			if(cmd.equals("/score.GameController")) {
				String id = (String) session.getAttribute("loginId");
				String nickname = dao.nicknameSerch(id);
				if(nickname!=null) { 
					request.setAttribute("id", id);
					request.setAttribute("nickname", nickname);
					int gameId = Integer.parseInt(request.getParameter("game_id"));
	                int score = Integer.parseInt(request.getParameter("score"));
	                
	                Rankdto dto=new Rankdto();
	                dto.setGame_id(gameId);        // 게임 ID
	                dto.setUser_name(nickname);    // 세션에서 가져온 닉네임
	                dto.setScore(score);           // 점수
	                
	                int result=gamedao.insertScore(dto);
	                System.out.println("[DEBUG] insertScore result = " + result 
	                           + ", user=" + dto.getUser_name()
	                           + ", game_id=" + dto.getGame_id()
	                           + ", score=" + dto.getScore());
	                response.getWriter().write(result > 0 ? "success" : "fail");
				} 
				  
			}
			
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("에러발생");
		}
	
		
		
	}

}
