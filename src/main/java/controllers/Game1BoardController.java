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

import commons.GameBoardConfig;
import dao.Game1BoardDAO;
import dao.Game1CommentDAO;
import dao.MembersDAO;
import dto.Game1CommentDTO;
import dto.GameBoardDTO;

@WebServlet("*.Game1Controller")
public class Game1BoardController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		HttpSession session = request.getSession();
		MembersDAO mdao = MembersDAO.getInstance();
		Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
		Game1CommentDAO gcdao = Game1CommentDAO.getInstance();
		response.setContentType("application/json; charset=UTF-8");
	    request.setCharacterEncoding("UTF-8");
		
		try {
			if(cmd.equals("/game1BoradInsert.Game1Controller")) { //게임 1 게시판 글작성완료버튼
				String id = (String) session.getAttribute("loginId");
				int gameid = Integer.parseInt(request.getParameter("gameid"));
				String title = request.getParameter("title");
				String wrtier = mdao.nicknameSerch(id);
				String coment = request.getParameter("coment");
				
				gbdao.boardInsert(new GameBoardDTO(0,gameid,title,coment,wrtier,"",0));
				response.sendRedirect("/game1borad.Game1Controller");
				
			}else if(cmd.equals("/game1borad.Game1Controller")){ //게임 1 게시판 목록 출력
				String cpageStr = request.getParameter("cpage");
				String gameid = request.getParameter("gameid");

				// gameid 기본값 1
				if(gameid == null || gameid.isEmpty()) {
				    gameid = "1";
				}

				// cpage 기본값 1
				int cpage = 1;
				if(cpageStr != null && !cpageStr.isEmpty()) {
				    try {
				        cpage = Integer.parseInt(cpageStr);
				    } catch(NumberFormatException e) {
				        cpage = 1; // 변환 실패 시 기본값
				    }
				}

				    ArrayList<GameBoardDTO> list = gbdao.selectFromTo(
				            cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE - (GameBoardConfig.RECORD_COUNT_PER_PAGE - 1),
				            cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE,
				            gameid
				    );

				    request.setAttribute("recordTotalCount", gbdao.getRecordTotalCount());
				    request.setAttribute("recordCountPerPage", GameBoardConfig.RECORD_COUNT_PER_PAGE);
				    request.setAttribute("naviCountPerPage", GameBoardConfig.NABI_COUNT_PER_PAGE);
				    request.setAttribute("currentPage", cpage);
				    request.setAttribute("list", list);
				    request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);
				
			}else if(cmd.equals("/game1boradDetil.Game1Controller")) { //글 내용 출력
				String id = (String) session.getAttribute("loginId");
				String seq = request.getParameter("seq");
				ArrayList<GameBoardDTO> list = gbdao.listCheck(Integer.parseInt(seq));
				ArrayList<Game1CommentDTO> comentList = gcdao.selectAll(Integer.parseInt(seq));
				int count = list.get(0).getView_count();
				count += 1;
				gbdao.count(count, Integer.parseInt(seq));
				String nickname = mdao.nicknameSerch(id);
				
				request.setAttribute("list", list);
				request.setAttribute("viewCount", count);
				request.setAttribute("comentList", comentList);
				if(nickname.equals(list.get(0).getGamewrtier())) { // 글작성자와 현유저가 같을시
					request.setAttribute("result", 1);
				}else {  //다른 유저일시
					request.setAttribute("result", -1);
				}
				int comentCount = gcdao.countComent(Integer.parseInt(seq));
				request.setAttribute("comentCount", comentCount);
				request.setAttribute("nickname", nickname);
				
				request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);
				
			}else if(cmd.equals("/boardInsert.Game1Controller")) { //글 작성 페이지 이동
				String gameid = request.getParameter("gameid");
				request.setAttribute("gameid", gameid);
				request.getRequestDispatcher("board/game1boardInsert.jsp").forward(request, response);
				
			}else if(cmd.equals("/delete.Game1Controller")) { //글 삭제
				String seq = request.getParameter("seq");
				int result = gbdao.deleteGameBoard(seq);
				
				response.getWriter().write(String.valueOf(result));
				
			}else if(cmd.equals("/updat.Game1Controller")) { //글 수정
				String text = request.getParameter("text");
				String seq = request.getParameter("seq");
				
				int result = gbdao.updateGameBoard(seq, text);
				response.getWriter().write(String.valueOf(result));
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
