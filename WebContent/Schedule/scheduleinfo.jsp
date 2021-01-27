<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
String ilocation = request.getParameter("ilocation");
String usernames= request.getParameter("usernames");
String title = request.getParameter("title2");
String memo = request.getParameter("memo2");
String datetime = request.getParameter("datetime");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>최종 스케줄 출력화면</title>
<link rel="stylesheet" type="text/css" href="../css/Schedule_Info.css">
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap"
	rel="stylesheet">
	
</head>
<body>
<center>
  <div id="header" name="header">
		    	<h1><input type=image src="moimlogo2.PNG" width="50px;" height="50px"/>
		    	Moim</h1>
<a href="">메인</a> | 
<a href="">스케줄</a> | 
<a href="">모임관리</a> | 
<a href="">마이페이지</a> | 
<a href="">게시판</a>

<%-- 
<form action="<%=request.getContextPath()%>/login/login_pro.jsp" method="post"><input type ="submit" value = "로그인">

</form>
 --%>

<hr>			   
		 </div>
<div id="div2" name="div2">
	
		<h1>최종 스케줄 출력화면</H1>
<form action="matjiplist.jsp" method="post" accept-charset="UTF-8">
	<table>
		<tr>
			<td align="center"> 제목   :</td>
			<td align="center"><input type="text" id="title" name="title" value="<%=title %>" style="text-align: center"></td>		
			</tr>
				<tr>
			<td align="center"> 메모   :</td>
			<td align="center"><input type="text" id="memo" name="memo" value="<%=memo %>" style="text-align: center"></td>		
			</tr>
	
		<tr>
			<td align="center"> 참여자   :</td>
			<td align="center"><input type="text" id="usernames" name="usernames" value="<%=usernames %>" style="text-align: center"></td>		
			</tr>
		<tr>
			<td align="center">시간   :</td>
		<td align="center"><input type="text" id="datetime" name="datetime" value="<%=datetime %>" style="text-align: center"></td>
		</tr>
		
		<tr>
			<td align="center">장소   :</td>
				
			<td align="center"><input type="text" id="ilocation2" name="ilocation2" value="<%=ilocation %>" style="text-align: center"></td>

		</tr>





	</table>
	
	</br>
	<button onclick="" value="주변맛집 검색" id="button1" class="button1">주변맛집 검색</button>
</form>
<input type="button" id=matjiplist name=matjiplist value="스케줄 저장"/>
<input type="button" id=matjiplist name=matjiplist value="돌아가기"/>




<hr>	

         <div id="footer">
		    	
		    	<h1>Moim Project</h1>
    <p>Copyright © 2020 moimproject.co.,Ltd. All rights reserved.</p>
    <address>Contact hoseong for more information. 010-5268-1254</address>


</center>

		   
		 </div>


		
		
</body>
</html>