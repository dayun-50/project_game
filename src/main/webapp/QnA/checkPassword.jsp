<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<style>
body { background-color: #0c0c1a; color: #fff; font-family: Arial, sans-serif; display:flex; justify-content:center; align-items:center; height:100vh; }
form { display:flex; flex-direction:column; gap:10px; background: rgba(20,20,40,0.95); padding:30px; border-radius:10px; width:300px; }
input { padding:10px; border-radius:5px; border:none; font-size:16px; }
button { padding:10px; border:none; border-radius:5px; background:linear-gradient(135deg,#9b59b6,#e91e63); color:#fff; cursor:pointer; font-weight:bold; }
</style>
</head>
<body>
<form action="detailCheck.qna" method="post">
    <input type="hidden" name="id" value="${inqu_id}" />
    <label>비밀번호를 입력하세요:</label>
    <input type="password" name="pw" required />
    <button type="submit">확인</button>
</form>
</body>
</html>
