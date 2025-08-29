<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<fieldset>
<legend>파일업로드</legend>
<form action="/upload.files" method="post" enctype="multipart/form-data">
<input type="text" name="sender" placeholder="파일 업로드 하는 사람의 이름"/><br />
<input type="file" name="file" /><br />
<input type="submit" value="업로드" />

</fieldset>
</form>

<button id="listfiles">목록 불러오기 </button>

<fieldset>
<legend>파일 목록</legend>
<div id="list"> 
<c:forEach var="file" items="${list}">

<div>${file.seq}. <a href="/download.files?sysname=${file.sysName}&oriname=${file.oriName}">${file.oriName}</a> </div>

</c:forEach>

</div>
</fieldset>

<script>
$("#listfiles").on("click",function(){
$.ajax({
    url:"list.files",
    method:"GET",
    dataType:"json"
}).done(function(result){
    console.log(result);
    $("#list").empty();
    result.forEach(file => {
        let line = $("<div>");
        let a = $("<a>");
        a.attr("href","/download.files?sysname="+file.sysName+"&oriname="+file.oriName);
        a.text(file.oriName);
        line.append(file.seq + ". ").append(a);
        $("#list").append(line);
    });
});
})

</script>

</body>
</html>