package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.InquiriesCommentDAO;
import dao.MembersDAO;
import dao.QnADAO;
import dto.InquiriesCommentDTO;
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

        try {
            // 글 작성 완료
            if (cmd.equals("/postdone.qna")) {
                String id = (String) request.getSession().getAttribute("loginId");
                String inqu_user_name = mdao.nicknameSerch(id);
                String inqu_Title = request.getParameter("title");
                String inqu_write = request.getParameter("write");
                String inqu_pw = request.getParameter("password");
                Timestamp inqu_date = new Timestamp(System.currentTimeMillis());

                QnADTO dto = new QnADTO(0, inqu_pw, inqu_Title, inqu_write, inqu_user_name, inqu_date);
                dao.insert(dto);
                response.sendRedirect("list.qna");

            // 리스트
            } else if (cmd.equals("/list.qna")) {
                int page = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);

                int pageSize = 10;
                int start = (page - 1) * pageSize + 1;
                int end = page * pageSize;

                List<QnADTO> list = dao.selectPage(start, end);
                
                InquiriesCommentDAO cdao = InquiriesCommentDAO.getInstance();
                for(QnADTO dto : list) {
                    int commentCount = cdao.countCommentsByPostId(dto.getInqu_id());
                    if(commentCount > 0) {
                        dto.setAnswerStatus("답변완료");
                    } else {
                        dto.setAnswerStatus("검토중");
                    }
                }
                
                int totalCount = dao.getTotalCount();
                int totalPage = (int) Math.ceil(totalCount / (double) pageSize);

                int blockSize = 10;
                int currentBlock = (int) Math.ceil(page / (double) blockSize);
                int startPage = (currentBlock - 1) * blockSize + 1;
                int endPage = Math.min(startPage + blockSize - 1, totalPage);

                request.setAttribute("list", list);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPage", totalPage);
                request.setAttribute("startPage", startPage);
                request.setAttribute("endPage", endPage);
                request.getRequestDispatcher("/QnA/QnAlist.jsp").forward(request, response);

            // 상세 보기 진입 → 비밀번호 입력 페이지로 이동
            } else if (cmd.equals("/detail.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("inqu_id", inqu_id);
                request.getRequestDispatcher("/QnA/checkPassword.jsp").forward(request, response);

            // 비밀번호 체크
            } else if (cmd.equals("/detailCheck.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                String inputPw = request.getParameter("pw"); // jsp에서 name="pw"

                QnADTO dto = dao.selectById(inqu_id);

                if (dto != null && dto.getInqu_pw().equals(inputPw)) {
                    // 비밀번호 일치 → 상세페이지
                    request.setAttribute("dto", dto);
                    List<InquiriesCommentDTO> comments = dao.selectComments(inqu_id);
                    request.setAttribute("comments", comments);
                    RequestDispatcher rd = request.getRequestDispatcher("/QnA/QnAdetail.jsp");
                    rd.forward(request, response);
                } else {
                    // 비밀번호 불일치 → 경고창
                    response.setContentType("text/html;charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>alert('비밀번호가 틀렸습니다.'); history.back();</script>");
                    out.close();
                }

            // 글 수정
            } else if (cmd.equals("/update.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String write = request.getParameter("write");

                QnADTO dto = new QnADTO();
                dto.setInqu_id(inqu_id);
                dto.setInqu_Title(title);
                dto.setInqu_write(write);

                dao.update(dto);
                response.sendRedirect("list.qna");

            // 글 삭제
            } else if (cmd.equals("/delete.qna")) {
                int inqu_id = Integer.parseInt(request.getParameter("id"));
                dao.delete(inqu_id);
                response.sendRedirect("list.qna");

            // 글 작성 폼
            } else if (cmd.equals("/post.qna")) {
                request.getRequestDispatcher("/QnA/QnApost.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
