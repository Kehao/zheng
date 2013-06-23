//= require jquery
//= require_self
//= require jquery_ujs
//= require flat-ui
//= require bootstrap
//= require bootstrap-editable
//= require bootstrap-editable-rails
//= require bootstrap-datepicker.zh-CN
//= require clients
//= require companies
//= require jquery.validate.min
//
//= require highcharts/highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/exporting
//
//= require common
//= require statistics
//= require jquery.highlight
//= require jquery.deletable
//= require jquery.validate.min
//= require messages
//= require relationship
//= require jquery.district-ul

Array.prototype.map = function(fun /*, thisp*/) { 
    var len = this.length >>> 0;
    if (typeof fun != "function")
      throw new TypeError();

    var res = new Array(len);
    var thisp = arguments[1];
    for (var i = 0; i < len; i++) {
        if (i in this)
            res[i] = fun.call(thisp, this[i], i, this);
    }

    return res;
};
