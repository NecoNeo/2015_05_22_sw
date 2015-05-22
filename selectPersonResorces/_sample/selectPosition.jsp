<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<s:head />

<script id="selectingListTmp" type="text/template">
	<li id="{{=it.id}}">
		<a href="javascript:void(0)">
			<em class="icon l-arrow-down"></em>
			{{=it.title}}
		</a>
		<ul>

		</ul>
	</li>
</script>


<script type="text/javascript">
	$(function() {
		var options = JSON.parse('${options}');
		var currentBranchId = "${currentBranchId}";
		var currentDepartmentId = "${currentDepartmentId}";
		var selectedRoute = {};

		var selectingListTmp = doT.template($("#selectingListTmp").html());

		init();
		
		function init(){
			//选择外部人员
			if(options.outerUser){
				$("#outerUser").show();
			}
			
			initBranchList();
			if(options.data){
				$(options.data).map(function(){
					var a = $("<a data-role='" + this.type + "_" + this.key + "' href='javascript:void(0)'></a>").click(function() {
						$(this).parent("li").remove();
					}).appendTo($("<li></li>").prependTo($("#selectedList")));
					if(options.valueType == "user"){
						a.html(this.userName + " <b class='blue'>></b> " + this.departmentName + " <b class='blue'>></b> " + this.branchName);
					}else if(options.valueType == "position"){
						a.html(this.positionName + " <b class='blue'>></b> " + this.departmentName + " <b class='blue'>></b> " + this.branchName);
					}else if(options.valueType == "positionUser"){
						a.html(this.userName + " <b class='blue'>></b> " + this.departmentName + " <b class='blue'>></b> " + this.branchName);
					}
				});
			}
		}

		function initBranchList() {
			$.post('/' + appName + '/ajaxBranch', function(data) {
				data = JSON.parse(data);
				$(data).map(function() {
					this.type = 1;
					this.parentId = 0;
					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>").click(function() {
						if (!$(this).hasClass("active")) {
							$(this).addClass("active").siblings().removeClass("active");
							currentBranchId = $(this).data("key");
							initDepartmentList();

							selectedRoute.branch = $(this).data("value");
							selectedRoute.department = "";
							selectedRoute.thirdLevel = "";
							initSelectedRoute();
						}
					}).data(this).appendTo($("#branchList"));
					if (this.key == currentBranchId) {
						a.click();
					}
				});
			});
		}

		function initDepartmentList() {
			$.post('/' + appName + '/ajaxDepartment', {
				"parentId": currentBranchId
			}, function(data) {
				data = JSON.parse(data);
				$("#departmentList").empty();
				$(data).map(function() {
					this.type = 2;
					this.parentId = currentBranchId;

					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>").click(function() {
						if (!$(this).hasClass("active")) {
							$(this).addClass("active").siblings().removeClass("active");
							currentDepartmentId = $(this).data("key");

							selectedRoute.department = $(this).data("value");
							selectedRoute.thirdLevel = "";
							initSelectedRoute();

							initSelectingList();
						}
					}).data(this).appendTo($("#departmentList"));
					if (this.key == currentDepartmentId) {
						a.click();
					}
				});
			});
		}

		function initSelectedRoute() {
			var value = [];
			if (selectedRoute.branch) {
				value.push(selectedRoute.branch);
			}
			if (selectedRoute.department) {
				value.push(selectedRoute.department);
			}
			if (selectedRoute.thirdLevel) {
				value.push(selectedRoute.thirdLevel);
			}

			$("#selectedRoute").html('<em class="fr">x</em>' + value.join(" > "))

		}

		function initSelectingList(){
			if(selectedRoute.thirdLevel == "position"){

			}else if(selectedRoute.thirdLevel == "duty"){

			}else if(selectedRoute.thirdLevel == "user"){

			}else if(selectedRoute.department){
				if(options.option.position){
					$("#selectingList li#positionList").remove();
					$("#selectingList").append(selectingListTmp({
						id: "positionList",
						title: "岗位 <b class='blue'>></b> " + selectedRoute.department + " <b class='blue'>></b> " + selectedRoute.branch
					}));
					initSelectingPosition();
				}
				if(options.option.duty){
					$("#selectingList li#dutyList").remove();
					$("#selectingList").append(selectingListTmp({
						id:"dutyList",
						title:"职位 <b class='blue'>></b> " + selectedRoute.department +" <b class='blue'>></b> "+ selectedRoute.branch
					}));
					initSelectingDuty();
				}
				if(options.option.user){
					$("#selectingList li#userList").remove();
					$("#selectingList").append(selectingListTmp({
						id:"userList",
						title:"人员 <b class='blue'>></b> " + selectedRoute.department +" <b class='blue'>></b> "+ selectedRoute.branch
					}));
					initSelectingUser();
				}
				
				if(options.option.outerUser){
					$("#selectingList li#outerUserList").empty();
					$("#selectingList").append(selectingListTmp({
						id:"outerUserList",
						title:"外部人员"
					}));
					initSelectingOuterUser();
				}

			}else if(selectedRoute.branch){

			}
		}

		function initSelectingPosition(){
			$.post('/' + appName + '/ajaxPosition',{
				"parentId":currentDepartmentId
			},function(data){
				data = JSON.parse(data);
				
				$(data).map(function() {
					this.type = 4;
					this.parentId = currentDepartmentId;
					this.displayName = this.value + " <b class='blue'>></b> " + selectedRoute.department +" <b class='blue'>></b> "+ selectedRoute.branch;
					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>")
							.data(this).appendTo($("<li></li>").appendTo($("#positionList>ul")));

				});
			});
		}

		function initSelectingDuty(){
			$.post('/' + appName + '/ajaxDuty',{
				"parentId":currentBranchId
			},function(data){
				data = JSON.parse(data);

				$(data).map(function(){
					this.type = 3;
					this.parentId = currentDepartmentId;
					this.displayName = this.value + " <b class='blue'>></b> " + selectedRoute.department +" <b class='blue'>></b> "+ selectedRoute.branch;
					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>")
							.data(this).appendTo($("<li></li>").appendTo($("#dutyList>ul")));

				});
			});
		}

		function initSelectingUser(){
			$.post('/' + appName + '/ajaxUser',{
				"parentId":currentDepartmentId
			},function(data){
				data = JSON.parse(data);

				$(data).map(function(){
					this.type = 5;
					this.parentId = currentDepartmentId;
					this.displayName = this.value + " <b class='blue'>></b> " + selectedRoute.department +" <b class='blue'>></b> "+ selectedRoute.branch;
					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>")
							.data(this).appendTo($("<li></li>").appendTo($("#userList>ul")));

				});
			});
		}
		
		function initSelectingOuterUser(){
			
			
			$.post('/' + appName + '/ajaxOuterUser',function(data){
				data = JSON.parse(data);

				$(data).map(function(){
					this.type = 6;
					this.displayName = this.value + " <b class='blue'>></b> 外部人员";
					var a = $("<a id='" + this.type + "_" + this.key + "' href='javascript:void(0)'>" + this.value + "</a>")
							.data(this).appendTo($("<li></li>").appendTo($("#outerUserList>ul")));

				});
			});
		}


		$("#selectingList").on("click","ul a",function(){
			$("#selectedList a[data-role="+$(this).attr("id")+"]").remove();
			var data = $(this).data();
			var a = $("<a data-role='" + $(this).attr("id") + "' href='javascript:void(0)'>" + data.displayName + "</a>").click(function(){
						$(this).parent("li").remove();
					}).appendTo($("<li></li>").prependTo($("#selectedList")));
		});

		$("#selectAll").click(function(){
			$("#selectingList ul a").click();
		});

		$("#removeAll").click(function(){
			$("#selectedList a").click();
		});
	});
</script>
</head>
<body>
	<div class="panel-body panel-body-noheader panel-body-noborder dialog-content"
		style="width: 778px; height: 636px;">
		<section class="popup_padding">
			<section class="choice_form">
				<section class="gray_border">
					<dl>
						<dt>
							<a id="branchType" href="javascript:void(0);">机构：</a>
						</dt>
						<dd>
							<a href="#" class="right">&gt;&gt;</a>
							<span id="branchList">
							</span>
						</dd>
					</dl>
					<div class="clear">&nbsp;</div>
					<dl class="no_dash">
						<dt>
							<a id="departmentType" href="javascript:void(0)" >部门：</a>
						</dt>
						<dd>
							<a href="#" class="right">&gt;&gt;</a>
							<span id="departmentList">
							</span>
						</dd>
					</dl>
					<div class="clear">&nbsp;</div>
				</section>

				<section class="tap gray_border">
					<a id="positionType" href="javascript:void(0)">岗位</a><a id="dutyType" href="javascript:void(0)">职位</a><a id="userType" href="javascript:void(0)">人员</a><a id="outerUser" href="javascript:void(0)" style="display:none;">外部人员</a>
				</section>

				<section class="choice_result">
					<dl>
						<dt>选择路径：</dt>
						<dd>
							<span>
								<a id="selectedRoute" href="javascript:void(0)" class="active"></a>
							</span>
						</dd>
					</dl>
					<div class="clear">&nbsp;</div>
				</section>
				
				<section class="choice_details">
					<section class="list_tree">
						<section class="title">
							待选项（<b class="blue">25</b>）
						</section>
						<section class="content">
							<!-- 去right -->
							<section>
								<!-- height发生变化 -->
								<section class="tree_menu height">
									<section class="scroll">
										<section class="padding">
											<ul id="selectingList">
												
											</ul>
										</section>
									</section>
								</section>
							</section>

							<div class="clear">&nbsp;</div>
						</section>
					</section>
					<section class="btn_group">
						<a id="selectAll" href="javascript:void(0);" class="btn btn_gray">全部添加</a>
						<a id="removeAll" href="javascript:void(0);" class="btn btn_gray">全部删除</a>
					</section>
					<section class="tree_result">
						<section class="title">
							已选项（<b>1</b>）
						</section>
						<section class="tree_rmenu">
							<section class="scroll">
								<section class="padding">
									<ul id="selectedList">
										<li>
										</li>
									</ul>
								</section>
							</section>
						</section>
					</section>
				</section>
			</section>
		</section>
	</div>
</body>
</html>
