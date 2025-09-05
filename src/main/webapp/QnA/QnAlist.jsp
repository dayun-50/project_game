<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QnA 게시판</title>
    <style>
        /* 기존 디자인 그대로 유지 */
        body { background-color: #0c0c1a; color: #fff; font-family: 'Arial', sans-serif; display: flex; justify-content: center; padding-top: 50px; }
        .board-container { width: 50%; }
        h1 { text-align: center; color: #ff9800; margin-bottom: 20px; font-size: 2em; border-bottom: 1px solid #3c3c5c; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; text-align: left; margin-bottom: 20px; }
        th, td { padding: 10px; font-size: 0.9em; }
        th { color: #d683f2; border-bottom: 1px solid #4b2d5e; }
        td { border-bottom: 1px solid #3c1f5c; color: #b276d1; }
        td:first-child { color: #ff5fd6; font-weight: bold; width: 30px; }
        .button-group { display: flex; justify-content: center; gap: 50px; margin-top: 30px; }
        .write-btn, .gamepage { width: 150px; padding: 10px 0; text-align: center; font-weight: bold; color: #fff; background: linear-gradient(135deg, #9b59b6, #e91e63); border: none; border-radius: 10px; cursor: pointer; box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; transition: transform 0.2s, box-shadow 0.2s; }
        .write-btn:hover, .gamepage:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
        .post-title { color: #ffffff; text-decoration: none; }
        .post-title:hover { color: #ff9800; }
        .pagination { text-align: center; margin-top: 20px; font-weight: bold; color: #b276d1; }
        .star {
        position: fixed;
        width: 2px;
        height: 2px;
        background: white;
        border-radius: 50%;
        animation: twinkle 3s infinite ease-in-out;
        z-index: 0;
    }

    @keyframes twinkle {
        0%, 100% { opacity: 0.2; }
        50% { opacity: 1; }
    }
       
    </style>
</head>

<body>
    <div class="board-container">
        <h1>QnA 게시판</h1>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:set var="num" value="${fn:length(list)}" />
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${num}</td>
                                <td><a href="detail.qna?id=${dto.inqu_id}" class="post-title">${dto.inqu_Title}</a></td>
                                <td>${dto.inqu_user_name}</td>
                                <td><fmt:formatDate value="${dto.inqu_date}" pattern="yyyy-MM-dd" /></td>
                              	<td>${dto.answerStatus}</td>
                            </tr>
                            <c:set var="num" value="${num - 1}" />
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align:center;">게시물이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- 페이지네비게이터 -->
        <div class="pagination">
            <c:if test="${startPage > 1}">
                <a href="list.qna?page=${startPage - 1}">&lt;&lt;</a>
            </c:if>
            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span style="color:#ff9800;">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="list.qna?page=${i}"><span>${i}</span></a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${endPage < totalPage}">
                <a href="list.qna?page=${endPage + 1}">>></a>
            </c:if>
        </div>

        <form class="button-group" action="/post.qna" method="get">
            <button type="submit" class="write-btn">글작성</button>
            <button type="button" class="gamepage" onclick="location.href='game/gameMain.jsp'">메인으로가기</button>
        </form>
    </div>

    <script>
 // 별 배경
    for (let i = 0; i < 150; i++) {
        const s = document.createElement('div'); 
        s.className = 'star';
        s.style.top = Math.random() * 100 + 'vh';
        s.style.left = Math.random() * 100 + 'vw';
        s.style.animationDuration = (2 + Math.random() * 3) + 's';
        document.body.appendChild(s);
    }

    </script>
</body>
</html>
