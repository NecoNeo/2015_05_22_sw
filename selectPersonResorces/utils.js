Object.equals = function(x, y) {
	if (x === y)
		return true;
	// if both x and y are null or undefined and exactly the same

	if (!(x instanceof Object) || !(y instanceof Object))
		return false;
	// if they are not strictly equal, they both need to be Objects

	if (x.constructor !== y.constructor)
		return false;
	// they must have the exact same prototype chain, the closest we can do is
	// test there constructor.

	for ( var p in x) {
		if (!x.hasOwnProperty(p))
			continue;
		// other properties were tested using x.constructor === y.constructor

		if (!y.hasOwnProperty(p))
			return false;
		// allows to compare x[ p ] and y[ p ] when set to undefined

		if (x[p] === y[p])
			continue;
		// if they have the same strict value or identity then they are equal

		if (typeof (x[p]) !== "object")
			return false;
		// Numbers, Strings, Functions, Booleans must be strictly equal

		if (!Object.equals(x[p], y[p]))
			return false;
		// Objects and Arrays must be tested recursively
	}

	for (p in y) {
		if (y.hasOwnProperty(p) && !x.hasOwnProperty(p))
			return false;
		// allows x[ p ] to be set to undefined
	}
	return true;
};

String.isNullOrEmpty = function(str) {
	return str == undefined || str == null || str == "";
};

String.prototype.startWith = function(str) {
	var reg = new RegExp("^" + str);
	return reg.test(this);
};

String.prototype.endWith = function(str) {
	var reg = new RegExp(str + "$");
	return reg.test(this);
};

String.prototype.format = function(args) {
	var result = this;

	if (arguments.length > 0) {
		if (arguments.length == 1 && typeof (args) == "object") {
			for ( var key in args) {
				if (args[key] != undefined) {
					var reg = new RegExp("({" + key + "})", "g");
					result = result.replace(reg, args[key]);
				}
			}
		} else {
			for (var i = 0; i < arguments.length; i++) {
				if (arguments[i] != undefined) {
					var reg = new RegExp("({[" + i + "]})", "g");
					result = result.replace(reg, arguments[i]);
				}
			}
		}
	}

	return result;
};

Array.prototype.unique = function() {
	var u = {}, a = [];
	for (var i = 0, l = this.length; i < l; ++i) {
		if (u.hasOwnProperty(this[i])) {
			continue;
		}
		a.push(this[i]);
		u[this[i]] = 1;
	}
	return a;
};

(function($) {
	$._url = function(url, params) {
		if (url.charAt(0) == "/") {
			url = globals.APP_NAME + url;
		} else {
			if (!url.startWith("http")) {
				var href = window.location.href;
				url = href.substring(0, href.lastIndexOf("/") + 1) + url;
			}
		}

		if (params != null) {
			url += url.indexOf("?") < 0 ? "?" : "&";
			url += $.param(params);
		}

		return url;
	};

	$._location = function(url, params) {
		window.location.href = $._url(url, params);
	};

	$._notify = function(options) {
		var opts = $.extend(true, {}, $._notify.defaults, options);
		opts.text = opts.message;
		opts.type = opts.className;
		top.$().toastmessage("showToast", opts);
	};

	$._notify.defaults = {
		position : 'top-right',
		className : 'success',
		stayTime : 2000
	};

	$._confirm = function(options) {
		var opts = $.extend(true, {}, $._confirm.defaults, options);

		opts.buttons = {
			"确定" : function() {
				opts.ok.apply(this, arguments);
				$(this).dialog("close");
			},
			"取消" : function() {
				$(this).dialog("close");
			}
		};

		opts.message = "<div style='padding:20px 10px'>" + opts.message + "<div/>";

		$._dialog(opts);
	};

	$._confirm.defaults = {
		width : 300,
		height : 200,
		ok : function() {
		}
	};

	$._ajax = function(options) {
		var opts = $.extend(true, {}, $._ajax.defaults, options);

		opts.url = $._url(opts.url);
		opts.type = "post";
		opts.data = opts.params;
		opts.dataType = "json";

		$.ajax($.extend({}, opts, {
			success : function(result) {
				if (result.success) {
					opts.success.apply(opts.that || this, arguments);
				} else {
					opts.failed.apply(opts.that || this, arguments);

					if (Array.isArray(result.messages)) {
						$.each(result.messages, function(i, e) {
							$._notify({
								message : e,
								className : "error"
							});
						});
					} else {
						$._notify({
							message : result.error,
							className : "error"
						});
					}
				}
			},
			error : function(xhr, status, errMsg) {
				$._notify({
					message : "error",
					className : "error"
				});
			}
		}));
	};

	$._ajax.defaults = {
		params : {},
		success : function() {
		},
		failed : function() {
		}
	};

	$._autoHeight = function() {

	};

	$._tree = function(rows, options) {
		var opts = $.extend(true, {}, $._tree.defaults, options);
		var tree = [];
		var map = {};

		$.each(rows, function(i, e) {
			map[e[opts.id]] = e;
			if (e[opts.children] == null) {
				e[opts.children] = [];
			}
		});

		$.each(rows, function(i, e) {
			if (e[opts.parentId] != null && map[e[opts.parentId]] != null) {
				map[e[opts.parentId]][opts.children].push(e);
			} else {
				tree.push(e);
			}
		});

		return tree;
	};

	$._tree.defaults = {
		id : "id",
		parentId : "parentId",
		children : "children"
	};

	$._treeGroup = function(rows, group, columns, options) {
		var opts = $.extend(true, {}, $._treeGroup.defaults, options);
		var result = [];
		var groupMap = {};

		$.each(group, function(i, e) {
			var id = "";
			var parentId = "";

			for (var j = 0; j < columns.length; ++j) {
				var column = columns[j];

				parentId = id;
				id = column.id + "-" + e[column.id];

				if (groupMap[id]) {
					groupMap[id].n += e.n;
				} else {
					var row = $.extend(true, {}, e);

					row[opts.id] = id;
					row[opts.treeField] = e[column.name];
					row[opts.children] = [];

					groupMap[id] = row;

					if (!String.isNullOrEmpty(parentId)) {
						groupMap[parentId][opts.children].push(row);
					} else {
						result.push(row);
					}
				}
			}
		});

		var column = columns.pop();

		$.each(rows, function(i, e) {
			groupMap[column.id + "-" + e[column.id]].children.push(e);
		});

		return result;
	};

	$._treeGroup.defaults = {
		id : "id",
		children : "children",
		treeField : "treeField"
	};

	$._allChildren = function(row, options) {
		var opts = $.extend(true, {}, $._allChildren.defaults, options);
		var children = row[opts.children];

		if (children != null && children.length > 0) {
			return $.map(children, function(e, i) {
				if (e.children != null && e.children.length > 0) {
					return $.merge([ e ], $._allChildren(e, options));
				} else {
					return e;
				}
			});
		}

		return [];
	};

	$._allChildren.defaults = {
		children : "children"
	};

	$._formatLength = function(value, options) {
		var opts = $.extend(true, {}, $._formatLength.defaults, options);

		if (value > 0) {
			return opts.template.format(value);
		} else if (value != null && value.length > 0) {
			return opts.template.format(value.length);
		}

		return "";
	};

	$._formatLength.defaults = {
		template : "({0})"
	};

	$._dialog = function(options) {
		var opts = $.extend(true, {}, $._dialog.defaults, options);
		var $div = $("<div>" + opts.message + "</div>");
		$div.appendTo(top.document.body);
		$div.dialog($.extend({}, opts, {
			close : function(event, ui) {
				$(this).dialog("destroy");
				$div.remove();
			}
		}));

		$div.dialog("option", "position", {
			my : "center",
			at : "center",
			of : top
		});
	};

	$._dialog.defaults = {
		modal : true,
		resizable : false,
		width : 800,
		height : 600
	};

	$.fn._data = function(name) {
		var $this = $(this);
		return eval("({" + ($this.data(name) || "") + "})");
	};

	$.fn._refresh = function() {
		var $this = $(this);
		var url = $this.attr("src");
		$this.attr("src", url);
	};

	$.fn._url = function(url, params) {
		var $this = $(this);
		$this.attr("src", url == null ? "" : $._url(url, params));
	};

	$.fn._autoHeight = function() {
		$(this).each(function() {
			var $this = $(this);
			var height = $this.height();
			var $child = $(this);

			$this.parents().each(function(i, e) {
				var bottom = $child.offset().top + $child.outerHeight(true);

				$(e).children().each(function(i, e) {
					if ($(e).offset().top > bottom) {
						bottom = Math.max(bottom, $(e).offset().top + $(e).outerHeight(true));
					}
				});

				bottom = $(e).offset().top + $(e).height() - bottom;

				if (bottom > 10) {
					$this.height(Math.floor($this.height() + bottom));
					return false;
				}

				$child = $(e);
			});
		});
	};

	$.fn._ajaxSubmit = function(options) {
		var $this = $(this);
		var opts = $.extend(true, {}, $.fn._ajaxSubmit.defaults, options);
		var time = new Date().getTime();

		if (time - $this.data("_ajaxSubmit") < 10 * 1000) {
			return;
		}

		$this.data("_ajaxSubmit", time);

		opts.url = $._url(opts.url);
		opts.type = "post";
		opts.data = opts.params;
		opts.dataType = "json";

		$this.ajaxSubmit($.extend({}, opts, {
			beforeSubmit : function(arr, $form, options) {
				return $form.valid();
			},
			success : function(result) {
				$this.data("_ajaxSubmit", 0);
				if (result.success) {
					opts.success.apply(opts.that || this, arguments);
				} else {
					opts.failed.apply(opts.that || this, arguments);

					if (Array.isArray(result.messages)) {
						$.each(result.messages, function(i, e) {
							$._notify({
								message : e,
								className : "error"
							});
						});
					} else {
						$._notify({
							message : result.error,
							className : "error"
						});
					}
				}
			},
			error : function(xhr, status, errMsg) {
				$this.data("_ajaxSubmit", 0);
				$._notify({
					message : "error",
					className : "error"
				});
			}
		}));
	};

	$.fn._ajaxSubmit.defaults = {
		params : {},
		success : function() {
		},
		failed : function() {
		}
	};

	$.fn._jsonSelect = function(options) {
		$(this).each(function() {
			var $this = $(this);
			var opts = $.extend(true, {}, $.fn._jsonSelect.defaults, options);

			$this.find("option[value != '']").remove();

			$.each(opts.rows, function(i, e) {
				$this.append("<option value='" + e.key + "'>" + e.value + "</option>");
			});

			$this.val(opts.value);

			if ($this.find("option:selected").size() == 0) {
				$this.find("option:first").prop("selected", "selected");
			}
		});

		return $(this);
	};

	$.fn._jsonSelect.defaults = {
		rows : [],
		value : ""
	};

	$.fn._ajaxSelect = function(options) {
		$(this).each(function() {
			var $this = $(this);
			var opts = $.extend(true, {}, $.fn._ajaxSelect.defaults, $this._data("select"), options);
			var oldOpts = null;

			if ($this.data("_ajaxSelect") != null) {
				oldOpts = $this.data("_ajaxSelect").opts;
			}

			$this.data("_ajaxSelect", {
				opts : opts
			});

			opts.success = function(result) {
				opts.rows = result.data.rows;
				$this._jsonSelect(opts);
			};

			if (!String.isNullOrEmpty(opts.parentId)) {
				var parentIds = opts.parentId.split(",");
				var parentParams = opts.parentParam.split(",");

				$.each(parentIds, function(i, e) {
					var parentId = e;
					var parentParam = parentParams[i];
					var $parent = $("#" + parentId);

					if ($parent.data("_ajaxSelect") != null) {
						opts.params[parentParam] = $parent.data("_ajaxSelect").opts.value;
					} else {
						opts.params[parentParam] = $parent.val();
					}

					if (oldOpts == null) {
						$parent.change(function() {
							opts.params[parentParam] = $parent.val();
							opts.value = "";

							$._ajax($.extend({}, opts, {
								success : function(result) {
									opts.rows = result.data.rows;
									$this._jsonSelect(opts);
									$this.trigger("change");
								}
							}));
						});
					}
				});
			}

			if (oldOpts == null || !Object.equals(oldOpts.params, opts.params)) {
				$._ajax($.extend({}, opts, {
					success : function(result) {
						opts.rows = result.data.rows;
						$this._jsonSelect(opts);
					}
				}));
			} else {
				opts.rows = oldOpts.rows;
				$this._jsonSelect(opts);
			}

		});

		return $(this);
	};

	$.fn._ajaxSelect.defaults = {
		params : {}
	};

	$.fn._dictSelect = function(options) {
		$(this).each(function() {
			var $this = $(this);
			var opts = $.extend(true, {}, $.fn._dictSelect.defaults, $this._data("select"), options);
			opts.params.type = opts.type;
			opts.params.parentKey = opts.parentKey;
			$this._ajaxSelect(opts);
		});

		return $(this);
	};

	$.fn._dictSelect.defaults = {
		url : "/sys/dictDictionary",
		parentParam : "parentKey",
		params : {}
	};

	$.fn._dictCusSelect = function(options) {
		$(this).each(function() {
			var $this = $(this);
			var opts = $.extend(true, {}, $.fn._dictCusSelect.defaults, $this._data("select"), options);
			opts.params.type = opts.type;
			opts.params.parentKey = opts.parentKey;
			opts.params.orgId = opts.orgId;
			$this._ajaxSelect(opts);
		});

		return $(this);
	};

	$.fn._dictCusSelect.defaults = {
		url : "/sys/dictCusDictionary",
		parentParam : "parentKey",
		orgId : -1,
		params : {}
	};
})(jQuery);
