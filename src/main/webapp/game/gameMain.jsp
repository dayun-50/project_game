<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>닌텐도 스위치 - 커비 스타일 미래지향</title>

<!-- 구글 폰트 불러오기: Press Start 2P, 레트로 게임 느낌 -->
<link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">

<style>
/* ============================
   기본 HTML/Body 스타일
   ============================ */
body {
  margin:0; 
  padding:0; 
  width:100%; 
  height:100%;
  font-family:'Press Start 2P', cursive; /* 레트로 게임 폰트 */
  overflow-y: auto; /* 세로 스크롤 가능 */
  display:flex; 
  flex-direction:column; 
  align-items:center; 
  justify-content:flex-start;
  background: radial-gradient(circle at 50% 50%, #0ff, #003366); /* 중심이 밝은 블루, 외곽 진한 블루 */
  position: relative;
}

/* ============================
   별 배경 (움직이는 별)
   ============================ */
.star {
  position: absolute; 
  width:6px; 
  height:6px; 
  background:yellow; 
  border-radius:50%; /* 원 모양 */
  animation: starMove linear infinite; /* 애니메이션 적용 */
  z-index:0; /* 다른 요소 뒤 */
}
/* 별이 아래로 움직이면서 약간 오른쪽 이동 */
@keyframes starMove {
  0% { transform: translateY(-10px) translateX(0) }
  100% { transform: translateY(110vh) translateX(20px) }
}

/* ============================
   점프 블록 (배경 애니메이션)
   ============================ */
.background-block {
  position:absolute; 
  width:20px; 
  height:20px;
  background:#ff5555; 
  border:2px solid #fff; 
  animation:blockMove linear infinite alternate; /* 위아래 반복 */
  z-index:0; 
  filter: drop-shadow(1px 1px 1px #aaa); /* 그림자 */
}
@keyframes blockMove {
  0% { transform: translateY(0) }
  100% { transform: translateY(-20px) }
}

/* ============================
   닌텐도 스위치 본체 컨테이너
   ============================ */
.switch {
  width:90vw; 
  aspect-ratio:600/280; /* 비율 유지 */
  background: linear-gradient(to bottom, #333 0%, #111 100%); /* 화면 테두리 느낌 */
  border-radius:5vw; 
  display:flex; 
  box-shadow:0 0 20px #000 inset, 0 0 30px #555; /* 입체감 */
  position:relative; 
  margin-top:5vh; 
  z-index:1;
}

/* ============================
   Joy-Con 좌우 컨트롤러
   ============================ */
.joycon-left,.joycon-right {
  width:23%; 
  padding:3%; 
  box-sizing:border-box; 
  position:relative; 
  z-index:1;
  border:2px solid #666;
}

/* 좌측 Joy-Con 스타일 */
.joycon-left {
  background: linear-gradient(145deg,#39c5bb,#1c8e85);
  border-top-left-radius:5vw; 
  border-bottom-left-radius:5vw;
  box-shadow:3px 3px 8px #000 inset;
}

/* 우측 Joy-Con 스타일 */
.joycon-right {
  background: linear-gradient(145deg,#ff5555,#cc2222);
  border-top-right-radius:5vw; 
  border-bottom-right-radius:5vw;
  box-shadow:3px 3px 8px #000 inset;
}

/* ============================
   스위치 화면
   ============================ */
.screen {
  flex-grow:1; /* 가능한 공간 차지 */
  background: linear-gradient(to bottom, #fffae5, #e0f7ff); /* 화면 안 배경 */
  margin:3% 1.5%; 
  border-radius:2vw;
  box-shadow: inset 0 0 20px #fff5, 0 0 20px #000; /* 안쪽, 바깥쪽 그림자 */
  display:flex; 
  justify-content:center; 
  align-items:flex-end; /* Kirby 아래 배치 */
  position:relative; 
  overflow:hidden;
}

/* ============================
   커비 픽셀 캐릭터 애니메이션
   ============================ */
.kirby {
  position:absolute; 
  bottom:10%; 
  left:20%; 
  width:32px; 
  height:32px;
  background: #ff66cc; 
  border-radius:50%; /* 원 */
  box-shadow: inset -4px -4px 0 #ff99cc, inset 4px 4px 0 #ff3399; /* 간단한 입체감 */
  animation: kirbyJump 1.2s ease-in-out infinite alternate;
  z-index:2; /* Joy-Con 위 */
}
@keyframes kirbyJump {
  0% { transform: translateY(0) }
  50% { transform: translateY(-20px) } /* 점프 */
  100% { transform: translateY(0) }
}

/* ============================
   둥근 버튼 스타일
   ============================ */
.btn-round {
  background-color:#fff; 
  border:3px solid #555; 
  border-radius:50%; 
  color:#222;
  cursor:pointer; 
  box-shadow:2px 2px 0 #333; 
  transition: transform 0.05s, box-shadow 0.05s;
  display:flex; 
  align-items:center; 
  justify-content:center; 
  font-weight:bold; 
  z-index:1;
  overflow:visible; 
  text-align:center; 
  white-space:nowrap;
  font-size:1.2vw; 
  padding:0.5vw;
}
.btn-round:active { transform:translate(2px,2px); box-shadow:none; }
.btn-round:focus { outline:none; }

/* ============================
   스틱 컨트롤러 (Joy-Con)
   ============================ */
.stick {
  width:10vw;
  height:6vw;
  position:absolute;
  border-radius:1.5vw;
  background: linear-gradient(135deg, #0ff, #08f); /* 미래지향 블루톤 그라디언트 */
  box-shadow: 0 0 15px #0ff, inset 0 0 5px #08f; /* 네온 느낌 */
  font-size:1.2vw;
  display:flex;
  align-items:center;
  justify-content:center;
  text-align:center;
  color:white;
  font-weight:bold;
}
.stick:hover {
  box-shadow: 0 0 25px #0ff, inset 0 0 10px #08f;
  transform: translateY(-2px);
}
/* 위치 지정 */
.joycon-left .stick { top:14%; left:21%; }
.joycon-right .stick { bottom:14%; right:21%; }

/* ============================
   좌측 D-Pad (방향 버튼)
   ============================ */
.dpad-joycon { 
  --diameter:3.6vw; 
  --gap:2.2vw; 
  position:absolute; 
  bottom:14%; 
  left:18%;
  display:grid; 
  grid-template-columns: var(--diameter) var(--gap) var(--diameter);
  grid-template-rows: var(--diameter) var(--gap) var(--diameter);
  width:calc(var(--diameter)*3 + var(--gap)*2); 
  height:calc(var(--diameter)*3 + var(--gap)*2);
  place-items:center; 
  z-index:1;
}
.dpad-joycon .btn-round { width: var(--diameter); height: var(--diameter); font-size:1vw; }
/* 버튼 위치 지정 */
#dpad-up { grid-column:2; grid-row:1; }
#dpad-down { grid-column:2; grid-row:3; }
#dpad-left { grid-column:1; grid-row:2; }
#dpad-right { grid-column:3; grid-row:2; }

/* ============================
   우측 버튼 배열
   ============================ */
.buttons { 
  position:absolute; 
  top:14%; 
  right:18%; 
  display:grid; 
  grid-template-columns:repeat(2,6vw); 
  grid-template-rows:repeat(2,6vw); 
  gap:1.5vw; 
  z-index:1; 
}
.buttons button { 
  width:6vw; 
  height:6vw; 
  font-size:1.2vw; 
  display:flex; 
  align-items:center; 
  justify-content:center; 
  text-align:center; 
  word-break:break-word; 
  padding:0.3vw; 
  box-sizing:border-box; 
  overflow:visible; 
}

/* ============================
   설명창 스타일 (타자기 효과)
   ============================ */
#description {
  max-width: 90vw;
  background: linear-gradient(135deg, #9b59b6, #e91e63); /* 보라→핑크 */
  border-radius: 1vw;
  padding: 2vw;
  box-shadow: 0 0 20px #e91e63, inset 0 0 10px #9b59b6; /* 네온 느낌 */
  transform: translateY(-20px);
  opacity: 0; /* 초기 숨김 */
  transition: all 0.4s ease;
  margin-top: 2vh;
  font-size: 1.8vw;
  line-height: 1.6;
  color: #fff;
  text-shadow: 1px 1px 2px #9b59b6;
  letter-spacing: 0.05em;
  font-family: 'Press Start 2P', cursive;
  white-space: pre-wrap;
  z-index: 3;
}
#description.show { transform: translateY(0); opacity: 1; }
</style>
</head>
<body>
<!-- ============================
     별과 블록 생성 컨테이너
     ============================ -->
<div id="stars"></div>
<div id="blocks"></div>

<!-- ============================
     닌텐도 스위치 본체
     ============================ -->
<div class="switch">

  <!-- 좌측 Joy-Con -->
  <div class="joycon-left">
    <button class="stick btn-round" id="stick-left">◉</button>

    <!-- D-Pad 방향 버튼 -->
    <div class="dpad-joycon">
      <button class="btn-round" id="dpad-up">▲</button>
      <button class="btn-round" id="dpad-left">◀</button>
      <button class="btn-round" id="dpad-right">▶</button>
      <button class="btn-round" id="dpad-down">▼</button>
    </div>
  </div>

  <!-- 중앙 화면 -->
  <div class="screen" id="screen">INSERT COIN
    <div class="kirby" id="kirby"></div> <!-- Kirby 캐릭터 -->
  </div>

  <!-- 우측 Joy-Con -->
  <div class="joycon-right">
    <div class="buttons">
      <button id="btn-x" class="btn-round">혜빈</button>
      <button id="btn-y" class="btn-round">범판</button>
      <button id="btn-b" class="btn-round">승진</button>
      <button id="btn-a" class="btn-round">유승</button>
    </div>
    <button class="stick btn-round" id="stick-right">Login</button>
  </div>
</div>

<!-- 설명창 -->
<div id="description"><p id="description-text"></p></div>

<script>
// ============================
// 별 생성
// ============================
for(let i=0;i<50;i++){
  const s=document.createElement('div'); 
  s.className='star';
  s.style.top=Math.random()*100+'vh';
  s.style.left=Math.random()*100+'vw';
  s.style.animationDuration=(5+Math.random()*10)+'s'; // 각기 다른 속도
  document.body.appendChild(s);
}

// ============================
// 배경 블록 생성
// ============================
for(let i=0;i<30;i++){
  const b=document.createElement('div'); 
  b.className='background-block';
  b.style.bottom=Math.random()*50+'vh';
  b.style.left=Math.random()*100+'vw';
  b.style.animationDuration=(1+Math.random()*2)+'s';
  document.body.appendChild(b);
}

// ============================
// 오른쪽 스틱 클릭 시 설명창 타자기 효과
// ============================
const fullText = `혜빈이와 아이들의 프로젝트에 오신 여러분을 환영합니다.`;
const description = document.getElementById("description");
const descText = document.getElementById("description-text");

document.getElementById("stick-right").addEventListener("click", () => {
  description.classList.toggle("show"); // 설명창 보이기/숨기기
  if(description.classList.contains("show")) {
    descText.textContent="";
    let i=0;
    function typeWriter(){
      if(i<fullText.length){
        descText.textContent+=fullText.charAt(i); 
        i++;
        setTimeout(typeWriter,15); // 한 글자씩 15ms 간격
      }
    }
    typeWriter();
  }
});
</script>
</body>
</html>