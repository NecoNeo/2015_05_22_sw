<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<style type="text/css">
.s_c {
	width: 150px;
}
</style>
<%
	String path = request.getScheme() + "://" + request.getServerName()
			+ ":" + request.getServerPort();// + request.getServletPath();
%>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-1.11.0.js"
	charset="utf-8"></script>
</head>
<body>
	省市区实例：
	<br />
	<br />
	<br />

	<select name="jq_naction" id="jq_naction" class="s_c"><option
			value="0">请选择</option></select>
	<select name="jq_province" id="jq_province" class="s_c"><option
			value="0">请选择</option></select>
	<select name="jq_city" id="jq_city" class="s_c"><option
			value="0">请选择</option></select>
	<select name="jq_area" id="jq_area" class="s_c"><option
			value="0">请选择</option></select>

	<script type="text/javascript">
		$(document).ready(
				function() {
					//获取国家数据
					$.ajax({ //一个Ajax过程 
						type : "post", //以post方式与后台沟通 
						url :'<%=path%>/jq/ajaxDictionary',
						dataType : 'json',//返回的值以 JSON方式 解释 
						data : {
							dictType : 'nation',
							parentId : '0'
						},
						success : function(json) {
							for ( var i = 0; i < json.length; i++) {

								document.getElementById("jq_naction").options
										.add(new Option(json[i].value,
												json[i].key));
							}
						}
					});

				});
		
		$('#jq_naction').change(function(){
			document.getElementById("jq_province").options.length = 1; 
			document.getElementById("jq_city").options.length = 1;  		
			document.getElementById("jq_area").options.length = 1;  
			if($('#jq_naction').val()!='0'){				
				$.ajax({ 
					type : "post", 
					url :'<%=path%>/jq/ajaxDictionary',
					dataType : 'json',
					data : {
						dictType : 'province',
						parentId : $('#jq_naction').val()
					},
					success : function(json) {
						for ( var i = 0; i < json.length; i++) {

							document.getElementById("jq_province").options
									.add(new Option(json[i].value,
											json[i].key));
						}
					}
				});
			}else{
				//TODO
			}
		});
		
		
		$('#jq_province').change(function(){
			document.getElementById("jq_city").options.length = 1;  
			if($('#jq_province').val()!='0'){
				$.ajax({ 
					type : "post", 
					url :'<%=path%>/jq/ajaxDictionary',
					dataType : 'json',
					data : {
						dictType : 'city',
						parentId : $('#jq_province').val()
					},
					success : function(json) {
						for ( var i = 0; i < json.length; i++) {

							document.getElementById("jq_city").options
									.add(new Option(json[i].value,
											json[i].key));
						}
					}
				});
			}else{
				//TODO
			}
		});
		
		
		$('#jq_city').change(function(){
			document.getElementById("jq_area").options.length = 1;  	
			if($('#jq_city').val()!='0'){
				$.ajax({ 
					type : "post", 
					url :'<%=path%>/jq/ajaxDictionary',
					dataType : 'json',
					data : {
						dictType : 'area',
						parentId : $('#jq_city').val()
					},
					success : function(json) {
						for ( var i = 0; i < json.length; i++) {

							document.getElementById("jq_area").options
									.add(new Option(json[i].value,
											json[i].key));
						}
					}
				});
			}else{
				//TODO
			}
		});
	</script>

</body>
</html>