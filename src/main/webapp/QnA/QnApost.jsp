<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QnA 글쓰기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<style>
/* --- 기존 디자인 유지 --- */
* { box-sizing: border-box; }
.con { border: 1px solid black; width: 90%; max-width: 1000px; margin: auto; }
#editor { width: 100%; height: 60vh; margin: auto; }
#postname { height: 50px; width: 100%; display: flex; justify-content: start; align-items: center; background-color: #dad9d9; border-radius: 5px; font-size: 20px; margin: auto; color: #000000; padding: 0 10px; }
#postname:empty::before { content: "제목을 입력하세요"; color: #9b9b9b; pointer-events: none; }
#password { width: 150px; padding: 5px 10px; margin-bottom: 10px; border-radius:5px; border:1px solid #ccc; font-size:16px; }
body { background-color: #0c0c1a; color: #fff; font-family: 'Arial', sans-serif; display: flex; justify-content: center; padding-top: 50px; }
.star, .shooting-star { position: fixed; z-index: 0; border-radius: 50%; }
.star { animation: twinkle linear infinite; background: white; }
@keyframes twinkle { 0%,100% { opacity:0.1; } 25% { opacity:0.6; } 50% { opacity:1; } 75% { opacity:0.4; } }
#line { border:1px solid #dad9d9; margin-bottom:20px; }
h1 { width:100%; height:100%; display:flex; justify-content:center; align-items:center; }
h2 { width:100%; height:100%; }
#logo { width:100px; height:100px; }
#postdone, #cancel { width:100px; height:50px; font-weight:bold; color:#fff; background:linear-gradient(135deg,#9b59b6,#e91e63); border:none; border-radius:10px; cursor:pointer; box-shadow:0 0 15px #e91e63, inset 0 0 5px #9b59b6; transition: transform 0.2s, box-shadow 0.2s; }
.btns { display:flex; justify-content:flex-end; margin-top:15px; gap:10px; }
#btnform { display:block; width:100%; }
form { width:100px; height:30px; font-weight:bold; }
#editor img { max-width: 100%; height: auto; display: block; margin: 10px 0; }
</style>
</head>

<body>
<div class="con">
    <h1><img src="/board/로고.png" id="logo"> 혜빈이와 아이들 </h1>
    <h2>QnA 글쓰기</h2>
    <div id="line"></div>

    <!-- QnAController.postdone.qna 연동 -->
    <form action="/postdone.qna" method="post" id="btnform">
        <!-- 4자리 비밀번호 입력 -->
        <input type="password" id="password" name="password" placeholder="4자리 비밀번호" maxlength="4" pattern="\d{4}" required>
        
        <div id="postname" contenteditable="true"></div>
        <div id="editor"></div>
        <input type="hidden" name="title" id="postTitleInput">
        <input type="hidden" name="write" id="postContentInput">
        
        <div class="btns">
            <button id="postdone" type="submit">작성완료</button>
            <button id="cancel" type="button">취소</button>
        </div>
    </form>
</div>

<script>
// Toast Editor 초기화
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
                callback(base64data, '이미지'); // Base64 삽입
            }
            reader.readAsDataURL(blob);
            return false; // 서버 업로드 방지
        }
    }
});

// 제목과 내용, 비밀번호 히든 필드에 복사
document.getElementById('btnform').addEventListener('submit', function(e){
    document.getElementById('postTitleInput').value = document.getElementById('postname').innerText;
    document.getElementById('postContentInput').value = editor.getHTML();
});

// 취소 버튼
document.getElementById('cancel').addEventListener('click', () => {
    window.location.href = "/list.qna";
});

// 별 생성
function createStars(count, topRange = [0,100], leftRange=[0,100], sizeRange=[1,3]) {
    for (let i=0; i<count; i++){
        const s = document.createElement('div');
        s.className='star';
        const size = Math.random()*(sizeRange[1]-sizeRange[0])+sizeRange[0];
        s.style.width = size+'px';
        s.style.height = size+'px';
        s.style.top = (Math.random()*(topRange[1]-topRange[0])+topRange[0])+'vh';
        s.style.left = (Math.random()*(leftRange[1]-leftRange[0])+leftRange[0])+'vw';
        s.style.background=`rgba(255,255,255,${Math.random()})`;
        s.style.animationDuration=(1+Math.random()*3)+'s';
        document.body.appendChild(s);
    }
}

createStars(800);
createStars(400, [20,50], [20,80], [1,2]);
</script>
</body>
</html>
