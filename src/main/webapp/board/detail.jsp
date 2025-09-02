<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">

<style>
/* --- CSS는 요청하신 원래 형태 --- */
body { background-color: #0c0c1a; color: #fff; font-family: 'Arial', sans-serif; display: flex; justify-content: center; padding-top: 50px; overflow-x: hidden; }
.container { width: 100%; max-width: 600px; background: rgba(20, 20, 40, 0.95); border-radius: 12px; padding: 30px 40px; box-shadow: 0 0 20px rgba(180, 180, 255, 0.5); color: #fff; position: relative; z-index: 1; }
h2 { color: #ff9800; font-size: 2em; margin-bottom: 20px; border-bottom: 1px solid #3c3c5c; padding-bottom: 10px; }
.meta-info { color: #b276d1; margin-bottom: 20px; }
pre { background: rgba(50, 50, 80, 0.8); border: 1px solid #5e72be; border-radius: 10px; padding: 20px; color: #e0e8ff; white-space: pre-wrap; }
.btn-back, .btn-edit, .btn-delete { margin-top: 20px; padding: 10px 25px; border-radius: 10px; font-weight: bold; cursor: pointer; border: none; color: #fff; background: linear-gradient(135deg, #9b59b6, #e91e63); box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; transition: transform 0.2s, box-shadow 0.2s; margin-right: 10px; }
.btn-back:hover, .btn-edit:hover, .btn-delete:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
.comment-section { margin-top: 30px; border-top: 1px solid #3c3c5c; padding-top: 20px; }
.comment-list { height: 100%;  margin-bottom: 20px; }
.comment-item { border-bottom: 1px solid #3c1f5c; padding: 10px 0; }
.comment-meta { font-size: 0.9em; color: #b276d1; display: flex; justify-content: space-between; align-items: center; }
.comment-contents {width: 80%; height: 30px; color: #e0e8ff; }
.comment-actions button { background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.comment-actions button:hover { text-decoration: underline; }
.comment-form textarea { width: 100%; height: 80px; border-radius: 8px; border: 1px solid #5e72be; padding: 10px; background: rgba(30, 30, 60, 0.8); color: #fff; font-family: 'Arial', sans-serif; }
.comment-form button { margin-top: 10px; padding: 10px 20px; border-radius: 10px; border: none; font-weight: bold; background: linear-gradient(135deg, #9b59b6, #e91e63); color: #fff; cursor: pointer; box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; }
.comment-form button:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
.savebtn { text-align: right; background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.savebtn:hover { text-decoration: underline; }
.cancelbtn { text-align: right; background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.cancelbtn:hover { text-decoration: underline; }

.post-content img {
    max-width: 100%;
    height: auto;
    display: block;
    margin: 10px 0;
}

/* 별 효과 */
.star, .shooting-star { position: fixed; z-index: 0; border-radius: 50%; }
.star { width: 2px; height: 2px; background: white; animation: twinkle linear infinite; }
@keyframes twinkle { 0%,100%{opacity:0.1;}25%{opacity:0.6;}50%{opacity:1;}75%{opacity:0.4;} }
.shooting-star { width: 2px; height: 10px; background: white; animation: shootingStar linear forwards; }
@keyframes shootingStar { 0%{transform:translateY(-5vh) translateX(0) rotate(0deg);opacity:1;}100%{transform:translateY(120vh) translateX(50px) rotate(45deg);opacity:0;} }
</style>
</head>
<body>
<div class="container">
    <h2 id="postTitle">${dto.fb_Title}</h2>
    <div class="post-content">
    <pre id="postContent">${dto.fb_write}</pre>
    </div>
    <div class="meta-info">
        작성자: <strong>${dto.fb_user_name}</strong> &nbsp;|&nbsp;
        작성일: <fmt:formatDate value="${dto.fb_date}" pattern="yyyy-MM-dd HH:mm" /> &nbsp;|&nbsp;
        조회수: ${dto.view_count}
    </div>

    <!-- 수정용 폼 -->
    <form id="editPostForm" action="update.free" method="post" style="display:none;">
        <input type="hidden" name="id" value="${dto.fb_id}" />
        <input type="text" name="title" id="editTitle" value="${dto.fb_Title}" required /><br><br>
        <div id="editor"></div>
        <input type="hidden" name="write" id="editorContent" />
    </form>

    <button class="btn-edit" id="editPostBtn">수정</button>
    <button class="btn-delete" id="deletePostBtn">삭제</button>
    <button class="btn-back" onclick="location.href='list.free'">목록으로</button>

    <div class="comment-section">
        <h4>댓글 <small>(${fn:length(comments)})</small></h4>
        <div class="comment-list">
            <c:forEach var="c" items="${comments}">
    <div class="comment-item">
        <input type="hidden" name="fc_id" value="${c.fc_id}" />
        <input type="hidden" name="fb_id" value="${dto.fb_id}" />
        <div class="comment-meta">
            ${c.fc_user_name} | <fmt:formatDate value="${c.fc_date}" pattern="yyyy-MM-dd HH:mm" />
            <div class="comment-actions">
                <c:if test="${dto.fb_user_name eq c.fc_user_name}">
                    <button type="button" class="updatebtn">수정</button>
                    <form action="delete.fComment" method="post" style="display:inline;">
                        <input type="hidden" name="fc_id" value="${c.fc_id}" />
                        <input type="hidden" name="fb_id" value="${dto.fb_id}" />
                        <button type="submit">삭제</button>
                    </form>
                </c:if>
            </div>
        </div>
        <div class="comment-contents" contenteditable="false">${c.fc_write}</div>
    </div>
</c:forEach>


        </div>

        <form class="comment-form" action="insert.fComment" method="post">
            <input type="hidden" name="fb_id" value="${dto.fb_id}" />
            <textarea name="write" placeholder="댓글을 입력하세요..." required></textarea>
            <button type="submit">댓글 등록</button>
        </form>
    </div>
</div>


<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// Toast Editor + 수정/삭제 기능
let editing = false;
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '300px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '내용을 입력하세요'
});

// 수정 해도 사진 그대로 남아있게
document.getElementById('editPostBtn').addEventListener('click', () => {
    const form = document.getElementById('editPostForm');
    const postTitle = document.getElementById('postTitle');
    const postContent = document.getElementById('postContent');
    const deleteBtn = document.getElementById('deletePostBtn');

    if(!editing) {
        editing = true;
        form.style.display = 'block';
        postTitle.style.display = 'none';
        postContent.style.display = 'none';
        deleteBtn.textContent = '취소';
        // HTML 그대로 넣기
        editor.setHTML(postContent.innerHTML);
    } else {
        document.getElementById('editorContent').value = editor.getHTML();
        form.submit();
    }
});
//여기까지

//댓글 수정 부분
$(document).on("click", ".updatebtn", function () {
  const c = $(this).closest(".comment-item");
  const contentDiv = c.find(".comment-contents"); //댓글내용

  // 수정 모드로 전환
  contentDiv.attr("contenteditable", "true").focus();
  c.find(".comment-actions").hide();

  // 완료/취소 버튼 추가
  const saveBtn = $("<button class='savebtn'>완료</button>");
  const cancelBtn = $("<button class='cancelbtn'>취소</button>");
  contentDiv.after(saveBtn, cancelBtn);
	
  // 원래 내용 백업
  c.data("orig", contentDiv.html());
});

$(document).on("click", ".savebtn", function () {
  const c = $(this).closest(".comment-item");
  const contentDiv = c.find(".comment-contents");

  contentDiv.removeAttr("contenteditable");
  c.find(".comment-actions").show();
  $(this).next(".cancelbtn").remove();
  $(this).remove();
});

$(document).on("click", ".cancelbtn", function () {
  const c = $(this).closest(".comment-item");
  const contentDiv = c.find(".comment-contents");

  contentDiv.html(c.data("orig")).removeAttr("contenteditable");
  c.find(".comment-actions").show();
  $(this).prev(".savebtn").remove();
  $(this).remove();
});


document.getElementById('deletePostBtn').addEventListener('click', () => {
    const form = document.getElementById('editPostForm');
    const postTitle = document.getElementById('postTitle');
    const postContent = document.getElementById('postContent');
    const editBtn = document.getElementById('editPostBtn');
    if(editing){
        editing = false;
        form.style.display = 'none';
        postTitle.style.display = 'block';
        postContent.style.display = 'block';
        this.textContent = '삭제';
    } else {
        location.href='delete.free?id=${dto.fb_id}';
    }
});

// 별 효과
function createStars(count){for(let i=0;i<count;i++){const s=document.createElement('div');s.className='star';const size=Math.random()*2+1;s.style.width=size+'px';s.style.height=size+'px';s.style.top=Math.random()*100+'vh';s.style.left=Math.random()*100+'vw';s.style.background=`rgba(255,255,255,${Math.random()})`;s.style.animationDuration=(1+Math.random()*3)+'s';document.body.appendChild(s);}}
function createShootingStar(){const star=document.createElement('div');star.className='shooting-star';star.style.left=Math.random()*100+'vw';star.style.animationDuration=(1+Math.random()*1)+'s';document.body.appendChild(star);star.addEventListener('animationend',()=>star.remove());}
createStars(500); setInterval(createShootingStar,2000);
</script>
</body>
</html>
