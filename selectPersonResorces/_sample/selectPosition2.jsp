<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>弹窗</title>
<link type="text/css" href="css/easyui/themes/icon.css"
	rel="Stylesheet" />
<link type="text/css" href="css/easyui/themes/gray/easyui.css"
	rel="Stylesheet" />
<link type="text/css" href="css/style.css" rel="Stylesheet" />

<script type="text/javascript" src="js/jquery-1.11.0.js"></script>
<script type="text/javascript" src="js/doT.js"></script>
<script id="topPanelTemp" type="text/template">
<dl data-role="topPanel">
	<dt>
		<a href="javascript:void(0)" data-role="title">{{=it.title}}</a>
		<section class="popup_choice" style="display: none">
			<em class="icon pop_arrow"></em>
			<section class="choice_content">
				{{for (var i = 0, l = it.data.length; i < l; i++) {}}
					<a href="javascript:void(0)" data-role="" data-id="{{=it.data[i].id}}" data-type="{{=it.data[i].type}}" data-parentId="{{=it.data[i].parentId}}">{{=it.data[i].name}}</a>
				{{}}}
			</section>
			<section class="pagination">
				<section class="right">
					<a href="#" class="btn btn_blue">确定</a>
				</section>
			</section>
		</section>
	</dt>
	<dd>
		<a href="#" class="right" data-role="more">&gt;&gt;</a>
		<span>
		{{for (var i = 0, l = it.data.length; i < l; i++) {}}
			<a href="javascript:void(0)" data-role="topPanelButton" data-id="{{=it.data[i].id}}" data-type="{{=it.data[i].type}}" data-parentId="{{=it.data[i].parentId}}">{{=it.data[i].name}}</a>
		{{}}}
		</span>
		<section class="popup_choice" style="display:none;">
			<section class="choice_content">
				<span class="active"><input type="checkbox" checked="checked" />广州</span><span><input type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input type="checkbox" />中山</span><span><input type="checkbox" />佛山

				</span>
			</section>

		</section>
	</dd>
</dl>
</script>

<script id="selectingPanelTemp" type="text/template">
<li data-role="selectingPanel" data-id="{{=it.orgId}}_{{=it.departmentId}}">
	<a href="javascript:void(0)"> <em class="icon l-arrow-down"></em>
		{{=it.orgName}}&nbsp;<b class="blue">&gt;</b>&nbsp;{{=it.departmentName}}
	</a>
	<ol>
	</ol>
</li>
</script>

<script type="text/javascript">
//org_position_auth id
// var type = {
// 	project,  
// 	message, 
// 	flow,
// }
// var options = {
// 	type: "flow" //message,project
// 	//currentOrgId: 1,
// 	//currentDepId: 2
// }

var actionName = "selectPosition2";

//初始化机构
function initOrgSelector(){
	$.post(actionName + "!getOrgList", function(data) {
		var orgArray = JSON.parse(data);

		var orgPanel = doT.template($("#topPanelTemp").html());
		$("#topPanel").append(orgPanel({
			title: "机构",
			data: orgArray
		}));
		$("#topPanel").find("[data-role='topPanelButton'][data-type='org'][data-id=" + $("#currentBranchId").val() + "]").click();

	});

}

//初始化部门（部门层级，部门列表）
function initDepartSelector(level,depArray){
	$("#topPanel").find("[data-role=topPanel]:gt(" + level + ")").remove();

	if (depArray.length > 0) {
		var depPanel = doT.template($("#topPanelTemp").html());
		$("#topPanel").append(depPanel({
			title: "部门",
			data: depArray
		}));
	}

	if($("#currentDepartmentIds").val() != ""){
		var d = $("#currentDepartmentIds").val().split(",");
		if(level == d.length - 1){
			$("#currentDepartmentIds").val("");
		}
		$("#topPanel").find("[data-role='topPanelButton'][data-type='dep'][data-id=" + d[level] + "]").click();
	}

	$("#topPanel").find("[data-role=topPanel]").last().addClass("no_dash").siblings().removeClass("no_dash");
}


//初始化待选区
function initSelectingPanel(dataArray){
	//$("#selectingPanel ul").empty();
	var allPanel = $("#selectingPanel ul[data-role='all']").empty(),
		hotPanel = $("#selectingPanel ul[data-role='hot']"),
		newPanel = $("#selectingPanel ul[data-role='new']");
	$(dataArray).map(function(){
		if(this.isSelf){
			var myselfPanel = $("#selectingPanel ul[data-role='myself']").empty();
			var selectingPanel = doT.template($("#selectingPanelTemp").html());
				myselfPanel.append(selectingPanel(this));

			var ol = myselfPanel.find("[data-id='" + this.orgId + "_" + this.departmentId + "']").find("ol");
			ol.append("<li><a href='javascript:void(0)' data-id='" + this.id + "' data-type='" + this.type + "'>" + this.name + "</a></li>");
		}else{
			if (allPanel.find("[data-id='" + this.orgId + "_" + this.departmentId + "']").size() == 0) {
				var selectingPanel = doT.template($("#selectingPanelTemp").html());
				allPanel.append(selectingPanel(this));
			}
			var ol = allPanel.find("[data-id='" + this.orgId + "_" + this.departmentId + "']").find("ol");
			ol.append("<li><a href='javascript:void(0)' data-id='" + this.id + "' data-type='" + this.type + "'>" + this.name + "</a></li>");

		}
	});


	$(".tree_tab a").last().click();
}

//更新选择路径
function refreshSelectRoute() {
	$("#selectRoute").empty();
	var routeArray = [];
	$("#topPanel").find(".active[data-id]").each(function() {
		routeArray.push($(this).html());
	});
	if (routeArray.length > 0) {
		$("#selectRoute").append('<a href="#" class="active"><em class="fr">x</em>' + routeArray.join(" > ") + '</a>');
	}
}

//初始化已选项
function initSelectedPanel(){
	if($("#selectedPosition").val()){
		var selectedPosition  = JSON.parse($("#selectedPosition").val());
		$(selectedPosition).map(function(){
			var displayName = this.displayName,
				type = this.type,
				name = this.name,
				id = this.id.split("_")[this.id.split("_").length - 1];
			var html = '<li><a href="javascript:void(0);" data-type="'+type+'" data-id="'+id+'" data-name="'+name+'">' + displayName + '</a><li>';
		    $(html).prependTo($("#selectedPanel"));
		});

		$("#selectedCount").html($("#selectedPanel li a").size());
	}
}

//点击机构部门筛选条件
$(document).on("click","#topPanel [data-role='topPanelButton']",function(){
	if(!$(this).hasClass("active")){
		$(this).addClass("active").siblings().removeClass("active");

		var obj = this,params,level;

		if ($(obj).attr("data-type") == "org") {
			$("#currentBranchId").val($(obj).attr("data-id"));
			params = {
				currentBranchId: $("#currentBranchId").val()
			};
			level = 0;

		} else if ($(obj).attr("data-type") == "dep") {
			$("#currentDepartmentId").val($(obj).attr("data-id"));
			params = {
				currentBranchId: $("#currentBranchId").val(),
				currentDepartmentId: $("#currentDepartmentId").val(),
				condition: $("#condition").val()
			}
			level = $(obj).parents("[data-role='topPanel']").index();

			$.post(actionName + "!getPositionList", params, function(data) {
				initSelectingPanel(JSON.parse(data));
			});
		}

		if ($(obj).data("depArray")) {
			initDepartSelector(level, $(obj).data("depArray"));
		} else {
			$.post(actionName + "!getDepartmentList", params, function(data) {
				$(obj).data("depArray", JSON.parse(data));
				initDepartSelector(level, $(obj).data("depArray"));
			});
		}

		refreshSelectRoute();
	}
});


//切换选择区域tab页（高频，最近，全部）
$(document).on("click",".tree_tab a",function(){
	$(this).addClass("active").siblings().removeClass("active");
	var selectingPanel = $("#selectingPanel > ul").eq($(this).index());
	selectingPanel.show().siblings().hide();

	$("#selectingCount").html(selectingPanel.find("ol a").size());
});

//点击选中项
$(document).on("click","#selectedPanel a",function(){
	$(this).parent().remove();

	$("#selectedCount").html($("#selectedPanel li a").size());
});

//点击待选项
$(document).on("click","#selectingPanel a",function(){
	if ($(this).parents("ol").size() > 0) {
		var htmlArray = [];

		htmlArray.push($(this).html());

		var parent = $(this).parents("ol").eq(0).prev().clone();
		parent.find("em").remove();
		htmlArray.push(parent.html());

		var html = '<li><a href="javascript:void(0);" data-type="'+$(this).attr("data-type")+'" data-id="'+$(this).attr("data-id")+'" data-name="'+$(this).html()+'">' + htmlArray.join(' <b class="blue">&gt;</b> ') + '</a><li>';

		$("#selectedPanel").find("a[data-type='"+$(this).attr("data-type")+"'][data-id='"+$(this).attr("data-id")+"']").remove()
	    $(html).prependTo($("#selectedPanel"));
		
	}else{
		// $(this).next().children("li").each(function(){
		// 	$(this).children("a").click();
		// });
	}

	$("#selectedCount").html($("#selectedPanel li a").size());
});

$(function(){

	$(document).on("click","[data-role=more]",function(){
		$("[data-role='title']").removeClass("active");
		$(".popup_choice").hide();

		$(this).parent().prev().find(".popup_choice").show();
		$(this).parent().prev().find("[data-role='title']").addClass("active");
	});

	// $(document).on("click","[data-role=title]",function(){
	// 	$("[data-role='title']").removeClass("active");
	// 	$(".popup_choice").hide();

	// 	$(this).parent().prev().find(".popup_choice").show();
	// 	$(this).parent().prev().find("[data-role='title']").addClass("active");
	// });

	// $(document).on("click","[data-type='dis'][data-id=3]",function(){
	// 	$(this).parent().next(".popup_choice").toggle();
	// });

	$("#addAll").click(function(){
		$("#selectingPanel").find("ul:visible").find("ol a").each(function(){
			$(this).click();
		});
	});

	$("#removeAll").click(function(){
		$("#selectedPanel a").each(function(){
			$(this).click();
		});
	});


	initOrgSelector();
	initSelectedPanel();


});
</script>
</head>
<body>
	<input id="currentBranchId" value="${currentBranchId}" type="hidden" />
	<input id="currentDepartmentId" value="${currentDepartmentId}" type="hidden"  />
	<input id="currentDepartmentIds" value="${currentDepartmentIds}" type="hidden" />
	<input id="currentCompanyNo" value="${currentCompanyNo}" type="hidden" />
	<input id="condition" value="${condition}" type="hidden" />
	<input id="selectedPosition" value='${selectedPosition}' type="hidden" />

	<section class="popup_padding">

		<section class="choice_form">
			<section id="topPanel" class="gray_border"></section>

			<section class="choice_result">
				<section class="search right">
					<a class="fr" href="#"> <em onclick="findByName();"
						class="icon csearch"></em>
					</a>
					<input type="search" id="queryName"
						placeholder="请输入关键字"></section>
				<section class="left">
					<dl>
						<dt>选择路径：</dt>
						<dd>
							<span id="selectRoute"></span>
						</dd>
					</dl>
				</section>
				<div class="clear">&nbsp;</div>
			</section>

			<section class="choice_details">
				<section class="list_tree">
					<section class="title">
						待选项（ <b id="selectingCount" class="blue"></b>
						）
					</section>
					<section class="content">
						<section class="tree_tab">
							<a class="active" href="javascript:void(0)">高频</a>
							<a href="javascript:void(0)">最近</a>
							<a href="javascript:void(0)">全部</a>
						</section>
						<section class="tree_menu">
							<section class="scroll">
								<section id="selectingPanel" class="padding">
									<ul style="display:none;" data-role="hot"></ul>
									<ul style="display:none;" data-role="new"></ul>
									<ul style="display:none;">
										<li>
											<a href="#"> <em class="icon l-arrow-down"></em>
												我自己
											</a>
											<ul data-role="myself"></ul>
										</li>
										<li>
											<a href="#">
												<em class="icon l-arrow-down"></em>
												全部
											</a>
											<ul data-role="all"></ul>
										</li>
									</ul>
								</section>
							</section>
						</section>
						<div class="clear">&nbsp;</div>
					</section>
				</section>
				<section class="btn_group">
					<a href="javascript:void(0)" class="btn btn_gray">添加</a>
					<a href="javascript:void(0)" class="btn btn_gray" id="addAll">全部添加</a>
					<a href="javascript:void(0)" class="btn btn_gray">删除</a>
					<a href="javascript:void(0)" class="btn btn_gray" id="removeAll">全部删除</a>
				</section>
				<section class="tree_result">
					<section class="title">
						已选项（ <b id="selectedCount">0</b>
						）
					</section>
					<section class="tree_rmenu">
						<section class="scroll">
							<section class="padding">
								<ul id="selectedPanel"></ul>
							</section>
						</section>
					</section>
				</section>
			</section>
		</section>
	</section>
</body>
</html>