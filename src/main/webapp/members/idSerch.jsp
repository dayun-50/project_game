<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>
<style>
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
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 1;
  }
}
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

    h1 {
    	text-align: center;
        font-size: 50px;
        margin-bottom: 50px;
        margin-top: 15px;
        color: #00fff7;
        text-shadow: 0 0 5px #00fff7, 0 0 15px #00fff7;
    }

    form {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    label {
        text-align: left;
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #00ffff;
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
            width: 500px;
            height: 33px;
            margin-bottom: 10px; 
    }

    input::placeholder {
        color: #aaa;
    }

    .btn-submit {
        	float:left;
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

		#btn{
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

    button:hover {
        box-shadow: 0 0 25px #ff6ec7;
        transform: scale(1.05);
    }
    
    #butbox{
    width:  100%;
    	float:left;
    	display: flex;
        align-items: center;
        margin-bottom: 10px;
    }
    
    h4{
      text-align: center;
      margin-bottom: 5px; 
    }
        
    h4 a{
      text-align: center;
      text-decoration: none;
      color: #ffffff;
      text-shadow: 0 0 5px #ff00ff, 0 0 15px #ff00ff;
    }
</style>
</head>
<body>

	<div class="container">
	<h4><a href="/indexpage.MembersController">혜빈이와 아이들</a></h4>
    <h1>아이디 찾기</h1>
    <form action="/idSerch.MembersController" method="post">
        <div>
            <label for="name">이름</label>
            <input type="text" id="name" name="name" placeholder="이름 입력">
        </div>
        <div>
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" placeholder="이메일 입력">
        </div>
        <div>
            <label for="phone">전화번호</label>
            <input type="text" id="phone" name="phone" placeholder="전화번호 입력">
        </div>
        
        <div id="butbox">
        	<button id="serch-btn" class="btn-submit">아이디 찾기</button>
        	<button id="btn" type="button" class="btn-submit">로그인</button>
        </div>
      </form> 
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

		let nameText = false;
		let emailText = false;
		let phoneText = false;


		$("#btn").on("click", function(){ // 로그인 페이지로 이동
        	window.location.href = "/loginpgae.MembersController";
        });

		$("#name").on("input", function(){
			nameText=true;
		});
		$("#email").on("input", function(){
			emailText=true;
		});

		$("#phone").on("input", function(){
			phoneText=true;
		});



		$("#serch-btn").on("click", function(e){ //null값인 경우 폼 차단
			let name = $("#name").val();
			let email = $("#email").val();
			let phone = $("#phone").val();
			
			if(name==="" || email ==="" || phone === ""){
				alert("모든 정보를 입력해 주세요.");
				e.preventDefault();
				return;
			}

			if(nameText === false || emailText === false || phoneText === false){
				alert("모든 정보를 입력해 주세요.");
				e.preventDefault();
				return;
			}

		});
		
	</script>
</body>
</html>
