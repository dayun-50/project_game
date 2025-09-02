<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: black;
            /* body 전체 배경 */
            overflow: hidden;
            /* 별이 튀어나가는 걸 방지 */
        }

        .container {
            width: 600px;
            min-height: 600px;
            background-color: black;
            position: relative;
            z-index: 1;
            /* container 위로 내용 표시 */
        }

        .top {
            height: 100px;
            border: 1px solid black;
            background: linear-gradient(135deg, rgba(18, 125, 112, 0.7), rgba(132, 41, 120, 0.5));
        }

        .top h1 {
            color: white;
            font-family: 'Montserrat', sans-serif;
            margin: 45px 0 0 30px;
        }

        .control {
            height: 80px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .box {
            width: 400px;
            height: 40px;
            display: flex;
            background: linear-gradient(135deg, #b01cbe, #18a393);
        }

        .box button {
            flex: 1;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: transparent;
            color: white;
            font-weight: bold;
            font-size: 15px;
            font-family: 'Lato', sans-serif;
            cursor: pointer;
        }

        .search {
            height: 50px;
            display: flex;
            align-items: center;
            padding-left: 1px;
        }

        .adminsearch input {
            border: none;
            border-bottom: 1px solid #00ffff;
            background: transparent;
            color: white;
            font-size: 16px;
            width: 315px;
            margin-left: 10px;
            padding: 5px 0;
        }

        .search label {
            font-weight: bold;
            color: white;
            margin: 15px 0 0 80px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            color: white;
            font-family: 'Montserrat', sans-serif;
            text-align: center;
        }

        .table th {
            font-weight: bold;
            padding: 12px;
        }

        .table td {
            padding: 10px;
            border-bottom: 1px solid #00ffff;
        }

        .table input {
            background: transparent;
            border: none;
            border-bottom: 1px solid #00ffff;
            color: white;
            font-size: 14px;
            width: 90%;
            text-align: center;
        }

        .star {
            position: fixed;
            width: 2px;
            height: 2px;
            background: white;
            border-radius: 50%;
            animation: twinkle 3s infinite ease-in-out;
            z-index: 0;
            /* container 뒤로 별 위치 */
        }

        @keyframes twinkle {

            0%,
            100% {
                opacity: 0.2;
            }

            50% {
                opacity: 1;
            }
        }

        .searchbutton {
            background: linear-gradient(135deg, #b01cbe, #18a393);
            color: white;
            border: none;
            padding: 8px 15px;
            font-weight: bold;
            font-size: 14px;
            border-radius: 5px;
            /* 오른쪽 둥글게 */
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .searchbutton:hover {
            filter: brightness(1.2);
            /* 살짝 밝아지게 */
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
 <div class="container">
        <div class="top">
            <h1>Master Admin</h1>
        </div>

        <div class="control">
            <div class="box">
                <button>관리자 관리</button>
                <button>블랙리스트 관리</button>
            </div>
        </div>

        <div class="search">
            <label for="adminsearch">계정 검색:</label>
            <div class="adminsearch">
                <input type="text" id="adminsearch" name="adminsearch">
            </div>
            <button class="searchbutton">검색</button>
        </div>

        <table class="table" id="table">
            <tr>
                <th>Num</th>
                <th>nickname</th>
                <th>Comment</th>
            </tr>
        </table>
    </div>

    <script>
        // 별 생성
        const colors = ['#ffffff', '#aabbff', '#ffb3ff', '#b3ffea', '#ffd9b3']; // 은하수 느낌 색상
        for (let i = 0; i < 300; i++) {
            const s = document.createElement('div');
            s.className = 'star';
            s.style.top = Math.random() * 100 + 'vh';
            s.style.left = Math.random() * 100 + 'vw';
            s.style.width = s.style.height = (Math.random() * 2 + 1) + 'px'; // 크기 랜덤
            s.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
            s.style.animationDuration = (2 + Math.random() * 3) + 's';
            document.body.appendChild(s);
        }
    </script>
</body>
</html>