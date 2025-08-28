<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>닌텐도 스위치 - 커비 스타일 미래지향</title>

<!-- 구글 폰트 불러오기: Press Start 2P, 레트로 게임 느낌 -->
<link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
html, body {
    margin:0; padding:0; width:100%; height:100%;
    font-family: 'Press Start 2P', cursive;
    background: radial-gradient(circle at 50% 50%, #111 0%, #000022 100%);
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
}

.star, .shooting-star { position: fixed; z-index:0; border-radius:50%; }

.star {
    animation: twinkle linear infinite;
    background: white;
}
@keyframes twinkle {
    0%,100%{opacity:0.1}25%{opacity:0.6}50%{opacity:1}75%{opacity:0.4}
}

@keyframes shootingStar {
    0% { transform: translateY(-5vh) translateX(0) rotate(0deg); opacity: 1; }
    100% { transform: translateY(120vh) translateX(50px) rotate(45deg); opacity: 0; }
}

.shooting-star {
    width: 2px; height: 10px;
    background: white;
    animation: shootingStar linear forwards;
}

/* 스위치 */
.switch {
    width: 90vw;
    aspect-ratio: 600/280;
    background: linear-gradient(to bottom, #333,#111);
    border-radius:5vw;
    display:flex;
    position: relative;
    z-index:1;
    box-shadow:0 0 20px #000 inset, 0 0 30px #555;
}
.joycon-left, .joycon-right {
    width:23%;
    padding:3%;
    box-sizing:border-box;
    position:relative;
    border:2px solid #666;
}
.joycon-left {
    background: linear-gradient(145deg, #39c5bb, #1c8e85);
    border-top-left-radius:5vw;
    border-bottom-left-radius:5vw;
    box-shadow:3px 3px 8px #000 inset;
}
.joycon-right {
    background: linear-gradient(145deg, #ff5555, #cc2222);
    border-top-right-radius:5vw;
    border-bottom-right-radius:5vw;
    box-shadow:3px 3px 8px #000 inset;
}

/* 화면 */
.screen { flex-grow:1; background: linear-gradient(to bottom, #fffae5,#e0f7ff); margin:3% 1.5%; border-radius:2vw; position: relative; overflow: hidden; display:flex; justify-content:center; align-items:flex-end; box-shadow: inset 0 0 20px #fff5, 0 0 20px #000; font-size:20px; }

/* 버튼 */
.btn-round { background-color:#fff; border:3px solid #555; border-radius:50%; color:#222; cursor:pointer; box-shadow:2px 2px 0 #333; transition: transform 0.05s, box-shadow 0.05s; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:1.2vw; padding:0.5vw; z-index:1; }
.btn-round:active { transform: translate(2px,2px); box-shadow:none; }
.btn-round:focus{outline:none;}

.stick { width:10vw; height:6vw; position:absolute; border-radius:1.5vw; background: linear-gradient(135deg,#0ff,#08f); box-shadow:0 0 15px #0ff, inset 0 0 5px #08f; font-size:1.2vw; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; }
.joycon-left .stick { top:14%; left:21%; }
.joycon-right .stick { bottom:14%; right:21%; }

.dpad-joycon { --diameter:3.6vw; position:absolute; bottom:14%; left:18%; width:12vw; height:12vw; z-index:1; }
.dpad-joycon .btn-round { width:var(--diameter); height:var(--diameter); font-size:1vw; position:absolute; }
#dpad-up{top:0; left:50%; transform:translateX(-50%);}
#dpad-down{bottom:0; left:50%; transform:translateX(-50%);}
#dpad-left{left:0; top:50%; transform:translateY(-50%);}
#dpad-right{right:0; top:50%; transform:translateY(-50%);}

.buttons { position:absolute; top:14%; right:18%; display:grid; grid-template-columns:repeat(2,6vw); grid-template-rows:repeat(2,6vw); gap:1.5vw; z-index:1; }
.buttons button{ width:6vw; height:6vw; font-size:1.2vw; display:flex; align-items:center; justify-content:center; }

/* 튜토리얼 오버레이 */
#tutorial-overlay { position:fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index:20; }
#tutorial-close { position:absolute; top:10px; right:10px; font-size:2vw; background:transparent; border:none; color:white; cursor:pointer; }
.tutorial-item { position:absolute; color:white; font-size:2vw; cursor:default; display:flex; flex-direction:column-reverse; align-items:center; transform: translate(-50%, -100%); }
.tutorial-text { margin-top:0.5vw; font-size:1.5vw; background:rgba(0,0,0,0.6); padding:0.3vw 0.6vw; border-radius:0.5vw; text-align:center; }

</style>
</head>
<body>
<div class="switch">
    <div class="joycon-left">
        <button class="stick btn-round" id="stick-left">${nickname }</button>
        <div class="dpad-joycon">
            <button class="btn-round" id="dpad-up">▲</button>
            <button class="btn-round" id="dpad-left">◀</button>
            <button class="btn-round" id="dpad-right">▶</button>
            <button class="btn-round" id="dpad-down">▼</button>
        </div>
    </div>
    <div class="screen" id="screen"> 
    	<div id="mypage"><button id="mypage-btn">마이페이지</button></div>
    </div>
    <div class="joycon-right">
        <div class="buttons">
            <button id="btn-x" class="btn-round">Game1</button>
            <button id="btn-y" class="btn-round">Game2</button>
            <button id="btn-b" class="btn-round">Game3</button>
            <button id="btn-a" class="btn-round">Game4</button>
        </div>
        <button class="stick btn-round" id="stick-right">Menu</button>
    </div>
</div>

<div id="tutorial-overlay">
    <button id="tutorial-close">×</button>
    <div class="tutorial-item" data-target="stick-left">↓<div class="tutorial-text">여기에 닉네임 나온다 했었나</div></div>
    <div class="tutorial-item" data-target="stick-right">↓<div class="tutorial-text">아직 기능 미정</div></div>
    <div class="tutorial-item" data-target="dpad-up">↓<div class="tutorial-text">아직 기능 미정</div></div>
    <div class="tutorial-item" data-target="btn-x">↓<div class="tutorial-text">클릭하면 각 게임이 화면에 표시됩니다.</div></div>
</div>

<script>
$("#mypage").hide();
function createStars(count, topRange=[0,100], leftRange=[0,100], sizeRange=[1,3]){
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

function createShootingStar() {
    const star = document.createElement('div');
    star.className = 'shooting-star';
    star.style.left = Math.random()*100 + 'vw';
    star.style.animationDuration = (1 + Math.random()*1) + 's';
    document.body.appendChild(star);
    star.addEventListener('animationend', () => star.remove());
}

// 별 생성
createStars(800);
createStars(400,[20,50],[20,80],[1,2]);

// 일정 시간마다 별똥별 생성
setInterval(createShootingStar, 2000);

// 튜토리얼 위치
function updateTutorialPositions(){
    document.querySelectorAll('.tutorial-item').forEach(item=>{
        const targetId=item.getAttribute('data-target');
        const target=document.getElementById(targetId);
        if(target){
            const rect=target.getBoundingClientRect();
            item.style.left=(rect.left + rect.width/2)+'px';
            item.style.top=(rect.top)+'px';
        }
    });
}
updateTutorialPositions();
window.addEventListener('resize', updateTutorialPositions);

// 튜토리얼 닫기
document.getElementById('tutorial-close').addEventListener('click',()=>{ document.getElementById('tutorial-overlay').style.display='none'; });

$("#stick-right").on("click", function(){ //메뉴버튼
	$("#mypage").show();
});

$("#mypage-btn").on("click", function(){ //마이페이지 이동버튼
	window.location.href = "/mypage.MembersController?id=${id}"
});


</script>
</body>
</html>