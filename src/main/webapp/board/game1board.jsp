<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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

        h2 {
            color: #ff9800;
            font-size: 2em;
            margin-bottom: 20px;
            border-bottom: 1px solid #3c3c5c;
            padding-bottom: 10px;
        }

        .meta-info {
            color: #b276d1;
            margin-bottom: 20px;
        }

        pre {
            background: rgba(50, 50, 80, 0.8);
            border: 1px solid #5e72be;
            border-radius: 10px;
            padding: 20px;
            color: #e0e8ff;
            white-space: pre-wrap;
        }

        .btn-back,
        .btn-edit,
        .btn-delete {
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

        .btn-back:hover,
        .btn-edit:hover,
        .btn-delete:hover {
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

        .comment-section {
            margin-top: 30px;
            border-top: 1px solid #3c3c5c;
            padding-top: 20px;
        }

        .comment-list {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
        }

        .comment-item {
            border-bottom: 1px solid #3c1f5c;
            padding: 10px 0;
        }

        .comment-meta {
            font-size: 0.9em;
            color: #b276d1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .comment-contents {
            color: #e0e8ff;
        }

        .comment-actions button {
            background: none;
            border: none;
            color: #87CEEB;
            cursor: pointer;
            font-weight: 600;
            padding: 0;
            margin: 0 5px;
        }

        .comment-actions button:hover {
            text-decoration: underline;
        }

        .comment-form textarea {
            width: 100%;
            height: 80px;
            border-radius: 8px;
            border: 1px solid #5e72be;
            padding: 10px;
            background: rgba(30, 30, 60, 0.8);
            color: #fff;
            font-family: 'Arial', sans-serif;
        }

        .comment-form button {
            margin-top: 10px;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            font-weight: bold;
            background: linear-gradient(135deg, #9b59b6, #e91e63);
            color: #fff;
            cursor: pointer;
            box-shadow: 0 0 15px #e91e63, inset 0 0 5px #9b59b6;
        }

        .comment-form button:hover {
            transform: scale(1.05);
            box-shadow: 0 0 25px #e91e63, 0 0 50px #9b59b6;
        }

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
        <h2>샘플 게시글 제목</h2>
        <div class="meta-info">
            <span>작성자: <strong>홍길동</strong></span> &nbsp;|&nbsp;
            <span>작성일: 2025-08-29</span> &nbsp;|&nbsp;
            <span>조회수: 123</span>
        </div>

        <pre>
샘플 게시글 내용입니다.
여러 줄의 내용도 표시됩니다.
        </pre>

        <button class="btn-back">목록으로</button>
        <button class="btn-edit">수정하기</button>
        <button class="btn-delete">삭제하기</button>

        <div class="comment-section">
            <h4>댓글 <small>(2)</small></h4>

            <div class="comment-list">
                <div class="comment-item">
                    <div class="comment-meta">
                        <div>홍길동 | 2025-08-29</div>
                        <div class="comment-actions">
                            <button>수정</button>
                            <button>삭제</button>
                        </div>
                    </div>
                    <div class="comment-contents">샘플 댓글 내용입니다.</div>
                </div>
                <div class="comment-item">
                    <div class="comment-meta">
                        <div>김철수 | 2025-08-28</div>
                        <div class="comment-actions">
                            <button>수정</button>
                            <button>삭제</button>
                        </div>
                    </div>
                    <div class="comment-contents">두 번째 샘플 댓글입니다.</div>
                </div>
            </div>

            <form class="comment-form">
                <textarea placeholder="댓글을 입력하세요..." required></textarea>
                <button type="submit">댓글 등록</button>
            </form>
        </div>
    </div>

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
    </script>
</body>
</html>