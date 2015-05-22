(function ($) {
"use strict";

$.fn._selectPerson = function (options) {
    this.each(function () {
        var $this = $(this);
        console.log($this);
    });
    return this;
};

var Selector = function () {};

Selector.prototype = {
    constructor: Selector,
    init: function () {}
};

})($ || jQuery);