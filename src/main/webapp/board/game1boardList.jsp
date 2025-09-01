<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

        /* 탭 메뉴 */
        .tabs {
            display: flex;
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
        }

        .tab {
            flex: 1;
            text-align: center;
            padding: 12px 0;
            cursor: pointer;
            font-weight: bold;
            color: white;
            transition: all 0.3s;
        }

        .tab:hover {
            transform: scale(1.05);
            /* 글작성 버튼처럼 살짝 커짐 */
            box-shadow: 0 0 40px rgba(255, 0, 102, 0.7), 0 0 80px rgba(180, 180, 255, 0.5);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        /* 연속 그라데이션 탭 */
        .tab:nth-child(1) {
            background: linear-gradient(to right, #33c5c0, #5e72be);
        }

        .tab:nth-child(2) {
            background: linear-gradient(to right, #5e72be, #8a79d4);
        }

        .tab:nth-child(3) {
            background: linear-gradient(to right, #8a79d4, #b276d1);
        }

        .tab:nth-child(4) {
            background: linear-gradient(to right, #b276d1, #d78ae8);
        }

        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            margin-bottom: 20px;
        }

        th,
        td {
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

        /* 페이지 번호 */
        .pagination {
            text-align: center;
            margin-top: 10px;
            color: #b276d1;
            font-weight: bold;
        }

        .pagination span {
            margin: 0 3px;
            cursor: pointer;
            transition: 0.2s;
        }

        .pagination span:hover {
            color: #ff9800;
        }

        /* 글 작성 버튼 - 보라색 그라데이션 */
        .write-btn {
            display: block;
            width: 100px;
            margin: 10px auto;
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

        .write-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

        .star,
        .shooting-star {
            position: fixed;
            z-index: 0;
            border-radius: 50%;
        }

        .star {
            animation: twinkle linear infinite;
            background: white;
        }

        @keyframes twinkle {

            0%,
            100% {
                opacity: 0.1
            }

            25% {
                opacity: 0.6
            }

            50% {
                opacity: 1
            }

            75% {
                opacity: 0.4
            }
        }

        

        .shooting-star {
            width: 2px;
            height: 10px;
            background: white;
            animation: shootingStar linear forwards;
        }
        .title-container {
    display: flex;               /* 가로로 나란히 */
    align-items: center;         /* 수직 중앙 정렬 */
    gap: 15px;                   /* 이미지와 제목 사이 간격 */
    justify-content: center;
    margin-left: 20px;           /* 화면 왼쪽에서 살짝 띄움 */
    margin-bottom: 20px;         /* 아래 여백 */
}

.title-image {
    width: 100px;                /* 이미지 크기 */
    height: 100px;
    object-fit: contain;
}

.title-container h1 {
    margin: 0;
    color: #ff9800;
    font-size: 2em;
    border-bottom: 1px solid #3c3c5c;
    padding-bottom: 10px;
    text-align: left;            /* 텍스트 왼쪽 정렬 */
}

.title{
	width: 40%;
}

td{
	text-align: center;
}

th{
	text-align: center;
}

a {
text-decoration: none;
color: inherit; 
}


    </style>
</head>
<body>
<div class="board-container">
        <div class="title-container">
    <img src="GameLogo.png" alt="게임 로고" class="title-image">
    <h1>게임 게시판</h1>
</div>
        <div class="tabs">
            <div class="tab active"><a href="/game1borad.Game1Controlle?gameid=1">Game 1</a></div>
            <div class="tab"><a href="/game1borad.Game1Controlle?gameid=2">Game 2</a> </div>
            <div class="tab"><a href="/game1borad.Game1Controlle?gameid=3">Game 3</a></div>
            <div class="tab"><a href="/game1borad.Game1Controlle?gameid=4">Game 4</a></div>
        </div>

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
            <c:forEach var="dto" items="${list}">
                <tr>
                    <td>${dto.game_seq }</td>
                    <td class="title">
                    	<a href="/game1boradDetil.Game1Controller?seq=${dto.game_seq }">${dto.gameboardtitle }</a>
                    </td>
                    <td>${dto.gamewrtier }</td>
                    <td>${dto.game_board_date }</td>
                    <td>${dto.view_count}</td>
                </tr>
             </c:forEach>
            </tbody>
        </table>

       <div  class="pagination" id="pageNavi"></div>
		
		<input type="hidden" id="gameid" name="gameid" value="${dto.gameid }">
		
        <div class="write-btn" id="btn">글작성</div>
        <div class="write-btn" id="backbtn">뒤로가기</div>
    </div>

    <script>
        function createStars(count, topRange = [0, 100], leftRange = [0, 100], sizeRange = [1, 3]) {
            for (let i = 0; i < count; i++) {
                const s = document.createElement('div');
                s.className = 'star';
                const size = Math.random() * (sizeRange[1] - sizeRange[0]) + sizeRange[0];
                s.style.width = size + 'px';
                s.style.height = size + 'px';
                s.style.top = (Math.random() * (topRange[1] - topRange[0]) + topRange[0]) + 'vh';
                s.style.left = (Math.random() * (leftRange[1] - leftRange[0]) + leftRange[0]) + 'vw';
                s.style.background = `rgba(255,255,255,${Math.random()})`;
                s.style.animationDuration = (1 + Math.random() * 3) + 's';
                document.body.appendChild(s);
            }
        }

        function createShootingStar() {
            const star = document.createElement('div');
            star.className = 'shooting-star';
            star.style.left = Math.random() * 100 + 'vw';
            star.style.animationDuration = (1 + Math.random() * 1) + 's';
            document.body.appendChild(star);
            star.addEventListener('animationend', () => star.remove());
        }

        // 별 생성
        createStars(800);
        createStars(400, [20, 50], [20, 80], [1, 2]);



        // 튜토리얼 위치
        function updateTutorialPositions() {
            document.querySelectorAll('.tutorial-item').forEach(item => {
                const targetId = item.getAttribute('data-target');
                const target = document.getElementById(targetId);
                if (target) {
                    const rect = target.getBoundingClientRect();
                    item.sctyle.left = (rect.left + rect.width / 2) + 'px';
                    item.style.top = (rect.top) + 'px';
                }
            });
        }
        updateTutorialPositions();
        window.addEventListener('resize', updateTutorialPositions);
        
        $("#btn").on("click", function(){ //글작성버튼
        	window.location.href = "/boardInsert.Game1Controller?gameid="+$("#gameid").val();
        });
        
        
        let recordTotalCount = parseInt("${recordTotalCount}");
		let recordCountPerPage = parseInt("${recordCountPerPage}");
		let naviCountPerPage = parseInt("${naviCountPerPage}");
		let currentPage = parseInt("${currentPage}");

		let pageTotalCount = Math.ceil(recordTotalCount / recordCountPerPage);
		if(currentPage < 1) {
			currentPage=1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		
		let startNavi = Math.floor((currentPage - 1) / naviCountPerPage)
				* naviCountPerPage + 1;
		
		let endNavi = startNavi + (naviCountPerPage - 1);
		if (endNavi > pageTotalCount)
			endNavi = pageTotalCount;

		let html = "";
		let needPrev = true;
		let needNext = true;
		
		if(startNavi == 1) {needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}

		if (needPrev) {
			html += "<a href='/game1borad.Game1Controller?cpage=" + (startNavi - 1) + "'>< </a>";
	      }

	      for (let i = startNavi; i <= endNavi; i++) {
	    	  html += "<a href='/game1borad.Game1Controller?cpage=" + i + "'>" + i + "</a> ";
	      }

	      if (needNext) {
	    	  html += "<a href='/game1borad.Game1Controller?cpage=" + (endNavi + 1) + "'>> </a>";
	      }
	    
		document.getElementById("pageNavi").innerHTML = html;
		
		$("#backbtn").on("click", function(){ // 뒤로가기버튼
			window.location.href = "/gamapage.GameController"	
		});
    </script>
</body>
</html>