package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import commons.GameBoardConfig;
import dao.Game1BoardDAO;
import dao.Game1CommentDAO;
import dao.MembersDAO;
import dto.Game1CommentDTO;
import dto.GameBoardDTO;

@WebServlet("*.Game1Controller")
public class Game1BoardController extends HttpServlet {

    private MembersDAO mdao = MembersDAO.getInstance();
    private Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
    private Game1CommentDAO gcdao = Game1CommentDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cmd = request.getRequestURI();
        HttpSession session = request.getSession();
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 게시글 작성 페이지 이동(GET)
            if (cmd.equals("/boardInsert.Game1Controller")) {
                String gameid = request.getParameter("gameid");
                request.setAttribute("gameid", gameid);
                request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);

            // 게시판 목록(GET)
            } else if (cmd.equals("/game1borad.Game1Controller")) {
                String cpageStr = request.getParameter("cpage");
                String gameid = request.getParameter("gameid");

                // 기본값 처리
                if (gameid == null || gameid.isEmpty()) gameid = "1";

                int cpage = 1;
                if (cpageStr != null && !cpageStr.isEmpty()) {
                    try {
                        cpage = Integer.parseInt(cpageStr);
                    } catch (NumberFormatException e) {
                        cpage = 1;
                    }
                }

                ArrayList<GameBoardDTO> list = gbdao.selectFromTo(
                        cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE - (GameBoardConfig.RECORD_COUNT_PER_PAGE - 1),
                        cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE,
                        gameid
                );

                request.setAttribute("recordTotalCount", gbdao.getRecordTotalCount());
                request.setAttribute("recordCountPerPage", GameBoardConfig.RECORD_COUNT_PER_PAGE);
                request.setAttribute("naviCountPerPage", GameBoardConfig.NABI_COUNT_PER_PAGE);
                request.setAttribute("currentPage", cpage);
                request.setAttribute("list", list);

                request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);

           
            // 게시글 삭제(GET)
            } else if (cmd.equals("/delete.Game1Controller")) {
                String seq = request.getParameter("seq");
                int result = gbdao.deleteGameBoard(seq);
                response.getWriter().write(String.valueOf(result));

            
             // 게시글 상세 보기(GET)
        } else if (cmd.equals("/game1boradDetil.Game1Controller")) {
            String id = (String) session.getAttribute("loginId");
            String seq = request.getParameter("seq");

            ArrayList<GameBoardDTO> list = gbdao.listCheck(Integer.parseInt(seq));
            ArrayList<Game1CommentDTO> comentList = gcdao.selectAll(Integer.parseInt(seq));

            int count = list.get(0).getView_count() + 1;
            gbdao.count(count, Integer.parseInt(seq));

            String nickname = mdao.nicknameSerch(id);

            request.setAttribute("list", list);
            request.setAttribute("viewCount", count);
            request.setAttribute("comentList", comentList);
            request.setAttribute("comentCount", gcdao.countComent(Integer.parseInt(seq)));
            request.setAttribute("nickname", nickname);

            if (nickname.equals(list.get(0).getGamewrtier())) {
                request.setAttribute("result", 1);
            } else {
                request.setAttribute("result", -1);
            }

            request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);
           
        }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("게임 1 게시판 GET 처리 에러");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cmd = request.getRequestURI();
        HttpSession session = request.getSession();
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 게시글 작성 완료(POST)
            if (cmd.equals("/game1BoradInsert.Game1Controller")) {
                String id = (String) session.getAttribute("loginId");
                int gameid = Integer.parseInt(request.getParameter("gameid"));
                String title = request.getParameter("title");
                String writer = mdao.nicknameSerch(id);
                String coment = request.getParameter("coment");

                String reComent = Jsoup.clean(coment, Safelist.basicWithImages());

                gbdao.boardInsert(new GameBoardDTO(0, gameid, title, reComent, writer, "", 0));

                response.sendRedirect("/game1borad.Game1Controller");
           
             // 게시글 수정(GET)
            }else if (cmd.equals("/updat.Game1Controller")) {
            	int game_seq = Integer.parseInt(request.getParameter("seq"));
                
                // 해당 게시글 가져오기
                GameBoardDTO dto = gbdao.selectById(game_seq);
                
                // 댓글 가져오기
                List<Game1CommentDTO> commentList = gcdao.selectAll(game_seq);
                
                // 세션에서 로그인 아이디 가져오기
                String loginId = (String) session.getAttribute("loginId");
                String nickname = mdao.nicknameSerch(loginId);
                
                // JSP로 포워딩
                request.setAttribute("dto", dto);
                request.setAttribute("comentList", commentList);
                request.setAttribute("nickname", nickname);
                
                // 작성자 여부 확인
                if (nickname.equals(dto.getGamewrtier())) {
                    request.setAttribute("result", 1); // 작성자일 경우
                } else {
                    request.setAttribute("result", -1); // 작성자가 아닐 경우
                }
                
                request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("게임 1 게시판 POST 처리 에러");
        }
    }
}
