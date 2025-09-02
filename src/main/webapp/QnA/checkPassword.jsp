<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
</head>
<body>
<h2>게시글 비밀번호 확인</h2>
<form action="checkPassword.qna" method="post">
    <input type="hidden" name="id" value="${id}">
    비밀번호(4자리): <input type="password" name="password" maxlength="4" pattern="\d{4}" required /><br>
    <input type="submit" value="확인">
</form>
</body>
</html>
