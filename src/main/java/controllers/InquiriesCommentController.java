package controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.InquiriesCommentDAO;
import dto.InquiriesCommentDTO;

@WebServlet("/detail.inqc")
public class InquiriesCommentController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            int fb_id = Integer.parseInt(request.getParameter("fb_id"));
            InquiriesCommentDAO dao = InquiriesCommentDAO.getInstance();
            List<InquiriesCommentDTO> comments = dao.selectByFbId(fb_id);

            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/QnA/QnAdetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/error.jsp");
        }
    }
}
