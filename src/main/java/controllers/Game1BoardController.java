package controllers;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import commons.GameBoardConfig;
import dao.Game1BoardDAO;
import dao.Game1CommentDAO;
import dao.MembersDAO;
import dto.GameBoardDTO;
import dto.Game1CommentDTO;

@WebServlet("*.Game1Controller")
public class Game1BoardController extends HttpServlet {
    private Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
    private MembersDAO mdao = MembersDAO.getInstance();
    private Game1CommentDAO gcdao = Game1CommentDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();

        try {
            String cmd = request.getRequestURI();

            if (cmd.equals("/boardInsert.Game1Controller")) {
                request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);

            } else if (cmd.equals("/game1borad.Game1Controller")) {
                int cpage = 1;
                String cpageStr = request.getParameter("cpage");
                int gameid = 1;
                if (request.getParameter("gameid") != null) gameid = Integer.parseInt(request.getParameter("gameid"));
                if (cpageStr != null) cpage = Integer.parseInt(cpageStr);

                int from = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE - (GameBoardConfig.RECORD_COUNT_PER_PAGE - 1);
                int to = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE;

                ArrayList<GameBoardDTO> list = gbdao.selectFromTo(from, to, gameid);

                request.setAttribute("list", list);
                request.setAttribute("recordTotalCount", gbdao.getRecordTotalCount(gameid));
                request.setAttribute("recordCountPerPage", GameBoardConfig.RECORD_COUNT_PER_PAGE);
                request.setAttribute("naviCountPerPage", GameBoardConfig.NABI_COUNT_PER_PAGE);
                request.setAttribute("currentPage", cpage);
                request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);

            } else if (cmd.equals("/game1boardDetail.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                GameBoardDTO dto = gbdao.selectById(seq);
                gbdao.incrementView(seq);

                // 댓글 불러오기
                ArrayList<Game1CommentDTO> comentList = gcdao.selectAll(seq);
                int comentCount = gcdao.countComent(seq);

                request.setAttribute("dto", dto);
                request.setAttribute("comentList", comentList);
                request.setAttribute("comentCount", comentCount);

                request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);

            } else if (cmd.equals("/edit.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                GameBoardDTO dto = gbdao.selectById(seq);
                request.setAttribute("dto", dto);
                request.getRequestDispatcher("/board/game1boardEdit.jsp").forward(request, response);

            } else if (cmd.equals("/delete.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                gbdao.deleteGameBoard(seq);
                response.sendRedirect("/game1borad.Game1Controller");

            } else if (cmd.equals("/game1BoradInsert.Game1Controller")) {
                String title = request.getParameter("title");

                // ✅ 이미지/스타일/figure 허용한 sanitize
                String coment = Jsoup.clean(
                    request.getParameter("coment"),
                    Safelist.relaxed()
                        .addAttributes(":all", "class", "style")
                        .addAttributes("img", "src", "alt", "title", "width", "height")
                        .addTags("figure", "figcaption")
                        .addProtocols("img", "src", "data", "http", "https")
                        .preserveRelativeLinks(true)
                );

                String loginId = (String) session.getAttribute("loginId");
                String writer = mdao.nicknameSerch(loginId);
                int gameid = Integer.parseInt(request.getParameter("gameid"));

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGameid(gameid);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);
                dto.setGamewrtier(writer);

                gbdao.boardInsert(dto);
                response.sendRedirect("/game1borad.Game1Controller");

            } else if (cmd.equals("/updatePost.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                String title = request.getParameter("title");

                // ✅ 이미지/스타일/figure 허용한 sanitize
                String coment = Jsoup.clean(
                    request.getParameter("coment"),
                    Safelist.relaxed()
                        .addAttributes(":all", "class", "style")
                        .addAttributes("img", "src", "alt", "title", "width", "height")
                        .addTags("figure", "figcaption")
                        .addProtocols("img", "src", "data", "http", "https")
                        .preserveRelativeLinks(true)
                );

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGame_seq(seq);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);

                gbdao.update(dto);
                response.sendRedirect("/game1boardDetail.Game1Controller?seq=" + seq);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 필요시 에러 페이지로 forward 또는 공통 에러 처리
        }
    }
}
