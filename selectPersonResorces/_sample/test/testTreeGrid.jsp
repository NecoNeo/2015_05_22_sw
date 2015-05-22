<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="inc.jsp"></jsp:include>
<script >
var tab;
$(function() {
	tab = $("#tab").treegrid({
		url: "testTreeGridAction!treegrid",
		title : 'treegrid树状表',
		toolbar:'#toolbar',
		//rownumbers: true,
		pagination: true,
		pageSize: 10,
		pageList: [10,20,30],
		idField: 'aid',
		treeField:'aname',
		columns:[[
         {field:'aid',title:'aid',hidden:true},
		 {field:'aname',title:'用户名',width:180},
		 {field:'apwd',title:'密码',width:60,align:'right'},
		 {field:'idCard',title:'身份证',width:80},
		 {field:'type',title:'类型',width:80},
		 //操作不是对象的属性，是用来添加删除的
		 {field : 'action',title:'操作',width:180,align : 'center',
			 formatter : function(value, row) {
					var str = '';
					str += $.formatString('<a href="#" class="easyui-buttonOne"  onclick="appendLots(\'{0}\');"></a>', row.aid);
					str += '&nbsp;&nbsp;';
					str += $.formatString('<a href="#" class="easyui-buttonTwo"  onclick="removeAccount(\'{0}\');"></a>', row.aid);
					return str;
				}	 
		 }
		 ]],
		 
		 onBeforeLoad: function(row,param){
			 if (row) { //如果点击父节点，展开父节点
				 $(this).treegrid('options').url = "testTreeGridAction!treegrid?pageSon=1&&rowsSon=999&&fatherId="+row.aid;
			 }else{//分页
				 $('#tab').treegrid('options').url = "testTreeGridAction!treegrid";
			 }
         },
         //加载成功后把按钮的样式加上
	     onLoadSuccess:function(data){ 
			$(".easyui-buttonOne").linkbutton({ text:'添加', plain:true, iconCls:'icon-edit'});
			$(".easyui-buttonTwo").linkbutton({ text:'删除', plain:true, iconCls:'icon-edit'});
	     }
	});
	
});


var fatherId;



function removeAccount(aid){
	$.ajax({
			url: 'testTreeGridAction!removeAccount',
			 data:{aid:aid},
			 dataType : 'json',
			 success : function(r){
			    	 tab.treegrid('reload');
			    $.messager.show({
					title : '提示',
					msg : r.msg
				});
			 }
	});
}


//弹出批量添加窗口
function appendLots(aid){
	fatherId = aid;
	$('#addForm2 input').val('');
	$('#addDialog2').dialog('open');
	
}

//检查是否有下一行，没有则添加一行
//大牛可以尝试下用jquery写法
function checkNextTr(input){
	$(".fatherId").val(fatherId);
	var tr = $(input).parent().parent();
	if($(tr).next().length>0){
		//alert("exist");
	}else{
		//alert("nothing");
		$(tr).after(
			"   <tr class='lines'>    " +
			"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
			"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
			"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
			"	<td><input type='text' onkeyup='checkNextTr(this)' /></td> " +
			"	<td><input type='text' readonly='readonly' class='fatherId' /></td> " +
		        " </tr>"
				);
	}
}

//批量添加
function appendAdd2(){
	var rowcount = $(".lines").length-1;
	var addRow = new Array(rowcount);
	for(i=0;i<rowcount;i++){
		var account = new Object();
		//属性的两种写法，自行挑选,建议带引号的，现在比较流行和便于检查
		account["aname"] = $(".lines").eq(i).find("input").eq(0).val();
		account["apwd"] = $(".lines").eq(i).find("input").eq(1).val();
		account.idCard = $(".lines").eq(i).find("input").eq(2).val();
		account.type = $(".lines").eq(i).find("input").eq(3).val();
		account.fatherId = $(".lines").eq(i).find("input").eq(4).val();
		addRow[i] = account;
	}
	var effectRow = new Object();
	if(addRow.length){
		//把结果对象封装成JSON传到后台
		effectRow["addRow"] = JSON.stringify(addRow);
		$.post(
		 "testTreeGridAction!addAccounts?",effectRow,function(r){
			var obj = jQuery.parseJSON(r);
		    if (obj.success) {
		    	 tab.treegrid('reload');
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



//弹出添加窗口
function append() {
		$('#addForm input').val('');
		$('#addDialog').dialog('open');
}


//添加根节点
function appendAdd(){
	if(!checkWrite()){
		return;
	};
	$('#addForm').form('submit', {
		url : 'testTreeGridAction!addAccount',
		success : function(r) {
			var obj = jQuery.parseJSON(r);
			if (obj.success) {
			    tab.treegrid('reload');
				$('#addDialog').dialog('close');
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


</script>

</head>
<body>
<div id="toolbar" style="height: 30px">	 
   
		<a onclick="append();"  iconCls='icon-add' class="easyui-linkbutton">增加根节点</a>
		
	
</div>


<form id="form1" runat="server">
		<table id="tab"></table>
</form>

     <div id="addDialog2" class="easyui-dialog"
		data-options="closed:true,modal:true,title:'demo(*为必填项)',buttons:[{
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
					$('.lines').eq(0).nextAll().remove();
				}
			}]"
		style="width: 1200px; height: 500px; align: center">
		<form id="addForm2" method="post">
		  <table style="margin-top: 5px">
			<tr>
			<td>&nbsp;&nbsp;用户名</td>
			<td>&nbsp;&nbsp;密&nbsp;&nbsp;&nbsp;&nbsp;码</td>
			<td>&nbsp;&nbsp;身份证</td>
			<td>&nbsp;&nbsp;类型</td>
			<td>&nbsp;&nbsp;父节点</td>
			</tr>
			<tr class='lines'>
					<td><input type='text' onkeyup='checkNextTr(this)' /></td>
					<td><input type='text' onkeyup='checkNextTr(this)' /></td>
					<td><input type='text' onkeyup='checkNextTr(this)' /></td>
					<td><input type='text' onkeyup='checkNextTr(this)' /></td>
					<td><input type='text' readonly='readonly' class='fatherId' /></td>
			</tr>
		  </table>
		</form>
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

</body>
</html>
