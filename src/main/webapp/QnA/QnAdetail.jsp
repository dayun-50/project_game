<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>QnA 게시글 상세</title>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<style>
/* 기존 CSS 유지 */
body { background-color: #0c0c1a; color: #fff; font-family: 'Arial', sans-serif; display: flex; justify-content: center; padding-top: 50px; overflow-x: hidden; }
.container { width: 100%; max-width: 600px; background: rgba(20, 20, 40, 0.95); border-radius: 12px; padding: 30px 40px; box-shadow: 0 0 20px rgba(180, 180, 255, 0.5); color: #fff; position: relative; z-index: 1; }
h2 { color: #ff9800; font-size: 2em; margin-bottom: 20px; border-bottom: 1px solid #3c3c5c; padding-bottom: 10px; }
.meta-info { color: #b276d1; margin-bottom: 20px; }
pre { background: rgba(50, 50, 80, 0.8); border: 1px solid #5e72be; border-radius: 10px; padding: 20px; color: #e0e8ff; white-space: pre-wrap; }
.btn-back, .btn-edit, .btn-delete { margin-top: 20px; padding: 10px 25px; border-radius: 10px; font-weight: bold; cursor: pointer; border: none; color: #fff; background: linear-gradient(135deg, #9b59b6, #e91e63); box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; transition: transform 0.2s, box-shadow 0.2s; margin-right: 10px; }
.btn-back:hover, .btn-edit:hover, .btn-delete:hover { transform: scale(1.05); box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6; }
.comment-section { margin-top: 30px; border-top: 1px solid #3c3c5c; padding-top: 20px; }
.comment-item { border-bottom: 1px solid #3c1f5c; padding: 10px 0; }
.comment-meta { font-size: 0.9em; color: #b276d1; margin-bottom: 5px; }
.comment-contents { color: #e0e8ff; }
.post-content img { max-width: 100%; height: auto; display: block; margin: 10px 0; }
.star, .shooting-star { position: fixed; z-index: 0; border-radius: 50%; }
.star { width: 2px; height: 2px; background: white; animation: twinkle linear infinite; }
@keyframes twinkle { 0%,100%{opacity:0.1;}25%{opacity:0.6;}50%{opacity:1;}75%{opacity:0.4;} }
.shooting-star { width: 2px; height: 10px; background: white; animation: shootingStar linear forwards; }
@keyframes shootingStar { 0%{transform:translateY(-5vh) translateX(0) rotate(0deg);opacity:1;}100%{transform:translateY(120vh) translateX(50px) rotate(45deg);opacity:0;} }
</style>
</head>
<body>
<div class="container">
    <!-- 게시글 제목 -->
    <h2 id="postTitle">${dto.inqu_Title}</h2>
    
    <!-- 게시글 내용 -->
    <div class="post-content">
        <pre id="postContent">${dto.inqu_write}</pre>
    </div>
    
    <!-- 게시글 메타정보: 작성자, 작성일 -->
    <div class="meta-info">
        작성자: <strong>${dto.inqu_user_name}</strong> &nbsp;|&nbsp;
        작성일: <fmt:formatDate value="${dto.inqu_date}" pattern="yyyy-MM-dd HH:mm" />
    </div>

    <!-- 게시글 수정용 폼 -->
    <form id="editPostForm" action="update.qna" method="post" style="display:none;">
        <input type="hidden" name="id" value="${dto.inqu_id}" />
        <input type="text" name="title" id="editTitle" value="${dto.inqu_Title}" required /><br><br>
        <div id="editor"></div>
        <input type="hidden" name="write" id="editorContent" />
    </form>

    <!-- 수정/삭제 버튼: 로그인한 닉네임과 게시글 작성자가 같을 때만 표시 -->
    <c:if test="${sessionScope.nickname eq dto.inqu_user_name}">
        <button class="btn-edit" id="editPostBtn">수정</button>
        <button class="btn-delete" id="deletePostBtn">삭제</button>
    </c:if>
    <button class="btn-back" onclick="location.href='list.qna'">목록으로</button>

    <!-- 댓글/답변 영역 -->
    <div class="comment-section">
        <h4>관리자 답변</h4>
        <c:forEach var="c" items="${comments}">
            <div class="comment-item">
                <div class="comment-meta">
                    관리자 | <fmt:formatDate value="${c.inqc_date}" pattern="yyyy-MM-dd HH:mm" />
                </div>
                <div class="comment-contents">${c.inqc_write}</div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ToastUI Editor 라이브러리 -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
// 게시글 수정 모드 상태 저장
let editing = false;

// ToastUI Editor 초기화
const editor = new toastui.Editor({
    el: document.querySelector('#editor'), // 에디터 DOM
    height: '300px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '내용을 입력하세요'
});

// 게시글 수정 버튼 클릭 이벤트
document.getElementById('editPostBtn')?.addEventListener('click', () => {
    const form = document.getElementById('editPostForm'); // 수정 폼
    const postTitle = document.getElementById('postTitle'); // 기존 제목
    const postContent = document.getElementById('postContent'); // 기존 내용
    const deleteBtn = document.getElementById('deletePostBtn'); // 삭제 버튼

    if(!editing){ // 수정 시작
        editing = true;
        form.style.display = 'block'; // 폼 표시
        postTitle.style.display = 'none'; // 제목 숨김
        postContent.style.display = 'none'; // 내용 숨김
        deleteBtn.textContent = '취소'; // 삭제 버튼 텍스트 변경
        editor.setHTML(postContent.innerHTML); // 기존 내용 에디터에 넣기
    } else { // 수정 완료
        document.getElementById('editorContent').value = editor.getHTML(); // 에디터 내용 hidden에 저장
        form.submit(); // 폼 제출
    }
});

// 게시글 삭제 버튼 클릭 이벤트
document.getElementById('deletePostBtn')?.addEventListener('click', function() {
    if(editing){ // 수정 모드 중이면 취소
        editing = false;
        document.getElementById('editPostForm').style.display = 'none';
        document.getElementById('postTitle').style.display = 'block';
        document.getElementById('postContent').style.display = 'block';
        this.textContent = '삭제';
    } else { // 삭제 실행
        if(confirm("정말 삭제하시겠습니까?")){
            location.href='delete.qna?id=${dto.inqu_id}';
        }
    }
});

// 별 효과 생성
function createStars(count){
    for(let i=0;i<count;i++){
        const s=document.createElement('div'); // 별 div 생성
        s.className='star';
        const size=Math.random()*2+1; // 크기 랜덤
        s.style.width=size+'px';
        s.style.height=size+'px';
        s.style.top=Math.random()*100+'vh';
        s.style.left=Math.random()*100+'vw';
        s.style.background=`rgba(255,255,255,${Math.random()})`; // 투명도 랜덤
        s.style.animationDuration=(1+Math.random()*3)+'s'; // 애니메이션 속도 랜덤
        document.body.appendChild(s);
    }
}
function createShootingStar(){
    const star=document.createElement('div');
    star.className='shooting-star';
    star.style.left=Math.random()*100+'vw';
    star.style.animationDuration=(1+Math.random()*1)+'s';
    document.body.appendChild(star);
    star.addEventListener('animationend',()=>star.remove()); // 애니메이션 끝나면 제거
}
createStars(500); // 고정 별 생성
setInterval(createShootingStar,2000); // 2초마다 유성 생성
</script>
</body>
</html>
