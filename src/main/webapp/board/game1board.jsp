<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- ToastUI Editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

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
        width: 50%;
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
    .pre { background: rgba(50,50,80,0.8); border:1px solid #5e72be; border-radius:10px; padding:20px; color:#e0e8ff; white-space: pre-wrap; }

    .btn-back, .btn-edit, .btn-delete {
        margin-top: 20px; padding: 10px 25px; border-radius:10px; font-weight:bold;
        cursor:pointer; border:none; color:#fff;
        background: linear-gradient(135deg, #9b59b6, #e91e63);
        box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
        transition: transform 0.2s, box-shadow 0.2s; margin-right:10px;
    }
    .btn-back:hover, .btn-edit:hover, .btn-delete:hover {
        transform: scale(1.05); box-shadow:0 0 25px #e91e63, 0 0 50px #9b59b6;
    }

    /* 댓글 스타일 */
    .comment-section { margin-top:30px; border-top:1px solid #3c3c5c; padding-top:20px; }
    .comment-list { max-height:300px; overflow-y:auto; margin-bottom:20px; }
    .comment-item { border-bottom:1px solid #3c1f5c; padding:10px 0; }
    .comment-meta { font-size:0.9em; color:#b276d1; display:flex; justify-content:space-between; align-items:center; }
    .comment-contents { color:#e0e8ff; }
    .comment-actions button { background:none; border:none; color:#87CEEB; cursor:pointer; font-weight:600; padding:0; margin:0 5px; }
    .comment-actions button:hover { text-decoration:underline; }
    .comment-form textarea { width:100%; height:80px; border-radius:8px; border:1px solid #5e72be; padding:10px; background:rgba(30,30,60,0.8); color:#fff; font-family:'Arial', sans-serif; }
    .comment-form button { margin-top:10px; padding:10px 20px; border-radius:10px; border:none; font-weight:bold; background: linear-gradient(135deg, #9b59b6, #e91e63); color:#fff; cursor:pointer; box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6; }
    .comment-form button:hover { transform: scale(1.05); box-shadow:0 0 25px #e91e63,0 0 50px #9b59b6; }

    /* 댓글 수정 버튼 */
    .comentcomplbtn, .comentbackbtn { display:none; }
</style>
</head>

<body>
<div class="container">
    <!-- 게시글 제목 -->
    <h2>${list[0].gameboardtitle}</h2>

    <!-- 게시글 메타정보 -->
    <div class="meta-info">
        <span>작성자: <strong>${list[0].gamewrtier}</strong></span> &nbsp;|&nbsp;
        <span>작성일: ${list[0].game_board_date}</span> &nbsp;|&nbsp;
        <span>조회수: ${viewCount}</span>
    </div>

    <!-- 게시글 내용 -->
    <div class="pre" id="textbox">${list[0].gamecoment}</div>

    <!-- 게시글 수정용 폼 (ToastUI Editor 사용) -->
    <form id="editPostForm" action="/updat.Game1Controller" method="post" style="display:none;">
        <input type="hidden" name="seq" id="seq" value="${list[0].game_seq}">
        <input type="text" name="title" id="editTitle" value="${list[0].gameboardtitle}" required /><br><br>
        <div id="editor"></div> <!-- Editor 영역 -->
        <input type="hidden" name="text" id="editorContent">
    </form>

    <!-- 버튼 -->
    <button class="btn-back" id="backList">목록으로</button>
    <c:choose>
        <c:when test="${result == 1}">
            <button class="btn-edit" id="updtn">수정하기</button>
            <button class="btn-delete" id="dlebtn">삭제하기</button>
            <button class="btn-edit" id="complebtn">수정완료</button>
            <button class="btn-delete" id="backbtn">수정취소</button>
        </c:when>
    </c:choose>

    <!-- 댓글 영역 -->
    <div class="comment-section">
        <h4>댓글 <small>(${comentCount})</small></h4>
        <div class="comment-list">
            <c:forEach var="Cdto" items="${comentList}">
                <div class="comment-item">
                    <div class="comment-meta">
                        <div>${Cdto.game_coment_writer} | ${Cdto.game_coment_date}</div>
                        <c:choose>
                            <c:when test="${nickname eq Cdto.game_coment_writer}">
                                <div class="comment-actions">
                                    <button class="comentupbtn">수정</button>
                                    <button class="comentdlebtn">삭제</button>
                                    <button class="comentcomplbtn">완료</button>
                                    <button class="comentbackbtn">취소</button>
                                    <input type="hidden" class="comentseq" value="${Cdto.game_comet_seq}">
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="comment-contents">${Cdto.game_coment}</div>
                </div>
            </c:forEach>
        </div>

        <!-- 댓글 등록 폼 -->
        <form class="comment-form" action="/comentInsert.GameComentController" method="post">
            <input type="hidden" name="seq" value="${list[0].game_seq}">
            <textarea placeholder="댓글을 입력하세요..." name="coment" required></textarea>
            <button type="submit">댓글 등록</button>
        </form>
    </div>
</div>

<script>
$(function(){
    // ToastUI Editor 초기화
    const editor = new toastui.Editor({
        el: document.querySelector('#editor'),
        height: '300px',
        initialEditType: 'wysiwyg',
        previewStyle: 'vertical',
        language: 'ko-KR',
        placeholder: '내용을 입력하세요'
    });

    // 초기 버튼 상태
    $("#complebtn, #backbtn").hide();

    // 목록 버튼
    $("#backList").click(function(){ window.location.href="/game1borad.Game1Controller"; });

    // 글 수정 클릭
    $("#updtn").click(function(){
        $("#editPostForm").show();
        $("#updtn, #dlebtn, #textbox").hide();
        editor.setHTML($("#textbox").html()); // 기존 내용 에디터에 삽입
        $("#complebtn, #backbtn").show();
    });

    // 글 수정 취소
    $("#backbtn").click(function(){
        $("#editPostForm").hide();
        $("#updtn, #dlebtn, #textbox").show();
        $("#complebtn, #backbtn").hide();
    });

    // 글 수정 완료
    $("#complebtn").click(function(){
        $("#editorContent").val(editor.getHTML());
        $("#editPostForm").submit();
    });

    // 글 삭제
    $("#dlebtn").click(function(){
        if(confirm("정말로 삭제하시겠습니까?")){
            $.ajax({
                url:"/delete.Game1Controller",
                type:"post",
                data:{seq:$("#seq").val()},
                dataType:"json",
                success:function(resp){
                    if(resp==1) window.location.href="/game1borad.Game1Controller";
                }
            });
        }
    });

    // 댓글 삭제
    $(".comentdlebtn").click(function(){
        let commentItem = $(this).closest(".comment-item");
        if(confirm("댓글을 삭제하시겠습니까?")){
            $.ajax({
                url:"/delete.GameComentController",
                type:"post",
                data:{seq:commentItem.find(".comentseq").val()},
                dataType:"json",
                success:function(resp){ if(resp==1) window.location.reload(); }
            });
        }
    });

    // 댓글 수정 클릭
    $(document).on("click",".comentupbtn", function(){
        const commentDiv = $(this).closest(".comment-item").find(".comment-contents");
        const originalHtml = commentDiv.html();
        commentDiv.hide();

        const editorDiv = $("<div class='comment-editor'></div>");
        commentDiv.after(editorDiv);

        const commentEditor = new toastui.Editor({
            el: editorDiv[0],
            height: '150px',
            initialEditType: 'wysiwyg',
            previewStyle: 'vertical',
            language: 'ko-KR',
            initialValue: originalHtml
        });

        $(this).siblings(".comentcomplbtn, .comentbackbtn").show();
        $(this).hide();

        // 댓글 수정 완료
        $(this).siblings(".comentcomplbtn").off("click").on("click", function(){
            const seq = $(this).siblings(".comentseq").val();
            $.ajax({
                url:"/updatComent.GameComentController",
                type:"post",
                dataType:"json",
                data:{text:commentEditor.getHTML(), seq:seq},
                success:function(resp){ if(resp==1) window.location.reload(); }
            });
        });

        // 댓글 수정 취소
        $(this).siblings(".comentbackbtn").off("click").on("click", function(){
            editorDiv.remove();
            commentDiv.show();
            $(this).siblings(".comentupbtn").show();
            $(this).hide();
            $(this).siblings(".comentcomplbtn").hide();
        });
    });
});
</script>
</body>
</html>
