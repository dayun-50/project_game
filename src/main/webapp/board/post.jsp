<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<style>
* { box-sizing: border-box; }
body { background-color:#0c0c1a; color:#fff; font-family:'Arial', sans-serif; display:flex; justify-content:center; padding-top:50px; }
.con { border:1px solid black; width:90%; max-width:1000px; margin:auto; padding:15px; }
#postname { height:50px; width:100%; display:flex; align-items:center; background-color:#dad9d9; border-radius:5px; font-size:20px; color:#000; padding:0 10px; }
#postname:empty::before { content:"제목을 입력하세요"; color:#9b9b9b; pointer-events:none; }
#editor { width:100%; height:60vh; margin-top:15px; }
#postdone, #cancel { width:100px; height:50px; font-weight:bold; color:#fff; background:linear-gradient(135deg,#9b59b6,#e91e63); border:none; border-radius:10px; cursor:pointer; box-shadow:0 0 15px #e91e63, inset 0 0 5px #9b59b6; transition: transform 0.2s, box-shadow 0.2s; }
.btns { display:flex; justify-content:flex-end; margin-top:15px; gap:10px; }
/* 에디터 내용 안 이미지 최대 너비 조정 */
#editor img {
    max-width: 100%;  /* 부모 컨테이너 너비를 넘지 않도록 */
    height: auto;     /* 비율 유지 */
    display: block;   /* 가운데 정렬 시 margin auto 사용 가능 */
    margin: 10px 0;   /* 상하 간격 */
}

#logo{
width:100px;
height:100px;
}

</style>
</head>
<body>

<div class="con">
    <div><h1><img src="/board/로고.png" id="logo"> 혜빈이와 아이들 </h1></div>
    <h2>게시판 글쓰기</h2>
    <div id="line" style="border:1px solid #dad9d9; margin-bottom:20px;"></div>

    <form action="/postdone.free" method="post" id="btnform">
        <div id="postname" contenteditable="true"></div>
        <div id="editor"></div>
        <input type="hidden" name="title" id="postnameInput">
        <input type="hidden" name="write" id="editorContent">
        
        <div class="btns">
            <button id="postdone" type="submit">작성완료</button>
            <button id="cancel" type="button">취소</button>
        </div>
    </form>
</div>

<script>
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '500px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '내용을 입력하세요',
    hooks: {
        addImageBlobHook: (blob, callback) => {
            const reader = new FileReader();
            reader.onload = function(e) {
                callback(e.target.result, '이미지'); // Base64 이미지 삽입
            };
            reader.readAsDataURL(blob);
        }
    }
});

document.getElementById('btnform').addEventListener('submit', function(e){
    document.getElementById('postnameInput').value = document.getElementById('postname').innerText;
    document.getElementById('editorContent').value = editor.getHTML();
});

document.getElementById('cancel').addEventListener('click', () => {
    window.location.href = "/list.free";
});
</script>
</body>
</html>
