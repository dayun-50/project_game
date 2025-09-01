<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<form action="update.free" method="post">
    <input type="hidden" name="id" value="${dto.fb_id}">
    제목: <input type="text" name="title" value="${dto.fb_Title}"><br>
    내용: <textarea name="write" rows="10" cols="50">${dto.fb_write}</textarea><br>
    <button type="submit">수정완료</button>
</form>
<a href="detail.free?id=${dto.fb_id}">취소</a>
