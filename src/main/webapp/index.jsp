<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>혜빈이와 아이들 프로젝트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap"
	rel="stylesheet">
<style>
/* ====== 전체 기본 스타일 ====== */
body {
	margin: 0;
	font-family: 'Orbitron', sans-serif;
	color: #fff;
	overflow-x: hidden;
	background: radial-gradient(circle at center, #05070d, #000000);
	position: relative;
}

/* ====== 별, 블록 배경 ====== */
.star {
	position: fixed;
	width: 2px;
	height: 2px;
	background: white;
	border-radius: 50%;
	animation: twinkle 3s infinite ease-in-out;
	z-index: 1;
}

@
keyframes twinkle { 0%,100%{
	opacity: 0.3;
}
50%{opacity:1;}
}
.background-block {
	position: fixed;
	width: 10px;
	height: 10px;
	background: #ffcc00;
	border: 2px solid #d4a017;
	border-radius: 50%;
	animation: float 3s ease-in-out infinite, twinkle 3s infinite
		ease-in-out;
	z-index: 0;
}

@
keyframes float { 0%,100%{
	transform: translateY(0);
}

50
%
{
transform
:
translateY(
-10px
);
}
}

/* ====== 메인 컨테이너 ====== */
.container {
	position: relative;
	width: 1200px;
	margin: 0 auto;
	text-align: center;
	padding-bottom: 50px;
	z-index: 1;
}

h1, h2 {
	font-family: 'Orbitron', sans-serif;
	color: #00fff7;
	text-shadow: 0 0 5px #00fff7, 0 0 20px #00fff7;
}

.header {
	padding: 50px 0;
	border-bottom: 2px solid #00fff7;
}

.header .subtitle {
	color: #ff00ff;
	margin-bottom: 20px;
	text-shadow: 0 0 5px #ff00ff, 0 0 15px #ff00ff;
	font-size: 18px;
}

.header-buttons {
	margin-top: 20px;
	display: flex;
	justify-content: center;
	gap: 20px;
}

.header-buttons button {
	padding: 10px 25px;
	font-size: 16px;
	font-weight: bold;
	color: #fff;
	background: linear-gradient(135deg, #00fff7, #ff00ff);
	border: none;
	border-radius: 10px;
	cursor: pointer;
	box-shadow: 0 0 15px rgba(0, 255, 255, 0.5);
	transition: transform 0.2s, box-shadow 0.2s;
}

.header-buttons button:hover {
	transform: scale(1.1);
	box-shadow: 0 0 25px #ff00ff, 0 0 50px #00fff7;
}

/* ====== 닌텐도 스위치 UI (고정 크기) ====== */
html, body {
	font-family: 'Press Start 2P', cursive;
}

.switch {
	width: 900px;
	height: 420px;
	background:  #333;;
	border-radius: 75px;
	display: flex;
	box-shadow: 0 0 20px #000 inset, 0 0 30px #555;
	position: relative;
	margin: 50px auto;
	z-index: 2;
}

.joycon-left, .joycon-right {
	width: 23%;
	height: 100%;
	padding: 20px;
	box-sizing: border-box;
	position: relative;
	z-index: 2;
	border: 2px solid #666;
}

.joycon-left {
	background: linear-gradient(145deg, #39c5bb, #1c8e85);
	border-top-left-radius: 75px;
	border-bottom-left-radius: 75px;
	box-shadow: 3px 3px 8px #000 inset;
}

.joycon-right {
	background: linear-gradient(145deg, #ff5555, #cc2222);
	border-top-right-radius: 75px;
	border-bottom-right-radius: 75px;
	box-shadow: 3px 3px 8px #000 inset;
}

.screen {
	flex-grow: 1;
	background:  linear-gradient(to bottom, #0d1b3c 0%, #0a0f1a 100%);
	margin: 12px;
	border-radius: 30px;
	box-shadow: inset 0 0 20px #fff5, 0 0 20px #000;
	display: flex;
	justify-content: center;
	align-items: flex-end;
	position: relative;
	overflow: hidden;
	z-index: 3; /* 기존보다 높게 */
}

/* 버튼/스틱 디자인 (고정) */
.btn-round {
	background-color: #fff;
	border: 3px solid #555;
	border-radius: 50%;
	color: #222;
	cursor: pointer;
	box-shadow: 2px 2px 0 #333;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	z-index: 2;
	overflow: visible;
	text-align: center;
	white-space: nowrap;
	font-size: 16px;
	width: 50px;
	height: 50px;
}

.btn-round:active {
	transform: translate(2px, 2px);
	box-shadow: none;
}

.btn-round:focus {
	outline: none;
}

.stick {
	width: 150px;
	height: 100px;
	position: absolute;
	border-radius: 25%;
	background: linear-gradient(135deg, #0ff, #08f);
	box-shadow: 0 0 15px #0ff, inset 0 0 5px #08f;
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
	color: white;
	font-weight: bold;
	font-size: 14px;
}

.stick:hover {
	box-shadow: 0 0 25px #0ff, inset 0 0 10px #08f;
	transform: translateY(-2px);
}

.joycon-left .stick {
	top: 60px;
	left: 30px;
}

.joycon-right .stick {
	bottom: 60px;
	right: 25px;
}

/* D-Pad 고정 */
.dpad-joycon {
	position: absolute;
	bottom: 50px;
	left: 40px;
	display: grid;
	grid-template-columns: 50px 30px 50px;
	grid-template-rows: 50px 30px 50px;
	place-items: center;
	z-index: 2;
}

.dpad-joycon .btn-round {
	width: 50px;
	height: 50px;
	font-size: 14px;
}

#dpad-up {
	grid-column: 2;
	grid-row: 1;
}

#dpad-down {
	grid-column: 2;
	grid-row: 3;
}

#dpad-left {
	grid-column: 1;
	grid-row: 2;
}

#dpad-right {
	grid-column: 3;
	grid-row: 2;
}

/* ABXY 버튼 고정 */
.buttons {
	position: absolute;
	top: 60px;
	right: 45px;
	display: grid;
	grid-template-columns: 50px 50px;
	grid-template-rows: 50px 50px;
	gap: 30px;
	z-index: 2;
}

.buttons button {
	width: 70px;
	height: 70px;
	font-size: 14px;
}

/* 설명창 */
#description {
	width: 800px;
	background: linear-gradient(135deg, #9b59b6, #e91e63);
	border-radius: 10px;
	padding: 20px;
	box-shadow: 0 0 20px #e91e63, inset 0 0 10px #9b59b6;
	transform: translateY(-20px);
	opacity: 0;
	transition: all 0.4s ease;
	margin: 20px auto;
	font-size: 16px;
	line-height: 1.6;
	color: #fff;
	text-shadow: 1px 1px 2px #9b59b6;
	letter-spacing: 0.05em;
	font-family: 'Press Start 2P', cursive;
	white-space: pre-wrap;
	z-index: 3;
}

#description.show {
	transform: translateY(0);
	opacity: 1;
}

/* 게임 카드 */
.game-cards {
	width: 1200px;
	margin: 50px auto;
	display: flex;
	flex-direction: column;
	gap: 50px;
}

.game-card {
	display: flex;
	gap: 20px;
	width: 100%;
	align-items: flex-start;
}

.game-card.reverse {
	flex-direction: row-reverse;
}

.card-left {
	display: flex;
	flex-direction: column;
	gap: 10px;
	flex-shrink: 0;
}

.game-image {
	width: 250px;
	height: 250px;
	background: linear-gradient(135deg, #ffb6ff, #00f9ff);
	border-radius: 15px;
}

.game-info {
	flex-grow: 1;
	text-align: left;
}

.game-info h3 {
	font-size: 3rem;
	margin-bottom: 10px;
	
}

.game-info p {
	font-size: 2rem;
}

.card-left button {
	width: 250px;
	padding: 0.8em 0;
	font-size: 1rem;
	font-weight: bold;
	background: linear-gradient(135deg, #00fff7, #ff00ff);
	color: #fff;
	border: none;
	border-radius: 10px;
	cursor: pointer;
	transition: 0.2s;
}

.card-left button:hover {
	transform: scale(1.05);
	box-shadow: 0 0 15px #ff00ff, 0 0 25px #00fff7;
}

.seungjin{
	color: orange;
}
#seungjin{
	color: purple;
}

/* 즐기러 가기 버튼 */
#play-btn {
  padding: 18px 50px;
  font-size: 24px;
  font-weight: bold;
  color: #fff;
  background: linear-gradient(135deg, #ff00ff, #00fff7);
  border: none;
  border-radius: 12px;
  cursor: pointer;
  box-shadow: 0 0 20px #ff00ff, 0 0 40px #00fff7;
  transition: transform 0.2s, box-shadow 0.2s;
}

#play-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 0 35px #ff00ff, 0 0 60px #00fff7;
}

.play-btn-container {
  margin-top: 30px;
  text-align: center;
}

#stick-right{
	font-size: 20px;

}
.footer {
    width: 100%;
    background-color: #111;             /* 어두운 배경 */
    color: #ccc;                        /* 글자 색상 */
    font-family: 'Montserrat', sans-serif;
    /* border-top: 1px solid orangered;    위쪽 경계선 */

    display: flex;
    flex-direction: column;
    justify-content: flex-end;          /* 글자를 아래쪽으로 정렬 */
    align-items: center;            /* 왼쪽 정렬 */
    padding: 10px 20px;                 /* 위/아래 여백 조절, 글자와 경계선 간격 */
}

.footer p {
    margin: 2px 0;                      /* 문단 간 간격 최소화 */
    font-size: 12px;
}
.game-card:nth-child(1) .game-image {
    background-image: url('BOSS.png'); /* 실제 이미지 경로 */
    background-size: cover;       /* 꽉 채우기 */
    background-position: center;  /* 중앙 정렬 */
    background-repeat: no-repeat; /* 반복 금지 */
}
.game-card:nth-child(2) .game-image {
    background-image: url('bro.png'); /* 실제 이미지 경로 */
    background-size: cover;       /* 꽉 채우기 */
    background-position: center;  /* 중앙 정렬 */
    background-repeat: no-repeat; /* 반복 금지 */
}
.game-card:nth-child(3) .game-image {
    background-image: url('game3back.jpg'); /* 실제 이미지 경로 */
    background-size: cover;       /* 꽉 채우기 */
    background-position: center;  /* 중앙 정렬 */
    background-repeat: no-repeat; /* 반복 금지 */
}
.game-card:nth-child(4) .game-image {
    background-image: url('kaplestory.png'); /* 실제 이미지 경로 */
    background-size: cover;       /* 꽉 채우기 */
    background-position: center;  /* 중앙 정렬 */
    background-repeat: no-repeat; /* 반복 금지 */
}
/* 스크린 레트로 느낌 */
#screen {
    font-family: 'Press Start 2P', monospace;
    color: yellow;
    text-shadow: 0 0 5px #0ff, 0 0 15px #0ff;
    position: relative;
    overflow: hidden;
    background: #0a0f1a;
    z-index:3;
}

#screen::before {
    content: "INSERT COIN";
    position: absolute;
    width: 100%;
    text-align: center;
    top: 50%;
    transform: translateY(-50%);
    animation: blinkText 3s infinite; /* 깜빡임 주기 */
    font-size: 30px;
}

@keyframes blinkText {
    0%, 50%, 100% { opacity: 1; }
    25%, 75% { opacity: 0; }
}
.boss{ /*혜빈*/
	color:skyblue;
}
.redboss{ /*혜빈*/
	color:red;
}
.sj{ /*승진*/
	color:red;
}
.bro{ /*범찬*/
	color:green;
}
.bros{ /*범찬*/
	color:rgb(215, 53, 129);
}
.brother{ /*유승*/
	color:yellow;
}
.kaple{ /*유승*/
	color:red;
}
</style>
</head>
<body>

	<div id="stars"></div>
	<div id="blocks"></div>

	<script>
	
// 별 생성
for(let i=0;i<200;i++){
  const s=document.createElement('div'); s.className='star';
  s.style.top=Math.random()*100+'vh';
  s.style.left=Math.random()*100+'vw';
  s.style.animationDuration=(2+Math.random()*3)+'s';
  document.body.appendChild(s);
}
// 블록 생성
for(let i=0;i<30;i++){
  const b=document.createElement('div'); b.className='background-block';
  b.style.bottom=Math.random()*100+'vh';
  b.style.left=Math.random()*100+'vw';
  document.body.appendChild(b);
}
const screen = document.getElementById('screen');

//screen 안 별 생성
for(let i = 0; i < 20; i++){  // 원하는 개수
 const star = document.createElement('div');
 star.className = 'pixel-star';
 
 star.style.top = Math.random() * (screen.clientHeight - 10) + 'px';
 star.style.left = Math.random() * (screen.clientWidth - 10) + 'px';
 
 // 랜덤 깜빡임 속도
 const blinkDuration = 1 + Math.random() * 2; // 1~3초
 star.style.animation = `moveStar 2s linear infinite, blinkStar ${blinkDuration}s infinite alternate`;
 
 screen.appendChild(star);
}
</script>

	<div class="container">
	
		<div class="header">
			<div class="subtitle">Welcome to the Game</div>
			<h1>혜빈이와 아이들</h1>
			<h1>Game play</h1>
			<div class="header-buttons">
				<button id="login-btn">로그인</button>
				<button id="signup-btn">회원가입</button>
			
			</div>
		</div>

		<div class="switch">
			<div class="joycon-left">
				<button class="stick btn-round" id="stick-left">◉</button>
				<div class="dpad-joycon">
					<button class="btn-round" id="dpad-up">▲</button>
					<button class="btn-round" id="dpad-left">◀</button>
					<button class="btn-round" id="dpad-right">▶</button>
					<button class="btn-round" id="dpad-down">▼</button>
				</div>
			</div>
			<div class="screen" id="screen">
    		</div>
			<div class="joycon-right">
				<div class="buttons">
					<button id="btn-x" class="btn-round">혜빈</button>
					<button id="btn-y" class="btn-round">범찬</button>
					<button id="btn-b" class="btn-round">승진</button>
					<button id="btn-a" class="btn-round">유승</button>
				</div>
				<button class="stick btn-round" id="stick-right">
					PlayEX</button>
			</div>
		</div>

		<div id="description">
			<p id="description-text"></p>
		</div>

		<!-- 게임 카드 -->
		<div class="game-cards">
			<div class="game-card">
				<div class="card-left">
					<div class="game-image"></div>
				</div>
				<div class="game-info">
					<h3 class="boss">애완토끼의 간을 찾아서 (별주부전)</h3>
					<p>애완토끼의 <span class="redboss">간</span>을 빼앗긴 혜빈찡....<br> <span class="redboss">용왕</span>을 만나러 가는데...</p>
				</div>
			</div>

			<div class="game-card reverse">
				<div class="card-left">
					<div class="game-image"></div>
				</div>
				<div class="game-info">
					<h3 class="bro">귀멸의 칼날:무한성편</h3>
					<p>짭지로는 <span class="bros">혈귀</span>의 본거지 무안성을 찾았다.<br><span class="bros">부하</span>들과 그들의 보스 <span class="bros">무잔</span>을 무찔러라!!!!</p>
				</div>
			</div>

			<div class="game-card">
				<div class="card-left">
					<div class="game-image">
    <img src="seungjin.png" alt="나뭇잎 마을 이타치" style="width:100%; height:100%; border-radius: 15px;">
</div>
				</div>
				<div class="game-info">
					<h3 class="seungjin" id="seungjin">☆탈주닌자 <span class="sj">이타치</span></span>☆</h3>
					<p class="seungjin">나뭇잎 마을을 탈주한 이타치.. 그를 향해 날아오는 적들의 표창을 피하라!!</p>
				</div>
			</div>

			<div class="game-card reverse">
				<div class="card-left">
					<div class="game-image"></div>
				</div>
				<div class="game-info">
					<h3 class="brother">Kaple Story</h3>
					<p class="kaple">궁지에 몰린 검은 마법사는 결국 금단의 지식에 손을댔고.... 그렇게 키메라를 만들어 내게 되는데...
					메이플 월드의 평화를 위해 키메라를 무찔러라!!!</p>
				</div>
			</div>

			<div class="play-btn-container">
				<button id="play-btn">즐기러 가기</button>
			</div>
		</div>
	</div>
	</div>

	<script>


$("#signup-btn").on("click", function(){ //회원가입 페이지이동
	window.location.href = "/signuppage.MembersController"; 
});

$("#login-btn").on("click", function(){ //로그인 페이지이동
	window.location.href = "/loginpgae.MembersController";
});

$("#play-btn").on("click", function(){ // 즐기러가기 버튼
	 $('html, body').animate({ scrollTop: 0 }, 300); // 300ms 동안 부드럽게 스크롤
});

</script>


<footer class="footer">
        <p>(주)자바 스프링 리액트로 완성하는 클라우드 활용 풀스택 개발 | 대표이사 조성태 | 주소 : 서울 관악구 봉천로 227 보라매샤르망 5층 한국정보교육원 | 전화 : 010-9006-2139 | Fax:02-856-9742</p>
        <p>E-mail : kyoungwon199@naver.com | 사업자 등록번호 : 202-506-09 | 개인정보보호책임자 : 김선경 (kyoungwon199@naver.com)</p>
        <p>&copy; 2025 Your Company. 한국정보교육원은 항상 여러분과 함께합니다.</p>
        <p>문의 : 010-9006-2139</p>
    </footer>
</body>
</html>