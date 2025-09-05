

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
    .con {  border: 1px solid black;
        width: 90%;
        max-width: 1000px;
        margin: auto; }
    #postname { height:48px; background:#dad9d9; color:#000; border-radius:8px; padding:0 12px; display:flex; align-items:center; }
    #postname:empty::before{ content:"제목을 입력하세요"; color:#888; }
    #editor{ background:#fff; color:#000; margin-top:12px; border-radius:8px; }
    .btns{ display:flex; gap:10px; justify-content:flex-end; margin-top:14px; }
    button{ height:44px; padding:0 16px; border:none; border-radius:8px; font-weight:700; color:#fff;
            background:linear-gradient(135deg,#9b59b6,#e91e63); cursor:pointer; }

             #logo { width:100px; height:100px; }
      #line { border:1px solid #dad9d9; margin-bottom:20px; }
     h1 {
        width:100%;
        height:100%;
        display:flex;
        justify-content:center;
        align-items:center;
    }
            .star,
    .shooting-star {
        position: fixed;
        z-index: 0;
        border-radius: 50%;
    }

    .star {
        animation: twinkle linear infinite;
        background: white;
    }

    @keyframes twinkle {
        0%,100% { opacity:0.1; }
        25% { opacity:0.6; }
        50% { opacity:1; }
        75% { opacity:0.4; }

    }
  </style>
</head>
<body>
  <div class="con">
    <h1><img src="/board/로고.png" id="logo"> 혜빈이와 아이들 </h1>
    <h2>게시판 글쓰기</h2>
    <div id="line"></div>
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
//====== 이미지 압축/리사이즈 설정 ======
  const IMG_MAX_WIDTH = 1280;         // 긴 변 기준 최대 폭
  const JPEG_QUALITY = 0.82;          // 0~1 (품질-용량 트레이드오프)
  const MAX_BASE64_LEN = 8_000_000;   // dataURL 길이 상한(약 8MB, 필요시 조정)

  // WebP 지원여부
  function supportWebP(){
    try {
      const c = document.createElement('canvas');
      return c.toDataURL('image/webp').indexOf('data:image/webp') === 0;
    } catch { return false; }
  }

  // 투명 채널 존재 여부 간이 검사
  function detectAlpha(imgOrCanvas, w, h) {
    const c = document.createElement('canvas');
    c.width = Math.min(64, w);
    c.height = Math.min(64, h);
    const ctx = c.getContext('2d');
    const scale = Math.max(w / c.width, h / c.height);
    // drawImage 인자는 원본이 <img>든 <canvas>든 동일하게 동작
    ctx.drawImage(imgOrCanvas, 0, 0, w, h, 0, 0, c.width, c.height);
    const data = ctx.getImageData(0, 0, c.width, c.height).data;
    for (let i = 3; i < data.length; i += 4) {
      if (data[i] < 255) return true;
    }
    return false;
  }

  // EXIF 회전 보정 시도
  async function loadBitmap(file) {
    if ('createImageBitmap' in window) {
      try {
        return await createImageBitmap(file, { imageOrientation: 'from-image' });
      } catch { /* fallback */ }
    }
    const url = URL.createObjectURL(file);
    const img = new Image();
    img.decoding = 'async';
    img.referrerPolicy = 'no-referrer';
    await new Promise((res, rej) => {
      img.onload = () => res();
      img.onerror = rej;
      img.src = url;
    });
    img.close = () => URL.revokeObjectURL(url);
    return img;
  }

  async function compressToBase64(file) {
    const bmp = await loadBitmap(file);
    const w = bmp.width, h = bmp.height;

    // 리사이즈 비율 계산 (긴 변 기준)
    const scale = Math.min(1, IMG_MAX_WIDTH / Math.max(w, h));
    const outW = Math.round(w * scale);
    const outH = Math.round(h * scale);

    const canvas = document.createElement('canvas');
    canvas.width = outW; canvas.height = outH;
    const ctx = canvas.getContext('2d');
    if ('imageSmoothingQuality' in ctx) ctx.imageSmoothingQuality = 'high';
    ctx.drawImage(bmp, 0, 0, outW, outH);
    if (bmp.close) try { bmp.close(); } catch {}

    const hasAlpha = detectAlpha(canvas, outW, outH);

    // 포맷 선택: 알파 있으면 PNG, 없으면 WebP/ JPEG
    let mime = 'image/jpeg';
    if (hasAlpha) mime = 'image/png';
    else if (supportWebP()) mime = 'image/webp';

    const quality = (mime === 'image/png') ? undefined : JPEG_QUALITY;
    let dataUrl = canvas.toDataURL(mime, quality);

    // 안전장치: 너무 크면 한 번 더 줄이기
    if (dataUrl.length > MAX_BASE64_LEN && mime !== 'image/png') {
      const canvas2 = document.createElement('canvas');
      canvas2.width = Math.round(outW * 0.8);
      canvas2.height = Math.round(outH * 0.8);
      const ctx2 = canvas2.getContext('2d');
      if ('imageSmoothingQuality' in ctx2) ctx2.imageSmoothingQuality = 'high';
      ctx2.drawImage(canvas, 0, 0, canvas2.width, canvas2.height);
      dataUrl = canvas2.toDataURL(mime, Math.max(0.6, (JPEG_QUALITY - 0.1)));
    }
    return dataUrl;
  }



  //====== Toast UI Editor 초기화 (Base64 압축 삽입) ======
  const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '500px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '내용을 입력하세요',
    hooks: {
      addImageBlobHook: async (blob, callback) => {
        try {
          const base64 = await compressToBase64(blob);
          callback(base64, '이미지'); // 압축/리사이즈된 Base64 삽입
        } catch (e) {
          console.error(e);
          alert('이미지 처리 중 오류가 발생했습니다.');
        }
        return false; // 서버 업로드 방지 (Base64만 사용)
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

      document.getElementById('postnameInput').value = title;
      document.getElementById('editorContent').value = html;
      
      if (!title || (!html || html === '<p><br></p>')) {
        alert('제목 또는 내용(텍스트/이미지)을 입력하세요.');
        e.preventDefault();
        return;
      }

      

      submitting = true;
    });

    // 취소: 항상 실제 목록 라우트로 이동 (캐시 영향 최소화)
    document.getElementById('cancel').addEventListener('click', () => {
      const gid = document.querySelector('input[name="gameid"]')?.value || 1;
      location.href = `<c:url value='/game1borad.Game1Controller'/>?gameid=${gid}&ts=${Date.now()}`;
    });
    

 // 별 생성 기능 유지
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


