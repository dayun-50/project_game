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
    private static final long serialVersionUID = 1L;


    private final Game1BoardDAO gbdao = Game1BoardDAO.getInstance();
    private final MembersDAO mdao = MembersDAO.getInstance();
    private final Game1CommentDAO gcdao = Game1CommentDAO.getInstance();
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

        // ✅ 캐시 방지: 과거 목록 보이는 문제 방지
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");

        HttpSession session = request.getSession();

        try {
            // ✅ 컨텍스트 제거해서 분기 안정화
            String cmd = request.getRequestURI().substring(request.getContextPath().length());

            // ===== 글쓰기 화면 (GET)
            if (cmd.equals("/boardInsert.Game1Controller") && "GET".equalsIgnoreCase(request.getMethod())) {
                request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);
                return;
            }

         // ===== 목록 (GET)
            else if (cmd.equals("/game1borad.Game1Controller") && "GET".equalsIgnoreCase(request.getMethod())) {
                int cpage = 1;
                String cpageStr = request.getParameter("cpage");
                if (cpageStr != null && !cpageStr.isEmpty()) {
                    try { cpage = Integer.parseInt(cpageStr); } catch (NumberFormatException ignore) {}
                }

                int gameid = 1;
                String gameidStr = request.getParameter("gameid");
                if (gameidStr != null && !gameidStr.isEmpty()) {
                    try { gameid = Integer.parseInt(gameidStr); } catch (NumberFormatException ignore) {}
                }

                // 🔍 검색어
                String q = request.getParameter("q");
                boolean hasQuery = (q != null && !q.trim().isEmpty());
                if (hasQuery) q = q.trim();

                int from = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE - (GameBoardConfig.RECORD_COUNT_PER_PAGE - 1);
                int to   = cpage * GameBoardConfig.RECORD_COUNT_PER_PAGE;

                ArrayList<GameBoardDTO> list;
                int totalCount;

                if (hasQuery) {
                    // 제목 검색 페이징
                    list = gbdao.searchTitleFromTo(from, to, gameid, q);
                    totalCount = gbdao.getTitleSearchCount(gameid, q);
                } else {
                    // 전체 목록 페이징
                    list = gbdao.selectFromTo(from, to, gameid);
                    totalCount = gbdao.getRecordTotalCount(gameid);
                }

                request.setAttribute("list", list);
                request.setAttribute("recordTotalCount", totalCount);
                request.setAttribute("recordCountPerPage", GameBoardConfig.RECORD_COUNT_PER_PAGE);
                request.setAttribute("naviCountPerPage", GameBoardConfig.NABI_COUNT_PER_PAGE);
                request.setAttribute("currentPage", cpage);
                request.setAttribute("q", hasQuery ? q : ""); // JSP에서 유지/표시용

                request.getRequestDispatcher("/board/game1boardList.jsp").forward(request, response);
                return;
            }
            // ===== 상세 (GET)
            else if (cmd.equals("/game1boardDetail.Game1Controller") && "GET".equalsIgnoreCase(request.getMethod())) {
                String seqStr = request.getParameter("seq");
                if (seqStr == null || seqStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/game1borad.Game1Controller");
                    return;
                }
                int seq = Integer.parseInt(seqStr);
                GameBoardDTO dto = gbdao.selectById(seq);
                if (dto != null) gbdao.incrementView(seq);

                ArrayList<Game1CommentDTO> comentList = gcdao.selectAll(seq);
                int comentCount = gcdao.countComent(seq);

                request.setAttribute("dto", dto);
                request.setAttribute("comentList", comentList);
                request.setAttribute("comentCount", comentCount);

                request.getRequestDispatcher("/board/game1board.jsp").forward(request, response);
                return;
            }

            // ===== 수정 화면 (GET)
            else if (cmd.equals("/edit.Game1Controller") && "GET".equalsIgnoreCase(request.getMethod())) {
                String seqStr = request.getParameter("seq");
                if (seqStr == null || seqStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/game1borad.Game1Controller");
                    return;
                }
                int seq = Integer.parseInt(seqStr);
                GameBoardDTO dto = gbdao.selectById(seq);
                request.setAttribute("dto", dto);
                request.getRequestDispatcher("/board/game1boardEdit.jsp").forward(request, response);
                return;
            }

            // ===== 삭제 (GET)  ※ 필요하면 POST로 바꾸세요
            else if (cmd.equals("/delete.Game1Controller") && "GET".equalsIgnoreCase(request.getMethod())) {
                String seqStr = request.getParameter("seq");
                if (seqStr != null && !seqStr.isEmpty()) {
                    try {
                        int seq = Integer.parseInt(seqStr);
                        gbdao.deleteGameBoard(seq);
                    } catch (NumberFormatException ignore) {}
                }
                response.sendRedirect(request.getContextPath() + "/game1borad.Game1Controller");
                return;
            }

            // ===== 작성 완료 (POST)  ※ 철자 유지: /game1BoradInsert
            else if (cmd.equals("/game1BoradInsert.Game1Controller") && "POST".equalsIgnoreCase(request.getMethod())) {
                // 원본 파라미터 (null-safe)
                String rawTitle  = request.getParameter("title");   if (rawTitle == null) rawTitle = "";
                String rawComent = request.getParameter("coment");  if (rawComent == null) rawComent = "";

                // 제목은 텍스트만
                String title = Jsoup.clean(rawTitle, Safelist.none()).trim();

                // 본문은 이미지/스타일 허용
                String coment = Jsoup.clean(
                    rawComent,
                    Safelist.relaxed()
                        .addAttributes(":all", "class", "style")
                        .addAttributes("img", "src", "alt", "title", "width", "height")
                        .addTags("figure", "figcaption")
                        .addProtocols("img", "src", "data", "http", "https")
                        .preserveRelativeLinks(true)
                ).trim();

                // 이미지-only 본문도 허용
                boolean hasImage = coment.contains("<img");
                if (title.isEmpty() || (coment.isEmpty() && !hasImage)) {
                    request.setAttribute("error", "제목 또는 내용(텍스트/이미지)을 입력하세요.");
                    request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);
                    return;
                }

                // gameid
                int gameid = 1;
                String gameidStr = request.getParameter("gameid");
                if (gameidStr != null && !gameidStr.isEmpty()) {
                    try { gameid = Integer.parseInt(gameidStr); } catch (NumberFormatException ignore) {}
                }

                // 작성자 (없어도 진행)
                String writer = null;
                try {
                    String loginId = (String) session.getAttribute("loginId");
                    if (loginId != null) writer = mdao.nicknameSerch(loginId);
                } catch (Exception ignore) {}

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGameid(gameid);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);
                dto.setGamewrtier(writer);

                gbdao.boardInsert(dto);

                // ✅ PRG + 캐시 회피용 ts
                response.sendRedirect(request.getContextPath()
                        + "/game1borad.Game1Controller?gameid=" + gameid + "&ts=" + System.currentTimeMillis());
                return;
            }

            // ===== 수정 저장 (POST)
            else if (cmd.equals("/updatePost.Game1Controller") && "POST".equalsIgnoreCase(request.getMethod())) {
                String seqStr = request.getParameter("seq");
                if (seqStr == null || seqStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/game1borad.Game1Controller");
                    return;
                }
                int seq = Integer.parseInt(seqStr);

                String rawTitle  = request.getParameter("title");  if (rawTitle == null) rawTitle = "";
                String rawComent = request.getParameter("coment"); if (rawComent == null) rawComent = "";

                String title = Jsoup.clean(rawTitle, Safelist.none()).trim();
                String coment = Jsoup.clean(
                    rawComent,
                    Safelist.relaxed()
                        .addAttributes(":all", "class", "style")
                        .addAttributes("img", "src", "alt", "title", "width", "height")
                        .addTags("figure", "figcaption")
                        .addProtocols("img", "src", "data", "http", "https")
                        .preserveRelativeLinks(true)
                ).trim();

                boolean hasImage = coment.contains("<img");
                if (title.isEmpty() || (coment.isEmpty() && !hasImage)) {
                    request.setAttribute("error", "제목 또는 내용(텍스트/이미지)을 입력하세요.");
                    request.setAttribute("dto", gbdao.selectById(seq));
                    request.getRequestDispatcher("/board/game1boardEdit.jsp").forward(request, response);
                    return;
                }

                GameBoardDTO dto = new GameBoardDTO();
                dto.setGame_seq(seq);
                dto.setGameboardtitle(title);
                dto.setGamecoment(coment);

                gbdao.update(dto);

                // ✅ PRG
                response.sendRedirect(request.getContextPath()
                        + "/game1boardDetail.Game1Controller?seq=" + seq + "&ts=" + System.currentTimeMillis());
                return;
            }

            // ===== 매칭 안 되면 목록으로
            response.sendRedirect(request.getContextPath() + "/game1borad.Game1Controller");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "알 수 없는 오류가 발생했습니다.");
            request.getRequestDispatcher("/board/game1boardInsert.jsp").forward(request, response);
        }
    }
}
