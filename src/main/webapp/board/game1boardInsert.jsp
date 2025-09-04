<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>

  <meta charset="UTF-8">
  <title>게임1 글쓰기</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
  <script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

  <style>
    body { background:#0c0c1a; color:#fff; font-family:Arial,sans-serif; display:flex; justify-content:center; padding:40px 0; }
    .con { width:90%; max-width:1000px; background:rgba(20,20,40,.85); padding:24px; border-radius:12px; }
    #postname { height:48px; background:#dad9d9; color:#000; border-radius:8px; padding:0 12px; display:flex; align-items:center; }
    #postname:empty::before{ content:"제목을 입력하세요"; color:#888; }
    #editor{ background:#fff; color:#000; margin-top:12px; border-radius:8px; }
    .btns{ display:flex; gap:10px; justify-content:flex-end; margin-top:14px; }
    button{ height:44px; padding:0 16px; border:none; border-radius:8px; font-weight:700; color:#fff;
            background:linear-gradient(135deg,#9b59b6,#e91e63); cursor:pointer; }
  </style>
</head>
<body>
  <div class="con">
    <h2>게시판 글쓰기</h2>

    <!-- ✅ 액션 경로: /game1BoradInsert.Game1Controller (오타 포함) -->
    <form action="<c:url value='/game1BoradInsert.Game1Controller'/>" method="post" id="btnform">
      <div id="postname" contenteditable="true"></div>
      <div id="editor"></div>

      <!-- 컨트롤러가 받는 name과 1:1 매칭 -->
      <input type="hidden" name="gameid" value="${param.gameid != null ? param.gameid : 1}"/>
      <input type="hidden" name="title" id="postnameInput"/>
      <input type="hidden" name="coment" id="editorContent"/>

      <div class="btns">
        <button type="submit" id="postdone">작성완료</button>
        <button type="button" id="cancel">취소</button>
      </div>
    </form>
  </div>


  <script>
    // TOAST UI Editor
    const editor = new toastui.Editor({
      el: document.querySelector('#editor'),
      height: '500px',
      initialEditType: 'wysiwyg',
      previewStyle: 'vertical',
      language: 'ko-KR',
      placeholder: '내용을 입력하세요',
      hooks: {
        addImageBlobHook: function (blob, callback) {
          const reader = new FileReader();
          reader.onloadend = function () { callback(reader.result, '이미지'); };
          reader.readAsDataURL(blob);
          return false; // 서버 업로드 방지(Base64 삽입)
        }
      }
    });

    // 제출 전 값 주입 + 더블서밋 방지 + 에디터 초기화 지연 대비
    let submitting = false;
    document.getElementById('btnform').addEventListener('submit', async function (e) {
      if (submitting) { e.preventDefault(); return; }
      let title = document.getElementById('postname').innerText.trim();
      let html  = editor.getHTML().trim();


      // 초기화 지연 대비: 비면 한 틱 양보 후 재읽기
      if (!html || html === '<p><br></p>') {
        await Promise.resolve();
        html = editor.getHTML().trim();
      }

      if (!title && (!html || html === '<p><br></p>')) {
        e.preventDefault();
        alert('제목 또는 내용(텍스트/이미지)을 입력하세요.');
        return;
      }

      document.getElementById('postnameInput').value = title;
      document.getElementById('editorContent').value = html;

      submitting = true;
    });

    // 취소: 항상 실제 목록 라우트로 이동 (캐시 영향 최소화)
    document.getElementById('cancel').addEventListener('click', () => {
      const gid = document.querySelector('input[name="gameid"]')?.value || 1;
      location.href = `<c:url value='/game1borad.Game1Controller'/>?gameid=${gid}&ts=${Date.now()}`;
    });
  </script>
</body>
</html>

