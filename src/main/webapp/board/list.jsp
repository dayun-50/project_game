<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자유 게시판</title>
    <style>
        body {
            background-color: #0c0c1a;
            color: #fff;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }

        .board-container {
            width: 50%;
        }

        h1 {
            text-align: center;
            color: #ff9800;
            margin-bottom: 20px;
            font-size: 2em;
            border-bottom: 1px solid #3c3c5c;
            padding-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            margin-bottom: 20px;
        }

        th, td {
            padding: 10px;
            font-size: 0.9em;
        }

        th {
            color: #d683f2;
            border-bottom: 1px solid #4b2d5e;
        }

        td {
            border-bottom: 1px solid #3c1f5c;
            color: #b276d1;
        }

        td:first-child {
            color: #ff5fd6;
            font-weight: bold;
            width: 30px;
        }
		.button-group {
    display: flex;
    justify-content: center; /* 버튼들 가운데 정렬 */
    gap: 40px; /* 버튼 사이 간격 */
    margin-top: 30px; /* 위아래 여백 */
}

.write-btn, .gamepage {
    width: 150px;
    padding: 10px 0;
    text-align: center;
    font-weight: bold;
    color: #fff;
    background: linear-gradient(135deg, #9b59b6, #e91e63);
    border: none;
    border-radius: 10px;
    cursor: pointer;
    box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
    transition: transform 0.2s, box-shadow 0.2s;
}

.write-btn:hover, .gamepage:hover {
    transform: scale(1.05);
    box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
}
		 .post-title {
   			color: #ffffff; /* 흰색 글씨 */
    		text-decoration: none; /* 밑줄 제거 */
		}

		.post-title:hover {
    		color: #ff9800; /* 마우스 오버 시 강조 색 */
		}
        

        .pagination {
            text-align: center;
            margin-top: 20px;
            font-weight: bold;
            color: #b276d1;
        }

        .star, .shooting-star {
            position: fixed;
            z-index: 0;
            border-radius: 50%;
        }

        .star {
            animation: twinkle linear infinite;
            background: white;
        }

        @keyframes twinkle {
            0%,100%{opacity:0.1} 
            25%{opacity:0.6} 
            50%{opacity:1} 
            75%{opacity:0.4} 
        }

        .shooting-star {
            width:2px;
            height:10px;
            background:white;
            animation: shootingStar linear forwards;
        }

        @keyframes shootingStar {
            0% { transform: translateY(-5vh) translateX(0) rotate(0deg); opacity: 1; }
            100% { transform: translateY(120vh) translateX(50px) rotate(45deg); opacity: 0; }
        }
       
    </style>
</head>

<body>
    <div class="board-container">
        <h1>자유게시판</h1>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:set var="num" value="${fn:length(list)}" />
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${num}</td>
                                <td><a href="detail.free?id=${dto.fb_id}" class="post-title">${dto.fb_Title}</a></td>
                                <td>${dto.fb_user_name}</td>
                                <td><fmt:formatDate value="${dto.fb_date}" pattern="yyyy-MM-dd" /></td>
                                <td>${dto.view_count}</td>
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
        

        <!-- 페이지네비게이터 자리 -->
    <div class="pagination">
    <c:if test="${startPage > 1}">
        <a href="list.free?page=${startPage - 1}">&lt;&lt;</a>
    </c:if>

    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:choose>
            <c:when test="${i == currentPage}">
                <span style="color:#ff9800;">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="list.free?page=${i}"><span>${i}</span></a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:if test="${endPage < totalPage}">
        <a href="list.free?page=${endPage + 1}">>></a>
    </c:if>
</div>

<form class="button-group" action="/post.free" method="get">
    <button type="submit" class="write-btn">글작성</button>

    <button type="button" class="gamepage" onclick="location.href='${pageContext.request.contextPath}/gamepage.free'">게임화면으로 가기</button>

</form>

    </div>

    <script>
        function createStars(count, topRange=[0,100], leftRange=[0,100], sizeRange=[1,3]) {
            for(let i=0;i<count;i++){
                const s=document.createElement('div');
                s.className='star';
                const size=Math.random()*(sizeRange[1]-sizeRange[0])+sizeRange[0];
                s.style.width=size+'px';
                s.style.height=size+'px';
                s.style.top=(Math.random()*(topRange[1]-topRange[0])+topRange[0])+'vh';
                s.style.left=(Math.random()*(leftRange[1]-leftRange[0])+leftRange[0])+'vw';
                s.style.background=`rgba(255,255,255,${Math.random()})`;
                s.style.animationDuration=(1+Math.random()*3)+'s';
                document.body.appendChild(s);
            }
        }

        function createShootingStar(){
            const star=document.createElement('div');
            star.className='shooting-star';
            star.style.left=Math.random()*100+'vw';
            star.style.animationDuration=(1+Math.random()*1)+'s';
            document.body.appendChild(star);
            star.addEventListener('animationend',()=>star.remove());
        }

        createStars(800);
        createStars(400,[20,50],[20,80],[1,2]);
        setInterval(createShootingStar,2000);
    </script>
</body>
</html>
