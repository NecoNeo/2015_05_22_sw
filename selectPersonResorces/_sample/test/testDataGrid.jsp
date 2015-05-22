<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<jsp:include page="inc.jsp"></jsp:include>
<!-- 国际化，中文就引入中国的语言包 chinese.js，if it is for english,use the english.js 
     easyui的国际化只要把inc.jsp里面的easyui-lang-zh_CN.js删除即可,默认为英文
              这里只是示例,只进行了部分国际化,实际开发中可以先用字符串 如 "我们"，待测试完后在把对应的地方换成国际化的参数  lan_we, lan_we = "我们",
     html标签中的可以保留默认版本，在引入语言包时再改为目标语言，避免开发困难，比如<td>名字：</td>，这里的名字可以保留在html中，
              但是在引入比如英文的时候用js替换掉即可，languageController，这里只做了一个增加的示例        
-->
<script type="text/javascript" src="${pageContext.request.contextPath}/language/chinese.js" charset="utf-8"></script>
<!--<script type="text/javascript" src="${pageContext.request.contextPath}/language/english.js" charset="utf-8"></script>-->
<script type="text/javascript" charset="utf-8" >
var flagCheckSimilar = 1;
//这里需要value和text保持一致
var state = [{"value" : lan_combobox_6,"text" : lan_combobox_6}, {"value" : lan_combobox_7,"text" : lan_combobox_7}];
//编辑
var editForm;
//检查页码标记
var checkPageFlag= 0;
//表格
var tab;
	
	$(function() {
		var editIndex='undefined';
   
		tab = $('#tab').datagrid({
			url : 'testDataGridAction!datagrid',
			title : lan_title,
			iconCls : 'icon-save',
			toolbar:'#toolbar',
			remoteSort : false,//不在服务器进行排序,此排序只在本页进行,如果要用sortable在前台排序，一定要设为true
			//默认在服务器排序true，如果在服务器排序的话要把sort和order传到后台,每次都会调用datagrid的action方法
			//rownumbers : true,//显示行号
			pagination : true,//分页信息
			pagePosition : 'bottom',
			pageSize : 100,
			pageList : [10, 25, 50, 75, 100],
			fit : true,
			
			fitColumns : true,//列宽度自适应,不出现水平滚动,   
			nowrap : false,//超出列宽时自动截取 
			border : false,
			idField : 'aid',//唯一字段
			//sortName : 'aid',   //默认排序字段名,由于我们 remoteSort : false，这里的排序失去了作用
			//sortOrder : 'asc',//默认排序方式 asc  desc
			checkOnSelect : false,
			selectOnCheck : true,
			//frozenColumns冻结列不可以拖动，如果想拖动请 用普通列,
			//另外当前方法普通列拖动到冻结列中会消失……算是个小BUG……请小心
			/*
			frozenColumns : [ [ {
				title : '编号',
				field : 'aid',
				width : 150,
				sortable : true,
				checkbox : true
			}, {
				title : '用户名',
				field : 'aname',
				width : 150,
				//sortable : true
			} ] ],
			*/
			
			columns : [ [
			             {
				title : lan_field_1,
				field : 'aid',
				//width : 150,
				//sortable : true,
				checkbox : true
			}, {
				title : lan_field_2,
				field : 'aname',
				//width : 150,
				width : fixWidth(0.25),
				sortable : true  //可排序，除非有需要，一般不用
			}, 
			
			{
				title : lan_field_3,
				field : 'apwd',
				//width : 100,
				width : fixWidth(0.25),
				sortable : true,
				formatter : function(value, rowData, rowIndex) {
					return '******';
				}
			}, {
				title : lan_field_4,
				field : 'idCard',
				//width : 150,
				width : fixWidth(0.25),
				sortable : true ,
				//hidden:true,
				editor:{
					type : 'combobox',
					options : {
						data: state,
						"panelHeight" : "auto",
						editable:false,
					}
				}
			} , {
				title : lan_field_5,
				field : 'type',
				//width : 150,
				width : fixWidth(0.25),
				sortable : true ,
				//hidden:true,
				editor:'text'
			},
			//操作不是对象的属性，是用来编辑删除的
			 {field : 'action',title:lan_field_6,
				//width:180,
				width : fixWidth(0.5),
				align : 'center',//hidden:true,
				 formatter : function(value, row) {
						var str = '';
						str += $.formatString('<a href="#" class="easyui-buttonOne"  onclick="editAccount2(\'{0}\');"></a>', row.aid);
						str += '&nbsp;&nbsp;';
						str += $.formatString('<a href="#" class="easyui-buttonTwo"  onclick="removeAccount2(\'{0}\');"></a>', row.aid);
						return str;
					}	 
			 }
			
			] ],
			
			//双击时 编辑
			onDblClickCell:function(rowIndex, field, value){
				console.log(rowIndex);
				
				editIndex=endEdit('tab',rowIndex,editIndex)
				var ed=$('#tab').datagrid('editCell',{index:rowIndex, field:field})
			},
			//加载成功后把按钮的样式加上
			onLoadSuccess:function(data){ 
				if(checkPageFlag == 0){
				var options = tab.datagrid('getPager').data("pagination").options;
				var pageNumber = options.pageNumber;
				var pageSize = options.pageSize;
				var total = options.total;
				var max = Math.ceil(total/pageSize);
				checkPage(pageNumber,max);
				}
				checkPageFlag= 0;
				
				$(".easyui-buttonOne").linkbutton({ text:lan_edit, plain:true, iconCls:'icon-edit'});
				$(".easyui-buttonTwo").linkbutton({ text:lan_remove, plain:true, iconCls:'icon-remove'});
		     },
			
		}).datagrid("columnMoving");
		
		
		
		//取消更改
		$('#cancelEdit').click(function(){
			 $('#tab').datagrid('reload');
				
		});
		
		//保存更改
		$('#saveEdit').click(function(){
			//所有行结束编辑状态
			var rowcount = $('#tab').datagrid('getRows').length;
		    for(var i=0; i<rowcount; i++){
		    	$('#tab').datagrid('endEdit',i);
		    }
			var updateRow=$('#tab').datagrid("getChanges",'updated');
			var effectRow = new Object();
			if(updateRow.length){
				effectRow["updateRow"] = JSON.stringify(updateRow);
				$.post("testDataGridAction!edit?", effectRow, function(r) {
					    var obj = jQuery.parseJSON(r);
					    if (obj.success) {
							tab.datagrid('getPager').pagination('select'); //编辑成功后刷新当前页   
							clearSelect();
						}
					    $.messager.show({
							title : '提示',
							msg : obj.msg
						});
			    	
		    	});
			}else{
				$.messager.alert('提醒','您尚未做任何修改!');
				return false;
			}
		});
		
	});
	
	//************以上表格生成方法***********//

	//点击操作栏删除
function removeAccount2(aid){
	$.ajax({
			url: 'testDataGridAction!removeAccount2',
			 data:{aid:aid},
			 dataType : 'json',
			 success : function(r){
			    	 tab.datagrid('reload');
			    $.messager.show({
					title : '提示',
					msg : r.msg
				});
			 }
	});
}	

	//点击操作栏修改
function editAccount2(aid){
	var editIndex='undefined';
	editForm = $('#editForm');
	var rows = $("#tab").datagrid("getRows"); //这段代码是获取当前页的所有行。
	for(var i=0;i<rows.length;i++)
	{
	//获取每一行的数据
	  //alert(rows[i].aid);//假设有aid这个字段
	  if(rows[i].aid==aid){
		  alert(i);
		  editIndex=endEdit('tab',i,i);
			var ed=$('#tab').datagrid('editCell',{index:i, field:"type"});
		/*  
		$('#editDialog').dialog('open');
		editForm.form('clear');
		editForm.form('load', {
			"account.aid" :  rows[i].aid,
			"account.aname" :  rows[i].aname,
			"account.apwd" :  rows[i].apwd,
			"account.idCard" :  rows[i].idCard,
			"account.type" :  rows[i].type,
		});
		*/
		break;
		
	  }
	}
	
}	
	
	
	//弹出批量添加窗口
    function appendLots(){
    	clearSelect();
		$('#addForm2 input').val('');
		$('#addDialog2').dialog('open');
		
	}
	
	//批量添加
	function appendAdd2(){
		if(flagCheckSimilar==1){
			getSimilarAccounts();
		}
		
		if (!confirm("确认要添加？")) {
            return;
        }
		
		var rowcount = $(".lines").length-1;
		var addRow = new Array(rowcount);
		for(i=0;i<rowcount;i++){
			var account = new Object();
			//属性的两种写法，自行挑选,建议带引号的，现在比较流行和便于检查
			account["aname"] = $(".lines").eq(i).find("input").eq(0).val();
			account["apwd"] = $(".lines").eq(i).find("input").eq(1).val();
			account.idCard = $(".lines").eq(i).find("input").eq(2).val();
			account.type = $(".lines").eq(i).find("input").eq(3).val();
			addRow[i] = account;
		}
		var effectRow = new Object();
		if(addRow.length){
			//把结果对象封装成JSON传到后台
			effectRow["addRow"] = JSON.stringify(addRow);
			$.post(
			 "testDataGridAction!addAccounts?",effectRow,function(r){
				var obj = jQuery.parseJSON(r);
			    if (obj.success) {
			    	 tab.datagrid('reload');
					$('#addDialog2').dialog('close');
					$(".lines").eq(0).nextAll().remove();
				}
			    $.messager.show({
					title : '提示',
					msg : obj.msg
				});
			 }
			);
		}else{
			$.messager.alert('提醒','您尚未添加任何信息!');
			return false;
		}
	}
	
	//检查是否有下一行，没有则添加一行
	//大牛可以尝试下用jquery写法
	function checkNextTr(input){
		var tr = $(input).parent().parent();
		if($(tr).next(".lines").length>0){
			//alert("exist");
		}else{
			//alert("nothing");
			$(tr).after(
				"   <tr class='lines'>    " +
				"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
				"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
				"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
				"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
			        " </tr>"
					);
		}
	}
	
	
	/*
		结束编辑
		@param tableId 表格id
		@param index 当前触发的行index
		@param editIndex 最后一次编辑的行index
	*/
	function endEdit(tableId,index,editIndex){
		if(editIndex != 'undefind'){
			$('#'+tableId).datagrid('endEdit', editIndex);
		}
		return index;
	}

	
	
	
	function edit() {
		editForm = $('#editForm');
		var rows = tab.datagrid('getChecked');
		
		if (rows.length != 1 && rows.length != 0) {
			$.messager.show({
				msg : '只能择一个用户进行编辑！您已经选择了' + rows.length + '个用户',
				title : '提示'
			});
		} else if (rows.length == 1) {
			$('#editDialog').dialog('open');
			editForm.form('clear');
			editForm.form('load', {
				"account.aid" :  rows[0].aid,
				"account.aname" :  rows[0].aname,
				"account.apwd" :  rows[0].apwd,
				"account.idCard" :  rows[0].idCard,
				"account.type" :  rows[0].type,
			});
		}else {
		$.messager.show({
			title : '提示',
			msg : '请勾选要编辑的记录！'
		});
	  }
   }
  //提交编辑
	function editAdd(){
		if(!checkWrite2()){
			return;
		};
		
		editForm.form('submit', {
			url : 'testDataGridAction!editAccount',
			success : function(r) {
				var obj = jQuery.parseJSON(r);
				if (obj.success) {
					$('#editDialog').dialog('close');
					tab.datagrid('getPager').pagination('select'); //编辑成功后刷新当前页   
					clearSelect();
				}
				$.messager.show({
					title : '提示',
					msg : obj.msg
				});
			}
		});
	}
	
	//检查添加填写是否正确
	function checkWrite(){
		var aname= $("#aname").val();
		var apwd= $("#apwd").val();
		if(aname=="" || aname==undefined){
			$.messager.show({
				title : '提示',
				msg : '请填写用户名！'
			});
			return false;
		}
		if(apwd=="" || apwd==undefined){
			$.messager.show({
				title : '提示',
				msg : '请填写密码！'
			});
			return false;
		}
		return true;
	}
	//检查编辑填写是否正确
	function checkWrite2(){
		var aname= $("#anameEdit").val();
		var apwd= $("#apwdEdit").val();
		if(aname=="" || aname==undefined){
			$.messager.show({
				title : '提示',
				msg : '请填写用户名！'
			});
			return false;
		}
		if(apwd=="" || apwd==undefined){
			$.messager.show({
				title : '提示',
				msg : '请填写密码！'
			});
			return false;
		}
		return true;
	}
	
	
	
	

	//弹出添加窗口
	function append() {
			clearSelect();
			$('#addForm input').val('');
			$('#addDialog').dialog('open');
			
	}
	//取消选中
	function clearSelect(){
		tab.datagrid('clearChecked');
		tab.datagrid('clearSelections');
	}
	
	
	//添加
	function appendAdd(){
		if(!checkWrite()){
			return;
		};
		$('#addForm').form('submit', {
			url : 'testDataGridAction!addAccount',
			success : function(r) {
				var obj = jQuery.parseJSON(r);
				if (obj.success) {
					//insertRow只是让用户感觉变好了，马上可以看到效果
					tab.datagrid('insertRow',{
						index:0,
						row:obj.obj
					});
				    //再次加载是标准用法,只刷新当前页面
				    //tab.datagrid('reload');
					$('#addDialog').dialog('close');
				}
				$.messager.show({
					title : '提示',
					msg : obj.msg
				});
			}
		});
	}
	
	//删除	
	function removeAccount() {
			//得到选中的行
			var rows = tab.datagrid('getChecked');
			var ids = [];
			if (rows.length > 0) {
				$.messager.confirm('确认', '您是否要删除当前选中的记录？', function(r) {
					if (r) {
						for ( var i = 0; i < rows.length; i++) {
							ids.push(rows[i].aid);
						}
						$.ajax({
							url : 'testDataGridAction!removeAccount',
							data : {
								ids :ids.join(',')
							},
							dataType : 'json',
							success : function(r) {
								tab.datagrid('reload');
								tab.datagrid('clearChecked');
								tab.datagrid('uncheckAll');
								$.messager.show({
									title : '提示',
									msg : r.msg
								});
							}
						});
					}
				});
			} else {
				$.messager.show({
					title : '提示',
					msg : '请勾选要删除的记录！'
				});
			}
	}
	
	
	//查询，多条件查询只要向后台多传几个值即可
	function findByName(){
		var queryAname = $("#queryAname").val();
		//这里的aname对应的是后台aname，其实就是名字,可以加单引号也可以不加
		tab.datagrid('load',{'aname':queryAname});
		
	}
	
	
	function getSimilarAccounts(){
		//把上次的查询结果删除
		$("#similar").nextAll().remove();
		var rowcount = $(".lines").length-1;
		var addRow = new Array(rowcount);
		for(i=0;i<rowcount;i++){
			var account = new Object();
			//属性的两种写法，自行挑选,建议带引号的，现在比较流行和便于检查
			account["aname"] = $(".lines").eq(i).find("input").eq(0).val();
			account["apwd"] = $(".lines").eq(i).find("input").eq(1).val();
			account.idCard = $(".lines").eq(i).find("input").eq(2).val();
			account.type = $(".lines").eq(i).find("input").eq(3).val();
			addRow[i] = account;
		}
		var effectRow = new Object();
		if(addRow.length){
			//把结果对象封装成JSON传到后台
			effectRow["addRow"] = JSON.stringify(addRow);
			$.post(
			 "testDataGridAction!getSimilarAccounts?",effectRow,function(r){
				var obj = jQuery.parseJSON(r);
			    if (obj.success) {
			    var similarAccounts = obj.obj;
			      for(i=0;i<similarAccounts.length;i++){
			    	  $("#addLotsTab").find("tr").last().after(
			    	  "<tr>"+
			    	  "<td>"+similarAccounts[i].aname+"</td>"+		
			    	  "<td>"+similarAccounts[i].apwd+"</td>"+
			    	  "<td>"+similarAccounts[i].idCard+"</td>"+
			    	  "<td>"+similarAccounts[i].type+"</td>"+
			    	  "</tr>"
			    	  );
			      }

				}
			    $.messager.show({
					title : '提示',
					msg : obj.msg
				});
			 }
			);
		}else{
			$.messager.alert('提醒','没有任何相似信息!');
			return false;
		}
		
		
	}
	
	
	//设置每页显示多少条
	function setPagesize(num){
		$("#tab").datagrid({pageSize : num}) ;
	}
	//右箭头
	function moveRight(){
		tab.datagrid({fitColumns : false}) ;
		tab.datagrid('hideColumn', 'idCard');
		tab.datagrid('hideColumn', 'type');
		tab.datagrid('showColumn', 'action');
		$("#moveRight").attr({"style":"display:none"});
		$("#moveLeft").attr({"style":""});
		tab.datagrid({fitColumns : true}).datagrid("columnMoving") ;
	}
	//左箭头
	function moveLeft(){
		tab.datagrid({fitColumns : false}) ;
		tab.datagrid('hideColumn', 'action');
		tab.datagrid('showColumn', 'idCard');
		tab.datagrid('showColumn', 'type');
		$("#moveLeft").attr({"style":"display:none"});
		$("#moveRight").attr({"style":""});
		tab.datagrid({fitColumns : true}).datagrid("columnMoving") ;
	}
	//设置宽度为百分比，相对宽度 
	function fixWidth(percent)  
	{  
	    return document.body.clientWidth * percent ; //这里你可以自己做调整  
	} 
	
	//让tab浮到页面上
	function tableAbove(){
	  $(".datagrid-view").attr({"style":"position: absolute;margin-left:5%;margin-top:100px;border:1px solid red;width:1500px;height:300px;"});
	 // $(".datagrid-htable").attr({"width":fixWidth(0.5)});
	 // $(".datagrid-btable").attr({"width":fixWidth(0.5)});
	 //$(".datagrid-pager pagination").attr({"style":"display:none"});
	}
	
	
	function setPage(page){
		var pageNum = $(page).text();
		//alert(pageNum);
		//两种方案，都可以获取到当前页码值
		//alert($(".pagination-num").val());
		//设置页码值
		var options = tab.datagrid('getPager').data("pagination").options;
		var pageNumber = options.pageNumber;
		var pageSize = options.pageSize;
		var total = options.total;
		var max = Math.ceil(total/pageSize);
		
		tab.datagrid({pageNumber:parseInt(pageNum)});
		pageNumber = pageNum;
		checkPage(pageNumber,max);
		checkPageFlag = 1;
	}
	
	function checkPage(pageNumber,max){
		if(parseInt(pageNumber)<=2){
			$("#page1").text(1);
			$("#page2").text(2);
			$("#page3").text(3);
			$("#page4").text(4);
		}else if(parseInt(pageNumber)>2 && parseInt(pageNumber)<(parseInt(max)-2)){
			$("#page1").text((parseInt(pageNumber)-1));
			$("#page2").text(parseInt(pageNumber));
			$("#page3").text((parseInt(pageNumber)+1));
			$("#page4").text((parseInt(pageNumber)+2));
		}else{
			$("#page1").text(max-3);
			$("#page2").text(max-2);
			$("#page3").text(max-1);
			$("#page4").text(max);
		}
		
	}
	
	
	
	
	

function initbody(){
	 var controller= new LanguageController();
	 $("#addForm").find("td").eq(0).html(controller.language.titles["aname"]);
	 $("#addForm").find("td").eq(2).html(controller.language.titles["apwd"]);
	 $("#addForm").find("td").eq(4).html(controller.language.titles["idCard"]);
	 $("#addForm").find("td").eq(6).html(controller.language.titles["type"]);
	 
}

</script>

</head>
<body class="easyui-layout" 
onload="initbody()" style="width: 100%;" >

 

<!--  data-options="fit:true" -->
    <div id="toolbar" style="height: 60px;" >	 
    <form id="searchForm" method="post">
	用户名：<s:textfield id="queryAname" />
	<a iconCls="icon-search" class="easyui-linkbutton" 
				onclick="findByName();">查询</a> 
	每页显示条数：			
	<a onclick="setPagesize(25);"  iconCls='icon-edit' class="easyui-linkbutton">25</a>
	<a onclick="setPagesize(50);"  iconCls='icon-edit' class="easyui-linkbutton">50</a>
	<a onclick="setPagesize(75);"  iconCls='icon-edit' class="easyui-linkbutton">75</a>
	<a onclick="setPagesize(100);"  iconCls='icon-edit' class="easyui-linkbutton">100</a>	
	<a onclick="moveRight()" iconCls='icon-edit' class="easyui-linkbutton" id="moveRight" >右箭头</a>		
	<a onclick="moveLeft()" iconCls='icon-edit' class="easyui-linkbutton" id="moveLeft" style="display: none;">左箭头</a>
	<a onclick="tableAbove();"  iconCls='icon-edit' class="easyui-linkbutton">表格浮层</a>	
				<br/>
			</form>	
		<a onclick="append();"  iconCls='icon-add' class="easyui-linkbutton">增加</a>
		<a onclick="appendLots();"  iconCls='icon-add' class="easyui-linkbutton">批量增加</a>
		<a onclick="removeAccount();"  iconCls='icon-remove' class="easyui-linkbutton">删除</a>
		<a onclick="edit();"  iconCls='icon-edit' class="easyui-linkbutton">编辑</a>
		
		
	<a iconCls='icon-save' class="easyui-linkbutton" plain="true"
				id="saveEdit">保存更改</a>|
	<a iconCls='icon-cancel' class="easyui-linkbutton" plain="true"
				id="cancelEdit">取消更改</a>
	
	<a onclick="setPage(this);"  style="font-size: 15px"  href="#" id="page1">1</a>
	<a onclick="setPage(this);"  style="font-size: 15px"  href="#" id="page2">2</a>
	<a onclick="setPage(this);"  style="font-size: 15px"  href="#" id="page3">3</a>
	<a onclick="setPage(this);"  style="font-size: 15px"  href="#" id="page4">4</a>			
				
	</div>
	 
	<div data-options="region:'center',border:false"
		style="overflow: hidden;width:80%">
		<table id="tab" style="width: 100%"></table>
	</div>

    <div id="addDialog" class="easyui-dialog"
		data-options="closed:true,modal:true,title:'demo(*为必填项)',buttons:[{
				text : '保存',
				iconCls : 'icon-add',
				plain : false,
				handler : function() {
					appendAdd();
				}
			},{
				text : '取消',
				iconCls : 'icon-remove',
				plain : false,
				handler : function() {
					$('#addDialog').dialog('close');
				}
			}]"
		style="width: 1200px; height: 500px; align: center">
		<form id="addForm" method="post">
		  <table style="margin-top: 5px">
			<tr>
					<td>&nbsp;&nbsp;用户名：</td>
					<td><s:textfield name="account.aname" id="aname" /><font color="red">*</font>
					</td>
					<td>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
					<td><s:textfield name="account.apwd" id="apwd" /><font color="red">*</font></td>
					<td>&nbsp;&nbsp;身份证：</td>
					<td><s:textfield name="account.idCard" id="idCard" /></td>
					<td>&nbsp;&nbsp;类型：</td>
					<td><s:textfield name="account.type" id="type" /></td>
			</tr>
		  </table>
		</form>
	</div>
			
	<div id="addDialog2" class="easyui-dialog"
		data-options="closed:true,modal:true,title:'demo(*为必填项)',buttons:[{
				text : '查询相似数据',
				iconCls : 'icon-search',
				plain : false,
				handler : function() {
					getSimilarAccounts();
				}
			},{
				text : '保存',
				iconCls : 'icon-add',
				plain : false,
				handler : function() {
					appendAdd2();
				}
			},{
				text : '取消',
				iconCls : 'icon-remove',
				plain : false,
				handler : function() {
					$('#addDialog2').dialog('close');
					$('.lines').eq(0).nextAll('.lines').remove();
					$('#similar').nextAll().remove();
				}
			}]"
		style="width: 1200px; height: 500px; align: center">
		<form id="addForm2" method="post">
			<table style="margin-top: 5px" id="addLotsTab">
			<tr>
			<td>&nbsp;&nbsp;用户名</td>
			<td>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;码</td>
			<td>&nbsp;&nbsp;身份证</td>
			<td>&nbsp;&nbsp;类型</td>
			</tr>
			<tr class='lines'>
					<td><input type="text" onkeyup='checkNextTr(this)' /></td>
					<td><input type="text" onkeyup='checkNextTr(this)' /></td>
					<td><input type="text" onkeyup='checkNextTr(this)' /></td>
					<td><input type="text" onkeyup='checkNextTr(this)' /></td>
			</tr>
			<tr id="similar">
			 <td colspan="4">相似数据如下：</td>
			</tr>
			
			
			</table>
			</form>
			</div>
			
		<div id="editDialog" class="easyui-dialog"
		data-options="closed:true,modal:true,title:'编辑(*为必填项)',buttons:[{
				text : '保存',
				iconCls : 'icon-edit',
				plain : false,
				handler : function() {
					editAdd();
				}
			},{
				text : '取消',
				iconCls : 'icon-remove',
				plain : false,
				handler : function() {
					$('#editDialog').dialog('close');
				}
			}]"
		style="width: 1200px; height: 500px; align: center">
		<form id="editForm" method="post">
			<table style="margin-top: 5px">
			<tr>
			<td>&nbsp;&nbsp;用户名：</td>
					<td>
					<s:hidden value="account.aid" name="account.aid"></s:hidden>
					<s:textfield name="account.aname" id="anameEdit" /><font color="red">*</font>
					</td>
					<td>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
					<td><s:textfield name="account.apwd" id="apwdEdit" /><font color="red">*</font></td>
					<td>&nbsp;&nbsp;身份证：</td>
					<td><s:textfield name="account.idCard" /></td>
					<td>&nbsp;&nbsp;类型：</td>
					<td><s:textfield name="account.type" /></td>
					</tr>
			</table>
			</form>
			</div>	
	
</body>
</html>