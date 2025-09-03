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
import dao.MembersDAO;
import dto.GameBoardDTO;

@WebServlet("*.Game1Controller")
public class Game1BoardController extends HttpServlet {
    private Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
    private MembersDAO mdao = MembersDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();

        try {
            String cmd = request.getRequestURI();

            if(cmd.equals("/boardInsert.Game1Controller")) {
                request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);

            } else if(cmd.equals("/game1borad.Game1Controller")) {
                int cpage = 1;
                String cpageStr = request.getParameter("cpage");
                int gameid = 1;
                if(request.getParameter("gameid") != null) gameid = Integer.parseInt(request.getParameter("gameid"));
                if(cpageStr != null) cpage = Integer.parseInt(cpageStr);

                int from = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE - (GameBoardConfig.RECORD_COUNT_PER_PAGE - 1);
                int to = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE;

                ArrayList<GameBoardDTO> list = gbdao.selectFromTo(from, to, gameid);

                request.setAttribute("list", list);
                request.setAttribute("recordTotalCount", gbdao.getRecordTotalCount(gameid));
                request.setAttribute("recordCountPerPage", GameBoardConfig.RECORD_COUNT_PER_PAGE);
                request.setAttribute("naviCountPerPage", GameBoardConfig.NABI_COUNT_PER_PAGE);
                request.setAttribute("currentPage", cpage);
                request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);

            } else if(cmd.equals("/game1boardDetail.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                GameBoardDTO dto = gbdao.selectById(seq);
                gbdao.incrementView(seq);

                request.setAttribute("dto", dto);
                request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);

            } else if(cmd.equals("/edit.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                GameBoardDTO dto = gbdao.selectById(seq);
                request.setAttribute("dto", dto);
                request.getRequestDispatcher("/board/game1boardEdit.jsp").forward(request, response);

            } else if(cmd.equals("/delete.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                gbdao.deleteGameBoard(seq);
                response.sendRedirect("/game1borad.Game1Controller");
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String cmd = request.getRequestURI();
            HttpSession session = request.getSession();

            if(cmd.equals("/game1BoradInsert.Game1Controller")) {
                String title = request.getParameter("title");
                String coment = Jsoup.clean(request.getParameter("coment"), Safelist.basicWithImages());
                String loginId = (String)session.getAttribute("loginId");
                String writer = mdao.nicknameSerch(loginId);
                int gameid = Integer.parseInt(request.getParameter("gameid"));

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGameid(gameid);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);
                dto.setGamewrtier(writer);

                gbdao.boardInsert(dto);
                response.sendRedirect("/game1borad.Game1Controller");

            } else if(cmd.equals("/updatePost.Game1Controller")) {
                int seq = Integer.parseInt(request.getParameter("seq"));
                String title = request.getParameter("title");
                String coment = Jsoup.clean(request.getParameter("coment"), Safelist.basicWithImages());

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGame_seq(seq);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);

                gbdao.update(dto);
                response.sendRedirect("/game1boardDetail.Game1Controller?seq=" + seq);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
