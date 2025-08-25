<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 완료</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    body {
        background-color: #0d0d1a;
        font-family: Arial, sans-serif;
        color: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        flex-direction: column;
        text-align: center;
    }

    .page-title {
        font-size: 20px;
        color: #ff00ff;
        text-shadow: 0 0 5px #ff00ff, 0 0 15px #ff00ff;
        margin-bottom: 20px;
    }

    .nickname {
        font-size: 50px;
        color: #00ffff;
        text-shadow: 0 0 5px #00ffff, 0 0 15px #00ffff;
        margin-bottom: 10px;
    }

    .message {
        font-size: 40px;
        color: #00ffff;
        text-shadow: 0 0 5px #ffff66, 0 0 15px #fffaaa;
        margin-bottom: 30px;
    }

    .btn {
        background: linear-gradient(to right, #00ffff, #ff4fc6);
        border: none;
        color: #fff;
        padding: 12px 20px;
        border-radius: 12px;
        cursor: pointer;
        font-size: 20px;
        margin: 30px;
        text-decoration: none;
        display: inline-block;
        width: 200px;
        height: 40px;
        font-weight: bold;
    }

	

    .star {
        position: fixed;
        width: 2px;
        height: 2px;
        background: white;
        border-radius: 50%;
        animation: twinkle 3s infinite ease-in-out;
        z-index: 0;
    }
    
    #box{
    	float: left;
    }

    @keyframes twinkle {
        0%, 100% { opacity: 0.3; }
        50% { opacity: 1; }
    }
</style>
</head>
<body>
    <div class="page-title">회원가입 완료 :)</div>
    <div class="nickname">${nickname } 님</div>
    <div class="message">회원가입을 축하드립니다!</div>
	
	<div id="box">
    <a href="/indexpage.MembersController" class="btn">메인 홈페이지로 이동</a>
    <a href="/loginpgae.MembersController" class="btn">로그인 화면으로 이동</a>
	</div>
<script>
    // 별 생성
    for (let i = 0; i < 200; i++) {
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
