<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시판 글쓰기</title>

  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <!-- TOAST UI Editor -->
  <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
  <script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

  <style>
    * { box-sizing: border-box; }

    body {
      background-color: #0c0c1a;
      color: #fff;
      font-family: 'Arial', sans-serif;
      display: flex;
      justify-content: center;
      padding-top: 50px;
      overflow-x: hidden;
    }

    .con {
      border: 1px solid black;
      width: 90%;
      max-width: 1000px;
      margin: auto;
      position: relative;
      z-index: 1;
      background: rgba(20,20,40,0.7);
      border-radius: 12px;
      padding: 24px;
    }

    #editor {
      width: 100%;
      height: 60vh;
      margin: auto;
      background: #fff;
      color: #000;
      border-radius: 8px;
      overflow: hidden;
    }

    #postname {
      height: 50px;
      width: 100%;
      display: flex;
      justify-content: start;
      align-items: center;
      background-color: #dad9d9;
      border-radius: 5px;
      font-size: 20px;
      margin: 12px 0 16px 0;
      color: #000000;
      padding: 0 12px;
      outline: none;
    }

    /* 내용이 없을 때만 표시 */
    #postname:empty::before {
      content: "제목을 입력하세요";
      color: #9b9b9b;
      pointer-events: none;
    }

    #line {
      border: 1px solid #dad9d9;
      margin: 12px 0 20px 0;
    }

    h1, h2 {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
    }

    h1 { justify-content: center; gap: 10px; margin: 0; }
    h2 { margin: 12px 0 0 0; }

    #logo { width: 100px; height: 100px; }

    #postdone, #cancel {
      width: 100px;
      height: 50px;
      font-weight: bold;
      color: #fff;
      background: linear-gradient(135deg, #9b59b6, #e91e63);
      border: none;
      border-radius: 10px;
      cursor: pointer;
      box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
      transition: transform 0.2s, box-shadow 0.2s;
    }

    #postdone:hover, #cancel:hover { transform: translateY(-1px); }

    .btns {
      display: flex;
      justify-content: flex-end;
      margin-top: 15px;
      gap: 10px;
    }

    /* 배경 별 효과 */
    .star, .shooting-star {
      position: fixed;
      z-index: 0;
      border-radius: 50%;
    }
    .star {
      animation: twinkle linear infinite;
      background: white;
    }
    @keyframes twinkle {
      0%,100% { opacity: 0.1 }
      25% { opacity: 0.6 }
      50% { opacity: 1 }
      75% { opacity: 0.4 }
    }
  </style>
</head>

<body>
  <div class="con">
    <h1><img src="/board/로고.png" id="logo" alt="logo"> 혜빈이와 아이들</h1>
    <h2>게시판 글쓰기</h2>
    <div id="line"></div>

    <!-- ✅ action 오타 수정: Borad -> Board -->
    <form action="/game1BoardInsert.Game1Controller" method="post" id="btnform">
      <!-- 제목 입력 -->
      <div id="postname" contenteditable="true"></div>

      <!-- 에디터 -->
      <div id="editor"></div>

      <!-- ✅ 서버에서 받는 파라미터 name 정확히 매칭 -->
      <input type="hidden" name="gameid" value="${gameid}" />
      <input type="hidden" name="gameboardtitle" id="postnameInput" />
      <input type="hidden" name="gamecoment" id="editorContent" />
      <!-- 필요 시 작성자도 함께 전송 (컨트롤러가 요구할 때만 사용) -->
      <c:if test="${not empty sessionScope.loginUserId}">
        <input type="hidden" name="gamewrtier" value="${sessionScope.loginUserId}" />
      </c:if>

      <div class="btns">
        <button id="postdone" type="submit">작성완료</button>
        <button id="cancel" type="button">취소</button>
      </div>
    </form>
  </div>

  <script>
    // 배경 별 생성
    function createStars(count, topRange = [0, 100], leftRange = [0, 100], sizeRange = [1, 3]) {
      for (let i = 0; i < count; i++) {
        const s = document.createElement('div');
        s.className = 'star';
        const size = Math.random() * (sizeRange[1] - sizeRange[0]) + sizeRange[0];
        s.style.width = size + 'px';
        s.style.height = size + 'px';
        s.style.top = (Math.random() * (topRange[1] - topRange[0]) + topRange[0]) + 'vh';
        s.style.left = (Math.random() * (leftRange[1] - leftRange[0]) + leftRange[0]) + 'vw';
        s.style.background = 'rgba(255,255,255,' + Math.random() + ')';
        s.style.animationDuration = (1 + Math.random() * 3) + 's';
        document.body.appendChild(s);
      }
    }
    createStars(800);
    createStars(400, [20, 50], [20, 80], [1, 2]);

    // TOAST UI Editor 초기화
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
          };
          reader.readAsDataURL(blob);
          return false; // 서버 업로드 방지
        }
      }
    });

    // 제출 전 값 복사 + 빈값 방지
    document.getElementById('btnform').addEventListener('submit', function(e) {
      const title = document.getElementById('postname').innerText.trim();
      const html  = editor.getHTML().trim();

      if (!title) {
        e.preventDefault();
        alert('제목을 입력하세요.');
        return;
      }
      if (!html || html === '<p><br></p>') {
        e.preventDefault();
        alert('내용을 입력하세요.');
        return;
      }

      document.getElementById('postnameInput').value = title;
      document.getElementById('editorContent').value = html;
    });

    // 취소 버튼
    document.getElementById('cancel').addEventListener('click', () => {
      window.location.href = "/list.free";
    });
  </script>
</body>
</html>
