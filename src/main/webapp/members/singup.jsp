<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>회원가입</title>
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
            font-size: 14px;
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
        
        #id{
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
        
        #nickname{
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
            background: linear-gradient(to right, #678989, #304242);
            color: #0d0d1a;
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
 <div class="container">
        <div class="page-title">혜빈이와 아이들</div>
        <h1>회원가입</h1>

	<form action="/signup.MembersController" method="post">
        <div class="form-group">
            <label for="id">ID</label>
            <div class="box">
            <input type="text" id="id" name="id">
            <div id="idtext"></div>
            </div>
            <button type="button" class="check-btn" id="idcheck">중복확인</button>
        </div>

        <div class="form-group">
            <label for="pw">PW</label>
            <div class="box">
            <input type="password" id="pw" name="pw">
            <div id="pwtext"></div>
            </div>
        </div>

        <div class="form-group">
            <label for="pw-check">PW check</label>
            <div class="box">
            <input type="password" id="pw-check">
            <div id="pw-checktext"></div>
            </div>
        </div>

        <div class="form-group">
            <label for="nickname">NickName</label>
            <div class="box">
            <input type="text" id="nickname" name="nickname">
            <div id="nicknametext"></div>
            </div>
            <button type="button" class="check-btn" id="nicknamecheck">중복확인</button>
        </div>

        <div class="form-group">
            <label for="name">Name</label>
            <div class="box">
            <input type="text" id="name" name="name">
            <div id="nametext"></div>
            </div>
        </div>

        <div class="form-group">
            <label for="phone">Phone</label>
            <div class="box">
            <input type="text" id="phone" name="phone">
            <div id="phonetext"></div>
            </div>
        </div>


        <div class="form-group">
            <label for="email">E-mail</label>
            <div class="box">
            <input type="email" id="email" name="email">
            <div id="emailtext"></div>
            </div>
        </div>

        <div class="agreement">
            <input type="radio" name="agree" id="agree-yes" value="Y" class="radio"><label for="agree-yes">동의합니다.</label>
            <input type="radio" name="agree" id="agree-no" value="N" class="radio"><label for="agree-no">동의하지 않습니다.</label>
        </div>

		<div class="form-group">
        	<button class="btn-submit">가입완료</button>
        	<button type="button" id="btn">뒤로가기</button>
        </div>
        </form>
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
        
        let check = false; //유효성 검사 전부 통과시에만 페이지넘어가게 false걸어둠
        let check2 = false; //아이디, 닉네임 중복검사
        const idRegex = /^[a-z0-9]{6,12}$/;
        const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,12}$/;
        const nicknameRegex = /^[a-zA-Z가-힣0-9]{4,12}$/;
        const nameRegex = /^[가-힣]{2,6}$/; 
        const phoneRegex = /^010-?[0-9]{4}-?[0-9]{4}$/;
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/;
        
        $("#id").on("input", function(){ // id 유효성검사
        	check2 = false;
        	if(idRegex.test($("#id").val())){
        		$("#idtext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#idtext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("영문 소문자, 숫자 조합 6~12자리 입력");
        		check = false;
        	}
        });
        
        $("#idcheck").on("click", function(){ // id 중복확인
        	$.ajax({
        		url:"/idCheck.MembersController",
				data:{id:$("#id").val()},
				type: "POST",
				success:function(reps){
					if(reps == "true"){
						alert("사용중인 ID입니다.");
						$("#id").val("");
						check2 = false;
					}else if(reps == "false"){
						alert("사용가능한 ID입니다.");
						check2 = true;
					}
				}
			});
        });
        
        $("#pw").on("input", function(){ // pw 유효성검사
        	if(pwRegex.test($("#pw").val())){
        		$("#pwtext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#pwtext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("영문 대소문자,숫자,특수문자 1개이상 8~12자리 입력");
        		check = false;
        	}
        });
        
        $("#pw-check, #pw").on("input", function(){ // pw 재확인
        	let pw = $("#pw").val();
        	let pwcheck = $("#pw-check").val();
        	if(pw === pwcheck){
        		$("#pw-checktext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("입력하신 비밀번호와 일치하지합니다.");
        		check=true;
        	}else{
        		$("#pw-checktext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("입력하신 비밀번호와 일치하지 않습니다.");	
        		check=false;
        	}
        });
        
        $("#nickname").on("input", function(){ // 닉네임 유효성검사
        	check2 = false;
        	if(nicknameRegex.test($("#nickname").val())){
        		$("#nicknametext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#nicknametext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("영문,한글,숫자 4~12자 입력");
        		check = false;
        	}
        });
        
        $("#nicknamecheck").on("click", function(){ // 닉네임 중복검사
            	$.ajax({
            		url:"/nicknameCheck.MembersController",
    				data:{nickname:$("#nickname").val()},
    				type: "POST",
    				success:function(reps){
    					if(reps == "true"){
    						alert("사용중인 닉네임입니다.");
    						check2 = false;
    					}else if(reps == "false"){
    						alert("사용가능한 닉네임입니다.");
    						check2 = true;
    					}
    				}
    			});
        });
        
        $("#name").on("input", function(){ // 이름 유효성검사
        	if(nameRegex.test($("#name").val())){
        		$("#nametext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#nametext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("한글 2~6자리 이름 입력");
        		check = false;
        	}
        });
        
        $("#phone").on("input", function(){ // 전화번호 유효성검사
        	if(phoneRegex.test($("#phone").val())){
        		$("#phonetext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#phonetext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("010 이후 8자 숫자 입력.ex)010-1234-1234");
        		check = false;
        	}
        });
        
        $("#email").on("input", function(){ // e-mail 유효성검사
        	if(emailRegex.test($("#email").val())){
        		$("#emailtext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		check = true;
        	}else{
        		$("#emailtext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("e-mail형식에 알맞게 입력");
        		check = false;
        	}
        });
        
        
        $(".btn-submit").on("click", function(e){ // 회원가입완료 버튼 누를시 개인정보동의, 모든유효성 검사 통과시 가입완료
        	let radio = $(".radio:checked").val();
        
        	if(check === false){
        		alert("모든 입력창에 정보를 알맞게 기입해주세요.");
        		e.preventDefault();
        		return;
        	}
        	
        	if(check2 === false){
        		alert("ID, 닉네임 중복검사는 필수사항입니다.");
        		e.preventDefault();
        		return;
        	}
        	
        	if(radio === "N"){
        		alert("개인정보 비동의시 가입이 불가합니다.");
        		e.preventDefault();
        	}
        	
        });
        
        $("#btn").on("click", function(){ // 뒤로가기버튼 메인홈페이지로 이동
        	 if (document.referrer) { // 이전 페이지가 존재하면
        	        history.back();
        	    } else {
        	        window.location.href = "/indexpage.MembersController"; // 이전 페이지가 없으면 홈으로
        	    }
        });
        
    </script>
</body>
</html>