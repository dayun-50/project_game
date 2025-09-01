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
body {
    background-color: #0c0c1a;
    color: #fff;
    font-family: 'Arial', sans-serif;
    display: flex;
    justify-content: center;
    padding-top: 50px;
    overflow-x: hidden;
}

.container {
    width: 100%;
    max-width: 600px;
    background: rgba(20, 20, 40, 0.95);
    border-radius: 12px;
    padding: 30px 40px;
    box-shadow: 0 0 20px rgba(180, 180, 255, 0.5);
    color: #fff;
    position: relative;
    z-index: 1;
}

h2 { color: #ff9800; font-size: 2em; margin-bottom: 20px; border-bottom: 1px solid #3c3c5c; padding-bottom: 10px; }
.meta-info { color: #b276d1; margin-bottom: 20px; }

.btn {
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
.btn:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }

.Comment-section { margin-top: 30px; border-top: 1px solid #3c3c5c; padding-top: 20px; }
.Comment-list { height: 100%; margin-bottom: 20px; }
.Comment-item { border-bottom: 1px solid #3c1f5c; padding: 10px 0; }
.Comment-meta { font-size: 0.9em; color: #b276d1; display: flex; justify-content: space-between; align-items: center; }
.Comment-contents { color: #e0e8ff; }
.Comment-actions button { background: none; border: none; color: #87CEEB; cursor: pointer; font-weight: 600; padding: 0; margin: 0 5px; }
.Comment-actions button:hover { text-decoration: underline; }
.Comment-form textarea,
.editCommentForm textarea { width: 100%; height: 80px; border-radius: 8px; border: 1px solid #5e72be; padding: 10px; background: rgba(30, 30, 60, 0.8); color: #fff; font-family: 'Arial', sans-serif; }
.Comment-form button,
.editCommentForm button { margin-top: 10px; padding: 10px 20px; border-radius: 10px; border: none; font-weight: bold; background: linear-gradient(135deg, #9b59b6, #e91e63); color: #fff; cursor: pointer; box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; }
.Comment-form button:hover,
.editCommentForm button:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
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

    <!-- 게시글 제목/내용 영역 -->
    <h2 id="postTitle">${dto.fb_Title}</h2>
    <pre id="postContent">${dto.fb_write}</pre>

    <div class="meta-info">
        <span>작성자: <strong>${dto.fb_user_name}</strong></span> &nbsp;|&nbsp;
        <span>작성일: <fmt:formatDate value="${dto.fb_date}" pattern="yyyy-MM-dd HH:mm" /></span>
    </div>

    <!-- 게시글 수정용 에디터 (숨김) -->
    <form id="editPostForm" action="update.free" method="post" style="display:none;">
        <input type="hidden" name="id" value="${dto.fb_id}" />
        <input type="text" name="title" id="editTitle" value="${dto.fb_Title}" required /><br><br>
        <div id="editor"></div>
        <input type="hidden" name="write" id="editorContent">
    </form>

    <!-- 버튼 영역 -->
    <button class="btn" id="editPostBtn">수정</button>
    <button class="btn" id="deletePostBtn" onclick="this.form.submit();">삭제</button>
    <a href="list.free"><button class="btn">목록</button></a>

    <!-- 댓글 섹션 -->
    <div class="Comment-section">
        <h4>댓글 <small>(${fn:length(comments)})</small></h4>
        <div class="Comment-list">
            <c:forEach var="c" items="${comments}">
                <div class="Comment-item" id="comment-${c.fc_id}">
                    <div class="Comment-meta">
                        <div>${c.fc_user_name} | <fmt:formatDate value="${c.fc_date}" pattern="yyyy-MM-dd HH:mm" /></div>
                        <div class="Comment-actions">
                            <c:if test="${dto.fb_user_name eq c.fc_user_name}">
                                <button type="button" class="editCommentBtn" data-id="${c.fc_id}">수정</button>
                                <form action="delete.fComment" method="post" style="display:inline;">
                                    <input type="hidden" name="fc_id" value="${c.fc_id}" />
                                    <input type="hidden" name="fb_id" value="${dto.fb_id}" />
                                    <button type="submit">삭제</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                    <div class="Comment-contents" id="commentContent-${c.fc_id}">${c.fc_write}</div>
                    <form class="editCommentForm" id="editCommentForm-${c.fc_id}" action="update.fComment" method="post" style="display:none;">
                        <input type="hidden" name="fc_id" value="${c.fc_id}" />
                        <input type="hidden" name="fb_id" value="${dto.fb_id}" />
                        <textarea name="write" required>${c.fc_write}</textarea><br>
                        <button type="submit">저장</button>
                        <button type="button" class="cancelCommentBtn" data-id="${c.fc_id}">취소</button>
                    </form>
                </div>
            </c:forEach>
        </div>

        <form class="Comment-form" action="insert.fComment" method="post">
            <input type="hidden" name="fb_id" value="${dto.fb_id}" />
            <textarea name="write" placeholder="댓글을 입력하세요..." required></textarea>
            <button type="submit">댓글 등록</button>
        </form>
    </div>
</div>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

document.addEventListener('DOMContentLoaded', function() {
    const editBtn = document.getElementById('editPostBtn');
    const deleteBtn = document.getElementById('deletePostBtn');
    const postTitle = document.getElementById('postTitle');
    const postContent = document.getElementById('postContent');
    const editForm = document.getElementById('editPostForm');

    const editor = new toastui.Editor({
        el: document.querySelector('#editor'),
        height: '300px',
        initialEditType: 'wysiwyg',
        previewStyle: 'vertical',
        language: 'ko-KR',
        placeholder: '내용을 입력하세요'
    });

    // 버튼 재활용
    let editing = false;
    editBtn.addEventListener('click', () => {
        if(!editing) {
            // 수정 시작: 버튼 텍스트 변경, 내용 에디터로 전환
            editing = true;
            editBtn.textContent = '저장';
            deleteBtn.textContent = '취소';
            postTitle.style.display = 'none';
            postContent.style.display = 'none';
            editForm.style.display = 'block';
            editor.setMarkdown(postContent.innerText);
        } else {
            // 저장
            document.getElementById('editorContent').value = editor.getHTML();
            editForm.submit();
        }
    });

    deleteBtn.addEventListener('click', () => {
        if(editing) {
            // 수정 취소
            editing = false;
            editBtn.textContent = '수정';
            deleteBtn.textContent = '삭제';
            editForm.style.display = 'none';
            postTitle.style.display = 'block';
            postContent.style.display = 'block';
        } else {
            // 원래 삭제 기능 수행
            editForm.remove(); // 안전하게 제거
            deleteBtn.closest('form').submit();
        }
    });

    // 댓글 수정/취소
    document.querySelectorAll('.editCommentBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            document.getElementById(`commentContent-${id}`).style.display = 'none';
            document.getElementById(`editCommentForm-${id}`).style.display = 'block';
            btn.style.display = 'none';
        });
    });

    document.querySelectorAll('.cancelCommentBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            document.getElementById(`commentContent-${id}`).style.display = 'block';
            document.getElementById(`editCommentForm-${id}`).style.display = 'none';
            document.querySelector(`button.editCommentBtn[data-id="${id}"]`).style.display = 'inline-block';
        });
    });
});

</script>
</body>
</html>
