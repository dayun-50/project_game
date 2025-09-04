<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<!-- jQuery -->
<style>
        body {
            background-color: #0c0c1a;
            color: #fff;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            padding-top: 50px;
            overflow-x: hidden;
        }
        
         #editor {
            width: 100%;
            height: 60vh;
            /* 브라우저 높이에 비례 */
            margin: auto;
        }
        

        .container {
            width: 50%;
            background: rgba(20, 20, 40, 0.95);
            border-radius: 12px;
            padding: 30px 40px;
            box-shadow: 0 0 20px rgba(180, 180, 255, 0.5);
            color: #fff;
            position: relative;
            z-index: 1;
        }

        h2 {
            color: #ff9800;
            font-size: 2em;
            margin-bottom: 20px;
            border-bottom: 1px solid #3c3c5c;
            padding-bottom: 10px;
        }

        .meta-info {
            color: #b276d1;
            margin-bottom: 20px;
        }

        .pre {
            background: rgba(50, 50, 80, 0.8);
            border: 1px solid #5e72be;
            border-radius: 10px;
            padding: 20px;
            color: #e0e8ff;
            white-space: pre-wrap;
        }

        .btn-back,
        .btn-edit,
        .btn-delete {
            margin-top: 20px;
            padding: 10px 25px;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            color: #fff;
            background: linear-gradient(135deg, #9b59b6, #e91e63);
            box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-right: 10px;
        }

        .btn-back:hover,
        .btn-edit:hover,
        .btn-delete:hover {
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

        .comment-section {
            margin-top: 30px;
            border-top: 1px solid #3c3c5c;
            padding-top: 20px;
        }

        .comment-list {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
        }

        .comment-item {
            border-bottom: 1px solid #3c1f5c;
            padding: 10px 0;
        }

        .comment-meta {
            font-size: 0.9em;
            color: #b276d1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .comment-contents {
            color: #e0e8ff;
        }

        .comment-actions button {
            background: none;
            border: none;
            color: #87CEEB;
            cursor: pointer;
            font-weight: 600;
            padding: 0;
            margin: 0 5px;
        }

        .comment-actions button:hover {
            text-decoration: underline;
        }

        .comment-form textarea {
            width: 100%;
            height: 80px;
            border-radius: 8px;
            border: 1px solid #5e72be;
            padding: 10px;
            background: rgba(30, 30, 60, 0.8);
            color: #fff;
            font-family: 'Arial', sans-serif;
        }

        .comment-form button {
            margin-top: 10px;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            font-weight: bold;
            background: linear-gradient(135deg, #9b59b6, #e91e63);
            color: #fff;
            cursor: pointer;
            box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
        }

        .comment-form button:hover {
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

        /* 별 효과 */
        .star,
        .shooting-star {
            position: fixed;
            z-index: 0;
            border-radius: 50%;
        }

        .star {
            width: 2px;
            height: 2px;
            background: white;
            animation: twinkle linear infinite;
        }

        @keyframes twinkle {
            0%,
            100% {
                opacity: 0.1;
            }

            25% {
                opacity: 0.6;
            }

            50% {
                opacity: 1;
            }

            75% {
                opacity: 0.4;
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
    </style>
</head>
<body>
<div class="container">
        <h2>${list[0].gameboardtitle }</h2>
        <div class="meta-info">
            <span>작성자: <strong>${list[0].gamewrtier }</strong></span> &nbsp;|&nbsp;
            <span>작성일: ${list[0].game_board_date }</span> &nbsp;|&nbsp;
            <span>조회수: ${viewCount }</span>
        </div>

        <div class="pre" id="textbox">
			${list[0].gamecoment }
        </div>
	<form action="/game1BoradInsert.Game1Controller" method="post" id="btnform">
		
		<div id="box">
    	<div id="postname" contenteditable="true"></div>
    	<div id="editor"></div>


		<input type="hidden" name="title" id="postnameInput">
  		<input type="hidden" name="coment" id="editorInput">
  		<input type="hidden" name="gameid" value="${gameid }">
    
		</div>
		
        <button class="btn-back" id="backList" type="button">목록으로</button>
      	<c:choose>
   			 <c:when test="${result == 1}">
   			 	<input type="hidden" id="seq" name="seq" value="${list[0].game_seq }">
        		<button class="btn-edit" id="updtn" type="button">수정하기</button>
       			 <button class="btn-delete" id="dlebtn" type="button">삭제하기</button>
       			 
       			<button class="btn-edit" id="complebtn">수정완료</button>
       			 <button class="btn-delete" id="backbtn" type="button">수정취소</button>
   			 </c:when>
		</c:choose>
      </form>  
    
       
        

        <div class="comment-section">
            <h4>댓글 <small>(${comentCount })</small></h4>
		
            <div class="comment-list">
            <c:forEach var="Cdto" items="${comentList}">
                <div class="comment-item">
                    <div class="comment-meta">
                        <div>${Cdto.game_coment_writer } | ${Cdto.game_coment_date }</div>
                       
                       <c:choose>
   			 				<c:when test="${nickname eq Cdto.game_coment_writer}">
   			 				<div class="comment-actions">
                            <button class="comentupbtn">수정</button>
                            <button class="comentdlebtn">삭제</button>
                            
                            <button class="comentcomplbtn">완료</button>
                            <button class="comentbackbtn">취소</button>
                           <input type="hidden" class="comentseq" value="${Cdto.game_comet_seq }">
                        	</div>
   			 				
   			 				</c:when>
   			 			</c:choose>
                       
                        
                    </div>
                    <div class="comment-contents">${Cdto.game_coment }</div>
                </div>
           </c:forEach>
            </div>

            <form class="comment-form" action="/comentInsert.GameComentController" method="post">
				<input type="hidden" name="seq" value="${list[0].game_seq }">
                <textarea placeholder="댓글을 입력하세요..." name="coment" required></textarea>
                <button type="submit">댓글 등록</button>
            </form>
        </div>
    </div>

    <script>
        // 랜덤 별 생성
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

        // 별똥별 생성
        function createShootingStar() {
            const star = document.createElement('div');
            star.className = 'shooting-star';
            star.style.left = Math.random() * 100 + 'vw';
            star.style.animationDuration = (1 + Math.random() * 1) + 's';
            document.body.appendChild(star);
            star.addEventListener('animationend', () => star.remove());
        }

        createStars(500);
        setInterval(createShootingStar, 2000);
        
        const editor = new toastui.Editor({
            el: document.querySelector('#editor'),
            height: '500px',
            initialEditType: 'wysiwyg',
            previewStyle: 'vertical',
            language: 'ko-KR',
            placeholder: '내용을 입력하세요',
            hooks: {
                addImageBlobHook: function(blob, callback) {
                    const reader = new FileReader();
                    reader.onloadend = function() {
                        const base64data = reader.result;
                        callback(base64data, '이미지'); // Base64 이미지 삽입
                    }
                    reader.readAsDataURL(blob);
                    return false; // 서버 업로드 방지, 로컬 Base64 삽입
                }
            }
        });
        
        
        $("#backList").on("click", function (){ //목록으로
        	window.location.href = "/game1borad.Game1Controller"
        });
        
        
        $("#dlebtn").on("click", function (){ //글삭제
        	 let result = confirm("정말로 삭제하시겠습니까?");
      	   
      	   if(result){
      		   alert("게시물 삭제가 완료되셨습니다.");
      		   $.ajax({
         				url: "/delete.Game1Controller",
         				data: {
         				seq:$("#seq").val()
         				},
         				type: "post",
         				dataType: "json",
         				success: function(resp){
         				if(resp == 1){
         					window.location.href = "/game1borad.Game1Controller";
         				}	
         			}
         		})  
      	   }
        });
        
        $(".comentdlebtn").on("click", function(){ //댓글삭제
        	 let result = confirm("댓글을 삭제하시겠습니까?");
        	   
        	   if(result){
        		   alert("댓글 삭제가 완료되셨습니다.");
        		   $.ajax({
           				url: "/delete.GameComentController",
           				data: {
           				seq:$(this).siblings(".comentseq").val()
           				},
           				type: "post",
           				dataType: "json",
           				success: function(resp){
           				if(resp == 1){
           					window.location.href = "/game1boradDetil.Game1Controller?seq=${list[0].game_seq }";
           				}	
           			}
           		})  
        	   }
        });
        
        $("#complebtn, #backbtn, #box").hide(); //글 수정완료/수정취소 버튼
        
        $("#updtn").on("click", function(){ //글 수정버튼 클릭시
        	$("#complebtn, #backbtn, #box").show();
        	$("#updtn, #dlebtn").hide();
        	
        	$("#textbox").hide(); 
        	
        	
        });
         
        $("#backbtn").on("click", function(){ //글 수정취소 버튼
        	$("#complebtn, #backbtn").hide();
        	$("#updtn, #dlebtn").show();
        	
        	$("#textbox").attr("contenteditable", false);
        	window.location.href = "/game1boradDetil.Game1Controller?seq=${list[0].game_seq }"
        });
        
        $("#complebtn").on("click", function(){ //글 수정완료 버튼
        	$("#complebtn, #backbtn").show();
        	$("#updtn, #dlebtn").hide();
        	$("#textbox").attr("contenteditable", false);
        	
        	$.ajax({
   				url: "/updat.Game1Controller",
   				data: {
   				text:$("#textbox").text(),
   				seq:$("#seq").val()
   				},
   				type: "post",
   				dataType: "json",
   				success: function(resp){
   				if(resp == 1){
   					window.location.href = "/game1boradDetil.Game1Controller?seq=${list[0].game_seq }";
   				}	
   			}
   		})  
        });
        
        $(".comentcomplbtn, .comentbackbtn").hide(); //댓글 수정완료/취소버튼
        
        $(".comentupbtn").on("click", function(){ //댓글수정
        	 // 해당 댓글 버튼이 속한 comment-item 안에서만 적용
            let commentDiv = $(this).closest(".comment-item").find(".comment-contents");
            
            // 버튼 토글
            $(this).siblings(".comentcomplbtn, .comentbackbtn").show();
            $(this).siblings(".comentdlebtn").hide();
            $(this).hide();
            
            // 클릭한 댓글만 편집 가능
            commentDiv.attr("contenteditable", true).focus();
        	
        });
        
        $(".comentbackbtn").on("click", function(){ //댓글 수정 취소버튼
        	window.location.href = "/game1boradDetil.Game1Controller?seq=${list[0].game_seq }"
        });
        
        $(".comentcomplbtn").on("click", function(){ //댓글 수정 완료버튼
        	let commentItem = $(this).closest(".comment-item");
        	$.ajax({
   				url: "/updatComent.GameComentController",
   				data: {
   				text:commentItem.find(".comment-contents").text(),
   				seq:commentItem.find(".comentseq").val()
   				},
   				type: "post",
   				dataType: "json",
   				success: function(resp){
   				if(resp == 1){
   					window.location.href = "/game1boradDetil.Game1Controller?seq=${list[0].game_seq }";
   				}	
   			}
   		})  
        });
        
        
    </script>
</body>
</html>