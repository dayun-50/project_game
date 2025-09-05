<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Game Ranker</title>
<style>
    body {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: radial-gradient(ellipse at bottom, #0a0a1a 0%, #050518 100%);
        color: #0ff;
        overflow-x: hidden;
    }

    h1 {
        text-align: center;
        font-size: 3rem;
        margin: 30px 0 20px 0;
        text-shadow: 0 0 20px #0ff, 0 0 40px #0ff;
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

    #mainTable {
        margin: 0 auto 20px auto;
        width: 90%;
        max-width: 800px;
        border-collapse: collapse;
        text-align: center;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
        background: rgba(0, 255, 255, 0.05);
    }

    #mainTable th, #mainTable td {
        padding: 12px;
        border-bottom: 1px solid rgba(0, 255, 255, 0.2);
    }

    #mainTable th {
        font-size: 1.2rem;
        text-shadow: 0 0 10px #0ff;
    }

    #mainTable td:first-child {
        cursor: pointer;
        color: #4c9aff;
        transition: all 0.3s ease;
    }

    #mainTable td:first-child:hover {
        color: #fff;
        text-shadow: 0 0 5px #0ff;
    }

    .tabs {
        display: flex;
        justify-content: center;
        margin: 20px auto;
        max-width: 800px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0, 255, 255, 0.3);
    }

    .tab {
        flex: 1;
        padding: 12px 0;
        text-align: center;
        cursor: pointer;
        font-weight: bold;
        background: linear-gradient(90deg, #1a1a30, #2a2a50);
        transition: all 0.3s ease;
        color: #0ff;
    }

    .tab.active {
        background: linear-gradient(90deg, #4c9aff, #8e5fff);
        color: #fff;
        box-shadow: 0 0 15px #0ff;
    }

    #gameTableContainer {
        width: 90%;
        max-width: 800px;
        margin: 20px auto 40px auto;
        overflow: hidden;
    }

    #gameTable {
        width: 100%;
        border-collapse: collapse;
        text-align: center;
        border-radius: 10px;
        background: rgba(10, 10, 38, 0.8);
        box-shadow: 0 0 20px rgba(0, 255, 255, 0.3);
        transition: transform 2s ease, opacity 2s ease;
    }

    #gameTable th, #gameTable td {
        padding: 12px;
        border-bottom: 1px solid rgba(0, 255, 255, 0.2);
    }

    #gameTable th {
        text-shadow: 0 0 10px #0ff;
    }

    #gameTable tr:hover {
        background: rgba(0, 255, 255, 0.1);
        transform: scale(1.02);
    }

    .pagination {
        text-align: center;
        margin-bottom: 40px;
    }

    .pagination span {
        margin: 0 5px;
        cursor: pointer;
        color: #0ff;
        transition: all 0.3s ease;
    }

    .pagination span.active {
        text-decoration: underline;
        font-weight: bold;
        color: #4c9aff;
        transform: scale(1.2);
    }
    
    
 
</style>
</head>

<body>
<h1>Game Ranker</h1>

<table id="mainTable">
    <tr>
        <th>Game Name</th>
        <th>Nick Name</th>
        <th>Score</th>
    </tr>
      <c:forEach var="rank" items="${rankshow}">
    <tr>
    <td>${rank.gameName}</td>
        <td>${nickname }</td>
    <td>${rank.score}</td>
    </tr>
    </c:forEach>  
</table>

<div class="tabs">
    <div class="tab active" onclick="showGame(1)">Game 1
    </div>
    <div class="tab" onclick="showGame(2)">Game 2</div>
    <div class="tab" onclick="showGame(3)">Game 3</div>
    <div class="tab" onclick="showGame(4)">Game 4</div>
</div>
<div id="gameTableContainer">
    <table id="gameTable">
        <tr>
            <th>Nick Name</th>
            <th>Score</th>
        </tr>
         <c:forEach var="rank" items="${ranklist}">
    <tr>
      <td>${rank.user_name}</td>
      <td>${rank.score}</td>
    </tr>
 	 </c:forEach>

    </table>
</div>

<div class="pagination" id="pagination"></div>

<script>
const allRanks = [
	  <c:forEach var="rank" items="${ranklist}" varStatus="loop">
	    { gameId: ${rank.game_id}, nick: "${rank.user_name}", score: ${rank.score} }<c:if test="${!loop.last}">,</c:if>
	  </c:forEach>
	];

const gameData = [1, 2, 3, 4].map(id => allRanks.filter(r => r.gameId == id));

console.log("GameData:", gameData); // 디버깅용


const rowsPerPage = 5;
let currentPage = 1;
let currentGame = 1;

function renderTable() {
    const table = document.getElementById('gameTable');
    
    table.style.opacity = 0;
    setTimeout(() => {
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const data = gameData[currentGame - 1].slice(start, end);

        // ✅ header는 항상 고정
        let header = "<tr><th>Nick Name</th><th>Score</th></tr>";
        let rows = "";
        data.forEach(row => {
            console.log("Row check:", row.nick, row.score); // ✅ 여기서 찍기
            rows += `<tr><td>\${row.nick}</td><td>\${row.score}</td></tr>`;
        });

        table.innerHTML = header + rows;

        table.style.opacity = 1;

        renderPagination(); // 페이지네이션도 여기서 호출
    }, 1000);
}


function renderPagination() {
    const totalPages = Math.ceil(gameData[currentGame - 1].length / rowsPerPage);
    const pagination = document.getElementById('pagination');
    let html = '';
    for (let i = 1; i <= totalPages; i++) {
        html += '<span class="' + (i === currentPage ? 'active' : '') +
                '" onclick="goPage(' + i + ')">' + i + '</span>';
    }
    pagination.innerHTML = html;
}

function goPage(page) {
    currentPage = page;
    renderTable();
}

function showGame(index) {
    currentGame = index;
    currentPage = 1;

    document.querySelectorAll('.tab').forEach((tab, i) => {
        tab.classList.toggle('active', i === index - 1);
    });
    renderTable();
}

// 초기 로딩
renderTable();

// 별 배경
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
