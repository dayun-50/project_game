<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>마이페이지</title>
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
            width: 550px;
            text-align: left;
            height: 550px;
        }

        /* ===== 페이지 제목 ===== */
        .page-title {
            font-size: 20px;
            font-weight: bold;
            color: #ff00ff;
            /* 기존 Welcome 색상 */
            text-shadow: 0 0 8px #ff00ff, 0 0 30px #ff00ff;
            /* 기존 스타일 */
            margin-top: 40px;
        }

        .page-title a {
            float: left;
            text-decoration: none;
            color: #ff00ff;
            text-shadow: 0 0 5px #ff00ff, 0 0 15px #ff00ff;
            margin-top: 10px;
        }

        h1 {
            margin-bottom: 5px;
            font-size: 50px;
            color: #ffffff;
            /* 민트 계열 */
            text-shadow:0 0 5px #00ffff;
            margin-top: 30px;
            margin-left: 15px;
        }

        h4 {
            margin-top: 10px;
            margin-left: 15px;

        }


        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            justify-content: center;
        }

        label {
            width: 120px;
            color: #00ffff;
            font-size: 18px;
            margin-top: 20px;
        }

        .agreement input[type="radio"] {
            transform: scale(0.5);
            /* 70% 크기로 축소 */
            margin-left: 70px;
        }


        .input {
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
            width: 25%;
            padding: 10px;
            margin-left: 20px;
            border: none;
            border-radius: 15px;
            background: linear-gradient(to right, #00ffff, #ff4fc6);
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            display: block;
        }

        #btn {
        	background: linear-gradient(to right, #678989, #304242);
            color: #0d0d1a;
            float: left;
            width: 25%;
            padding: 10px;
            margin-left: 150px;
            border: none;
            border-radius: 15px;
            font-size: 16px;
            cursor: pointer;
            display: block;
        }
	
		#btn2 {
        	background: linear-gradient(to right, #678989, #304242);
            color: #0d0d1a;
            float: left;
            width: 25%;
            padding: 10px;
            margin-left: 150px;
            border: none;
            border-radius: 15px;
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

        #btnbox {
            width: 100%;
            float: left;

        }

        #titlebox {
            display: flex;
            /* flex 적용 */
            flex-direction: column;
            /* 세로 정렬 */
            justify-content: center;
            /* 수직 중앙 정렬 */
            align-items: flex-start;
            /* 좌측 정렬 */
            background: linear-gradient(to right, #36ffff99, #ff4fc799);
            /* 조금 밝게 */
            height: 130px;
            border-radius: 10px 10px 0px 0px;
            padding-left: 15px;
            /* 왼쪽 여백 */
            
            margin-bottom: 20px;
        }

        #titlebox h1 {
            margin: 0;
            /* 기존 margin 제거 */
            font-size: 50px;
            color: #ffffff;
        }

        #titlebox h6 {
            margin: 5px 0 0 0;
            /* h1과 약간 띄우기 */
            font-size: 13px;
        }
        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            margin-bottom: 20px;
        }

        th{
            padding: 10px;
            font-size: 20px;
            color: #00ffff;
            border-bottom: 1px solid #00ffff;
        }
		.check-btn {
    background: linear-gradient(to right, #00ffff, #ff4fc6);
    color: #fff;
    border: none;
    border-radius: 15px;
    padding: 8px 15px;
    font-size: 14px;
    cursor: pointer;
    margin-left: 10px;
    transition: 0.3s;
}

.check-btn:hover {
    filter: brightness(1.2);
}

    </style>
</head>
<body>
   <div class="container">
        <div id="titlebox">
            <h1>${nickname }</h1>
            <h6>가입일 : ${date }</h6>
        </div>
        <table>
        <thead>
            <tr>
                <th>회원정보</th>
            </tr>
        </thead>
        </table>
        <form action="/signup.MembersController" method="post">
            <div class="form-group">
                <label for="id">ID</label>
                <div class="input" id="id">${id }</div>
            </div>

            

            <div class="form-group">
                <label for="name">Name</label>
                <div class="input" id="name">${name }</div>
                <div id="nametext"></div>
            </div>

            <div class="form-group">
                <label for="phone">Phone</label>
                <div class="input update" id="phone">${phone }</div>
                <div id="phonetext"></div>
            </div>


            <div class="form-group">
    <label for="email">E-mail</label>
    <div class="input update" id="email" contenteditable="true">${email}</div>
    <div id="emailtext" style="margin-top:5px; font-size:12px;"></div>
</div>

<div class="form-group">
    <label for="emailAuthCode">인증번호</label>
    <div class="input update" id="emailAuthCode" contenteditable="true"></div>
    <div id="emailAuthText" style="margin-top:5px; font-size:12px;"></div>
    <button type="button" class="check-btn" id="emailAuthBtn">발송</button>
    <button type="button" class="check-btn" id="verifyAuthBtn">확인</button>
</div>

            <div id="btnbox">

                <div class="page-title"><a href="/gamapage.GameController?id=${id }">혜빈이와 아이들</a></div>

                <div class="form-group" id="original">
                	<button type="button" id="btn">회원탈퇴</button>
                    <button type="button" class="btn-submit" id="btnup">정보수정</button>
                </div> 
                
                <div class="form-group" id="change" >
                	<button type="button" id="btn2">수정취소</button>
                    <button type="button" class="btn-submit" id="btnup2">수정완료</button>
                </div> 

            </div>
        </form>
    </div>

    <script>
		$("#change").hide();
        
		
		// 별 생성
        for (let i = 0; i < 200; i++) {
            const s = document.createElement('div'); s.className = 'star';
            s.style.top = Math.random() * 100 + 'vh';
            s.style.left = Math.random() * 100 + 'vw';
            s.style.animationDuration = (2 + Math.random() * 3) + 's';
            document.body.appendChild(s);
        }
		
       $("#btn").on("click", function(){ //회원탈퇴 버튼 클릭시
    	   let result = confirm("정말로 회원 탈퇴하시겠습니까?");
    	   
    	   if(result){
    		   alert("탈퇴 완료되셨습니다.");
    		   $.ajax({
       				url: "/secession.MembersController",
       				data: {
       				id:$("#id").text()
       				},
       				type: "post",
       				success: function(resp){
       				if(resp === "1"){
       					window.location.href = "/indexpage.MembersController";
       				}	
       			}
       		})  
    	   }
    	   
        });
		
		const nameRegex = /^[가-힣]{2,6}$/; 
        let nameValCheck = false;
        
        const phoneRegex = /^010-?[0-9]{4}-?[0-9]{4}$/;
        let phoneValCheck = false;
        
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/;
        let emailValCheck = false;
		let emailcerCheck = false;
        
        
        $("#btnup").on("click", function () { //정보수정 버튼 클릭시
        	$("#original").hide();
        	$("#change").show();
        	
        	$("#name, #phone, #email").attr("contenteditable", true).css({"background":"rgba(240, 255, 255, 0.208)"});
        });
        
        $("#name").on("input", function(){ // 이름 유효성검사
        	nameValCheck = false;
        	if(nameRegex.test($("#name").text())){
        		$("#nametext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		nameValCheck = true;
        	}else{
        		$("#nametext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("한글 2~6자리 이름 입력");
        	}
        });
        
        $("#phone").on("input", function(){ // 전화번호 유효성검사
        	phoneValCheck = false;
        	if(phoneRegex.test($("#phone").text())){
        		$("#phonetext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		phoneValCheck = true;
        	}else{
        		$("#phonetext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("010 이후 8자 숫자 입력.ex)010-1234-1234");	
        	}
        });
        
        $("#email").on("input", function(){ // e-mail 유효성검사
        	emailValCheck = false;
			emailcerCheck = false;
        	if(emailRegex.test($("#email").text())){
        		$("#emailtext").css({"color":"green", "font-size":"12px", "padding-top":"10px"}).html("규정에 일치합니다.");
        		emailValCheck = true;
        	}else{
        		$("#emailtext").css({"color":"red", "font-size":"12px", "padding-top":"10px"}).html("e-mail형식에 알맞게 입력");
        	}
        });

        $("#btnup2").on("click", function(e){ //수정 완료 클릭시
        	//유효성검사
        	if(nameValCheck === false || phoneValCheck === false || emailValCheck === false){
        		alert("모든 입력창에 정보를 알맞게 기입해주세요.");
        		e.preventDefault();
        		return;	
        	}
        	
        	//유효성 검사 통과시 div 입력속성 차단, 백그라운드컬러 원상복귀, 버튼도 original로 복구
        	$("#name, #phone, #email").attr("contenteditable", false).css({"background":"transparent"});	
        	$("#original").show();
        	$("#change").hide();
        	
        	//유효성 검사 설명 text 초기화
        	$("#nametext").html("");
        	$("#phonetext").html("");
        	$("#emailtext").html("");
        	
        	$.ajax({
        		url: "/update.MembersController",
        		data: {
        			name:$("#name").text(),
        			phone:$("#phone").text(),
        			email:$("#email").text()
        		},
        		type: "post",
        		success: function(resp){
        			if(resp === "1"){
        				window.location.href = "/mypage.MembersController";
        			}	
        		}
        	})
        });
        
        $("#btn2").on("click", function(){ //수정 취소시 페이지 재로딩으로 다시 원본내용 나오도록함
        	window.location.href = "/mypage.MembersController?id=${id }";
        });
		
        let serverAuthCode = ""; // 서버에서 받은 인증번호를 임시 저장

		// 1️⃣ 인증번호 발송
		$("#emailAuthBtn").on("click", function() {
		    const email = $("#email").text().trim();

		    // 이메일 형식 체크
		    if (!emailRegex.test(email)) {
		        alert("올바른 이메일을 입력해주세요.");
		        return;
		    }

		    // Ajax로 서버에 이메일 발송 요청
		    $.ajax({
		        url: "/sendEmailAuth.MembersController", // 실제 서버 경로
		        type: "POST",
		        data: { email: email, provider: "naver"},
		        success: function(authCode) {
		            // 서버에서 발송 후 인증번호를 반환하면 저장
		            serverAuthCode = authCode;
		            $("#emailAuthText").html("인증번호가 이메일로 발송되었습니다.").css("color", "green");
		        },
		        error: function() {
		            $("#emailAuthText").html("메일 전송 실패").css("color", "red");
		        }
		    });
		});

		// 2️⃣ 인증번호 확인
		$("#verifyAuthBtn").on("click", function() {
		    const inputCode = $("#emailAuthCode").text().trim();

		    if (!inputCode) {
		        alert("인증번호를 입력해주세요.");
		        return;
		    }

		    if (inputCode === serverAuthCode) {
		        $("#emailAuthText").html("인증 완료").css("color", "green");
		        emailValCheck = true; // 회원가입 버튼에서 유효성 검사에 사용
				emailcerCheck = true;
		    } else {
		        $("#emailAuthText").html("인증번호 불일치").css("color", "red");
		        emailValCheck = false;
		    }
		});


    </script>
</body>
</html>
