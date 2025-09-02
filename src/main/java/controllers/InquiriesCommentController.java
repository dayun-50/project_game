package controllers;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.InquiriesCommentDAO;
import dao.MembersDAO;
import dto.InquiriesCommentDTO;

@WebServlet("*.inqc")
public class InquiriesCommentController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String cmd = request.getRequestURI();
        InquiriesCommentDAO dao = InquiriesCommentDAO.getInstance();
        MembersDAO mdao = MembersDAO.getInstance();
        HttpSession session = request.getSession();
        try {
            // 1. 댓글 등록
            if (cmd.equals("/insert.inqc")) {
                String write = request.getParameter("write");
                Timestamp date = new Timestamp(System.currentTimeMillis());

                InquiriesCommentDTO dto = new InquiriesCommentDTO(0, write, date);
                dao.insert(dto);

                response.sendRedirect("/QnA/QnAdetail.jsp");

            // 2. 댓글 수정
            } else if (cmd.equals("/update.inqc")) {
                String seqParam = request.getParameter("inqc_seq");
                String write = request.getParameter("write");

                if (seqParam != null && !seqParam.trim().isEmpty()) {
                    int inqc_seq = Integer.parseInt(seqParam);
                    dao.update(inqc_seq, write);
                    response.sendRedirect("/QnA/QnAdetail.jsp");
                } else {
                    response.sendRedirect("/error.jsp");
                }

            // 3. 댓글 삭제
            } else if (cmd.equals("/delete.inqc")) {
                int inqc_seq = Integer.parseInt(request.getParameter("inqc_seq"));
                dao.delete(inqc_seq);
                response.sendRedirect("/QnA/QnAdetail.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/error.jsp");
        }
    }
}
