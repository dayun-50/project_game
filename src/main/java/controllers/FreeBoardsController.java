package controllers;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.FreeBoardsDAO;
import dao.MembersDAO;
import dto.FreeBoardsDTO;

@WebServlet("*.free")
public class FreeBoardsController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getRequestURI();
		FreeBoardsDAO dao = FreeBoardsDAO.getInstance();
		MembersDAO mdao = MembersDAO.getInstance();
		try {
			if(cmd.equals("/postdone.free")) {
				String fb_user_name = request.getParameter("id");
				String fb_Title = request.getParameter("title");
				String fb_write = request.getParameter("write");
				Timestamp fb_date = new java.sql.Timestamp(System.currentTimeMillis());
				FreeBoardsDTO dto = new FreeBoardsDTO(fb_user_name,fb_Title,fb_write,fb_date);
			}else if(cmd.equals("/post.free")) {
				response.sendRedirect("/board/post.jsp");
			}
			
			
		}catch(Exception e ){
			
		}
	}

}
