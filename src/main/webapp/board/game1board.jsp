<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">

<title>게임1 게시글 상세</title>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">

<style>
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
.comment-contents { width: 80%; color: #e0e8ff; }
.comment-actions button { background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.comment-actions button:hover { text-decoration: underline; }
.comment-form textarea { width: 100%; height: 80px; border-radius: 8px; border: 1px solid #5e72be; padding: 10px; background: rgba(30, 30, 60, 0.8); color: #fff; font-family: 'Arial', sans-serif; }
.comment-form button { margin-top: 10px; padding: 10px 20px; border-radius: 10px; border: none; font-weight: bold; background: linear-gradient(135deg, #9b59b6, #e91e63); color: #fff; cursor: pointer; box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; }
.comment-form button:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
.savebtn, .cancelbtn { background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.savebtn:hover, .cancelbtn:hover { text-decoration: underline; }
.post-content img { max-width: 100%; height: auto; display: block; margin: 10px 0; }
#editTitle{
 width: 100%;
    padding: 12px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: #fff;
    color: #000;
    box-sizing: border-box;
    margin-bottom: 15px; /* 에디터랑 간격 */
}
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
        0%, 100% { opacity: 0.2; }
        50% { opacity: 1; }
    }    
</style>
</head>
<body>
<div class="container">


    <!-- 게시글 제목 -->
    <h2 id="postTitle">${dto.gameboardtitle}</h2>

    <!-- 게시글 내용 -->
    <div class="post-content">
        <div id="postContent">${dto.gamecoment}</div>

    </div>

    <!-- 게시글 메타정보 -->
    <div class="meta-info">
        작성자: <strong>${dto.gamewrtier}</strong> &nbsp;|&nbsp;
        작성일: ${dto.game_board_date} &nbsp;|&nbsp;
        조회수: ${dto.view_count}
    </div>

    <!-- 수정용 폼 (ToastUI Editor 포함) -->
    <form id="editPostForm" action="updatePost.Game1Controller" method="post" style="display:none;">
        <input type="hidden" name="seq" value="${dto.game_seq}" />
        <input type="text" name="title" id="editTitle" value="${dto.gameboardtitle}" required /><br><br>
        <div id="editor"></div>
        <input type="hidden" name="coment" id="editorContent" />
    </form>

    <!-- 게시글 수정/삭제 버튼 -->
    <c:if test="${sessionScope.nickname eq dto.gamewrtier}">
        <button class="btn-edit" id="editPostBtn">수정</button>
        <button class="btn-delete" id="deletePostBtn">삭제</button>
    </c:if>

    <button class="btn-back" onclick="location.href='game1borad.Game1Controller?gameid=1'">목록으로</button>

    <!-- 댓글 영역 -->
    <div class="comment-section">
        <h4>댓글 <small>(${comentCount})</small></h4>
        <div class="comment-list">
            <c:forEach var="c" items="${comentList}">
                <div class="comment-item">
                    <div class="comment-meta">
                        ${c.game_coment_writer} | ${c.game_coment_date}
                        <div class="comment-actions">
                            <c:if test="${sessionScope.nickname eq c.game_coment_writer}">
                                <button type="button" class="updatebtn">수정</button>
                                <!-- AJAX용 삭제 버튼 -->
                                <button type="button" class="deletebtn" onclick="location.href='delete.GameComentController?seq=${c.game_comet_seq}&parentSeq=${dto.game_seq}'"> 삭제</button>
                            </c:if>
                        </div>
                    </div>
                    <div class="comment-contents" contenteditable="false">${c.game_coment}</div>
                </div>
            </c:forEach>
        </div>

        <!-- 댓글 등록 폼 -->
        <form class="comment-form" action="comentInsert.GameComentController" method="post">
            <input type="hidden" name="seq" value="${dto.game_seq}" />
            <textarea name="coment" placeholder="댓글을 입력하세요..." required></textarea>
            <button type="submit">댓글 등록</button>
        </form>
    </div>
</div>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
let editing = false;

// ToastUI Editor 초기화
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '300px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '내용을 입력하세요'
});

// 게시글 수정 버튼 클릭
document.getElementById('editPostBtn')?.addEventListener('click', () => {
    const form = document.getElementById('editPostForm');
    const postTitle = document.getElementById('postTitle');
    const postContent = document.getElementById('postContent');
    const deleteBtn = document.getElementById('deletePostBtn');

    if(!editing){ // 수정 모드 시작
        editing = true;
        form.style.display = 'block';
        postTitle.style.display = 'none';
        postContent.style.display = 'none';
        deleteBtn.textContent = '취소';
        editor.setHTML(postContent.innerHTML);
    } else { // 수정 완료
        document.getElementById('editorContent').value = editor.getHTML();
        form.submit();
    }
});

// 게시글 삭제/취소 버튼
document.getElementById('deletePostBtn')?.addEventListener('click', function(){
    if(editing){
        editing = false;
        document.getElementById('editPostForm').style.display='none';
        document.getElementById('postTitle').style.display='block';
        document.getElementById('postContent').style.display='block';
        this.textContent = '삭제';
    } else {
        location.href='delete.Game1Controller?seq=${dto.game_seq}';
    }
});

// 댓글 수정
$(document).on("click", ".updatebtn", function () {
    const c = $(this).closest(".comment-item");
    const contentDiv = c.find(".comment-contents");
    contentDiv.attr("contenteditable", "true").focus();
    c.find(".comment-actions").hide();

    const saveBtn = $("<button class='savebtn'>완료</button>");
    const cancelBtn = $("<button class='cancelbtn'>취소</button>");
    contentDiv.after(saveBtn, cancelBtn);
    c.data("orig", contentDiv.html());
});

// 댓글 완료
$(document).on("click", ".savebtn", function () {
    const c = $(this).closest(".comment-item");
    const contentDiv = c.find(".comment-contents");

    contentDiv.removeAttr("contenteditable");
    c.find(".comment-actions").show();
    $(this).next(".cancelbtn").remove();
    $(this).remove();
});

// 댓글 취소
$(document).on("click", ".cancelbtn", function () {
    const c = $(this).closest(".comment-item");
    const contentDiv = c.find(".comment-contents");

    contentDiv.html(c.data("orig")).removeAttr("contenteditable");
    c.find(".comment-actions").show();
    $(this).prev(".savebtn").remove();
    $(this).remove();
});

// 댓글 삭제 AJAX
$(document).on("click", ".deletebtn", function () {
    if(!confirm("정말 삭제하시겠습니까?")) return;

    const seq = $(this).data("seq");
    const commentItem = $(this).closest(".comment-item");

    $.ajax({
        url: "delete.GameComentController",
        type: "POST",
        data: { seq: seq },
        success: function (result) {
            if(result.trim() === "1"){
                commentItem.remove();
            } else {
                alert("댓글 삭제에 실패했습니다.");
            }
        },
        error: function () {
            alert("서버 오류 발생");
        }

    });
});

//별 배경
for (let i = 0; i < 150; i++) {
    const s = document.createElement('div'); 
    s.className = 'star';
    s.style.top = Math.random() * 100 + 'vh';
    s.style.left = Math.random() * 100 + 'vw';
    s.style.animationDuration = (2 + Math.random() * 3) + 's';
    document.body.appendChild(s);
}
</script>
</body>
</html>
