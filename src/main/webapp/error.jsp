<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류 페이지</title>
<style>
    body {
        background-color: #0d0d1a;
        font-family: Arial, sans-serif;
        color: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .container {
        text-align: center;
        background: linear-gradient(to bottom, #1a1a2e, #0d0d1a);
        padding: 50px;
        border-radius: 15px;
        box-shadow: 0 0 20px #00ffff50;
    }

    h2 {
        font-size: 28px;
        color: #ff00ff;
        text-shadow: 0 0 8px #ff00ff, 0 0 20px #ff00ff;
        margin-bottom: 40px;
    }

    .back-btn {
        background: linear-gradient(to right, #00ffff, #ff4fc6);
        color: #fff;
        border: none;
        border-radius: 15px;
        padding: 12px 25px;
        font-size: 18px;
        cursor: pointer;
        transition: 0.3s;
        box-shadow: 0 0 10px #00ffff50, 0 0 20px #ff4fc650;
    }

    .back-btn:hover {
        filter: brightness(1.2);
        transform: scale(1.05);
    }

    a {
        color: #ff00ff;
        text-decoration: none;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>오류가 계속 발생하면 연락바랍니다.<br>관리자 : 010-9006-2139</h2>
        <button class="back-btn" onclick="history.back();">이전 페이지로 이동</button>
    </div>

    <script>
    </script>
</body>
</html>
