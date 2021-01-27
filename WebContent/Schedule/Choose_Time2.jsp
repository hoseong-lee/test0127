<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시간 설정</title>

<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../css/choosetime2.css">

</head>
<body>
<div>
<jsp:include page="top.jsp"></jsp:include>
</div>

<center>


<div id="div2" name="div2">
<form action="Midpoint_Setting.jsp" method="post">
<h1 align="center">스케줄 설정</h1>


<table align='center'>
<tr>
<td align='center'>
<h2 id="h1">날짜 선택</h2>
<input type="datetime-local" name="datetime" id="datetime"/>

<br/>


<tr>
<td align='center'>


<h2 id="h1">제목</h2>
<textarea rows="30" cols="50" name="title" class="title" id="title"></textarea>
<h2 id="h1">메모</h2>
<textarea rows="30" cols="50" name="memo" class="memo" id="memo"></textarea>

</td>
</tr>
<tr>

<td align='center'>

<button onclick="">중간지점 찾기</button>
</form>
<br/>
<input type='reset'/>
</td>
</tr>
</center>
</table>

</form>
</div>

<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>