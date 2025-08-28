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
	color: #fff;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
}

.container {
	width: 500px;
	text-align: left;
}

/* ===== 페이지 제목 ===== */
.page-title {
	text-align: center;
	font-size: 20px;
	font-weight: bold;
	color: #ff00ff;
	/* 기존 Welcome 색상 */
	text-shadow: 0 0 5px #ff00ff, 0 0 15px #ff00ff;
	/* 기존 스타일 */
	margin-bottom: 10px;
}

h1 {
	font-size: 50px;
	color: #00ffff;
	/* 민트 계열 */
	text-align: center;
	margin-bottom: 40px;
	text-shadow: 0 0 5px #ffff66, 0 0 15px #fffaaa;
	margin-top: 10px;
}

.form-group {
	display: flex;
	align-items: center;
	margin-bottom: 10px;
}

label {
	width: 120px;
	color: #00ffff;
	font-size: 20px;
	text-align: center;
}

.agreement input[type="radio"] {
	transform: scale(0.5); /* 70% 크기로 축소 */
	margin-left: 70px;
}

input {
	flex: 1;
	padding: 5px;
	border: none;
	border-bottom: 1px solid #00ffff;
	background: transparent;
	color: #fff;
	outline: none;
	font-size: 18px;
	width: 370px;
	height: 33px;
}

#id {
	flex: 1;
	padding: 5px;
	border: none;
	border-bottom: 1px solid #00ffff;
	background: transparent;
	color: #fff;
	outline: none;
	font-size: 18px;
	width: 267px;
	height: 33px;
}

#nickname {
	flex: 1;
	padding: 5px;
	border: none;
	border-bottom: 1px solid #00ffff;
	background: transparent;
	color: #fff;
	outline: none;
	font-size: 18px;
	width: 267px;
	height: 33px;
}

.check-btn {
	background: linear-gradient(to right, #00ffff, #ff4fc6);
	border: none;
	color: #fff;
	padding: 10px 18px;
	border-radius: 12px;
	cursor: pointer;
	font-size: 14px;
	margin-left: 5px;
}

.agreement {
	margin: 15px 0;
	font-size: 12px;
	color: #aaa;
	display: flex;
	align-items: center;
	gap: 2px;
	padding-right: 40px;
}

.btn-submit {
	float: left;
	width: 30%;
	padding: 10px;
	margin: 20px 15px 0 auto;
	border: none;
	border-radius: 15px;
	background: linear-gradient(to right, #00ffff, #ff4fc6);
	color: #fff;
	font-size: 16px;
	cursor: pointer;
	display: block;
}

#btn {
	width: 30%;
	padding: 10px;
	margin: 20px auto 0 15px;
	border: none;
	border-radius: 15px;
	background: linear-gradient(to right, #00ffff, #ff4fc6);
	color: #fff;
	font-size: 16px;
	cursor: pointer;
	display: block;
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

@
keyframes twinkle { 0%, 100% {
	opacity: 0.3;
}
50
%
{
opacity
:
1;
}
}
</style>
</head>
<body>
	<div class="container">
		<div class="page-title">혜빈이와 아이들</div>
		<h1>
			[ ${id } ] 계정<br> 비밀번호 변경 완료
		</h1>

		<div class="form-group">
			<button type="button" class="btn-submit" id="main-btn">메인홈페이지</button>
			<button type="button" id="btn">로그인</button>

		</div>
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
		
		$("#main-btn").on("click", function(){ //메인 홈페이지 이동
			window.location.href = "/indexpage.MembersController";
		});
		
		$("#btn").on("click", function(){ // 로그인 페이지 이동
			window.location.href = "/loginpgae.MembersController";
		});
		
		
	</script>
</body>
</html>