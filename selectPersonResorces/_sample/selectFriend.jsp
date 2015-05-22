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


<style type="text/css">
body{
	font-size: 0.6em;
}
</style>

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

<li data-role="selectingPanel" data-id="{{=it.blockId}}">
	<a href="javascript:void(0)"> <em class="icon l-arrow-down"></em>
		{{=it.blockName[0]}}&nbsp;<b class="blue">&gt;</b>&nbsp;{{=it.blockName[1]}}
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
var options = {
	type: "message" //message,project
	//currentOrgId: 1,
	//currentDepId: 2
}

var actionName = "selectFriend";
var friendList = [];
var groupTypeList = [];
var secondLevelList = [];

//初始化好友类型
function initOrgSelector(){
	$.get(actionName + "!getFriendList", function(data) {
		friendList = eval("(" + data + ")");
		
		var groupIdList = [];
		var depIdList = [];
		var areaIdList = [];

		$(friendList).map(function(){
			var friend = this;

			friend.secondLevel = friend.depId || friend.areaId;
			friend.secondLevelName = friend.depName || friend.areaName;

			if($.inArray(friend.groupType,groupIdList) < 0){
				var groupType = {
					"id":friend.groupType,
					"name":friend.groupName,
					"type":"groupType",
					"parentId":0
				};
				groupTypeList.push(groupType);
				groupIdList.push(groupType.id);
			}

			//若为本企业版好友
			if(friend.groupType < 0){
				var depArray = friend.secondLevel.split(",");
				$(depArray).map(function(i){
					if($.inArray(this,depIdList) < 0){
						var dep = {
							"id": this,
							"name":friend.secondLevelName.split(",")[i],
							"type":"dep",
							"parentId":i == 0 ? friend.groupType:friend.secondLevel.split(",")[i-1]
						}
						secondLevelList.push(dep);
						depIdList.push(dep.id);
					}
				});
			}else{
				var areaArray = friend.secondLevel.split(",");
				$(areaArray).map(function(i){
					if($.inArray(this.toString(),areaIdList) < 0){
						var area = {
							"id": this.toString(),
							"name":friend.secondLevelName.split(",")[i],
							"type":"area",
							"parentId":i == 0 ? 0:friend.secondLevel.split(",")[i-1].toString()
						}
						secondLevelList.push(area);
						areaIdList.push(area.id);
					}
				})
			}


			if ($("#selectedFriend").val()) {
				var selectedFriend = $("#selectedFriend").val().split(",");
				var id = friend.companyNo + "_" + friend.positionId;
				if ($.inArray(id, selectedFriend) > -1) {
					initSelectedPanel(friend);
				}
			}

		});

		var groupPanel = doT.template($("#topPanelTemp").html());
		$("#topPanel").append(groupPanel({
			title: "好友类型",
			data: groupTypeList
		}));


		$("#topPanel").find("[data-role='topPanelButton'][data-type='groupType'][data-id='-1']").click();
	});

}

//初始化二级筛选条件
function initDepartSelector(level,parentId,type){

    $("#topPanel").find("[data-role=topPanel]:gt(" + level + ")").remove();

	var secondPanel = doT.template($("#topPanelTemp").html()),_title,_data;

	if(parentId < 0 && !type){
		type = "dep";
	}

	if (type == "dep") {
		_title = "部门";
		_data = $(secondLevelList).map(function() {
			if (this.type == "dep" && this.parentId == parentId) {
				return this;
			}
		}).get();
	}else if(level == 0){
		_title = "国家";
		_data = $(secondLevelList).map(function() {
			if (this.type == "area" && this.parentId == 0) {
				return this;
			}
		}).get();
	}else if(level == 1){
		_title = "省";
		_data = $(secondLevelList).map(function() {
			if (this.type == "area" && this.parentId == parentId) {
				return this;
			}
		}).get();
	}

	if (_data && _data.length > 0) {
		$("#topPanel").append(secondPanel({
			title: _title,
			data: _data
		}));
	}


	$("#topPanel").find("[data-role=topPanel]").last().addClass("no_dash").siblings().removeClass("no_dash");
}

//初始化带选区我自己
function initMySelf(){
	var myselfPanel = $("#selectingPanel ul[data-role='myself']").empty();
	var selectingPanel = doT.template($("#selectingPanelTemp").html());

	var blockId = $("#blockId").val(),
		blockName = [];
		blockName.push($("#orgName").val());
		blockName.push($("#depName").val());

	myselfPanel.append(selectingPanel({
		"blockId":blockId,
		"blockName":blockName
	}));

	var ol = myselfPanel.find("[data-id='" + blockId + "']").find("ol");
	ol.append("<li><a href='javascript:void(0)' data-id='" + $("#id").val() + "'>" + $("#posName").val()+" "+$("#userName").val() + "</a></li>");
}


//初始化待选区
function initSelectingPanel(){
	//$("#selectingPanel ul").empty();

	var allPanel = $("#selectingPanel ul[data-role='all']").empty(),
		hotPanel = $("#selectingPanel ul[data-role='hot']"),
		newPanel = $("#selectingPanel ul[data-role='new']");

		var currentGroupType;
		var condition = [];

	$("#selectRoute span").each(function(index,element){
		if(index == 0){
			currentGroupType = $(element).attr("data-id");
		}else{
			condition.push($(element).attr("data-id"));
		}
	});

	$(friendList).map(function(){	
		var flag = 1;
		if(this.groupType != currentGroupType){
			flag = 0;
		}

		if(condition.length > 0 && this.secondLevel.indexOf(condition.join(",")) == -1){
			flag = 0;
		}

		if(flag == 1){
			var blockId = (this.orgId || this.secondLevel.split(",")[1]) +"_"+ this.secondLevel.split(",")[this.secondLevel.split(",").length - 1],
				blockName = [];
				blockName.push(this.orgName || this.secondLevelName.split(",")[1]);
				blockName.push(this.secondLevelName.split(",")[this.secondLevelName.split(",").length - 1]);
			if (allPanel.find("[data-id='" + blockId + "']").size() == 0) {
				var selectingPanel = doT.template($("#selectingPanelTemp").html());
				allPanel.append(selectingPanel({
					"blockId":blockId,
					"blockName":blockName
				}));
			}
			var ol = allPanel.find("[data-id='" + blockId + "']").find("ol"),
				friendId = this.companyNo + "_" + this.positionId,
				friendName = (this.positionName || this.companyName) + " " + (this.userName);
			ol.append("<li><a href='javascript:void(0)' data-id='" + friendId + "'>" + friendName + "</a></li>");
		}
	});


}

//初始化已选项
function initSelectedPanel(data){
	var htmlArray = [];
	if (data.positionName) {
		htmlArray.push(data.positionName + " " + data.userName);
		htmlArray.push(data.secondLevelName.split(",")[data.secondLevelName.split(",").length - 1]);
		htmlArray.push(data.orgName);
	} else {
		htmlArray.push(data.companyName + " " + data.userName);
		htmlArray.push(data.secondLevelName.split(",")[2]);
		htmlArray.push(data.secondLevelName.split(",")[3]);
	}

	var html = '<li><a href="javascript:void(0);" data-id="' + data.companyNo + "_" + data.positionId + '" data-name="' + htmlArray[0] + '">' + htmlArray.join(' <b class="blue">&gt;</b> ') + '</a><li>';

	$("#selectedPanel").find("a[data-type='" + $(this).attr("data-type") + "'][data-id='" + $(this).attr("data-id") + "']").remove()
	$(html).prependTo($("#selectedPanel"));

	$("#selectedCount").html($("#selectedPanel li a").size());
}

//更新选择路径
function refreshSelectRoute() {
	$("#selectRoute").empty();
	var routeArray = [];
	$("#topPanel").find(".active[data-id]").each(function() {
		routeArray.push("<span data-id='" + $(this).attr("data-id") + "'>" + $(this).html() + "</span>");
	});
	if (routeArray.length > 0) {
		$("#selectRoute").append('<a href="#" class="active"><em class="fr">x</em>' + routeArray.join(" > ") + '</a>');
	}

	initSelectingPanel();
	$(".tree_tab a").last().click();
}

//点击筛选条件
$(document).on("click","#topPanel [data-role='topPanelButton']",function(){
	 if(!$(this).hasClass("active")){
	 	$(this).addClass("active").siblings().removeClass("active");

	 	var obj = this,params,level;

	 	if ($(obj).attr("data-type") == "groupType") {
			//$("#currentBranchId").val($(obj).attr("data-id"));
			level = 0;
			initDepartSelector(level,$(obj).attr("data-id"));
	 	} else {
	 		level = $(obj).parents("[data-role='topPanel']").index();
	 		initDepartSelector(level,$(obj).attr("data-id"),$(obj).attr("data-type"));
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

		var html = '<li><a href="javascript:void(0);" data-id="'+$(this).attr("data-id")+'" data-name="'+$(this).html()+'">' + htmlArray.join(' <b class="blue">&gt;</b> ') + '</a><li>';

		$("#selectedPanel").find("a[data-id='"+$(this).attr("data-id")+"']").remove()
		$(html).prependTo($("#selectedPanel"));
		
	}else{
		// $(this).next().children("li").each(function(){
		// 	$(this).children("a").click();
		// });
	}

	$("#selectedCount").html($("#selectedPanel li a").size());
});

$(function(){
	



	// $(document).on("click","[data-role=more]",function(){
	// 	$("[data-role='title']").removeClass("active");
	// 	$(".popup_choice").hide();

	// 	$(this).parent().prev().find(".popup_choice").show();
	// 	$(this).parent().prev().find("[data-role='title']").addClass("active");
	// });

	// $(document).on("click","[data-role=title]",function(){
	// 	$("[data-role='title']").removeClass("active");
	// 	$(".popup_choice").hide();

	// 	$(this).parent().prev().find(".popup_choice").show();
	// 	$(this).parent().prev().find("[data-role='title']").addClass("active");
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
	initMySelf();

});
</script>
</head>
<body>
	<input id="id" value="${request.userInfo.companyNo}_${request.userInfo.positionId}" type="hidden" />
	<input id="blockId" value="${request.userInfo.orgId}_${request.userInfo.departmentId}" type="hidden" />
	<input id="orgName" value="${request.userInfo.org.name}" type="hidden" />
	<input id="depName" value="${request.userInfo.position.orgDepartment.name}" type="hidden" />
	<input id="posName" value="${request.userInfo.position.name}" type="hidden" />
	<input id="userName" value="${request.userInfo.name}" type="hidden" />
	<input id="selectedFriend" value="${selectedFriend}" type="hidden" />

	<!-- <h1 style="margin: 20px 0px">1/项目、任务、即时通、流程使用中 选人、选择界面</h1>
	-->
	<section class="popup_padding">

		<section class="choice_form" style="width:100%;">
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
						<section>
							<section class="tree_tab">
								<a class="active" href="javascript:void(0)">高频</a>
								<a href="javascript:void(0)">最近</a>
								<a href="javascript:void(0)">全部</a>
							</section>
							<section class="tree_menu">
								<section class="scroll">
									<section id="selectingPanel" class="padding">
										<ul style="display:none;" data-role="hot">
											<li>
												<a href="#"> <em class="icon l-arrow-down"></em>
													我自己
												</a>
												<ul>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构1&nbsp; <b class="blue">&gt;</b>
															&nbsp;销售部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="1">销售部经理</a>
															</li>
														</ol>
													</li>
												</ul>
											</li>
											<li>
												<a href="#">
													<em class="icon l-arrow-down"></em>
													高频
												</a>
												<ul>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构1&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;销售部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="1">销售部经理</a>
															</li>
															<li>
																<a href="#" data-type="pos" data-id="2">销售员</a>
															</li>
														</ol>
													</li>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构2&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;采购部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="3">采购员</a>
															</li>
														</ol>
													</li>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															广东&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;广州
														</a>
														<ol>
															<li>
																<a href="#" data-type="cus" data-id="1">供应商1</a>
															</li>
														</ol>
													</li>
												</ul>
											</li>
										</ul>
										<ul style="display:none;" data-role="new">
											<li>
												<a href="#">
													<em class="icon l-arrow-down"></em>
													我自己
												</a>
												<ul>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构1&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;销售部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="1">销售部经理</a>
															</li>
														</ol>
													</li>
												</ul>
											</li>
											<li>
												<a href="#">
													<em class="icon l-arrow-down"></em>
													最近
												</a>
												<ul>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构1&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;销售部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="1">销售部经理</a>
															</li>
															<li>
																<a href="#" data-type="pos" data-id="2">销售员</a>
															</li>
														</ol>
													</li>
													<li>
														<a href="#">
															<em class="icon l-arrow-down"></em>
															机构2&nbsp;
															<b
																		class="blue">&gt;</b>
															&nbsp;采购部
														</a>
														<ol>
															<li>
																<a href="#" data-type="pos" data-id="3">采购员</a>
															</li>
														</ol>
													</li>
												</ul>
											</li>

										</ul>
										<ul style="display:none;">
											<li>
												<a href="#">
													<em class="icon l-arrow-down"></em>
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
						已选项（
						<b id="selectedCount">0</b>
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