(function ($) {
"use strict";

//default name settings
var selectButtonName = "选择";

//default Class Names
var markerClassName = "hasSelectorWidget";

//configuration of specified selector widgets

$.fn._selectPerson = function (options) {
    var defaultOptions = {};
    selectorInitialization(this, defaultOptions);
    return this;
};

//dom init
function selectorInitialization ($obj, options) {
    $obj.each(function () {
        var $this = $(this),
            $inputBox, $selectButton,
            selector;
        if ($this.hasClass(markerClassName)) {
            return false;
        } else {
            $this.empty();
            $this.addClass(markerClassName);
            $inputBox = $('<input type="text" disabled="disabled" />');
            $selectButton = $('<button>' + selectButtonName + '</button>');
            selector = new Selector();
            $selectButton.click(function () {
                selector.showDialog();
            });
            $this.append($inputBox).append($selectButton);
        }
    });
}

function Selector() {
    this.isShown = false;
    this.dom = {};
}

$.extend(Selector.prototype, {

    defaultDialogOptions: {
        "width": 400,
        "height": 600,
        "resizable": false,
        "modal": true
    },

    showDialog: function () {
        var that = this,
            options = $.extend({}, this.defaultDialogOptions);
        this._createDOM();
        this.dom.$div.dialog($.extend({}, options, {
            'buttons': {
                '确定' : function() {
                    //opts.ok.apply(this, arguments);
                    $(this).dialog('close');
                },
                '取消' : function() {
                    $(this).dialog('close');
                }
            },
            'close': function () {
                $(this).dialog("destroy");
                that.dom.$div.remove();
                that.dom = {};
                that.isShown = false;
            }
        }));
        this.isShown = true;
    },

    _createDOM: function () {
        if (this.isShown) return;

        this.dom.$div = $("<div></div>");

        this.dom.$groups = $("<div></div>").appendTo(this.dom.$div);

        this.dom.$columns = $("<div></div>").appendTo(this.dom.$div);

        this.dom.$itemTree = $("<div></div>").appendTo(this.dom.$columns);

        this.dom.$btnGroup = $("<div></div>").appendTo(this.dom.$columns);
        this.dom.$btnAdd = $("<button>添加</button>").appendTo(this.dom.$btnGroup);
        this.dom.$btnAddAll = $("<button>全部添加</button>").appendTo(this.dom.$btnGroup);
        this.dom.$btnRemove = $("<button>删除</button>").appendTo(this.dom.$btnGroup);
        this.dom.$btnRemoveAll = $("<button>全部删除</button>").appendTo(this.dom.$btnGroup);

        this.dom.$itemResult = $("<div></div>").appendTo(this.dom.$columns);
    },

    _generateHTML: function () {
        var html;
        return html;
    }
});

})($ || jQuery);