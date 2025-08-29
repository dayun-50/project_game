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
            height: 800px;
            /* container 위로 내용 표시 */
        }

        .top {
            height: 85px;
            border: 1px solid black;
            background: linear-gradient(135deg, rgba(18, 125, 112, 0.7), rgba(132, 41, 120, 0.5));
        }

        .top h1 {
            color: white;
            font-family: 'Montserrat', sans-serif;
            margin: 30px 0 0 30px;
        }

        .control {
        	margin-top: 20px;
        	margin-bottom: 10px;
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
            width: 285px;
            margin-left: 10px;
            padding: 5px 0;
        }

        .search label {
            font-weight: bold;
            color: white;
            margin: 0 0 0 80px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            color: white;
            font-family: 'Montserrat', sans-serif;
            text-align: center;
            margin-bottom: 30xp;
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
        
        .table2 {
        	position: relative;
        	top: 50px;
            width: 100%;
            border-collapse: collapse;
            color: white;
            font-family: 'Montserrat', sans-serif;
            text-align: center;
            margin-bottom: 30xp;
        }

        .table2 th {
            font-weight: bold;
            padding: 12px;
        }

        .table2 td {
            padding: 10px;
            border-bottom: 1px solid #00ffff;
        }

        .table2 input {
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
            margin-left: 15px;
        }

        .searchbutton:hover {
            filter: brightness(1.2);
            /* 살짝 밝아지게 */
            transform: translateY(-1px);
        }

        .table button {
            background-color: #14877a;
            color: white;
            border: none;
            padding: 5px 12px;
            margin: 0 2px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .table button.remove {
            background-color: #7a1168;
        }
        
        .table2 button {
            background-color: #14877a;
            color: white;
            border: none;
            padding: 5px 12px;
            margin: 0 2px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .table2 button.remove {
            background-color: #7a1168;
        }
        
        .search2 {
        	position: relative;
        	top: 30px;
        	height: 50px;
            display: flex;
            align-items: center;
            padding-left: 1px;
        }
        
        .search2 label {
            font-weight: bold;
            color: white;
            margin: 0 0 0 80px;
        }
        
        .pagination {
			text-align: center;
			padding: 10px 0;
			color: #fff;
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
                <th>ID</th>
                <th>nickname</th>
                <th>관리자 권한</th>
            </tr>
            <tr>
                <td>user1</td>
                <td>nickname1</td>
                <td>
                    <button class="remove">제거</button>
                </td>
            </tr>
            <tr>
                <td>user2</td>
                <td>nickname2</td>
                <td>
                    <button class="remove">제거</button>
                </td>
            </tr>
            <tr>
                <td>user2</td>
                <td>nickname2</td>
                <td>
                    <button class="remove">제거</button>
                </td>
            </tr>
            <tr>
                <td>user2</td>
                <td>nickname2</td>
                <td>
                    <button class="remove">제거</button>
                </td>
            </tr>
            <tr>
                <td>user2</td>
                <td>nickname2</td>
                <td>
                    <button class="remove">제거</button>
                </td>
            </tr>
        </table>
        
        <div class="pagination" id="pageNavi">1 2 3 4 5 6 7 8 9 ></div>
        
        <div class="search2">
            <label for="adminsearch">계정 검색:</label>
            <div class="adminsearch">
                <input type="text" id="adminsearch" name="adminsearch" placeholder="권한 부여할 ID검색">
            </div>
            <button class="searchbutton">검색</button>
        </div>
        
        <table class="table2" id="table">
        <tr>
                <td>user2</td>
                <td>nickname2</td>
                <td>
                    <button class="grant">부여</button>
                </td>
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