<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <style>
        body { /* <body> 전체 스타일 */
            background-color: #0c0c1a;
            color: #fff;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }

        .board-container { /* <div class="board-container"> */
            width: 50%;
        }

        h1 { /* <h1> 공통 제목 (게임 게시판) */
            text-align: center;
            color: #ff9800;
            margin-bottom: 20px;
            font-size: 2em;
            border-bottom: 1px solid #3c3c5c;
            padding-bottom: 10px;
        }

        /* 탭 메뉴 */
        .tabs { /* <div class="tabs"> */
            display: flex;
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
        }

        .tab { /* <div class="tab"> (Game1~4) */
            flex: 1;
            text-align: center;
            padding: 12px 0;
            cursor: pointer;
            font-weight: bold;
            color: white;
            transition: all 0.3s;
        }

        .tab:hover { /* 탭 호버 시 */
            transform: scale(1.05);
            box-shadow: 0 0 40px rgba(255, 0, 102, 0.7), 0 0 80px rgba(180, 180, 255, 0.5);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        /* 연속 그라데이션 탭 */
        .tab:nth-child(1) { background: linear-gradient(to right, #33c5c0, #5e72be); }
        .tab:nth-child(2) { background: linear-gradient(to right, #5e72be, #8a79d4); }
        .tab:nth-child(3) { background: linear-gradient(to right, #8a79d4, #b276d1); }
        .tab:nth-child(4) { background: linear-gradient(to right, #b276d1, #d78ae8); }

        /* 테이블 스타일 */
        table { /* <table> 게시판 목록 */
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            margin-bottom: 20px;
        }

        th, td { /* <th>, <td> */
            padding: 10px;
            font-size: 0.9em;
        }

        th { /* 테이블 헤더 */
            color: #d683f2;
            border-bottom: 1px solid #4b2d5e;
        }

        td { /* 테이블 내용 */
            border-bottom: 1px solid #3c1f5c;
            color: #b276d1;
        }

        td:first-child { /* 번호 컬럼 */
            color: #ff5fd6;
            font-weight: bold;
            width: 30px;
        }

        /* 페이지 번호 */
        .pagination { /* <div class="pagination"> */
            text-align: center;
            margin-top: 10px;
            color: #b276d1;
            font-weight: bold;
        }

        .pagination span { /* <span> 페이지 번호 각각 */
            margin: 0 3px;
            cursor: pointer;
            transition: 0.2s;
        }

        .pagination span:hover { color: #ff9800; }

        /* 글 작성 버튼 */
        .write-btn { /* <div class="write-btn"> */
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

        .write-btn:hover { /* 글작성 버튼 호버 */
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

        /* 배경 별, 별똥별 */
        .star, .shooting-star { position: fixed; z-index: 0; border-radius: 50%; }
        .star { animation: twinkle linear infinite; background: white; }
        @keyframes twinkle { 0%,100%{opacity:0.1} 25%{opacity:0.6} 50%{opacity:1} 75%{opacity:0.4} }
        .shooting-star { width:2px; height:10px; background:white; animation: shootingStar linear forwards; }
        @keyframes shootingStar {
            0% { transform: translateY(-5vh) translateX(0) rotate(0deg); opacity: 1; }
            100% { transform: translateY(120vh) translateX(50px) rotate(45deg); opacity: 0; }
        }

        /* 제목 + 로고 묶는 컨테이너 */
        .title-container { /* <div class="title-container"> */
            display: flex;
            align-items: center;
            gap: 15px;
            justify-content: center;
            margin-left: 20px;
            margin-bottom: 20px;
        }

        .title-image { /* <img class="title-image"> 로고 */
            width: 100px;
            height: 100px;
            object-fit: contain;
        }

        .title-container h1 { /* 제목 <h1> (게임 게시판) */
            margin: 0;
            color: #ff9800;
            font-size: 2em;
            border-bottom: 1px solid #3c3c5c;
            padding-bottom: 10px;
            text-align: left;
        }
    </style>
</head>

<body>
    <div class="board-container">
        <div class="title-container">
    <img src="로고.png" alt="게임 로고" class="title-image">
    <h1>게임 게시판</h1>
</div>
        <div class="tabs">
            <div class="tab active">Game 1</div>
            <div class="tab">Game 2</div>
            <div class="tab">Game 3</div>
            <div class="tab">Game 4</div>
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
                <tr>
                    <td>1</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                
            </tbody>
        </table>

        <div class="pagination">
            <span>1</span><span>2</span><span>3</span><span>4</span><span>5</span>
            <span>6</span><span>7</span><span>8</span><span>9</span><span>&gt;</span>
        </div>

        <div class="write-btn">글작성</div>
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

        // 일정 시간마다 별똥별 생성
        setInterval(createShootingStar, 2000);

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
    </script>
</body>
</html>