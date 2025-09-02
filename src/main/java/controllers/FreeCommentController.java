package controllers;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FreeCommentDAO;
import dao.MembersDAO;
import dto.FreeCommentDTO;

@WebServlet("*.fComment")
public class FreeCommentController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String cmd = request.getRequestURI();
        FreeCommentDAO dao = FreeCommentDAO.getInstance();
        MembersDAO mdao = MembersDAO.getInstance();
        HttpSession session = request.getSession();

        try {
            // 1. 댓글 등록
            if (cmd.equals("/insert.fComment")) {
                String loginId = (String) session.getAttribute("loginId");
                String userName = mdao.nicknameSerch(loginId);

                int fb_id = Integer.parseInt(request.getParameter("fb_id"));
                String write = request.getParameter("write");
                Timestamp date = new Timestamp(System.currentTimeMillis());

                FreeCommentDTO dto = new FreeCommentDTO(fb_id, userName, write, date);
                dao.insert(dto);

                response.sendRedirect("/detail.free?id=" + fb_id);

            // 2. 댓글 수정
            }  else if(cmd.equals("/update.fComment")) {
                String fcIdParam = request.getParameter("fc_id");
                String fbIdParam = request.getParameter("fb_id");
                String write = request.getParameter("write");

                if (fcIdParam != null && !fcIdParam.trim().isEmpty() &&
                    fbIdParam != null && !fbIdParam.trim().isEmpty()) {

                    int fc_id = Integer.parseInt(fcIdParam);
                    int fb_id = Integer.parseInt(fbIdParam);

                    dao.update(fc_id, write);
                    response.sendRedirect("/detail.free?id=" + fb_id);

                } else {
                    System.out.println("fc_id 또는 fb_id가 비어있습니다.");
                    response.sendRedirect("/error.jsp");
                }



            // 3. 댓글 삭제
            } else if (cmd.equals("/delete.fComment")) {
                int fc_id = Integer.parseInt(request.getParameter("fc_id"));
                int fb_id = Integer.parseInt(request.getParameter("fb_id"));

                dao.delete(fc_id);

                response.sendRedirect("/detail.free?id=" + fb_id);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/error.jsp");
        }
    }
}
