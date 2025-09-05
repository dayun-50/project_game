package controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
         // 1. 게시글 등록 및 이미지 base64 이미지 변환 저장
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
            
          ///list.free
         } else if(cmd.equals("/list.free")) {
          String q = request.getParameter("q");     // 🔍 제목 검색어
          int page = 1;
          String pageParam = request.getParameter("page");
          if(pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);

          int pageSize = 10;
          int start = (page - 1) * pageSize + 1;
          int end = page * pageSize;

          List<freeBoardDTO> list;
          int totalCount;

          if(q != null && !q.trim().isEmpty()) {
              // ✅ 제목 검색 전용 페이징
              list = dao.searchTitlePage(q.trim(), start, end);
              totalCount = dao.getTitleSearchCount(q.trim());
          } else {
              // 전체 목록
              list = dao.selectPage(start, end);
              totalCount = dao.getTotalCount();
          }

          int totalPage = (int)Math.ceil(totalCount / (double)pageSize);
          int blockSize = 10;
          int currentBlock = (int)Math.ceil(page / (double)blockSize);
          int startPage = (currentBlock - 1) * blockSize + 1;
          int endPage = Math.min(startPage + blockSize - 1, totalPage);

          // 🔁 JSP에서 검색어 유지/표시
          request.setAttribute("list", list);
          request.setAttribute("currentPage", page);
          request.setAttribute("totalPage", totalPage);
          request.setAttribute("startPage", startPage);
          request.setAttribute("endPage", endPage);
          request.setAttribute("q", q);

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
            
         // 5. 게시글 수정페이지 base64 이미지 포함 HTML그대로 가져오기
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
            
         // 8. 게임화면 이동
         }else if(cmd.equals("/gamepage.free")) {
        	    request.getRequestDispatcher("/game/gameMain.jsp").forward(request, response);
         }
         
      } catch(Exception e) {
         e.printStackTrace();
         response.sendRedirect("/error.jsp");
      }
   }
}
