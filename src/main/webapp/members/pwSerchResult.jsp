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
            background: linear-gradient(to right, #00ffff, #ff4fc6);
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            display: block;
		}

		#btn1{
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
        

<c:choose>
    <c:when test="${id == '0'}">
    	<div class="page-title">혜빈이와 아이들</div>
        <h1>검색하신 정보가 <br> 존재하지 않습니다.</h1>
        
        <div class="form-group">
        	<button type="button" class="btn-submit" id="main-btn">메인홈페이지</button>
        	<button id="btn1">로그인</button>
        </div>
    </c:when>
    <c:otherwise>
    <form action="/pwUpdate.MembersController" method="post">
    	<div class="page-title">혜빈이와 아이들</div>
        <h1>[ ${id } ] 계정<br> 비밀번호 변경</h1>
        <input type="hidden" name="id" value="${id}">
    	<div class="form-group">
            <label for="pw">PW</label>
            <div class="box">
            <input type="password" id="pw" name="pw" placeholder="변경하실 비밀번호 입력">
            <div id="pwtext"></div>
            </div>
        </div>

        <div class="form-group">
            <label for="pw-check">PW check</label>
            <div class="box">
            <input type="password" id="pw-check" placeholder="동일 비밀번호 입력">
            <div id="pw-checktext"></div>
            </div>
        </div>
        	
        <div class="form-group">
        	<button type="button" class="btn-submit" id="main-btn">메인홈페이지</button>
        	<button id="btn">변경완료</button>
        	
        </div>	
     	</form>
    </c:otherwise>
</c:choose>
      
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
       
       $("#main-btn").on("click", function(){ // 메인 홈페이지 이동
    	   window.location.href = "/indexpage.MembersController";
       });
       
       const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,12}$/;
       let check = false;
       
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
       		$("#pw-checktext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("입력하신 비밀번호와 일치합니다.");
       		check=true;
       	}else{
       		$("#pw-checktext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("입력하신 비밀번호와 일치하지 않습니다.");	
       		check=false;
       	}
       });

		$("btn1").on("click", function(){
			window.location.href = "/loginpgae.MembersController";
});

       
       $("#btn").on("click",function(){
    	   let pw = $("#pw").val();
           let pwcheck = $("#pw-check").val();
           if(pw==="" || pwcheck ==="" ){ //모든 정보가 입력되어야 통과
        	   alert("모든 정보를 입력해 주세요.");
			   e.preventDefault();
			   return;
           }
           
           if(check = false){ //모든 유효성 검사 통과시 통과
        	   alert("모든 입력창에 정보를 알맞게 기입해주세요.");
       		   e.preventDefault();
       		   return;
           }
       });
        
    </script>
</body>
</html>
