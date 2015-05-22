<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<s:head />
<s:include value="/include/batch.jsp"></s:include>

<script id="typeTemplate" type="text/template">
<s:select list="findDict(DictUtils.DT_BRANCH_TYPE)" listKey="key"
	listValue="value" headerKey="" headerValue="请选择"></s:select>
</script>

<script id="categoryTemplate" type="text/template">
<s:select list="findDict(DictUtils.DT_BRANCH_CATEGORY)" listKey="key"
	listValue="value" headerKey="" headerValue="请选择"></s:select>
</script>

<script id="industryTemplate" type="text/template">
<s:select list="findDict(DictUtils.DT_BRANCH_INDUSTRY)" listKey="key"
	listValue="value" headerKey="" headerValue="请选择"></s:select>
</script>

<script type="text/javascript">
	$(function() {
		$("#tab")._batch({
			name : "orgBranchInfos",
			formatters : {
				type : function(id, value) {
					return $("#typeTemplate").html();
				},
				category : function(id, value) {
					return $("#categoryTemplate").html();
				},
				industry : function(id, value) {
					return $("#industryTemplate").html();
				}
			}
		});
	});
</script>

</head>
<body>
	<s:form>
		<article class="container">
			<section class="popup-padding">
				<section class="edit_form">
					<section class="table-box">
						<!-- tr标签加样式 active 为选中状态 -->
						<table id="tab" class="popup-table">
							<thead>
								<tr>
									<th data-column="formatter:'index'" style="width: 2em;">序号</th>
									<th data-column="id:'type',formatter:'type'" class="required">机构类型</th>
									<th data-column="id:'category',formatter:'category'"
										class="required">机构类别</th>
									<th data-column="id:'shortName',suffix:true" class="required">机构简称</th>
									<th data-column="id:'name',suffix:true" class="required">机构全称</th>
									<th data-column="id:'industry',formatter:'industry'"
										class="required">行业</th>
									<th data-column="id:'area'" class="required">地区</th>
									<th data-column="id:'address'" style="width: 15%;"
										class="required">机构地址</th>
									<th data-column="id:'phone'">电话</th>
									<th data-column="id:'contacts'">联系人</th>
									<th data-column="id:'remark'">备注</th>
									<th data-column="formatter:'commands'" style="width: 6em;">操作</th>
								</tr>
							</thead>
						</table>
					</section>

				</section>
			</section>
		</article>
	</s:form>
</body>
</html>
