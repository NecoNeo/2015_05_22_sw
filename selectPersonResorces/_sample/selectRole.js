(function($) {
	$.selectRole = function(options) {
		var opts = jQuery.extend({}, $.selectRole.defaults, options);
		top.$.openDialog({
			title : opts.title,
			url : "/selectRole",
			params : {
				selectedIds : opts.roleIds,
				relationType : opts.relationType,
				relationId : opts.relationId,
				orgId : opts.orgId
			},
			width : opts.width,
			height : opts.height,
			onSave : function(dlg, frame) {
				opts.onSave(dlg, frame[0].contentWindow.selectedIds);
			}
		});
	};

	$.selectRole.defaults = {
		title : "选择角色",
		roleIds : [],
		width : 1000,
		height : 1000,
		onSave : function() {
		}
	};
})(jQuery);
