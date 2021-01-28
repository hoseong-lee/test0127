<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
String lat = request.getParameter("ilocationlat1");
String lon = request.getParameter("ilocationlon1");
String username1 = request.getParameter("select1");
String username2 = request.getParameter("select2");
String username3 = request.getParameter("select3");
String datetime = request.getParameter("datetime");
String title = request.getParameter("title");
String memo = request.getParameter("memo");

String lon1 = request.getParameter("lon1");
String lon2 = request.getParameter("lon2");
String lon3 = request.getParameter("lon3");
String lat1 = request.getParameter("lat1");
String lat2 = request.getParameter("lat2");
String lat3 = request.getParameter("lat3");

%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>중간지점 출력 화면</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/Midpoint_print.css">
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap"
	rel="stylesheet">
<script
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=l7xx2ebd1e5483b84cd088c3e9f79d3b2b36"></script>
<script type="text/javascript">
	var map, marker, marker_s, marker_e;
	function initTmap() {

		// 1. 지도 띄우기
		map = new Tmapv2.Map("map_div", {
			center : new Tmapv2.LatLng(
<%=lat%>
	,
<%=lon%>
	),
			width : "50%",
			height : "400px",
			zoom : 15,
			zoomControl : true,
			scrollwheel : true

		});

	
		
		
		
		
		
		
		
		
		// 마커 초기화
		marker1 = new Tmapv2.Marker(
				{
					icon : "moimlogo.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});

		// 2. API 사용요청
		var lon, lat;

		map
				.addListener(
						"click",
						function onClick(evt) {
							var mapLatLng = evt.latLng;

							//기존 마커 삭제
							marker1.setMap(null);

							var markerPosition = new Tmapv2.LatLng(
									mapLatLng._lat, mapLatLng._lng);
							//마커 올리기
							marker1 = new Tmapv2.Marker(
									{
										position : markerPosition,
										icon : "moimlogo.png",
										iconSize : new Tmapv2.Size(24, 38),
										map : map
									});

							reverseGeo(mapLatLng._lng, mapLatLng._lat);
						});

		function reverseGeo(lon, lat) {
			$
					.ajax({
						method : "GET",
						url : "https://apis.openapi.sk.com/tmap/geo/reversegeocoding?version=1&format=json&callback=result",
						async : false,
						data : {
							"appKey" : "l7xx2ebd1e5483b84cd088c3e9f79d3b2b36",
							"coordType" : "WGS84GEO",
							"addressType" : "A10",
							"lon" : lon,
							"lat" : lat
						},
						success : function(response) {
							// 3. json에서 주소 파싱
							var arrResult = response.addressInfo;

							//법정동 마지막 문자 
							var lastLegal = arrResult.legalDong
									.charAt(arrResult.legalDong.length - 1);

							// 새주소
							newRoadAddr = arrResult.city_do + ' '
									+ arrResult.gu_gun + ' ';

							if (arrResult.eup_myun == ''
									&& (lastLegal == "읍" || lastLegal == "면")) {//읍면
								newRoadAddr += arrResult.legalDong;
							} else {
								newRoadAddr += arrResult.eup_myun;
							}
							newRoadAddr += ' ' + arrResult.roadName + ' '
									+ arrResult.buildingIndex;

							// 새주소 법정동& 건물명 체크
							if (arrResult.legalDong != ''
									&& (lastLegal != "읍" && lastLegal != "면")) {//법정동과 읍면이 같은 경우

								if (arrResult.buildingName != '') {//빌딩명 존재하는 경우
									newRoadAddr += (' (' + arrResult.legalDong
											+ ', ' + arrResult.buildingName + ') ');
								} else {
									newRoadAddr += (' (' + arrResult.legalDong + ')');
								}
							} else if (arrResult.buildingName != '') {//빌딩명만 존재하는 경우
								newRoadAddr += (' (' + arrResult.buildingName + ') ');
							}

							// 구주소
							jibunAddr = arrResult.city_do + ' '
									+ arrResult.gu_gun + ' '
									+ arrResult.legalDong + ' ' + arrResult.ri
									+ ' ' + arrResult.bunji;
							//구주소 빌딩명 존재
							if (arrResult.buildingName != '') {//빌딩명만 존재하는 경우
								jibunAddr += (' ' + arrResult.buildingName);
							}

							result = "새주소 : " + newRoadAddr + "</br>";
							result += "지번주소 : " + jibunAddr + "</br>";
							result += "위경도좌표 : " + lat + ", " + lon;

							var resultDiv = document.getElementById("result");
							resultDiv.innerHTML = result;
							$('#ilocation').val(jibunAddr);

						},
						error : function(request, status, error) {
							console.log("code:" + request.status + "\n"
									+ "message:" + request.responseText + "\n"
									+ "error:" + error);
						}
					});

		}
	
		
		//1번째 장소
		marker_1 = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(<%=lat1%>, <%=lon1%>),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_1.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});

		//2번째 장소
		marker_2 = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(<%=lat2%>, <%=lon2%>),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_2.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		//3번째 장소
		marker_3 = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(<%=lat3%>, <%=lon3%>),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_w_m_3.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		
		marker_4 = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(<%=lat%>, <%=lon%>),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_g_m_p.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		
		new Tmapv2.extension.MeasureDistance({
			map: map
        });
	
	}
</script>
</head>
<center>
	<body onload="initTmap();">
			
  <div id="header" name="header">
		    	<h1><input type=image src="moimlogo2.PNG" width="50px;" height="50px"/>
		    	Moim</h1>
<a href="<%= request.getContextPath() %>/user/user_insert_form.jsp">메인</a> | 
<a href="<%= request.getContextPath() %>/user/user_list.jsp">스케줄</a> | 
<a href="#">모임관리</a> | 
<a href="#">마이페이지</a> | 
<a href="#">게시판</a>

<%-- 
<form action="<%=request.getContextPath()%>/login/login_pro.jsp" method="post"><input type ="submit" value = "로그인">

</form>
 --%>
 </center>
<hr>			   
		 </div>
		 		<center>
		<h1>중간지점 출력 화면</h1>
		<p id="result"></p>
		<div id="map_wrap" class="map_wrap3">
			<div id="map_div"></div>
		</div>
		<div class="map_act_btn_wrap clear_box"></div>
		<br />
<!-- <input type="button" id="mapbutton" onclick="map_button();" value="거리 구하기"/>
 -->			<form action="scheduleinfo.jsp" method="post" accept-charset="UTF-8">
				
				
	
				<table>
						<tr align="center">
			<td align="center">
			<label>시간 : </label>
			<input type="text" class="datetime" id="datetime" name="datetime" style="text-align: center"
				value="<%=datetime %>"	size="40" />
			</td>
			</tr>
				
				
					<tr align="center">
			<td align="center">
			<label>장소 : </label>
			<input type="text" class="ilocation" id="ilocation" name="ilocation" style="text-align: center"
					size="40" />
			</td>
			</tr>
			<tr align="center">
			
					<td align="center">
						<label>인원 :</label>
						<input type="text" id="usernames" name="usernames" 
							size="40" value="<%=username1%>,<%=username2%>,<%=username3%>" style="text-align: center"/>
						</td>
					</tr>
					<tr>
					<td></td>
					<td></td>
					</tr>
					<tr align="center">
					<td colspan="2">
				<button onclick="">최종 스케줄 출력</button>
				</td>
				</tr>
				</table>
				<tr>
<td>


	<input type="text" id="memo2" name="memo2" class="memo"
							size="40" value="<%=memo %>" style="text-align: center"/> 
				<input type="text" id="title2" name="title2" class="memo" 
							size="40" value="<%=title%>" style="text-align: center"/> 
							</td>
							</tr>
				</form>
				</div>
				
				
				<hr>	

         <div id="footer">
		    	
		    	<h1>Moim Project</h1>
    <p>Copyright © 2020 moimproject.co.,Ltd. All rights reserved.</p>
    <address>Contact hoseong for more information. 010-5268-1254</address>


		   
		 </div>
		</center>
	</body>
</html>