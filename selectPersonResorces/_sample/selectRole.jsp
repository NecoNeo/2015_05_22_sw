<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<s:head />
<s:include value="/js/tooltip1.html" />
<style type="text/css">
.choice_form dt .popup_choice .pagination {
	padding: 5 0 0 0;
}

.choice_form dt,.choice_form dd {
	height: 120px
}

.choice_form dt a,.choice_form dd span {
	height: 100% !important;
}

.choice_form dt .popup_choice .pagination a.btn_blue {
	height: 22px !important;
}

.choice_form dt .popup_choice .choice_content a {
	height: 20px !important;
}
</style>
<script id="listTmp" type="text/template">
{{~ it.roles : role}}
<li>
	<a href="javascript:void(0)" data-Opts="id:{{=role.id}}">
		&nbsp;{{=role.orgShortName|| '全局角色'}}-{{=role.roleTypeName}}-{{=role.roleGroupName}}-{{=role.name}}
	</a>
</li>
{{~}}
</script>
<script type="text/javascript">
	var listTmp = doT.template($("#listTmp").html());

	var roles = JSON.parse('${rolesJson}');
	var selectedIds = JSON.parse('${selectedIdsJson}');
	var roleTypes = JSON.parse('${roleTypesJson}');

	var roles1 = [];
	var roles2 = [];

	function branchTooltip() {
		var values = [];

		if ('${orgId}' > 0) {
			values.push(parseInt('${orgId}'));
		}

		$("#branchTooltip").ajaxTooltip1({
			url : "ajaxBranch",
			title : "机构",
			click : refresh,
			size : 100,
			values : values,
			single : true,
			async : false,
			click : function() {
				roleGroupTooltip();
				refresh();
			}
		});
	}

	function roleTypeTooltip() {
		$("#roleTypeTooltip").ajaxTooltip1({
			url : "ajaxDictionary",
			title : "角色大类",
			data : {
				dictType : 'role_type'
			},
			single : true,
			async : false,
			click : function() {
				roleGroupTooltip();
				refresh();
			},
			size : 100,
			values : roleTypes
		});
	}

	function roleGroupTooltip() {
		var orgId = $("#branchTooltip").getTooltip1Sel()
		var parentId = $("#roleTypeTooltip").getTooltip1Sel();
		var orgId = orgId.length == 1 ? orgId[0].key : -1;
		var parentId = parentId.length == 1 ? parentId[0].key : -1;

		$("#roleGroupTooltip").ajaxTooltip1({
			url : "ajaxDictionary1",
			title : "角色组",
			async : false,
			data : {
				orgId : orgId,
				dictType : 'role_group',
				parentId : parentId
			},
			click : refresh,
			size : 100
		});
	}

	function refresh() {
		function isFilter(value, filter) {
			return $.isEmptyObject(filter) || filter[value];
		}

		roles1 = [];
		roles2 = [];

		var branches = $("#branchTooltip").getTooltip1Sel({
			dataType : "json"
		});

		var roleTypes = $("#roleTypeTooltip").getTooltip1Sel({
			dataType : "json"
		});

		var roleGroups = $("#roleGroupTooltip").getTooltip1Sel({
			dataType : "json"
		});

		$.each(roles, function(i, e) {
			if (selectedIds.indexOf(e.id) == -1) {
				if (isFilter(e.orgId, branches)
						&& isFilter(e.roleType, roleTypes)
						&& isFilter(e.roleGroup, roleGroups)) {
					roles1.push(e);
				}
			} else {
				roles2.push(e);
			}
		});

		$("#selectingList").html(listTmp({
			roles : roles1
		}));

		$("#selectedList").html(listTmp({
			roles : roles2
		}));
	}

	$(function() {
		branchTooltip();
		roleTypeTooltip();
		roleGroupTooltip();

		$("#selectingList").on("click", "a", function() {
			selectedIds.push($(this).dataOpts().id);
			refresh();
		});

		$("#selectedList").on("click", "a", function() {
			var index = selectedIds.indexOf($(this).dataOpts().id);

			if (index > -1) {
				selectedIds.splice(index, 1);
				refresh();
			}
		});

		$("#selectAll").click(function() {
			$.each(roles1, function(i, e) {
				selectedIds.push(e.id);
			});

			refresh();
		});

		$("#removeAll").click(function() {
			selectedIds = [];
			refresh();
		});

		refresh();
	});
</script>
</head>
<body>
	<div
		class="panel-body panel-body-noheader panel-body-noborder dialog-content">
		<section class="popup_padding">
			<section class="choice_form">
				<section class="gray_border">
					<dl id="branchTooltip">
					</dl>
					<div class="clear">&nbsp;</div>
					<dl id="roleTypeTooltip">
					</dl>
					<div class="clear">&nbsp;</div>
					<dl class="no_dash" id="roleGroupTooltip">
					</dl>
					<div class="clear">&nbsp;</div>
				</section>
				<section class="choice_result">
					<div class="clear">&nbsp;</div>
				</section>

				<section class="choice_details">
					<section class="list_tree">
						<section class="title">待选项</section>
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
						<section class="title">已选项</section>
						<section class="tree_rmenu">
							<section class="scroll">
								<section class="padding">
									<ul id="selectedList">
										<li></li>
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
