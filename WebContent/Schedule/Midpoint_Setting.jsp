<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- <%@include file='dbConn.jspf' %> --%>
<%
request.setCharacterEncoding("UTF-8");
String datetime = request.getParameter("datetime");
String title = request.getParameter("title");
String memo = request.getParameter("memo");


%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>중간지점 구하기 Midpoint - Moim project</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/choosetime.css">
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap"
	rel="stylesheet">
<script
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=l7xx2ebd1e5483b84cd088c3e9f79d3b2b36"></script>
<script type="text/javascript">

			var map, marker1;
			function initTmap() {
		
				// 1. 지도 띄우기
				map = new Tmapv2.Map("map_div", {
					center : new Tmapv2.LatLng(37.570028, 126.986072),
					width : "50%",
					height : "400px",
					zoom : 15,
					zoomControl : true,
					scrollwheel : true
		
				});
				// 마커 초기화
				marker1 = new Tmapv2.Marker(
					{
						icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
						iconSize : new Tmapv2.Size(24, 38),
						map : map
					});
		
				$("#btn_select").click(function() {
					// 2. API 사용요청
					var fullAddr = $("#fullAddr").val();
					$.ajax({
						method : "GET",
						url : "https://apis.openapi.sk.com/tmap/geo/fullAddrGeo?version=1&format=json&callback=result",
						async : false,
						data : {
							"appKey" : "l7xx2ebd1e5483b84cd088c3e9f79d3b2b36",
							"coordType" : "WGS84GEO",
							"fullAddr" : fullAddr
						},
						success : function(response) {

							var resultInfo = response.coordinateInfo; // .coordinate[0];
							console.log(resultInfo);
							
							// 기존 마커 삭제
							marker1.setMap(null);
							
							// 3.마커 찍기
							// 검색 결과 정보가 없을 때 처리
							if (resultInfo.coordinate.length == 0) {
								$("#result").text(
								"요청 데이터가 올바르지 않습니다.");
							} else {
								var lon, lat;
								var resultCoordinate = resultInfo.coordinate[0];
								if (resultCoordinate.lon.length > 0) {
									// 구주소
									lon = resultCoordinate.lon;
									lat = resultCoordinate.lat;
								} else { 
									// 신주소
									lon = resultCoordinate.newLon;
									lat = resultCoordinate.newLat
								}
							
								var lonEntr, latEntr;
								
								if (resultCoordinate.lonEntr == undefined && resultCoordinate.newLonEntr == undefined) {
									lonEntr = 0;
									latEntr = 0;
								} else {
									if (resultCoordinate.lonEntr.length > 0) {
										lonEntr = resultCoordinate.lonEntr;
										latEntr = resultCoordinate.latEntr;
									} else {
										lonEntr = resultCoordinate.newLonEntr;
										latEntr = resultCoordinate.newLatEntr;
									}
								}
									
								var markerPosition = new Tmapv2.LatLng(Number(lat),Number(lon));
								
								// 마커 올리기
								marker1 = new Tmapv2.Marker(
									{
										position : markerPosition,
										icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
										iconSize : new Tmapv2.Size(
										24, 38),
										map : map
									});
								map.setCenter(markerPosition);
								
								// 검색 결과 표출
								var matchFlag, newMatchFlag;
								// 검색 결과 주소를 담을 변수
								var address = '', newAddress = '';
								var city, gu_gun, eup_myun, legalDong, adminDong, ri, bunji;
								var buildingName, buildingDong, newRoadName, newBuildingIndex, newBuildingName, newBuildingDong;
								
								// 새주소일 때 검색 결과 표출
								// 새주소인 경우 matchFlag가 아닌
								// newMatchFlag가 응답값으로
								// 온다
								if (resultCoordinate.newMatchFlag.length > 0) {
									// 새(도로명) 주소 좌표 매칭
									// 구분 코드
									newMatchFlag = resultCoordinate.newMatchFlag;
									
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										newAddress += city + "\n";
									}
									
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										newAddress += gu_gun + "\n";
									}
									
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										newAddress += eup_myun + "\n";
									} else {
										// 출력 좌표에 해당하는
										// 법정동 명칭
										if (resultCoordinate.legalDong.length > 0) {
											legalDong = resultCoordinate.legalDong;
											newAddress += legalDong + "\n";
										}
										// 출력 좌표에 해당하는
										// 행정동 명칭
										if (resultCoordinate.adminDong.length > 0) {
											adminDong = resultCoordinate.adminDong;
											newAddress += adminDong + "\n";
										}
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										newAddress += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										newAddress += bunji + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 길 이름을 반환
									if (resultCoordinate.newRoadName.length > 0) {
										newRoadName = resultCoordinate.newRoadName;
										newAddress += newRoadName + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 번호를 반환
									if (resultCoordinate.newBuildingIndex.length > 0) {
										newBuildingIndex = resultCoordinate.newBuildingIndex;
										newAddress += newBuildingIndex + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 이름를 반환
									if (resultCoordinate.newBuildingName.length > 0) {
										newBuildingName = resultCoordinate.newBuildingName;
										newAddress += newBuildingName + "\n";
									}
									// 새주소 건물을 매칭한 경우
									// 새주소 건물 동을 반환
									if (resultCoordinate.newBuildingDong.length > 0) {
										newBuildingDong = resultCoordinate.newBuildingDong;
										newAddress += newBuildingDong + "\n";
									}
									
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(중심점) : " + lat + ", " + lon + "</br>위경도좌표(입구점) : " + latEntr + ", " + lonEntr;
										$("#result").html(text);
										$('#lat1').val(lat);
										$('#lon1').val(lon);
										
									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result").html(text);

									}
								}
								
								// 구주소일 때 검색 결과 표출
								// 구주소인 경우 newMatchFlag가
								// 아닌 MatchFlag가 응닶값으로
								// 온다
								if (resultCoordinate.matchFlag.length > 0) {
									// 매칭 구분 코드
									matchFlag = resultCoordinate.matchFlag;
								
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										address += city + "\n";
									}
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										address += gu_gun+ "\n";
									}
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										address += eup_myun + "\n";
									}
									// 출력 좌표에 해당하는 법정동
									// 명칭
									if (resultCoordinate.legalDong.length > 0) {
										legalDong = resultCoordinate.legalDong;
										address += legalDong + "\n";
									}
									// 출력 좌표에 해당하는 행정동
									// 명칭
									if (resultCoordinate.adminDong.length > 0) {
										adminDong = resultCoordinate.adminDong;
										address += adminDong + "\n";
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										address += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										address += bunji + "\n";
									}
									// 출력 좌표에 해당하는 건물 이름
									// 명칭
									if (resultCoordinate.buildingName.length > 0) {
										buildingName = resultCoordinate.buildingName;
										address += buildingName + "\n";
									}
									// 출력 좌표에 해당하는 건물 동을
									// 명칭
									if (resultCoordinate.buildingDong.length > 0) {
										buildingDong = resultCoordinate.buildingDong;
										address += buildingDong + "\n";
									}
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(중심점) : "+ lat+ ", "+ lon+ "</br>"+ "위경도좌표(입구점) : "+ latEntr+ ", "+ lonEntr;
										$("#result").html(text);
										$('#lat1').val(lat);
										$('#lon1').val(lon);
										var input = $('#lat1').val;
										$('#ilocation').val(lat);
									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result").html(text);
									}
								}
							}
						},
						error : function(request, status, error) {
							console.log(request);
							console.log("code:"+request.status + "\n message:" + request.responseText +"\n error:" + error);
							// 에러가 발생하면 맵을 초기화함
							// markerStartLayer.clearMarkers();
							// 마커초기화
							map.setCenter(new Tmapv2.LatLng(37.570028, 126.986072));
							$("#result").html("");
						
						}
					});
				});
		
			}
			function initTmap2() {
				
		
				// 마커 초기화
				marker1 = new Tmapv2.Marker(
					{
						icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
						iconSize : new Tmapv2.Size(24, 38),
						map : map
					});
		
				$("#btn_select2").click(function() {
					// 2. API 사용요청
					var fullAddr = $("#fullAddr2").val();
					$.ajax({
						method : "GET",
						url : "https://apis.openapi.sk.com/tmap/geo/fullAddrGeo?version=1&format=json&callback=result",
						async : false,
						data : {
							"appKey" : "l7xx2ebd1e5483b84cd088c3e9f79d3b2b36",
							"coordType" : "WGS84GEO",
							"fullAddr" : fullAddr
						},
						success : function(response) {

							var resultInfo = response.coordinateInfo; // .coordinate[0];
							console.log(resultInfo);
							
							// 기존 마커 삭제
							marker1.setMap(null);
							
							// 3.마커 찍기
							// 검색 결과 정보가 없을 때 처리
							if (resultInfo.coordinate.length == 0) {
								$("#result2").text(
								"요청 데이터가 올바르지 않습니다.");
							} else {
								var lon2, lat2;
								var resultCoordinate = resultInfo.coordinate[0];
								if (resultCoordinate.lon.length > 0) {
									// 구주소
									lon2 = resultCoordinate.lon;
									lat2 = resultCoordinate.lat;
								} else { 
									// 신주소
									lon2 = resultCoordinate.newLon;
									lat2 = resultCoordinate.newLat;
								}
							
								var lonEntr, latEntr;
								
								if (resultCoordinate.lonEntr == undefined && resultCoordinate.newLonEntr == undefined) {
									lonEntr = 0;
									latEntr = 0;
								} else {
									if (resultCoordinate.lonEntr.length > 0) {
										lonEntr = resultCoordinate.lonEntr;
										latEntr = resultCoordinate.latEntr;
									} else {
										lonEntr = resultCoordinate.newLonEntr;
										latEntr = resultCoordinate.newLatEntr;
									}
								}
									
								var markerPosition = new Tmapv2.LatLng(Number(lat2),Number(lon2));
								
								// 마커 올리기
								marker1 = new Tmapv2.Marker(
									{
										position : markerPosition,
										icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
										iconSize : new Tmapv2.Size(
										24, 38),
										map : map
									});
								map.setCenter(markerPosition);
								
								// 검색 결과 표출
								var matchFlag, newMatchFlag;
								// 검색 결과 주소를 담을 변수
								var address = '', newAddress = '';
								var city, gu_gun, eup_myun, legalDong, adminDong, ri, bunji;
								var buildingName, buildingDong, newRoadName, newBuildingIndex, newBuildingName, newBuildingDong;
								
								// 새주소일 때 검색 결과 표출
								// 새주소인 경우 matchFlag가 아닌
								// newMatchFlag가 응답값으로
								// 온다
								if (resultCoordinate.newMatchFlag.length > 0) {
									// 새(도로명) 주소 좌표 매칭
									// 구분 코드
									newMatchFlag = resultCoordinate.newMatchFlag;
									
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										newAddress += city + "\n";
									}
									
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										newAddress += gu_gun + "\n";
									}
									
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										newAddress += eup_myun + "\n";
									} else {
										// 출력 좌표에 해당하는
										// 법정동 명칭
										if (resultCoordinate.legalDong.length > 0) {
											legalDong = resultCoordinate.legalDong;
											newAddress += legalDong + "\n";
										}
										// 출력 좌표에 해당하는
										// 행정동 명칭
										if (resultCoordinate.adminDong.length > 0) {
											adminDong = resultCoordinate.adminDong;
											newAddress += adminDong + "\n";
										}
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										newAddress += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										newAddress += bunji + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 길 이름을 반환
									if (resultCoordinate.newRoadName.length > 0) {
										newRoadName = resultCoordinate.newRoadName;
										newAddress += newRoadName + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 번호를 반환
									if (resultCoordinate.newBuildingIndex.length > 0) {
										newBuildingIndex = resultCoordinate.newBuildingIndex;
										newAddress += newBuildingIndex + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 이름를 반환
									if (resultCoordinate.newBuildingName.length > 0) {
										newBuildingName = resultCoordinate.newBuildingName;
										newAddress += newBuildingName + "\n";
									}
									// 새주소 건물을 매칭한 경우
									// 새주소 건물 동을 반환
									if (resultCoordinate.newBuildingDong.length > 0) {
										newBuildingDong = resultCoordinate.newBuildingDong;
										newAddress += newBuildingDong + "\n";
									}
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(중심점) : " + lat2 + ", " + lon2 + "</br>위경도좌표(입구점) : " + latEntr + ", " + lonEntr;
										$("#result2").html(text);
										$('#lat2').val(lat2);
										$('#lon2').val(lon2);

									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result2").html(text);
									}
								}
								
								// 구주소일 때 검색 결과 표출
								// 구주소인 경우 newMatchFlag가
								// 아닌 MatchFlag가 응닶값으로
								// 온다
								if (resultCoordinate.matchFlag.length > 0) {
									// 매칭 구분 코드
									matchFlag = resultCoordinate.matchFlag;
								
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										address += city + "\n";
									}
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										address += gu_gun+ "\n";
									}
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										address += eup_myun + "\n";
									}
									// 출력 좌표에 해당하는 법정동
									// 명칭
									if (resultCoordinate.legalDong.length > 0) {
										legalDong = resultCoordinate.legalDong;
										address += legalDong + "\n";
									}
									// 출력 좌표에 해당하는 행정동
									// 명칭
									if (resultCoordinate.adminDong.length > 0) {
										adminDong = resultCoordinate.adminDong;
										address += adminDong + "\n";
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										address += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										address += bunji + "\n";
									}
									// 출력 좌표에 해당하는 건물 이름
									// 명칭
									if (resultCoordinate.buildingName.length > 0) {
										buildingName = resultCoordinate.buildingName;
										address += buildingName + "\n";
									}
									// 출력 좌표에 해당하는 건물 동을
									// 명칭
									if (resultCoordinate.buildingDong.length > 0) {
										buildingDong = resultCoordinate.buildingDong;
										address += buildingDong + "\n";
									}
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(중심점) : "+ lat2+ ", "+ lon2+ "</br>"+ "위경도좌표(입구점) : "+ latEntr+ ", "+ lonEntr;
										$("#result2").html(text);
										$('#lat2').val(lat2);
										$('#lon2').val(lon2);
									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result2").html(text);
									}
								}
							}
						},
						error : function(request, status, error) {
							console.log(request);
							console.log("code:"+request.status + "\n message:" + request.responseText +"\n error:" + error);
							// 에러가 발생하면 맵을 초기화함
							// markerStartLayer.clearMarkers();
							// 마커초기화
							map.setCenter(new Tmapv2.LatLng(37.570028, 126.986072));
							$("#result2").html("");
						
						}
					});
				});
		
			}
			function initTmap3() {
				
	
				// 마커 초기화
				marker1 = new Tmapv2.Marker(
					{
						icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
						iconSize : new Tmapv2.Size(24, 38),
						map : map
					});
		
				$("#btn_select3").click(function() {
					// 2. API 사용요청
					var fullAddr = $("#fullAddr3").val();
					$.ajax({
						method : "GET",
						url : "https://apis.openapi.sk.com/tmap/geo/fullAddrGeo?version=1&format=json&callback=result",
						async : false,
						data : {
							"appKey" : "l7xx2ebd1e5483b84cd088c3e9f79d3b2b36",
							"coordType" : "WGS84GEO",
							"fullAddr" : fullAddr
						},
						success : function(response) {

							var resultInfo = response.coordinateInfo; // .coordinate[0];
							console.log(resultInfo);
							
							// 기존 마커 삭제
							marker1.setMap(null);
							
							// 3.마커 찍기
							// 검색 결과 정보가 없을 때 처리
							if (resultInfo.coordinate.length == 0) {
								$("#result").text(
								"요청 데이터가 올바르지 않습니다.");
							} else {
								var lon3, lat3;
								var resultCoordinate = resultInfo.coordinate[0];
								if (resultCoordinate.lon.length > 0) {
									// 구주소
									lon3 = resultCoordinate.lon;
									lat3 = resultCoordinate.lat;
								} else { 
									// 신주소
									lon3 = resultCoordinate.newLon;
									lat3 = resultCoordinate.newLat;
								}
							
								var lonEntr, latEntr;
								
								if (resultCoordinate.lonEntr == undefined && resultCoordinate.newLonEntr == undefined) {
									lonEntr = 0;
									latEntr = 0;
								} else {
									if (resultCoordinate.lonEntr.length > 0) {
										lonEntr = resultCoordinate.lonEntr;
										latEntr = resultCoordinate.latEntr;
									} else {
										lonEntr = resultCoordinate.newLonEntr;
										latEntr = resultCoordinate.newLatEntr;
									}
								}
									
								var markerPosition = new Tmapv2.LatLng(Number(lat3),Number(lon3));
								
								// 마커 올리기
								marker1 = new Tmapv2.Marker(
									{
										position : markerPosition,
										icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
										iconSize : new Tmapv2.Size(
										24, 38),
										map : map
									});
								map.setCenter(markerPosition);
								
								// 검색 결과 표출
								var matchFlag, newMatchFlag;
								// 검색 결과 주소를 담을 변수
								var address = '', newAddress = '';
								var city, gu_gun, eup_myun, legalDong, adminDong, ri, bunji;
								var buildingName, buildingDong, newRoadName, newBuildingIndex, newBuildingName, newBuildingDong;
								
								// 새주소일 때 검색 결과 표출
								// 새주소인 경우 matchFlag가 아닌
								// newMatchFlag가 응답값으로
								// 온다
								if (resultCoordinate.newMatchFlag.length > 0) {
									// 새(도로명) 주소 좌표 매칭
									// 구분 코드
									newMatchFlag = resultCoordinate.newMatchFlag;
									
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										newAddress += city + "\n";
									}
									
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										newAddress += gu_gun + "\n";
									}
									
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										newAddress += eup_myun + "\n";
									} else {
										// 출력 좌표에 해당하는
										// 법정동 명칭
										if (resultCoordinate.legalDong.length > 0) {
											legalDong = resultCoordinate.legalDong;
											newAddress += legalDong + "\n";
										}
										// 출력 좌표에 해당하는
										// 행정동 명칭
										if (resultCoordinate.adminDong.length > 0) {
											adminDong = resultCoordinate.adminDong;
											newAddress += adminDong + "\n";
										}
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										newAddress += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										newAddress += bunji + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 길 이름을 반환
									if (resultCoordinate.newRoadName.length > 0) {
										newRoadName = resultCoordinate.newRoadName;
										newAddress += newRoadName + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 번호를 반환
									if (resultCoordinate.newBuildingIndex.length > 0) {
										newBuildingIndex = resultCoordinate.newBuildingIndex;
										newAddress += newBuildingIndex + "\n";
									}
									// 새(도로명)주소 매칭을 한
									// 경우, 건물 이름를 반환
									if (resultCoordinate.newBuildingName.length > 0) {
										newBuildingName = resultCoordinate.newBuildingName;
										newAddress += newBuildingName + "\n";
									}
									// 새주소 건물을 매칭한 경우
									// 새주소 건물 동을 반환
									if (resultCoordinate.newBuildingDong.length > 0) {
										newBuildingDong = resultCoordinate.newBuildingDong;
										newAddress += newBuildingDong + "\n";
									}
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(중심점) : " + lat3 + ", " + lon3 + "</br>위경도좌표(입구점) : " + latEntr + ", " + lonEntr;
										$("#result3").html(text);
										$('#lat3').val(lat3);
										$('#lon3').val(lon3);
									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>"
										var text = "검색결과(새주소) : " + newAddress + ",\n 응답코드:" + newMatchFlag + "(상세 코드 내역은 " + docs + " 에서 확인)" + "</br> 위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result3").html(text);
									}
								}
								
								// 구주소일 때 검색 결과 표출
								// 구주소인 경우 newMatchFlag가
								// 아닌 MatchFlag가 응닶값으로
								// 온다
								if (resultCoordinate.matchFlag.length > 0) {
									// 매칭 구분 코드
									matchFlag = resultCoordinate.matchFlag;
								
									// 시/도 명칭
									if (resultCoordinate.city_do.length > 0) {
										city = resultCoordinate.city_do;
										address += city + "\n";
									}
									// 군/구 명칭
									if (resultCoordinate.gu_gun.length > 0) {
										gu_gun = resultCoordinate.gu_gun;
										address += gu_gun+ "\n";
									}
									// 읍면동 명칭
									if (resultCoordinate.eup_myun.length > 0) {
										eup_myun = resultCoordinate.eup_myun;
										address += eup_myun + "\n";
									}
									// 출력 좌표에 해당하는 법정동
									// 명칭
									if (resultCoordinate.legalDong.length > 0) {
										legalDong = resultCoordinate.legalDong;
										address += legalDong + "\n";
									}
									// 출력 좌표에 해당하는 행정동
									// 명칭
									if (resultCoordinate.adminDong.length > 0) {
										adminDong = resultCoordinate.adminDong;
										address += adminDong + "\n";
									}
									// 출력 좌표에 해당하는 리 명칭
									if (resultCoordinate.ri.length > 0) {
										ri = resultCoordinate.ri;
										address += ri + "\n";
									}
									// 출력 좌표에 해당하는 지번 명칭
									if (resultCoordinate.bunji.length > 0) {
										bunji = resultCoordinate.bunji;
										address += bunji + "\n";
									}
									// 출력 좌표에 해당하는 건물 이름
									// 명칭
									if (resultCoordinate.buildingName.length > 0) {
										buildingName = resultCoordinate.buildingName;
										address += buildingName + "\n";
									}
									// 출력 좌표에 해당하는 건물 동을
									// 명칭
									if (resultCoordinate.buildingDong.length > 0) {
										buildingDong = resultCoordinate.buildingDong;
										address += buildingDong + "\n";
									}
									// 검색 결과 표출
									if (lonEntr > 0) {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(중심점) : "+ lat3+ ", "+ lon3+ "</br>"+ "위경도좌표(입구점) : "+ latEntr+ ", "+ lonEntr;
										$("#result3").html(text);
										$('#lat3').val(lat3);
										$('#lon3').val(lon3);
									} else {
										var docs = "<a style='color:orange' href='#webservice/docs/fullTextGeocoding'>Docs</a>";
										var text = "검색결과(지번주소) : "+ address+ ","+ "\n"+ "응답코드:"+ matchFlag+ "(상세 코드 내역은 "+ docs+ " 에서 확인)"+ "</br>"+ "위경도좌표(입구점) : 위경도좌표(입구점)이 없습니다.";
										$("#result3").html(text);
									}
								}
							}
						}
						,
						error : function(request, status, error) {
							console.log(request);
							console.log("code:"+request.status + "\n message:" + request.responseText +"\n error:" + error);
							// 에러가 발생하면 맵을 초기화함
							// markerStartLayer.clearMarkers();
							// 마커초기화
							map.setCenter(new Tmapv2.LatLng(37.570028, 126.986072));
							$("#result3").html("");
						
						}
					});
				});
		
			}
			function ilocation() {
	
				var flatsum1 = document.getElementById('lat1').value;
				var flatsum2 = document.getElementById('lat2').value;
				var flatsum3 = document.getElementById('lat3').value;

				var flonsum1 = document.getElementById('lon1').value;
				var flonsum2 = document.getElementById('lon2').value;
				var flonsum3 = document.getElementById('lon3').value;

				var latavr = (parseFloat(flatsum1) + parseFloat(flatsum2) + parseFloat(flatsum3))/3;
				var lonavr = (parseFloat(flonsum1) + parseFloat(flonsum2) + parseFloat(flonsum3))/3;
				
				$('#ilocationlat').val(latavr);
				$('#ilocationlon').val(lonavr);
			}
		</script>
</head>
<body onload=initTmap();initTmap2();initTmap3();>

	<form action="tamp_geo2.jsp" method="post">
		<center>


			<div>
				<jsp:include page="top.jsp"></jsp:include>
			</div>

			<h1>약속장소 정하기</h1>
			<table>
<tr>
<td>

<input type="text" id="datetime2" name="datetime" class="datetime"
							size="40" value="<%=datetime %>" style="text-align: center"/></textarea>  
	<input type="text" id="memo2" name="memo" class="memo"
							size="40" value="<%=memo %>" style="text-align: center"/> 
				<input type="text" id="title2" name="title" class="memo" 
							size="40" value="<%=title%>" style="text-align: center"/> 
							</td>
							</tr>
				<tr>
					<td align="center"><label>사용자1 이름</label> <input type="text"
						class="select1" name="select1" style="text-align: center" /> 

						<label>사용자1 주소</label> <input type="text" class="text_custom"
						id="fullAddr" name="fullAddr" value="" size="40"
						style="text-align: center">
						<button id="btn_select" type="button" onclick="">사용자1 주소
							좌표 구하기</button> <label>사용자1 위도</label> <input type="text" class="lat1"
						style="text-align: center" id="lat1" name="lat1"> <label>사용자1
							경도</label><input type="text" class="lon1" id="lon1" name="lon1"></td>
				</tr>
				<tr>
					<td align="center"><label>사용자2 이름</label> <input type="text"
						class="select2" name="select2" style="text-align: center" /> <label>사용자2
							주소</label> <input type="text" class="text_custom" id="fullAddr2"
						name="fullAddr" value="" size="40">
						<button id="btn_select2" type="button" onclick="">사용자2 주소
							좌표 구하기</button> <label>사용자2 위도</label> <input type="text" class="lat2"
						id="lat2" name="lat2" style="text-align: center"> <label>사용자2
							경도</label> <input type="text" class="lon2" id="lon2" name="lon2"
						style="text-align: center"></td>
				</tr>
				<tr>
					<td align="center"><label>사용자3 이름</label> 
					
					<input type="text"
						class="select3" name="select3" style="text-align: center" />
					
					<label>사용자3
							주소</label><input type="text" class="text_custom" id="fullAddr3"
						name="fullAddr" value="" size="40">

						<button id="btn_select3" type="button" onclick="">사용자3 주소
							좌표 구하기</button> <label>사용자3 위도</label> <input type="text" class="lat3"
						id="lat3" name="lat3" style="text-align: center"> <label>사용자3
							경도</label> <input type="text" class="lon3" name="lon3" id="lon3"></td>
				</tr>
				<tr>
					<td>
				</tr>
				<tr>
					<td align="center"><label>중간지점 계산</label> <input type="text"
						class="ilocationlat" id="ilocationlat" name="ilocationlat1" /> <input
						type="text" class="ilocationlon" id="ilocationlon"
						name="ilocationlon1" /></td>
				</tr>
				<tr align="center">
				
				
				
					<td align="center">
</br>

						<button onclick="ilocation();">지도 불러오기</button>
					</td>

				</tr>
				<tr>
				<td>
			


			</table>
	</form>
	</center>
	<center>
		<div id="map_wrap" class="map_wrap">
			<div id="map_div"></div>
		</div>
		<div class="map_act_btn_wrap clear_box"></div>
		<p id="result"></p>
		<p id="result2"></p>
		<p id="result3"></p>

		<jsp:include page="footer.jsp"></jsp:include>
	</center>

</body>
</html>




