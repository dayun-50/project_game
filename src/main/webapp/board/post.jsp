<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- TOAST UI Editor CDN -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<style>
    * { box-sizing: border-box; }

    .con {
        border: 1px solid black;
        width: 90%;
        max-width: 1000px;
        margin: auto;
    }

    #editor {
        width: 100%;
        height: 60vh;
        margin: auto;
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
        margin: auto;
        color: #000000;
        padding: 0 10px;
    }

    #postname:empty::before {
        content: "제목을 입력하세요";
        color: #9b9b9b;
        pointer-events: none;
    }

    body {
        background-color: #0c0c1a;
        color: #fff;
        font-family: 'Arial', sans-serif;
        display: flex;
        justify-content: center;
        padding-top: 50px;
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

    #line { border:1px solid #dad9d9; margin-bottom:20px; }

    h1 {
        width:100%;
        height:100%;
        display:flex;
        justify-content:center;
        align-items:center;
    }

    h2 { width:100%; height:100%; }

    #logo { width:100px; height:100px; }

    #postdone, #cancel {
        width:100px;
        height:50px;
        font-weight:bold;
        color:#fff;
        background:linear-gradient(135deg,#9b59b6,#e91e63);
        border:none;
        border-radius:10px;
        cursor:pointer;
        box-shadow:0 0 15px #e91e63, inset 0 0 5px #9b59b6;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .btns {
        display:flex;
        justify-content:flex-end;
        margin-top:15px;
        gap:10px;
    }

    #btnform { display:block; width:100%; }

    form { width:100px; height:30px; font-weight:bold; }

    /* 에디터 이미지가 박스를 벗어나지 않도록 */
    #editor img {
        max-width: 100%;
        height: auto;
        display: block;
        margin: 10px 0;
    }
</style>
</head>

<body>
<div class="con">
    <h1><img src="/board/로고.png" id="logo"> 혜빈이와 아이들 </h1>
    <h2>게시판 글쓰기</h2>
    <div id="line"></div>

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

// 제목과 내용 히든 필드에 복사
document.getElementById('btnform').addEventListener('submit', function(e){
	let title = document.getElementById('postname').innerText.trim();
	let content = editor.getHTML().trim();
	const isEmptyContent = !content || /^<p>(\s|&nbsp;|<br>)*<\/p>$/.test(content);
	
	if(title === "" || isEmptyContent){
		alert("제목과 내용을 모두 입력해주세요!");
		e.preventDefault(); 
		return;
	}
	
	document.getElementById('postnameInput').value = title;
    document.getElementById('editorContent').value = content;
});

// 취소 버튼
document.getElementById('cancel').addEventListener('click', () => {
    window.location.href = "/list.free";
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
