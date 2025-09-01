package controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.FreeCommentDAO;
import dao.MembersDAO;
import dao.freeBoardDAO;
import dto.FreeCommentDTO;
import dto.freeBoardDTO;

@WebServlet("*.free")
public class freeBoardController extends HttpServlet {

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doAction(request, response);
   }
   
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doAction(request, response);
   }
   
   protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String cmd = request.getRequestURI();
      freeBoardDAO dao = freeBoardDAO.getInstance();
      MembersDAO mdao = MembersDAO.getInstance();
      HttpSession session = request.getSession(); 
      
      try {
         // 1. 게시글 등록
         if(cmd.equals("/postdone.free")) {
            String id = (String) session.getAttribute("loginId");
            String fb_user_name = mdao.nicknameSerch(id);
            String fb_Title = request.getParameter("title");
            String fb_write = request.getParameter("write");
            Timestamp fb_date = new Timestamp(System.currentTimeMillis());
            
            freeBoardDTO dto = new freeBoardDTO(fb_user_name, fb_Title, fb_write, fb_date);
            dao.insert(dto);
            response.sendRedirect("/list.free");
            
         // 2. 게시글 작성 페이지 이동
         } else if(cmd.equals("/post.free")) {
            response.sendRedirect("/board/post.jsp");
            
         // 3. 게시글 목록
         } else if(cmd.equals("/list.free")) {
            int page = 1; 
            String pageParam = request.getParameter("page");
            if(pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);

            int pageSize = 10;
            int start = (page - 1) * pageSize + 1;
            int end = page * pageSize;

            List<freeBoardDTO> list = dao.selectPage(start, end);
            int totalCount = dao.getTotalCount();
            int totalPage = (int)Math.ceil(totalCount / (double)pageSize);

            int blockSize = 10;
            int currentBlock = (int)Math.ceil(page / (double)blockSize);
            int startPage = (currentBlock - 1) * blockSize + 1;
            int endPage = Math.min(startPage + blockSize - 1, totalPage);

            request.setAttribute("list", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.getRequestDispatcher("/board/list.jsp").forward(request, response);
            
         // 4. 게시글 상세보기
         } else if(cmd.equals("/detail.free")) {
            int fb_id = Integer.parseInt(request.getParameter("id"));
            dao.incrementViewCount(fb_id);

            freeBoardDTO dto = dao.selectById(fb_id);
            FreeCommentDAO cdao = FreeCommentDAO.getInstance();
            List<FreeCommentDTO> comments = cdao.selectByBoardId(fb_id);

            request.setAttribute("dto", dto);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/board/detail.jsp").forward(request, response);
            
         // 5. 게시글 수정페이지
         } else if(cmd.equals("/edit.free")) {
            int fb_id = Integer.parseInt(request.getParameter("id"));
            freeBoardDTO dto = dao.selectById(fb_id);
            FreeCommentDAO cdao = FreeCommentDAO.getInstance();
            List<FreeCommentDTO> comments = cdao.selectByBoardId(fb_id);
            request.setAttribute("dto", dto);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/board/detail.jsp").forward(request, response);
            
         // 6. 게시글 수정
         } else if(cmd.equals("/update.free")) {
            int fb_id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String write = request.getParameter("write");
            freeBoardDTO dto = new freeBoardDTO(fb_id, title, write);
            dao.update(dto);
            response.sendRedirect("/detail.free?id=" + fb_id);
            
         // 7. 게시글 삭제
         } else if(cmd.equals("/delete.free")) {
            int fb_id = Integer.parseInt(request.getParameter("id"));
            dao.delete(fb_id);
            response.sendRedirect("/list.free");
         }
         
      } catch(Exception e) {
         e.printStackTrace();
         response.sendRedirect("/error.jsp");
      }
   }
}
