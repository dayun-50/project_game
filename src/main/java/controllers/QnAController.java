package controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.MembersDAO;
import dao.QnADAO;
import dto.QnADTO;

@WebServlet("*.qna")
public class QnAController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String cmd = request.getRequestURI();
        QnADAO dao = QnADAO.getInstance();
        MembersDAO mdao = MembersDAO.getInstance();
        HttpSession session = request.getSession();

        try {
            if(cmd.equals("/postdone.qna")) {
                String id = (String) session.getAttribute("loginId");
                String inqu_user_name = mdao.nicknameSerch(id);
                String inqu_Title = request.getParameter("title");
                String inqu_write = request.getParameter("write");
                int inqu_pw = Integer.parseInt(request.getParameter("password"));
                Timestamp inqu_date = new Timestamp(System.currentTimeMillis());

                QnADTO dto = new QnADTO(0, inqu_pw, inqu_Title, inqu_write, inqu_user_name, inqu_date);
                dao.insert(dto);
                response.sendRedirect("/list.qna");

            } else if(cmd.equals("/post.qna")) {
                response.sendRedirect("/QnA/QnApost.jsp");

            } else if(cmd.equals("/list.qna")) {
                int page = 1;
                String pageParam = request.getParameter("page");
                if(pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);

                int pageSize = 10;
                int start = (page-1)*pageSize + 1;
                int end = page*pageSize;

                List<QnADTO> list = dao.selectPage(start, end);
                int totalCount = dao.getTotalCount();
                int totalPage = (int)Math.ceil(totalCount/(double)pageSize);

                int blockSize = 10;
                int currentBlock = (int)Math.ceil(page/(double)blockSize);
                int startPage = (currentBlock-1)*blockSize + 1;
                int endPage = Math.min(startPage + blockSize -1, totalPage);

                request.setAttribute("list", list);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPage", totalPage);
                request.setAttribute("startPage", startPage);
                request.setAttribute("endPage", endPage);
                request.getRequestDispatcher("/QnA/QnAlist.jsp").forward(request,response);

            } else if(cmd.equals("/checkPassword.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                int inputPw = Integer.parseInt(request.getParameter("password"));
                QnADTO dto = dao.selectById(inqu_id);

                if(dto != null && dto.getInqu_pw() == inputPw) {
                    // 글별 인증 세션 저장
                    session.setAttribute("auth_" + inqu_id, true);
                    response.sendRedirect("/detail.qna?id=" + inqu_id);
                } else {
                    response.getWriter().println("<script>alert('비밀번호가 틀렸습니다'); history.back();</script>");
                }

            } else if(cmd.equals("/detail.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                Boolean auth = (Boolean) session.getAttribute("auth_" + inqu_id);
                if(auth == null || !auth) {
                    response.sendRedirect("/checkPasswordForm.qna?id=" + inqu_id);
                    return;
                }
                QnADTO dto = dao.selectById(inqu_id);
                request.setAttribute("dto", dto);
                request.getRequestDispatcher("/QnA/QnAdetail.jsp").forward(request,response);

            } else if(cmd.equals("/update.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String write = request.getParameter("write");

                QnADTO dto = new QnADTO();
                dto.setInqu_id(inqu_id);
                dto.setInqu_Title(title);
                dto.setInqu_write(write);

                dao.update(dto); // 비밀번호 없이 수정
                response.sendRedirect("/detail.qna?id=" + inqu_id);

            } else if(cmd.equals("/delete.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                dao.delete(inqu_id); // 비밀번호 없이 삭제
                response.sendRedirect("/list.qna");

            } else if(cmd.equals("/checkPasswordForm.qna")) {
                request.setAttribute("id", request.getParameter("id"));
                request.getRequestDispatcher("/QnA/checkPassword.jsp").forward(request,response);
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("/error.jsp");
        }
    }
}
