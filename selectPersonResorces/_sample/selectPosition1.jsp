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
				<a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a>
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

<script id="mySelfTemp" type="text/template">

<li id="mySelf">
	<a href="#"> <em class="icon l-arrow-down"></em>
	我自己
	</a>
	<ul>
		<li>
			<a href="#"> <em class="icon l-arrow-down"></em>
				机构2&nbsp;
				<b
				class="blue">&gt;</b>
				&nbsp;销售部
			</a>
			<ol>
				<li>
					<a href="#" class="active">销售部经理</a>
				</li>
			</ol>
		</li>
	</ul>
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
	type: "project", //message,flow
	currentOrgId: 1,
	currentDepId: 2
}

var orgArray = [{
	id:1,
	name:"机构1",
	type:"org"
},{
	id:2,
	name:"机构2",
	type:"org"
},{
	id:3,
	name:"机构3",
	type:"org"
},{
	id:1,
	name:"客户",
	type:"customer"
},{
	id:2,
	name:"供应商",
	type:"customer"
},{
	id:3,
	name:"服务商",
	type:"customer"
}];

var depArray = [{
	id:1,
	name:"部门1-1",
	type:"dep",
	parentId:1
},{
	id:2,
	name:"部门1-2",
	type:"dep",
	parentId:1
},{
	id:3,
	name:"部门1-3",
	type:"dep",
	parentId:1
},{
	id:4,
	name:"部门2-1",
	type:"dep",
	parentId:2
},{
	id:5,
	name:"部门2-2",
	type:"dep",
	parentId:2
},{
	id:6,
	name:"部门3-1",
	type:"dep",
	parentId:3
}];

var friendGroup = [{
	id:4,
	name:"客户1",
	type:"",
	parentId:1
},{
	id:5,
	name:"客户2",
	type:"",
	parentId:1
},{
	id:6,
	name:"供应商1",
	type:"",
	parentId:2
},{
	id:7,
	name:"供应商2",
	type:"",
	parentId:2
},{
	id:8,
	name:"服务商1",
	type:"",
	parentId:3
}]


var countryArray = [{
	id:1,
	name:"中国",
	type:"cou"
},{
	id:2,
	name:"美国",
	type:"cou"
},{
	id:3,
	name:"新加坡",
	type:"cou"
}]

var distinctArray = [{
	id:1,
	name:"上海",
	type:"dis",
	parentId:1
},{
	id:2,
	name:"北京",
	type:"dis",
	parentId:1
},{
	id:3,
	name:"广东",
	type:"dis",
	parentId:1
},{
	id:4,
	name:"江苏",
	type:"dis",
	parentId:1
},{
	id:5,
	name:"加州",
	type:"dis",
	parentId:2
},{
	id:6,
	name:"佛州",
	type:"dis",
	parentId:2
},{
	id:7,
	name:"新加坡城",
	type:"dis",
	parentId:3
}]

function initProjectSelector(){
	var orgPanel = doT.template($("#topPanelTemp").html());
	$("#topPanel").append(orgPanel({
		title: "机构",
		data: orgArray
	}));
	$("#topPanel").find("[data-type='org'][data-id=" + options.currentOrgId + "]").click();
}

function getDepArray(orgId){
	return $(depArray).map(function(){
		if(this.parentId == orgId){
			return this;
		}
	}).get();
}

function getFriendGroupArray(parentId){
	return $(friendGroup).map(function(){
		if(this.parentId == parentId){
			return this;
		}
	}).get();
}

function initDepartSelector(){
	$("#topPanel").find("[data-role=topPanel]:gt(0)").remove();

	var depPanel = doT.template($("#topPanelTemp").html());
	$("#topPanel").append(depPanel({
		title:"部门",
		data:getDepArray(options.currentOrgId)
	}));

	var currentDep = $("#topPanel").find("[data-type='dep'][data-id=" + options.currentDepId + "]");
	if(currentDep.size() == 0){
		currentDep = $("#topPanel").find("[data-type='dep']").eq(0);
	}
	options.currentDepId = currentDep.attr("data-id");
	currentDep.click();
}

function initCustomerSelector(parentId){
	$("#topPanel").find("[data-role=topPanel]:gt(0)").remove();

	var friendGroupPanel = doT.template($("#topPanelTemp").html());
	$("#topPanel").append(friendGroupPanel({
		title:"好友小类",
		data:getFriendGroupArray(parentId)
	}));

	var couPanel = doT.template($("#topPanelTemp").html());
	$("#topPanel").append(couPanel({
		title:"国家",
		data:countryArray
	}));

	var disPanel = doT.template($("#topPanelTemp").html());
	$("#topPanel").append(disPanel({
		title:"省",
		data:distinctArray
	}));
}

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

function refreshSelectingPanel(){
	$(".tree_tab a").first().click();
}


$(function(){
	$(document).on("click","#topPanel [data-role='topPanelButton']",function(){
		if(!$(this).hasClass("active")){
			$(this).addClass("active").siblings().removeClass("active");

			if ($(this).attr("data-type") == "org") {
				options.currentOrgId = $(this).attr("data-id");
				initDepartSelector();
			} else if ($(this).attr("data-type") == "customer") {
				initCustomerSelector($(this).attr("data-id"));
			} else if ($(this).attr("data-type") == "dep") {
				options.currentDepId = $(this).attr("data-id");
			} else if ($(this).attr("data-type") == "cou") {
				$("#topPanel").find("[data-type='dis']").removeClass("active").hide();
				$("#topPanel").find("[data-type='dis'][data-parentId="+$(this).attr("data-id")+"]").show();
			}


			$("#topPanel").find("[data-role=topPanel]").last().addClass("no_dash");
			refreshSelectRoute();
			refreshSelectingPanel();
		}
	});

	$(document).on("click",".tree_tab a",function(){
		$(this).addClass("active").siblings().removeClass("active");
		var selectingPanel = $("#selectingPanel > ul").eq($(this).index());
		selectingPanel.show().siblings().hide();

		$("#selectingCount").html(selectingPanel.find("ol a").size());
	});

	$(document).on("click","#selectingPanel a",function(){
		if ($(this).parents("ol").size() > 0) {
			var htmlArray = [];

			htmlArray.push($(this).html());

			var parent = $(this).parents("ol").eq(0).prev().clone();
			parent.find("em").remove();
			htmlArray.push(parent.html());

			var html = '<li><a href="#" data-type="'+$(this).attr("data-type")+'" data-id="'+$(this).attr("data-id")+'">' + htmlArray.join(' <b class="blue">&gt;</b> ') + '</a><li>';

			$("#selectedPanel").find("a[data-type='"+$(this).attr("data-type")+"'][data-id='"+$(this).attr("data-id")+"']").remove()
		    $(html).prependTo($("#selectedPanel"));
			
		}else{
			$(this).next().children("li").each(function(){
				$(this).children("a").click();
			});
		}

		$("#selectedCount").html($("#selectedPanel li a").size());
	});

	$(document).on("click","#selectedPanel a",function(){
		$(this).parent().remove();

		$("#selectedCount").html($("#selectedPanel li a").size());
	});

	$(document).on("click","[data-role=more]",function(){
		$("[data-role='title']").removeClass("active");
		$(".popup_choice").hide();

		$(this).parent().prev().find(".popup_choice").show();
		$(this).parent().prev().find("[data-role='title']").addClass("active");
	});

	$(document).on("click","[data-role=title]",function(){
		$("[data-role='title']").removeClass("active");
		$(".popup_choice").hide();

		$(this).parent().prev().find(".popup_choice").show();
		$(this).parent().prev().find("[data-role='title']").addClass("active");
	});

	$(document).on("click","[data-type='dis'][data-id=3]",function(){
		$(this).parent().next(".popup_choice").toggle();
	});

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


	if(options.type=="project"){
		initProjectSelector();
	}


});
</script>
</head>
<body>


	<!-- <h1 style="margin: 20px 0px">1/项目、任务、即时通、流程使用中 选人、选择界面</h1> -->
	<div class="panel window" style="width: 780px; position: relative;">
		<div style="overflow: hidden; width: 778.233px; height: 746px;"
			title="" class="panel-body panel-body-noborder window-body">
			<div class="panel" style="display: block; width: 778px;">
				<div title=""
					class="panel-body panel-body-noheader panel-body-noborder dialog-content"
					style="width: 778px; height: 700px;">
					<section class="popup_padding">

						<section class="choice_form">
							<section id="topPanel" class="gray_border">

							</section>

							<section class="choice_result">
								<section class="search right">
									<a class="fr" href="#"><em onclick="findByName();"
										class="icon csearch"></em></a> <input type="search" id="queryName"
										placeholder="请输入关键字">
								</section>
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
										待选项（<b id="selectingCount" class="blue"></b>）
									</section>
									<section class="content">

											<section class="tree_tab">
												<a class="active" href="javascript:void(0)">高频</a><a href="javascript:void(0)">最近</a><a href="javascript:void(0)">全部</a>
											</section>
											<section class="tree_menu">
												<section class="scroll">
													<section id="selectingPanel" class="padding">
														<ul style="display:none;">
															<li>
																<a href="#"> <em class="icon l-arrow-down"></em>
																我自己
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																<a href="#"> <em class="icon l-arrow-down"></em>
																高频
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
														<ul style="display:none;">
															<li>
																<a href="#"> <em class="icon l-arrow-down"></em>
																我自己
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																<a href="#"> <em class="icon l-arrow-down"></em>
																最近
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																<a href="#"> <em class="icon l-arrow-down"></em>
																我自己
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																<a href="#"> <em class="icon l-arrow-down"></em>
																全部
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																				<a href="#" data-type="pos" data-id="4">销售员1</a>
																			</li>
																			<li>
																				<a href="#" data-type="pos" data-id="5">销售员2</a>
																			</li>
																		</ol>
																	</li>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
																			机构2&nbsp;
																			<b
																			class="blue">&gt;</b>
																			&nbsp;采购部
																		</a>
																		<ol>
																			<li>
																				<a href="#" data-type="pos" data-id="6">采购员1</a>
																			</li>
																			<li>
																				<a href="#" data-type="pos" data-id="7">采购员2</a>
																			</li>
																			<li>
																				<a href="#" data-type="pos" data-id="8">采购员3</a>
																			</li>
																			<li>
																				<a href="#" data-type="pos" data-id="9">采购员4</a>
																			</li>
																		</ol>
																	</li>
																</ul>
															</li>

															<li>
																<a href="#"> <em class="icon l-arrow-down"></em>
																高频
																</a>
																<ul>
																	<li>
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
																		<a href="#"> <em class="icon l-arrow-down"></em>
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
										已选项（<b id="selectedCount">0</b>）
									</section>
									<section class="tree_rmenu">
										<section class="scroll">
											<section class="padding">
												<ul id="selectedPanel">


												</ul>
											</section>
										</section>
									</section>
								</section>
							</section>
						</section>
					</section>

				</div>
			</div>
			<div class="dialog-button">
				<a href="javascript:void(0)" class="l-btn l-btn-small" group=""
					id=""><span class="l-btn-left"><span class="l-btn-text">保存</span></span></a><a
					href="javascript:void(0)" class="l-btn l-btn-small" group="" id=""><span
					class="l-btn-left"><span class="l-btn-text">取消</span></span></a>
			</div>
		</div>
	</div>


	<!-- <h1 style="margin: 20px 0px">2/项目、任务、即时通、流程使用中 选人、选择界面2-左侧树2</h1>
	<div class="panel window" style="width: 780px; position: relative;">
		<div style="overflow: hidden; width: 778.233px; height: 745px;"
			title="" class="panel-body panel-body-noborder window-body">
			<div class="panel" style="display: block; width: 778px;">
				<div title=""
					class="panel-body panel-body-noheader panel-body-noborder dialog-content"
					style="width: 778px; height: 700px;">
					<section class="popup_padding">

						<section class="choice_form">
							<section class="gray_border">
								<dl>
									<dt>
										<a href="#">类型：</a>
										<section class="popup_choice" style="display: none">
											<em class="icon pop_arrow"></em>
											<section class="choice_content">
												<a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a>
											</section>
											<section class="pagination">
												<section class="right">
													<a class="icon_bg" href="#"><em title="上一页" alt="上一页"
														class="icon cprev"></em></a><span><a class="active"
														href="#">1</a><a href="#">2</a><a href="#">3</a><a
														href="#">4</a></span><span>跳转到 <input type="text"
														value="1"> &nbsp;页/共4页
													</span><a class="icon_bg" href="#"><em title="下一页" alt="下一页"
														class="icon cnext"></em></a>
												</section>
												<section class="left">
													<a href="#" class="btn btn_blue">确定</a>
												</section>
											</section>
										</section>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">本机构</a><a
											href="#">机构1</a><a href="#" class="active">客户</a><a href="#">供应商</a><a
											href="#">服务商</a><a href="#">往来机构</a><a href="#">快递</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">类型2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">上海</a><a href="#">上海</a><a href="#">南京</a><a
											href="#">天津</a><a href="#">北京</a><a href="#">苏州</a><a
											href="#">西安</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">分类1：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">全部</a><a
											href="#">本部门</a><a href="#">财务部</a><a href="#" class="active">销售部</a><a
											href="#">销售部</a><a href="#">销售部</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">分类2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">全部</a><a href="#">本部门</a><a href="#">财务部</a><a
											href="#">销售部</a><a href="#">销售部</a><a href="#">销售部</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">角色：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">角色1</a><a href="#">角色1</a><a href="#">角色1</a><a
											href="#">角色1</a><a href="#">角色1</a><a href="#">角色1</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
							</section>

							<section class="tap gray_border">
								<a href="#" class="active">高频</a><a href="#">岗位</a><a href="#">职位</a><a
									href="#">人员</a>
							</section>

							<section class="choice_result">
								<section class="search right">
									<a class="fr" href="#"><em onclick="findByName();"
										class="icon csearch"></em></a> <input type="search" id="queryName"
										placeholder="请输入关键字">
								</section>
								<section class="left">
									<dl>
										<dt>选择路径：</dt>
										<dd>
											<span><a href="#" class="active"><em class="fr">x</em>本机构&nbsp;&gt;&nbsp;销售&nbsp;&gt;&nbsp;岗位</a></span>
										</dd>
									</dl>
								</section>
								<div class="clear">&nbsp;</div>
							</section>


							<section class="choice_details">
								<section class="list_tree">
									<section class="title">
										待选项（<b class="blue">25</b>）
									</section>
									<section class="content">
										<section class="right">
											<section class="fast_choice">
												<section class="stitle">快捷选择</section>
												<section class="fast_choice_list">
													<section class="scroll">
														<section class="padding">
															<ul>
																<li><input type="checkbox" />发起人</li>
																<li><input type="checkbox" />执行时选择</li>
															</ul>
															<hr />
															<b>发起人的</b>
															<ul>
																<li><input type="checkbox" />直属上级</li>
																<li><input type="checkbox" />直属上上级</li>
																<li><input type="checkbox" />部门负责人</li>
															</ul>
															<hr />
															<ul>
																<li><input type="checkbox" />本部门负责人</li>
																<li><input type="checkbox" />本部门最高上级</li>
																<li><input type="checkbox" />财务经理</li>
																<li><input type="checkbox" />总经理</li>
															</ul>
														</section>
													</section>
												</section>
											</section>

										</section>
										<section class="left">
											<section class="tree_tab">
												<a class="active" href="#">高频</a><a href="#">最近</a><a
													href="#">全部</a>
											</section>
											<section class="tree_menu">
												<section class="scroll">
													<section class="padding">
														<ul>
															<li><a href="#"><em class="icon l-arrow-down"></em>岗位&nbsp;<b
																	class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ111</a>
																<ul>
																	<li><a href="#" class="active">总经理</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																</ul></li>
															<li><a href="#"><em class="icon l-arrow-down"></em>岗位&nbsp;<b
																	class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ112</a>
																<ul>
																	<li><a href="#">总经理</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																	<li><a href="#">岗位</a></li>
																</ul></li>
														</ul>
													</section>
												</section>
											</section>
										</section>

										<div class="clear">&nbsp;</div>
									</section>
								</section>
								<section class="btn_group">
									<a href="#" class="btn btn_gray">添加</a><a href="#"
										class="btn btn_gray">全部添加</a><a href="#" class="btn btn_gray">删除</a><a
										href="#" class="btn btn_gray">全部删除</a>
								</section>
								<section class="tree_result">
									<section class="title">
										已选项（<b>1</b>）
									</section>
									<section class="tree_rmenu">
										<section class="scroll">
											<section class="padding">
												<ul>
													<li><a href="#" class="active">岗位&nbsp;<b
															class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ111&nbsp;<b
															class="blue">&gt;</b>&nbsp;总经理
													</a></li>

												</ul>
											</section>
										</section>
									</section>
								</section>
							</section>
						</section>
					</section>

				</div>
			</div>
			<div class="dialog-button">
				<a href="javascript:void(0)" class="l-btn l-btn-small" group=""
					id=""><span class="l-btn-left"><span class="l-btn-text">保存</span></span></a><a
					href="javascript:void(0)" class="l-btn l-btn-small" group="" id=""><span
					class="l-btn-left"><span class="l-btn-text">取消</span></span></a>
			</div>
		</div>
	</div>

	<h1 style="margin: 20px 0px">3/项目、任务、即时通、流程使用中 选人、选择界面3-无快速选择</h1>
	<div class="panel window" style="width: 780px; position: relative;">
		<div style="overflow: hidden; width: 778.233px; height: 745px;"
			title="" class="panel-body panel-body-noborder window-body">
			<div class="panel" style="display: block; width: 778px;">
				<div title=""
					class="panel-body panel-body-noheader panel-body-noborder dialog-content"
					style="width: 778px; height: 700px;">
					<section class="popup_padding">

						<section class="choice_form">
							<section class="gray_border">
								<dl>
									<dt>
										<a href="#">类型：</a>
										<section class="popup_choice" style="display: none">
											<em class="icon pop_arrow"></em>
											<section class="choice_content">
												<a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a>
											</section>
											<section class="pagination">
												<section class="right">
													<a class="icon_bg" href="#"><em title="上一页" alt="上一页"
														class="icon cprev"></em></a><span><a class="active"
														href="#">1</a><a href="#">2</a><a href="#">3</a><a
														href="#">4</a></span><span>跳转到 <input type="text"
														value="1"> &nbsp;页/共4页
													</span><a class="icon_bg" href="#"><em title="下一页" alt="下一页"
														class="icon cnext"></em></a>
												</section>
												<section class="left">
													<a href="#" class="btn btn_blue">确定</a>
												</section>
											</section>
										</section>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">本机构</a><a
											href="#">机构1</a><a href="#" class="active">客户</a><a href="#">供应商</a><a
											href="#">服务商</a><a href="#">往来机构</a><a href="#">快递</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">类型2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">上海</a><a href="#">上海</a><a href="#">南京</a><a
											href="#">天津</a><a href="#">北京</a><a href="#">苏州</a><a
											href="#">西安</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">分类1：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">全部</a><a
											href="#">本部门</a><a href="#">财务部</a><a href="#" class="active">销售部</a><a
											href="#">销售部</a><a href="#">销售部</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">分类2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">全部</a><a href="#">本部门</a><a href="#">财务部</a><a
											href="#">销售部</a><a href="#">销售部</a><a href="#">销售部</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">角色：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">角色1</a><a href="#">角色1</a><a href="#">角色1</a><a
											href="#">角色1</a><a href="#">角色1</a><a href="#">角色1</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
							</section>

							<section class="tap gray_border">
								<a href="#" class="active">高频</a><a href="#">岗位</a><a href="#">职位</a><a
									href="#">人员</a>
							</section>

							<section class="choice_result">
								<section class="search right">
									<a class="fr" href="#"><em onclick="findByName();"
										class="icon csearch"></em></a> <input type="search" id="queryName"
										placeholder="请输入关键字">
								</section>
								<section class="left">
									<dl>
										<dt>选择路径：</dt>
										<dd>
											<span><a href="#" class="active"><em class="fr">x</em>本机构&nbsp;&gt;&nbsp;销售&nbsp;&gt;&nbsp;岗位</a></span>
										</dd>
									</dl>
								</section>
								<div class="clear">&nbsp;</div>
							</section>


							<section class="choice_details">
								<section class="list_tree">
									<section class="title">
										待选项（<b class="blue">25</b>）
									</section>
									<section class="content">

										<section class="tree_tab">
											<a class="active" href="#">高频</a><a href="#">最近</a><a
												href="#">全部</a>
										</section>
										<section class="tree_menu">
											<section class="scroll">
												<section class="padding">
													<ul>
														<li><a href="#"><em class="icon l-arrow-down"></em>岗位&nbsp;<b
																class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ111</a>
															<ul>
																<li><a href="#" class="active">总经理</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
															</ul></li>
														<li><a href="#"><em class="icon l-arrow-down"></em>岗位&nbsp;<b
																class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ112</a>
															<ul>
																<li><a href="#">总经理</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
																<li><a href="#">岗位</a></li>
															</ul></li>
													</ul>
												</section>
											</section>
										</section>

									</section>
								</section>
								<section class="btn_group">
									<a href="#" class="btn btn_gray">添加</a><a href="#"
										class="btn btn_gray">全部添加</a><a href="#" class="btn btn_gray">删除</a><a
										href="#" class="btn btn_gray">全部删除</a>
								</section>
								<section class="tree_result">
									<section class="title">
										已选项（<b>1</b>）
									</section>
									<section class="tree_rmenu">
										<section class="scroll">
											<section class="padding">
												<ul>
													<li><a href="#" class="active">岗位&nbsp;<b
															class="blue">&gt;</b>&nbsp;总部&nbsp;<b class="blue">&gt;</b>&nbsp;JQ111&nbsp;<b
															class="blue">&gt;</b>&nbsp;总经理
													</a></li>

												</ul>
											</section>
										</section>
									</section>
								</section>
							</section>
						</section>
					</section>

				</div>
			</div>
			<div class="dialog-button">
				<a href="javascript:void(0)" class="l-btn l-btn-small" group=""
					id=""><span class="l-btn-left"><span class="l-btn-text">保存</span></span></a><a
					href="javascript:void(0)" class="l-btn l-btn-small" group="" id=""><span
					class="l-btn-left"><span class="l-btn-text">取消</span></span></a>
			</div>
		</div>
	</div>

	<h1 style="margin: 20px 0px">4/项目、任务、即时通、流程使用中 选人、选择界面4</h1>
	<div class="panel window" style="width: 780px; position: relative;">
		<div style="overflow: hidden; width: 778.233px; height: 745px;"
			title="" class="panel-body panel-body-noborder window-body">
			<div class="panel" style="display: block; width: 778px;">
				<div title=""
					class="panel-body panel-body-noheader panel-body-noborder dialog-content"
					style="width: 778px; height: 700px;">
					<section class="popup_padding">

						<section class="choice_form">
							<section class="gray_border">
								<dl>
									<dt>
										<a href="#">类型：</a>
										<section class="popup_choice" style="display: none">
											<em class="icon pop_arrow"></em>
											<section class="choice_content">
												<a href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构1</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构1</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构1</a><a href="#">机构2</a><a
													href="#">机构2</a><a href="#">机构2</a><a href="#">机构2</a>
											</section>
											<section class="pagination">
												<section class="right">
													<a class="icon_bg" href="#"><em title="上一页" alt="上一页"
														class="icon cprev"></em></a><span><a class="active"
														href="#">1</a><a href="#">2</a><a href="#">3</a><a
														href="#">4</a></span><span>跳转到 <input type="text"
														value="1"> &nbsp;页/共4页
													</span><a class="icon_bg" href="#"><em title="下一页" alt="下一页"
														class="icon cnext"></em></a>
												</section>
												<section class="left">
													<a href="#" class="btn btn_blue">确定</a>
												</section>
											</section>
										</section>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">本机构</a><a
											href="#" class="active">客户</a><a href="#">供应商</a><a href="#">服务商</a><a
											href="#">往来机构</a><a href="#">快递</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">类型2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">上海</a><a href="#">南通</a><a href="#">南京</a><a
											href="#">天津</a><a href="#">北京</a><a href="#">苏州</a><a
											href="#">西安</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl>
									<dt>
										<a href="#">分类1：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">中国</a><a
											href="#">美国</a><a href="#">新加坡</a><a href="#" class="active">加拿大</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">分类2：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#">北京</a><a
											href="#">上海</a><a href="#" class="active">广东</a><a href="#">江苏</a></span>
										<section class="popup_choice">
											<section class="choice_content">
												<span class="active"><input type="checkbox" checked="checked" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span><span><input type="checkbox" />广州</span><span><input
													type="checkbox" />中山</span><span><input type="checkbox" />佛山</span><span><input
													type="checkbox" />珠海</span>
											</section>

										</section>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
								<dl class="no_dash">
									<dt>
										<a href="#">角色：</a>
									</dt>
									<dd>
										<a href="#" class="right">&gt;&gt;</a><span><a href="#"
											class="active">角色1</a><a href="#">角色1</a><a href="#">角色1</a><a
											href="#">角色1</a><a href="#">角色1</a><a href="#">角色1</a></span>
									</dd>
								</dl>
								<div class="clear">&nbsp;</div>
							</section>

							<section class="tap gray_border">
								<a href="#" class="active">高频</a><a href="#">岗位</a><a href="#">职位</a><a
									href="#">人员</a>
							</section>

							<section class="choice_result">
								<section class="search right">
									<a class="fr" href="#"><em onclick="findByName();"
										class="icon csearch"></em></a> <input type="search" id="queryName"
										placeholder="请输入关键字">
								</section>
								<section class="left">
									<dl>
										<dt>选择路径：</dt>
										<dd>
											<span><a href="#" class="active"><em class="fr">x</em>本机构&nbsp;&gt;&nbsp;销售&nbsp;&gt;&nbsp;岗位</a></span>
										</dd>
									</dl>
								</section>
								<div class="clear">&nbsp;</div>
							</section>


							<section class="choice_details">
								<section class="list_tree">
									<section class="title">
										待选项（<b class="blue">25</b>）
									</section>
									<section class="content">

										<section class="tree_tab">
											<a class="active" href="#">高频</a><a href="#">最近</a><a
												href="#">全部</a>
										</section>
										<section class="tree_menu">
											<section class="scroll">
												<section class="padding">
													<ul>
														<li><a href="#"><em class="icon l-arrow-down"></em>我自己</a>
															<ul>
																<li><a href="#"><em class="icon l-arrow-down"></em>广东&nbsp;<b
																		class="blue">&gt;</b>&nbsp;广州</a>
																	<ol>
																		<li><a href="#" class="active">广州A客户</a></li>
																	</ol></li>
																<li><a href="#"><em class="icon l-arrow-down"></em>广东&nbsp;<b
																		class="blue">&gt;</b>&nbsp;广州</a>
																	<ol>
																		<li><a href="#">广州A客户</a></li>
																	</ol></li>
															</ul></li>

													</ul>
												</section>
											</section>
										</section>

									</section>
								</section>
								<section class="btn_group">
									<a href="#" class="btn btn_gray">添加</a><a href="#"
										class="btn btn_gray">全部添加</a><a href="#" class="btn btn_gray">删除</a><a
										href="#" class="btn btn_gray">全部删除</a>
								</section>
								<section class="tree_result">
									<section class="title">
										已选项（<b>1</b>）
									</section>
									<section class="tree_rmenu">
										<section class="scroll">
											<section class="padding">
												<ul>
													<li><a href="#" class="active">我自己&nbsp;<b
															class="blue">&gt;</b>&nbsp;广东&nbsp;<b class="blue">&gt;</b>&nbsp;广州&nbsp;<b
															class="blue">&gt;</b>&nbsp;广州A客户
													</a></li>

												</ul>
											</section>
										</section>
									</section>
								</section>
							</section>
						</section>
					</section>

				</div>
			</div>
			<div class="dialog-button">
				<a href="javascript:void(0)" class="l-btn l-btn-small" group=""
					id=""><span class="l-btn-left"><span class="l-btn-text">保存</span></span></a><a
					href="javascript:void(0)" class="l-btn l-btn-small" group="" id=""><span
					class="l-btn-left"><span class="l-btn-text">取消</span></span></a>
			</div>
		</div>
	</div> -->








	
</body>
</html>