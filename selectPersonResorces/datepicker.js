(function($) {
	$.fn._datepicker = function(options) {
		$(this).each(function() {
			var $this = $(this);
			var opts = $.extend(true, {}, $.fn._datepicker.defaults, $this._data("datepicker"), options);

			$this.datepicker(opts);
		});

		return $(this);
	};

	$.fn._datepicker.defaults = {

	};
})(jQuery);