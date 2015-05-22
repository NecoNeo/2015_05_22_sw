<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="inc.jsp"></jsp:include>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/datagrid-detailview.js"></script>
<script type="text/javascript">
/**
 * 日期格式请根据自己后台传过来的数据自行转换
 * 这里只是一个示例
 */
function myformatter(date){
	var strs = date.split(' ');
	return strs[0];
}

</script>
<script type="text/javascript" charset="utf-8">

	var datagrid;
	$(function() {
		
		datagrid = $('#datagrid').datagrid({
			url : 'testSubGridAction!datagrid',
			title : '玩家列表',
			iconCls : 'icon-save',
			pagination : true,
			pagePosition : 'bottom',
			pageSize : 10,
			pageList : [ 10, 20, 30, 40 ,50],
			fit : true,
			//fitColumns : true,
			nowrap : false,
			border : false,
			idField : 'id',
			sortName : 'id',
			sortOrder : 'desc',
			checkOnSelect : false,
			selectOnCheck : true,
			columns : [ [ 
                          {title : 'Id',field : 'id',width : 260,hidden : false,checkbox : true}, 
						  {title : '姓名',field : 'name',width : 260}, 
						  {title : '类型',field : 'type',width : 260},
			              ] ],
             
             view: detailview,
             detailFormatter:function(index,row){
                   return '<div style="padding:2px"><table class="ddv"></table></div>';
             },
             onExpandRow: function(index,row){
                 var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
                 ddv.datagrid({
                     url:'testSubGridAction!datagridDetail?playerId='+row.id,
                     idField : 'id',//唯一字段
                     fitColumns:true,
                     singleSelect:true,
                     rownumbers:true,
                     pagination : true,//分页信息
                     pageSize : 10,
         			 pageList : [ 10, 20, 30, 40 ,50],
     				 loadMsg:'子表数据加载中.....',
     				 sortName:'id',
     				 sortOrder:'asc',
                     height:'auto',
                     columns:[[
                         {field:'id',title:'ID',width:150,hidden:true},
                         {field:'petname',title:'宠物名',width:150},
                         {field:'idCard',title:'卡号',width:150},
                         {field:'birthday',title:'生日',width:150,formatter:myformatter},
                     ]],
                     onResize:function(){
                         $('#datagrid').datagrid('fixDetailRowHeight',index);
                     },
                     onLoadSuccess:function(){
                         setTimeout(function(){
                             $('#datagrid').datagrid('fixDetailRowHeight',index);
                         },0);
                     }
                 });
                 $('#datagrid').datagrid('fixDetailRowHeight',index);
             }
		});
		
	});
	
	 
</script>
</head>
<body class="easyui-layout" data-options="fit:true">
	
	<div data-options="region:'center',border:false" style="overflow: hidden;">
		<table id="datagrid"></table>
	</div>

	
</body>
</html>