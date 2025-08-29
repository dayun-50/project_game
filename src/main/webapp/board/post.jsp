<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<title>Document</title>
<!-- TOAST UI Editor CDN -->
	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<!-- 한국어 패치 -->
	<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
	<!-- TOAST UI Editor CSS -->
	<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

	<style>
		* {
			box-sizing: border-box;
		}

		.con {
			border: 1px solid black;
			width: 90%;         /* 브라우저 너비의 90% */
  			max-width: 1000px;  /* 너무 커지지 않도록 최대 제한 */
 			margin: auto;  
		}

		#editor {
			width: 100%;
			height: 60vh;      /* 브라우저 높이에 비례 */
			margin: auto;
		}

		#postname {
			height: 50px;
			width: 100%;
			display: flex;
			justify-content: start;
			align-items: center;
			background-color: #dad9d9;
			border-radius: 5px;
			font-size: 20px;
			margin: auto;
			color:#000000;
		}

		/* 내용이 없을 때만 표시 */
		#postname:empty::before {
			content: "제목을 입력하세요";
			color: #9b9b9b;
			pointer-events: none;
			/* 클릭해도 텍스트가 선택되지 않게 */
		}
		/*여기부터 전체테마 ccs*/
		body {
			/* <body> 전체 스타일 */
			background-color: #0c0c1a;
			color: #fff;
			font-family: 'Arial', sans-serif;
			display: flex;
			justify-content: center;
			padding-top: 50px;
		}

		.star,
		.shooting-star {
			position: fixed;
			z-index: 0;
			border-radius: 50%;
		}

		.star {
			animation: twinkle linear infinite;
			background: white;
		}

		@keyframes twinkle {

			0%,
			100% {
				opacity: 0.1
			}

			25% {
				opacity: 0.6
			}

			50% {
				opacity: 1
			}

			75% {
				opacity: 0.4
			}
		}

		.shooting-star {
			width: 2px;
			height: 10px;
			background: white;
			animation: shootingStar linear forwards;
		}

		@keyframes shootingStar {
			0% {
				transform: translateY(-5vh) translateX(0) rotate(0deg);
				opacity: 1;
			}

			100% {
				transform: translateY(120vh) translateX(50px) rotate(45deg);
				opacity: 0;
			}
		}
		/*여기까지 전체테마 ccs*/
		
		#line{
		border: 1px solid #dad9d9;
		margin-bottom: 30px;	
		}
		h1{
		witdh: 100%;
		height: 100%;
		display: flex;
		justify-content: center;
		align-items: center;
		}
		h2{
		witdh: 100%;
		height: 100%;
		}
		#logo{
		width:100px;
		height: 100px;
		}
		#postdone{
		width: 100px;
		height: 50px;
		font-weight: bold;
		color: #fff;
		background: linear-gradient(135deg, #9b59b6, #e91e63);
		border: none;
        border-radius: 10px;
        cursor: pointer;
		box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
		transition: transform 0.2s, box-shadow 0.2s;
		}
		#cancel{
		width: 100px;
		height: 50px;
		font-weight: bold;
		color: #fff;
		background: linear-gradient(135deg, #9b59b6, #e91e63);
		border: none;
        border-radius: 10px;
        cursor: pointer;
		box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
		transition: transform 0.2s, box-shadow 0.2s;
		}
		.btns{
		display: flex;
		justify-content: end;
		flex-direction: column;
		witdh: 100%;
		margin-top: 10px;
		
		}
		#btnform{
		display: flex;
		justify-content: end;
		width: 100%;
		}
		form{
		width: 100px;
		height: 30px;
		font-weight: bold;
		}
		
	
	</style>
</head>

<body>
	<div class="con">
	<h1><img src="/board/로고.png" id="logo"> 혜빈이와 아이들 </h1>
	<h2>게시판 글쓰기</h2>
	
	<div id="line"></div>
	
		<div id="postname" contenteditable="true"></div>
			
		<div id="editor"></div>
	
	<div class="btns">
	<form action="/postdone.free" method="post" id="btnform">
	<button id="postdone">작성완료</button>
	<button id="cancel">취소</button>
</form>
</div>
 
	</div>


	<script>
	
	
		const editor = new toastui.Editor({
			el: document.querySelector('#editor'),
			height: '500px',
			initialEditType: 'wysiwyg',
			previewStyle: 'vertical',
			language: 'ko-KR', // 한국어 적용
			placeholder: '내용을 입력하세요'
		});

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
	</script>
</body>
</html>