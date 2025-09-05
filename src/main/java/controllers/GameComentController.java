package controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.Game1BoardDAO;
import dao.Game1CommentDAO;
import dao.MembersDAO;
import dto.Game1CommentDTO;

@WebServlet("*.GameComentController")
public class GameComentController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		HttpSession session = request.getSession();
		MembersDAO mdao = MembersDAO.getInstance();
		Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
		Game1CommentDAO gcdao = Game1CommentDAO.getInstance();
		response.setContentType("application/json; charset=UTF-8");
	    request.setCharacterEncoding("UTF-8");
		
		try {
			if(cmd.equals("/comentInsert.GameComentController")) { // 댓글달기
				String coment = request.getParameter("coment");
				String id = (String) session.getAttribute("loginId");
				String nickname = mdao.nicknameSerch(id);
				String parentSeq = request.getParameter("seq");
				
				gcdao.comentInsert(new Game1CommentDTO(0,Integer.parseInt(parentSeq),0,nickname,coment,""));
				response.sendRedirect("/game1boardDetail.Game1Controller?seq=" + parentSeq);
			
			}else if(cmd.equals("/delete.GameComentController")) { // 댓글삭제
			    String seq = request.getParameter("seq");
			    String parentSeq = request.getParameter("parentSeq"); // 댓글의 게시글 번호
			    gcdao.comentDelete(seq);
			    
			    // 삭제 후 해당 게시글 상세 페이지로 리다이렉트
			    response.sendRedirect("/game1boardDetail.Game1Controller?seq=" + parentSeq);
			}else if(cmd.equals("/updatComent.GameComentController")) { // 댓글수정
				String seq = request.getParameter("seq");
				String text = request.getParameter("text");
				
				int result = gcdao.comentUpdate(seq, text);
				response.getWriter().write(String.valueOf(result));
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("게임게시판 댓글 오류");
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
