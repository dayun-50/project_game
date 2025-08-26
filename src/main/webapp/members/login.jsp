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
            background-color: #0d0d1a;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #fff;
        }

        .login-container {
            width: 400px;
            text-align: center;
            padding: 40px;
            border-radius: 15px;
            background-color: rgba(13, 13, 26, 0.8);
        }

        .login-container h1 {
            color: #00ffff;
            font-size: 50px;
            margin-bottom: 40px;
            text-shadow: 0 0 5px #ffff66, 0 0 15px #fffaaa;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 15px;
            margin: 20px 0;
            border: none;
            border-bottom: 2px solid #00ffff;
            background: transparent;
            color: #fff;
            outline: none;
            font-size: 16px;
        }

        .login-container input::placeholder {
            color: #888;
        }

        .login-container button {
            width: 100%;
            padding: 15px;
            margin-top: 25px;
            border: none;
            border-radius: 15px;
            font-size: 18px;
            cursor: pointer;
            background: linear-gradient(to right, #00ffff, #ff4fc6);
            color: #fff;
            transition: 0.3s;
        }

        .login-container button:hover {
            opacity: 0.8;
            box-shadow: 0 0 5px #ff4fc6, 0 0 30px pink;
        }

        /* 링크 스타일 유지 + hover 시 색상 변경 */
        .login-container .links {
            margin-top: 20px;
            font-size: 14px;
            color: #aaa;
        }

        .login-container .links a {
            color: #00ffff;
            /* 기본 민트색 */
            text-decoration: none;
            margin: 0 5px;
            transition: 0.3s;
        }

        .login-container .links a:hover {
            color: #ff4fc6;
            /* hover 시 보라색 */
        }
        /* ====== 별, 블록 배경 ====== */
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

            0%,
            100% {
                opacity: 0.3;
            }

            50% {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Login</h1>
        <form action="/login.MembersController" method="post">
        <input type="te	xt" placeholder="ID" id="id" name="id">
        <input type="password" placeholder="PW" id="pw" name="pw">
        <button>로그인</button>
        </form>
        <div class="links">
            <a href="#">아이디 찾기</a> /
            <a href="#">비밀번호 찾기</a> /
            <a href="#">회원가입</a>
        </div>
    </div>

    <script>
        // 별 생성
        for (let i = 0; i < 200; i++) {
            const s = document.createElement('div'); s.className = 'star';
            s.style.top = Math.random() * 100 + 'vh';
            s.style.left = Math.random() * 100 + 'vw';
            s.style.animationDuration = (2 + Math.random() * 3) + 's';
            document.body.appendChild(s);
        }
    </script>
</body>
</html>