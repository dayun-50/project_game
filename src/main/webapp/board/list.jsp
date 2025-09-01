<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<h1>자유게시판</h1>
<table border="1">
    <thead>
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty list}">
                <c:set var="num" value="${fn:length(list)}" />
                <c:forEach var="dto" items="${list}">
                    <tr>
                        <td>${num}</td>
                        <td><a href="detail.free?id=${dto.fb_id}">${dto.fb_Title}</a></td>
                        <td>${dto.fb_user_name}</td>
                        <td>${dto.fb_date}</td>
                    </tr>
                    <c:set var="num" value="${num - 1}" />
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="4" style="text-align:center;">게시물이 없습니다.</td></tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<form action="/post.free" method="get">
    <button>글작성</button>
</form>
