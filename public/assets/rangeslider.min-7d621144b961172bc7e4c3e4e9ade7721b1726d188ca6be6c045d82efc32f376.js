!function(t,i,e,s){var o=0,a=function(){var i=s.userAgent,e=/msie\s\d+/i;return 0<i.search(e)&&(i=e.exec(i).toString(),i=i.split(" ")[1],9>i)?(t("html").addClass("lt-ie9"),!0):!1}();Function.prototype.bind||(Function.prototype.bind=function(t){var i=this,e=[].slice;if("function"!=typeof i)throw new TypeError;var s=e.call(arguments,1),o=function(){if(this instanceof o){var a=function(){};a.prototype=i.prototype;var a=new a,n=i.apply(a,s.concat(e.call(arguments)));return Object(n)===n?n:a}return i.apply(t,s.concat(e.call(arguments)))};return o}),Array.prototype.indexOf||(Array.prototype.indexOf=function(t,i){var e;if(null==this)throw new TypeError('"this" is null or not defined');var s=Object(this),o=s.length>>>0;if(0===o)return-1;if(e=+i||0,1/0===Math.abs(e)&&(e=0),e>=o)return-1;for(e=Math.max(e>=0?e:o-Math.abs(e),0);o>e;){if(e in s&&s[e]===t)return e;e++}return-1});var n=function(s,o,a){this.VERSION="2.1.2",this.input=s,this.plugin_count=a,this.old_to=this.old_from=this.update_tm=this.calc_count=this.current_plugin=0,this.raf_id=this.old_min_interval=null,this.is_update=this.is_key=this.no_diapason=this.force_redraw=this.dragging=!1,this.is_start=!0,this.is_click=this.is_resize=this.is_active=this.is_finish=!1,this.$cache={win:t(e),body:t(i.body),input:t(s),cont:null,rs:null,min:null,max:null,from:null,to:null,single:null,bar:null,line:null,s_single:null,s_from:null,s_to:null,shad_single:null,shad_from:null,shad_to:null,edge:null,grid:null,grid_labels:[]},this.coords={x_gap:0,x_pointer:0,w_rs:0,w_rs_old:0,w_handle:0,p_gap:0,p_gap_left:0,p_gap_right:0,p_step:0,p_pointer:0,p_handle:0,p_single_fake:0,p_single_real:0,p_from_fake:0,p_from_real:0,p_to_fake:0,p_to_real:0,p_bar_x:0,p_bar_w:0,grid_gap:0,big_num:0,big:[],big_w:[],big_p:[],big_x:[]},this.labels={w_min:0,w_max:0,w_from:0,w_to:0,w_single:0,p_min:0,p_max:0,p_from_fake:0,p_from_left:0,p_to_fake:0,p_to_left:0,p_single_fake:0,p_single_left:0};var n=this.$cache.input;s=n.prop("value");var r;a={type:"single",min:10,max:100,from:null,to:null,step:1,min_interval:0,max_interval:0,drag_interval:!1,values:[],p_values:[],from_fixed:!1,from_min:null,from_max:null,from_shadow:!1,to_fixed:!1,to_min:null,to_max:null,to_shadow:!1,prettify_enabled:!0,prettify_separator:" ",prettify:null,force_edges:!1,keyboard:!1,keyboard_step:5,grid:!1,grid_margin:!0,grid_num:4,grid_snap:!1,hide_min_max:!1,hide_from_to:!1,prefix:"",postfix:"",max_postfix:"",decorate_both:!0,values_separator:" \u2014 ",input_values_separator:";",disable:!1,onStart:null,onChange:null,onFinish:null,onUpdate:null},n={type:n.data("type"),min:n.data("min"),max:n.data("max"),from:n.data("from"),to:n.data("to"),step:n.data("step"),min_interval:n.data("minInterval"),max_interval:n.data("maxInterval"),drag_interval:n.data("dragInterval"),values:n.data("values"),from_fixed:n.data("fromFixed"),from_min:n.data("fromMin"),from_max:n.data("fromMax"),from_shadow:n.data("fromShadow"),to_fixed:n.data("toFixed"),to_min:n.data("toMin"),to_max:n.data("toMax"),to_shadow:n.data("toShadow"),prettify_enabled:n.data("prettifyEnabled"),prettify_separator:n.data("prettifySeparator"),force_edges:n.data("forceEdges"),keyboard:n.data("keyboard"),keyboard_step:n.data("keyboardStep"),grid:n.data("grid"),grid_margin:n.data("gridMargin"),grid_num:n.data("gridNum"),grid_snap:n.data("gridSnap"),hide_min_max:n.data("hideMinMax"),hide_from_to:n.data("hideFromTo"),prefix:n.data("prefix"),postfix:n.data("postfix"),max_postfix:n.data("maxPostfix"),decorate_both:n.data("decorateBoth"),values_separator:n.data("valuesSeparator"),input_values_separator:n.data("inputValuesSeparator"),disable:n.data("disable")},n.values=n.values&&n.values.split(",");for(r in n)n.hasOwnProperty(r)&&(n[r]||0===n[r]||delete n[r]);s&&(s=s.split(n.input_values_separator||o.input_values_separator||";"),s[0]&&s[0]==+s[0]&&(s[0]=+s[0]),s[1]&&s[1]==+s[1]&&(s[1]=+s[1]),o&&o.values&&o.values.length?(a.from=s[0]&&o.values.indexOf(s[0]),a.to=s[1]&&o.values.indexOf(s[1])):(a.from=s[0]&&+s[0],a.to=s[1]&&+s[1])),t.extend(a,o),t.extend(a,n),this.options=a,this.validate(),this.result={input:this.$cache.input,slider:null,min:this.options.min,max:this.options.max,from:this.options.from,from_percent:0,from_value:null,to:this.options.to,to_percent:0,to_value:null},this.init()};n.prototype={init:function(t){this.no_diapason=!1,this.coords.p_step=this.convertToPercent(this.options.step,!0),this.target="base",this.toggleInput(),this.append(),this.setMinMax(),t?(this.force_redraw=!0,this.calc(!0),this.callOnUpdate()):(this.force_redraw=!0,this.calc(!0),this.callOnStart()),this.updateScene()},append:function(){this.$cache.input.before('<span class="irs js-irs-'+this.plugin_count+'"></span>'),this.$cache.input.prop("readonly",!0),this.$cache.cont=this.$cache.input.prev(),this.result.slider=this.$cache.cont,this.$cache.cont.html('<span class="irs"><span class="irs-line" tabindex="-1"><span class="irs-line-left"></span><span class="irs-line-mid"></span><span class="irs-line-right"></span></span><span class="irs-min">0</span><span class="irs-max">1</span><span class="irs-from">0</span><span class="irs-to">0</span><span class="irs-single">0</span></span><span class="irs-grid"></span><span class="irs-bar"></span>'),this.$cache.rs=this.$cache.cont.find(".irs"),this.$cache.min=this.$cache.cont.find(".irs-min"),this.$cache.max=this.$cache.cont.find(".irs-max"),this.$cache.from=this.$cache.cont.find(".irs-from"),this.$cache.to=this.$cache.cont.find(".irs-to"),this.$cache.single=this.$cache.cont.find(".irs-single"),this.$cache.bar=this.$cache.cont.find(".irs-bar"),this.$cache.line=this.$cache.cont.find(".irs-line"),this.$cache.grid=this.$cache.cont.find(".irs-grid"),"single"===this.options.type?(this.$cache.cont.append('<span class="irs-bar-edge"></span><span class="irs-shadow shadow-single"></span><span class="irs-slider single"></span>'),this.$cache.edge=this.$cache.cont.find(".irs-bar-edge"),this.$cache.s_single=this.$cache.cont.find(".single"),this.$cache.from[0].style.visibility="hidden",this.$cache.to[0].style.visibility="hidden",this.$cache.shad_single=this.$cache.cont.find(".shadow-single")):(this.$cache.cont.append('<span class="irs-shadow shadow-from"></span><span class="irs-shadow shadow-to"></span><span class="irs-slider from"></span><span class="irs-slider to"></span>'),this.$cache.s_from=this.$cache.cont.find(".from"),this.$cache.s_to=this.$cache.cont.find(".to"),this.$cache.shad_from=this.$cache.cont.find(".shadow-from"),this.$cache.shad_to=this.$cache.cont.find(".shadow-to"),this.setTopHandler()),this.options.hide_from_to&&(this.$cache.from[0].style.display="none",this.$cache.to[0].style.display="none",this.$cache.single[0].style.display="none"),this.appendGrid(),this.options.disable?(this.appendDisableMask(),this.$cache.input[0].disabled=!0):(this.$cache.cont.removeClass("irs-disabled"),this.$cache.input[0].disabled=!1,this.bindEvents()),this.options.drag_interval&&(this.$cache.bar[0].style.cursor="ew-resize")},setTopHandler:function(){var t=this.options.max,i=this.options.to;this.options.from>this.options.min&&i===t?this.$cache.s_from.addClass("type_last"):t>i&&this.$cache.s_to.addClass("type_last")},changeLevel:function(t){switch(t){case"single":this.coords.p_gap=this.toFixed(this.coords.p_pointer-this.coords.p_single_fake);break;case"from":this.coords.p_gap=this.toFixed(this.coords.p_pointer-this.coords.p_from_fake),this.$cache.s_from.addClass("state_hover"),this.$cache.s_from.addClass("type_last"),this.$cache.s_to.removeClass("type_last");break;case"to":this.coords.p_gap=this.toFixed(this.coords.p_pointer-this.coords.p_to_fake),this.$cache.s_to.addClass("state_hover"),this.$cache.s_to.addClass("type_last"),this.$cache.s_from.removeClass("type_last");break;case"both":this.coords.p_gap_left=this.toFixed(this.coords.p_pointer-this.coords.p_from_fake),this.coords.p_gap_right=this.toFixed(this.coords.p_to_fake-this.coords.p_pointer),this.$cache.s_to.removeClass("type_last"),this.$cache.s_from.removeClass("type_last")}},appendDisableMask:function(){this.$cache.cont.append('<span class="irs-disable-mask"></span>'),this.$cache.cont.addClass("irs-disabled")},remove:function(){this.$cache.cont.remove(),this.$cache.cont=null,this.$cache.line.off("keydown.irs_"+this.plugin_count),this.$cache.body.off("touchmove.irs_"+this.plugin_count),this.$cache.body.off("mousemove.irs_"+this.plugin_count),this.$cache.win.off("touchend.irs_"+this.plugin_count),this.$cache.win.off("mouseup.irs_"+this.plugin_count),a&&(this.$cache.body.off("mouseup.irs_"+this.plugin_count),this.$cache.body.off("mouseleave.irs_"+this.plugin_count)),this.$cache.grid_labels=[],this.coords.big=[],this.coords.big_w=[],this.coords.big_p=[],this.coords.big_x=[],cancelAnimationFrame(this.raf_id)},bindEvents:function(){this.no_diapason||(this.$cache.body.on("touchmove.irs_"+this.plugin_count,this.pointerMove.bind(this)),this.$cache.body.on("mousemove.irs_"+this.plugin_count,this.pointerMove.bind(this)),this.$cache.win.on("touchend.irs_"+this.plugin_count,this.pointerUp.bind(this)),this.$cache.win.on("mouseup.irs_"+this.plugin_count,this.pointerUp.bind(this)),this.$cache.line.on("touchstart.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.line.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.options.drag_interval&&"double"===this.options.type?(this.$cache.bar.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"both")),this.$cache.bar.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"both"))):(this.$cache.bar.on("touchstart.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.bar.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click"))),"single"===this.options.type?(this.$cache.single.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"single")),this.$cache.s_single.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"single")),this.$cache.shad_single.on("touchstart.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.single.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"single")),this.$cache.s_single.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"single")),this.$cache.edge.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.shad_single.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click"))):(this.$cache.single.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,null)),this.$cache.single.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,null)),this.$cache.from.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"from")),this.$cache.s_from.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"from")),this.$cache.to.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"to")),this.$cache.s_to.on("touchstart.irs_"+this.plugin_count,this.pointerDown.bind(this,"to")),this.$cache.shad_from.on("touchstart.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.shad_to.on("touchstart.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.from.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"from")),this.$cache.s_from.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"from")),this.$cache.to.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"to")),this.$cache.s_to.on("mousedown.irs_"+this.plugin_count,this.pointerDown.bind(this,"to")),this.$cache.shad_from.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click")),this.$cache.shad_to.on("mousedown.irs_"+this.plugin_count,this.pointerClick.bind(this,"click"))),this.options.keyboard&&this.$cache.line.on("keydown.irs_"+this.plugin_count,this.key.bind(this,"keyboard")),a&&(this.$cache.body.on("mouseup.irs_"+this.plugin_count,this.pointerUp.bind(this)),this.$cache.body.on("mouseleave.irs_"+this.plugin_count,this.pointerUp.bind(this))))},pointerMove:function(t){this.dragging&&(this.coords.x_pointer=(t.pageX||t.originalEvent.touches&&t.originalEvent.touches[0].pageX)-this.coords.x_gap,this.calc())},pointerUp:function(i){this.current_plugin===this.plugin_count&&this.is_active&&(this.is_active=!1,this.$cache.cont.find(".state_hover").removeClass("state_hover"),this.force_redraw=!0,a&&t("*").prop("unselectable",!1),this.updateScene(),this.restoreOriginalMinInterval(),(t.contains(this.$cache.cont[0],i.target)||this.dragging)&&(this.is_finish=!0,this.callOnFinish()),this.dragging=!1)},pointerDown:function(i,e){e.preventDefault();var s=e.pageX||e.originalEvent.touches&&e.originalEvent.touches[0].pageX;2!==e.button&&("both"===i&&this.setTempMinInterval(),i||(i=this.target),this.current_plugin=this.plugin_count,this.target=i,this.dragging=this.is_active=!0,this.coords.x_gap=this.$cache.rs.offset().left,this.coords.x_pointer=s-this.coords.x_gap,this.calcPointerPercent(),this.changeLevel(i),a&&t("*").prop("unselectable",!0),this.$cache.line.trigger("focus"),this.updateScene())},pointerClick:function(t,i){i.preventDefault();var e=i.pageX||i.originalEvent.touches&&i.originalEvent.touches[0].pageX;2!==i.button&&(this.current_plugin=this.plugin_count,this.target=t,this.is_click=!0,this.coords.x_gap=this.$cache.rs.offset().left,this.coords.x_pointer=+(e-this.coords.x_gap).toFixed(),this.force_redraw=!0,this.calc(),this.$cache.line.trigger("focus"))},key:function(t,i){if(!(this.current_plugin!==this.plugin_count||i.altKey||i.ctrlKey||i.shiftKey||i.metaKey)){switch(i.which){case 83:case 65:case 40:case 37:i.preventDefault(),this.moveByKey(!1);break;case 87:case 68:case 38:case 39:i.preventDefault(),this.moveByKey(!0)}return!0}},moveByKey:function(t){var i=this.coords.p_pointer,i=t?i+this.options.keyboard_step:i-this.options.keyboard_step;this.coords.x_pointer=this.toFixed(this.coords.w_rs/100*i),this.is_key=!0,this.calc()},setMinMax:function(){this.options&&(this.options.hide_min_max?(this.$cache.min[0].style.display="none",this.$cache.max[0].style.display="none"):(this.options.values.length?(this.$cache.min.html(this.decorate(this.options.p_values[this.options.min])),this.$cache.max.html(this.decorate(this.options.p_values[this.options.max]))):(this.$cache.min.html(this.decorate(this._prettify(this.options.min),this.options.min)),this.$cache.max.html(this.decorate(this._prettify(this.options.max),this.options.max))),this.labels.w_min=this.$cache.min.outerWidth(!1),this.labels.w_max=this.$cache.max.outerWidth(!1)))},setTempMinInterval:function(){var t=this.result.to-this.result.from;null===this.old_min_interval&&(this.old_min_interval=this.options.min_interval),this.options.min_interval=t},restoreOriginalMinInterval:function(){null!==this.old_min_interval&&(this.options.min_interval=this.old_min_interval,this.old_min_interval=null)},calc:function(t){if(this.options&&(this.calc_count++,(10===this.calc_count||t)&&(this.calc_count=0,this.coords.w_rs=this.$cache.rs.outerWidth(!1),this.calcHandlePercent()),this.coords.w_rs)){switch(this.calcPointerPercent(),t=this.getHandleX(),"click"===this.target&&(this.coords.p_gap=this.coords.p_handle/2,t=this.getHandleX(),this.target=this.options.drag_interval?"both_one":this.chooseHandle(t)),this.target){case"base":var i=(this.options.max-this.options.min)/100;t=(this.result.from-this.options.min)/i,i=(this.result.to-this.options.min)/i,this.coords.p_single_real=this.toFixed(t),this.coords.p_from_real=this.toFixed(t),this.coords.p_to_real=this.toFixed(i),this.coords.p_single_real=this.checkDiapason(this.coords.p_single_real,this.options.from_min,this.options.from_max),this.coords.p_from_real=this.checkDiapason(this.coords.p_from_real,this.options.from_min,this.options.from_max),this.coords.p_to_real=this.checkDiapason(this.coords.p_to_real,this.options.to_min,this.options.to_max),this.coords.p_single_fake=this.convertToFakePercent(this.coords.p_single_real),this.coords.p_from_fake=this.convertToFakePercent(this.coords.p_from_real),this.coords.p_to_fake=this.convertToFakePercent(this.coords.p_to_real),this.target=null;break;case"single":if(this.options.from_fixed)break;this.coords.p_single_real=this.convertToRealPercent(t),this.coords.p_single_real=this.calcWithStep(this.coords.p_single_real),this.coords.p_single_real=this.checkDiapason(this.coords.p_single_real,this.options.from_min,this.options.from_max),this.coords.p_single_fake=this.convertToFakePercent(this.coords.p_single_real);break;case"from":if(this.options.from_fixed)break;this.coords.p_from_real=this.convertToRealPercent(t),this.coords.p_from_real=this.calcWithStep(this.coords.p_from_real),this.coords.p_from_real>this.coords.p_to_real&&(this.coords.p_from_real=this.coords.p_to_real),this.coords.p_from_real=this.checkDiapason(this.coords.p_from_real,this.options.from_min,this.options.from_max),this.coords.p_from_real=this.checkMinInterval(this.coords.p_from_real,this.coords.p_to_real,"from"),this.coords.p_from_real=this.checkMaxInterval(this.coords.p_from_real,this.coords.p_to_real,"from"),this.coords.p_from_fake=this.convertToFakePercent(this.coords.p_from_real);break;case"to":if(this.options.to_fixed)break;this.coords.p_to_real=this.convertToRealPercent(t),this.coords.p_to_real=this.calcWithStep(this.coords.p_to_real),this.coords.p_to_real<this.coords.p_from_real&&(this.coords.p_to_real=this.coords.p_from_real),this.coords.p_to_real=this.checkDiapason(this.coords.p_to_real,this.options.to_min,this.options.to_max),this.coords.p_to_real=this.checkMinInterval(this.coords.p_to_real,this.coords.p_from_real,"to"),this.coords.p_to_real=this.checkMaxInterval(this.coords.p_to_real,this.coords.p_from_real,"to"),this.coords.p_to_fake=this.convertToFakePercent(this.coords.p_to_real);break;case"both":if(this.options.from_fixed||this.options.to_fixed)break;t=this.toFixed(t+.1*this.coords.p_handle),this.coords.p_from_real=this.convertToRealPercent(t)-this.coords.p_gap_left,this.coords.p_from_real=this.calcWithStep(this.coords.p_from_real),this.coords.p_from_real=this.checkDiapason(this.coords.p_from_real,this.options.from_min,this.options.from_max),this.coords.p_from_real=this.checkMinInterval(this.coords.p_from_real,this.coords.p_to_real,"from"),this.coords.p_from_fake=this.convertToFakePercent(this.coords.p_from_real),this.coords.p_to_real=this.convertToRealPercent(t)+this.coords.p_gap_right,this.coords.p_to_real=this.calcWithStep(this.coords.p_to_real),this.coords.p_to_real=this.checkDiapason(this.coords.p_to_real,this.options.to_min,this.options.to_max),this.coords.p_to_real=this.checkMinInterval(this.coords.p_to_real,this.coords.p_from_real,"to"),this.coords.p_to_fake=this.convertToFakePercent(this.coords.p_to_real);break;case"both_one":if(this.options.from_fixed||this.options.to_fixed)break;var e=this.convertToRealPercent(t);t=this.result.to_percent-this.result.from_percent;var s=t/2,i=e-s,e=e+s;0>i&&(i=0,e=i+t),e>100&&(e=100,i=e-t),this.coords.p_from_real=this.calcWithStep(i),this.coords.p_from_real=this.checkDiapason(this.coords.p_from_real,this.options.from_min,this.options.from_max),this.coords.p_from_fake=this.convertToFakePercent(this.coords.p_from_real),this.coords.p_to_real=this.calcWithStep(e),this.coords.p_to_real=this.checkDiapason(this.coords.p_to_real,this.options.to_min,this.options.to_max),this.coords.p_to_fake=this.convertToFakePercent(this.coords.p_to_real)}"single"===this.options.type?(this.coords.p_bar_x=this.coords.p_handle/2,this.coords.p_bar_w=this.coords.p_single_fake,this.result.from_percent=this.coords.p_single_real,this.result.from=this.convertToValue(this.coords.p_single_real),this.options.values.length&&(this.result.from_value=this.options.values[this.result.from])):(this.coords.p_bar_x=this.toFixed(this.coords.p_from_fake+this.coords.p_handle/2),this.coords.p_bar_w=this.toFixed(this.coords.p_to_fake-this.coords.p_from_fake),this.result.from_percent=this.coords.p_from_real,this.result.from=this.convertToValue(this.coords.p_from_real),this.result.to_percent=this.coords.p_to_real,this.result.to=this.convertToValue(this.coords.p_to_real),this.options.values.length&&(this.result.from_value=this.options.values[this.result.from],this.result.to_value=this.options.values[this.result.to])),this.calcMinMax(),this.calcLabels()}},calcPointerPercent:function(){this.coords.w_rs?(0>this.coords.x_pointer||isNaN(this.coords.x_pointer)?this.coords.x_pointer=0:this.coords.x_pointer>this.coords.w_rs&&(this.coords.x_pointer=this.coords.w_rs),this.coords.p_pointer=this.toFixed(this.coords.x_pointer/this.coords.w_rs*100)):this.coords.p_pointer=0},convertToRealPercent:function(t){return t/(100-this.coords.p_handle)*100},convertToFakePercent:function(t){return t/100*(100-this.coords.p_handle)},getHandleX:function(){var t=100-this.coords.p_handle,i=this.toFixed(this.coords.p_pointer-this.coords.p_gap);return 0>i?i=0:i>t&&(i=t),i},calcHandlePercent:function(){this.coords.w_handle="single"===this.options.type?this.$cache.s_single.outerWidth(!1):this.$cache.s_from.outerWidth(!1),this.coords.p_handle=this.toFixed(this.coords.w_handle/this.coords.w_rs*100)},chooseHandle:function(t){return"single"===this.options.type?"single":t>=this.coords.p_from_real+(this.coords.p_to_real-this.coords.p_from_real)/2?this.options.to_fixed?"from":"to":this.options.from_fixed?"to":"from"},calcMinMax:function(){this.coords.w_rs&&(this.labels.p_min=this.labels.w_min/this.coords.w_rs*100,this.labels.p_max=this.labels.w_max/this.coords.w_rs*100)},calcLabels:function(){this.coords.w_rs&&!this.options.hide_from_to&&("single"===this.options.type?(this.labels.w_single=this.$cache.single.outerWidth(!1),this.labels.p_single_fake=this.labels.w_single/this.coords.w_rs*100,this.labels.p_single_left=this.coords.p_single_fake+this.coords.p_handle/2-this.labels.p_single_fake/2):(this.labels.w_from=this.$cache.from.outerWidth(!1),this.labels.p_from_fake=this.labels.w_from/this.coords.w_rs*100,this.labels.p_from_left=this.coords.p_from_fake+this.coords.p_handle/2-this.labels.p_from_fake/2,this.labels.p_from_left=this.toFixed(this.labels.p_from_left),this.labels.p_from_left=this.checkEdges(this.labels.p_from_left,this.labels.p_from_fake),this.labels.w_to=this.$cache.to.outerWidth(!1),this.labels.p_to_fake=this.labels.w_to/this.coords.w_rs*100,this.labels.p_to_left=this.coords.p_to_fake+this.coords.p_handle/2-this.labels.p_to_fake/2,this.labels.p_to_left=this.toFixed(this.labels.p_to_left),this.labels.p_to_left=this.checkEdges(this.labels.p_to_left,this.labels.p_to_fake),this.labels.w_single=this.$cache.single.outerWidth(!1),this.labels.p_single_fake=this.labels.w_single/this.coords.w_rs*100,this.labels.p_single_left=(this.labels.p_from_left+this.labels.p_to_left+this.labels.p_to_fake)/2-this.labels.p_single_fake/2,this.labels.p_single_left=this.toFixed(this.labels.p_single_left)),this.labels.p_single_left=this.checkEdges(this.labels.p_single_left,this.labels.p_single_fake))},updateScene:function(){this.raf_id&&(cancelAnimationFrame(this.raf_id),this.raf_id=null),clearTimeout(this.update_tm),this.update_tm=null,this.options&&(this.drawHandles(),this.is_active?this.raf_id=requestAnimationFrame(this.updateScene.bind(this)):this.update_tm=setTimeout(this.updateScene.bind(this),300))},drawHandles:function(){this.coords.w_rs=this.$cache.rs.outerWidth(!1),this.coords.w_rs&&(this.coords.w_rs!==this.coords.w_rs_old&&(this.target="base",this.is_resize=!0),(this.coords.w_rs!==this.coords.w_rs_old||this.force_redraw)&&(this.setMinMax(),this.calc(!0),this.drawLabels(),this.options.grid&&(this.calcGridMargin(),this.calcGridLabels()),this.force_redraw=!0,this.coords.w_rs_old=this.coords.w_rs,this.drawShadow()),this.coords.w_rs&&(this.dragging||this.force_redraw||this.is_key)&&((this.old_from!==this.result.from||this.old_to!==this.result.to||this.force_redraw||this.is_key)&&(this.drawLabels(),this.$cache.bar[0].style.left=this.coords.p_bar_x+"%",this.$cache.bar[0].style.width=this.coords.p_bar_w+"%","single"===this.options.type?(this.$cache.s_single[0].style.left=this.coords.p_single_fake+"%",this.$cache.single[0].style.left=this.labels.p_single_left+"%",this.options.values.length?this.$cache.input.prop("value",this.result.from_value):this.$cache.input.prop("value",this.result.from),this.$cache.input.data("from",this.result.from)):(this.$cache.s_from[0].style.left=this.coords.p_from_fake+"%",this.$cache.s_to[0].style.left=this.coords.p_to_fake+"%",(this.old_from!==this.result.from||this.force_redraw)&&(this.$cache.from[0].style.left=this.labels.p_from_left+"%"),(this.old_to!==this.result.to||this.force_redraw)&&(this.$cache.to[0].style.left=this.labels.p_to_left+"%"),this.$cache.single[0].style.left=this.labels.p_single_left+"%",this.options.values.length?this.$cache.input.prop("value",this.result.from_value+this.options.input_values_separator+this.result.to_value):this.$cache.input.prop("value",this.result.from+this.options.input_values_separator+this.result.to),this.$cache.input.data("from",this.result.from),this.$cache.input.data("to",this.result.to)),this.old_from===this.result.from&&this.old_to===this.result.to||this.is_start||this.$cache.input.trigger("change"),this.old_from=this.result.from,this.old_to=this.result.to,this.is_resize||this.is_update||this.is_start||this.is_finish||this.callOnChange(),(this.is_key||this.is_click)&&(this.is_click=this.is_key=!1,this.callOnFinish()),this.is_finish=this.is_resize=this.is_update=!1),this.force_redraw=this.is_click=this.is_key=this.is_start=!1))},drawLabels:function(){if(this.options){var t,i=this.options.values.length,e=this.options.p_values;if(!this.options.hide_from_to)if("single"===this.options.type)i=i?this.decorate(e[this.result.from]):this.decorate(this._prettify(this.result.from),this.result.from),this.$cache.single.html(i),this.calcLabels(),this.$cache.min[0].style.visibility=this.labels.p_single_left<this.labels.p_min+1?"hidden":"visible",this.$cache.max[0].style.visibility=this.labels.p_single_left+this.labels.p_single_fake>100-this.labels.p_max-1?"hidden":"visible";else{i?(this.options.decorate_both?(i=this.decorate(e[this.result.from]),i+=this.options.values_separator,i+=this.decorate(e[this.result.to])):i=this.decorate(e[this.result.from]+this.options.values_separator+e[this.result.to]),t=this.decorate(e[this.result.from]),e=this.decorate(e[this.result.to])):(this.options.decorate_both?(i=this.decorate(this._prettify(this.result.from),this.result.from),i+=this.options.values_separator,i+=this.decorate(this._prettify(this.result.to),this.result.to)):i=this.decorate(this._prettify(this.result.from)+this.options.values_separator+this._prettify(this.result.to),this.result.to),t=this.decorate(this._prettify(this.result.from),this.result.from),e=this.decorate(this._prettify(this.result.to),this.result.to)),this.$cache.single.html(i),this.$cache.from.html(t),this.$cache.to.html(e),this.calcLabels(),e=Math.min(this.labels.p_single_left,this.labels.p_from_left),i=this.labels.p_single_left+this.labels.p_single_fake,t=this.labels.p_to_left+this.labels.p_to_fake;var s=Math.max(i,t);this.labels.p_from_left+this.labels.p_from_fake>=this.labels.p_to_left?(this.$cache.from[0].style.visibility="hidden",this.$cache.to[0].style.visibility="hidden",this.$cache.single[0].style.visibility="visible",this.result.from===this.result.to?("from"===this.target?this.$cache.from[0].style.visibility="visible":"to"===this.target&&(this.$cache.to[0].style.visibility="visible"),this.$cache.single[0].style.visibility="hidden",s=t):(this.$cache.from[0].style.visibility="hidden",this.$cache.to[0].style.visibility="hidden",this.$cache.single[0].style.visibility="visible",s=Math.max(i,t))):(this.$cache.from[0].style.visibility="visible",this.$cache.to[0].style.visibility="visible",this.$cache.single[0].style.visibility="hidden"),this.$cache.min[0].style.visibility=e<this.labels.p_min+1?"hidden":"visible",this.$cache.max[0].style.visibility=s>100-this.labels.p_max-1?"hidden":"visible"}}},drawShadow:function(){var t=this.options,i=this.$cache,e="number"==typeof t.from_min&&!isNaN(t.from_min),s="number"==typeof t.from_max&&!isNaN(t.from_max),o="number"==typeof t.to_min&&!isNaN(t.to_min),a="number"==typeof t.to_max&&!isNaN(t.to_max);"single"===t.type?t.from_shadow&&(e||s)?(e=this.convertToPercent(e?t.from_min:t.min),s=this.convertToPercent(s?t.from_max:t.max)-e,e=this.toFixed(e-this.coords.p_handle/100*e),s=this.toFixed(s-this.coords.p_handle/100*s),e+=this.coords.p_handle/2,i.shad_single[0].style.display="block",i.shad_single[0].style.left=e+"%",i.shad_single[0].style.width=s+"%"):i.shad_single[0].style.display="none":(t.from_shadow&&(e||s)?(e=this.convertToPercent(e?t.from_min:t.min),s=this.convertToPercent(s?t.from_max:t.max)-e,e=this.toFixed(e-this.coords.p_handle/100*e),s=this.toFixed(s-this.coords.p_handle/100*s),e+=this.coords.p_handle/2,i.shad_from[0].style.display="block",i.shad_from[0].style.left=e+"%",i.shad_from[0].style.width=s+"%"):i.shad_from[0].style.display="none",t.to_shadow&&(o||a)?(o=this.convertToPercent(o?t.to_min:t.min),t=this.convertToPercent(a?t.to_max:t.max)-o,o=this.toFixed(o-this.coords.p_handle/100*o),t=this.toFixed(t-this.coords.p_handle/100*t),o+=this.coords.p_handle/2,i.shad_to[0].style.display="block",i.shad_to[0].style.left=o+"%",i.shad_to[0].style.width=t+"%"):i.shad_to[0].style.display="none")},callOnStart:function(){this.options.onStart&&"function"==typeof this.options.onStart&&this.options.onStart(this.result)},callOnChange:function(){this.options.onChange&&"function"==typeof this.options.onChange&&this.options.onChange(this.result)},callOnFinish:function(){this.options.onFinish&&"function"==typeof this.options.onFinish&&this.options.onFinish(this.result)},callOnUpdate:function(){this.options.onUpdate&&"function"==typeof this.options.onUpdate&&this.options.onUpdate(this.result)},toggleInput:function(){this.$cache.input.toggleClass("irs-hidden-input")},convertToPercent:function(t,i){var e=this.options.max-this.options.min;return e?this.toFixed((i?t:t-this.options.min)/(e/100)):(this.no_diapason=!0,0)},convertToValue:function(t){var i,e,s=this.options.min,o=this.options.max,a=s.toString().split(".")[1],n=o.toString().split(".")[1],r=0,h=0;return 0===t?this.options.min:100===t?this.options.max:(a&&(r=i=a.length),n&&(r=e=n.length),i&&e&&(r=i>=e?i:e),0>s&&(h=Math.abs(s),s=+(s+h).toFixed(r),o=+(o+h).toFixed(r)),t=(o-s)/100*t+s,(s=this.options.step.toString().split(".")[1])?t=+t.toFixed(s.length):(t/=this.options.step,t*=this.options.step,t=+t.toFixed(0)),h&&(t-=h),h=s?+t.toFixed(s.length):this.toFixed(t),h<this.options.min?h=this.options.min:h>this.options.max&&(h=this.options.max),h)},calcWithStep:function(t){var i=Math.round(t/this.coords.p_step)*this.coords.p_step;return i>100&&(i=100),100===t&&(i=100),this.toFixed(i)},checkMinInterval:function(t,i,e){var s=this.options;return s.min_interval?(t=this.convertToValue(t),i=this.convertToValue(i),"from"===e?i-t<s.min_interval&&(t=i-s.min_interval):t-i<s.min_interval&&(t=i+s.min_interval),this.convertToPercent(t)):t},checkMaxInterval:function(t,i,e){var s=this.options;return s.max_interval?(t=this.convertToValue(t),i=this.convertToValue(i),"from"===e?i-t>s.max_interval&&(t=i-s.max_interval):t-i>s.max_interval&&(t=i+s.max_interval),this.convertToPercent(t)):t},checkDiapason:function(t,i,e){t=this.convertToValue(t);var s=this.options;return"number"!=typeof i&&(i=s.min),"number"!=typeof e&&(e=s.max),i>t&&(t=i),t>e&&(t=e),this.convertToPercent(t)},toFixed:function(t){return t=t.toFixed(9),+t},_prettify:function(t){return this.options.prettify_enabled?this.options.prettify&&"function"==typeof this.options.prettify?this.options.prettify(t):this.prettify(t):t},prettify:function(t){return t.toString().replace(/(\d{1,3}(?=(?:\d\d\d)+(?!\d)))/g,"$1"+this.options.prettify_separator)},checkEdges:function(t,i){return this.options.force_edges?(0>t?t=0:t>100-i&&(t=100-i),this.toFixed(t)):this.toFixed(t)},validate:function(){var t,i,e=this.options,s=this.result,o=e.values,a=o.length;if("string"==typeof e.min&&(e.min=+e.min),"string"==typeof e.max&&(e.max=+e.max),"string"==typeof e.from&&(e.from=+e.from),"string"==typeof e.to&&(e.to=+e.to),"string"==typeof e.step&&(e.step=+e.step),"string"==typeof e.from_min&&(e.from_min=+e.from_min),"string"==typeof e.from_max&&(e.from_max=+e.from_max),"string"==typeof e.to_min&&(e.to_min=+e.to_min),"string"==typeof e.to_max&&(e.to_max=+e.to_max),"string"==typeof e.keyboard_step&&(e.keyboard_step=+e.keyboard_step),"string"==typeof e.grid_num&&(e.grid_num=+e.grid_num),e.max<e.min&&(e.max=e.min),a)for(e.p_values=[],e.min=0,e.max=a-1,e.step=1,e.grid_num=e.max,e.grid_snap=!0,i=0;a>i;i++)t=+o[i],isNaN(t)?t=o[i]:(o[i]=t,t=this._prettify(t)),e.p_values.push(t);("number"!=typeof e.from||isNaN(e.from))&&(e.from=e.min),("number"!=typeof e.to||isNaN(e.from))&&(e.to=e.max),"single"===e.type?(e.from<e.min&&(e.from=e.min),
e.from>e.max&&(e.from=e.max)):((e.from<e.min||e.from>e.max)&&(e.from=e.min),(e.to>e.max||e.to<e.min)&&(e.to=e.max),e.from>e.to&&(e.from=e.to)),("number"!=typeof e.step||isNaN(e.step)||!e.step||0>e.step)&&(e.step=1),("number"!=typeof e.keyboard_step||isNaN(e.keyboard_step)||!e.keyboard_step||0>e.keyboard_step)&&(e.keyboard_step=5),"number"==typeof e.from_min&&e.from<e.from_min&&(e.from=e.from_min),"number"==typeof e.from_max&&e.from>e.from_max&&(e.from=e.from_max),"number"==typeof e.to_min&&e.to<e.to_min&&(e.to=e.to_min),"number"==typeof e.to_max&&e.from>e.to_max&&(e.to=e.to_max),s&&(s.min!==e.min&&(s.min=e.min),s.max!==e.max&&(s.max=e.max),(s.from<s.min||s.from>s.max)&&(s.from=e.from),(s.to<s.min||s.to>s.max)&&(s.to=e.to)),("number"!=typeof e.min_interval||isNaN(e.min_interval)||!e.min_interval||0>e.min_interval)&&(e.min_interval=0),("number"!=typeof e.max_interval||isNaN(e.max_interval)||!e.max_interval||0>e.max_interval)&&(e.max_interval=0),e.min_interval&&e.min_interval>e.max-e.min&&(e.min_interval=e.max-e.min),e.max_interval&&e.max_interval>e.max-e.min&&(e.max_interval=e.max-e.min)},decorate:function(t,i){var e="",s=this.options;return s.prefix&&(e+=s.prefix),e+=t,s.max_postfix&&(s.values.length&&t===s.p_values[s.max]?(e+=s.max_postfix,s.postfix&&(e+=" ")):i===s.max&&(e+=s.max_postfix,s.postfix&&(e+=" "))),s.postfix&&(e+=s.postfix),e},updateFrom:function(){this.result.from=this.options.from,this.result.from_percent=this.convertToPercent(this.result.from),this.options.values&&(this.result.from_value=this.options.values[this.result.from])},updateTo:function(){this.result.to=this.options.to,this.result.to_percent=this.convertToPercent(this.result.to),this.options.values&&(this.result.to_value=this.options.values[this.result.to])},updateResult:function(){this.result.min=this.options.min,this.result.max=this.options.max,this.updateFrom(),this.updateTo()},appendGrid:function(){if(this.options.grid){var t,i,e=this.options;t=e.max-e.min;var s,o,a=e.grid_num,n=0,r=0,h=4,l=0,c="";for(this.calcGridMargin(),e.grid_snap?(a=t/e.step,n=this.toFixed(e.step/(t/100))):n=this.toFixed(100/a),a>4&&(h=3),a>7&&(h=2),a>14&&(h=1),a>28&&(h=0),t=0;a+1>t;t++){for(s=h,r=this.toFixed(n*t),r>100&&(r=100,s-=2,0>s&&(s=0)),this.coords.big[t]=r,o=(r-n*(t-1))/(s+1),i=1;s>=i&&0!==r;i++)l=this.toFixed(r-o*i),c+='<span class="irs-grid-pol small" style="left: '+l+'%"></span>';c+='<span class="irs-grid-pol" style="left: '+r+'%"></span>',l=this.convertToValue(r),l=e.values.length?e.p_values[l]:this._prettify(l),c+='<span class="irs-grid-text js-grid-text-'+t+'" style="left: '+r+'%">'+l+"</span>"}this.coords.big_num=Math.ceil(a+1),this.$cache.cont.addClass("irs-with-grid"),this.$cache.grid.html(c),this.cacheGridLabels()}},cacheGridLabels:function(){var t,i,e=this.coords.big_num;for(i=0;e>i;i++)t=this.$cache.grid.find(".js-grid-text-"+i),this.$cache.grid_labels.push(t);this.calcGridLabels()},calcGridLabels:function(){var t,i;i=[];var e=[],s=this.coords.big_num;for(t=0;s>t;t++)this.coords.big_w[t]=this.$cache.grid_labels[t].outerWidth(!1),this.coords.big_p[t]=this.toFixed(this.coords.big_w[t]/this.coords.w_rs*100),this.coords.big_x[t]=this.toFixed(this.coords.big_p[t]/2),i[t]=this.toFixed(this.coords.big[t]-this.coords.big_x[t]),e[t]=this.toFixed(i[t]+this.coords.big_p[t]);for(this.options.force_edges&&(i[0]<-this.coords.grid_gap&&(i[0]=-this.coords.grid_gap,e[0]=this.toFixed(i[0]+this.coords.big_p[0]),this.coords.big_x[0]=this.coords.grid_gap),e[s-1]>100+this.coords.grid_gap&&(e[s-1]=100+this.coords.grid_gap,i[s-1]=this.toFixed(e[s-1]-this.coords.big_p[s-1]),this.coords.big_x[s-1]=this.toFixed(this.coords.big_p[s-1]-this.coords.grid_gap))),this.calcGridCollision(2,i,e),this.calcGridCollision(4,i,e),t=0;s>t;t++)i=this.$cache.grid_labels[t][0],i.style.marginLeft=-this.coords.big_x[t]+"%"},calcGridCollision:function(t,i,e){var s,o,a,n=this.coords.big_num;for(s=0;n>s&&(o=s+t/2,!(o>=n));s+=t)a=this.$cache.grid_labels[o][0],a.style.visibility=e[s]<=i[o]?"visible":"hidden"},calcGridMargin:function(){this.options.grid_margin&&(this.coords.w_rs=this.$cache.rs.outerWidth(!1),this.coords.w_rs&&(this.coords.w_handle="single"===this.options.type?this.$cache.s_single.outerWidth(!1):this.$cache.s_from.outerWidth(!1),this.coords.p_handle=this.toFixed(this.coords.w_handle/this.coords.w_rs*100),this.coords.grid_gap=this.toFixed(this.coords.p_handle/2-.1),this.$cache.grid[0].style.width=this.toFixed(100-this.coords.p_handle)+"%",this.$cache.grid[0].style.left=this.coords.grid_gap+"%"))},update:function(i){this.input&&(this.is_update=!0,this.options.from=this.result.from,this.options.to=this.result.to,this.options=t.extend(this.options,i),this.validate(),this.updateResult(i),this.toggleInput(),this.remove(),this.init(!0))},reset:function(){this.input&&(this.updateResult(),this.update())},destroy:function(){this.input&&(this.toggleInput(),this.$cache.input.prop("readonly",!1),t.data(this.input,"ionRangeSlider",null),this.remove(),this.options=this.input=null)}},t.fn.ionRangeSlider=function(i){return this.each(function(){t.data(this,"ionRangeSlider")||t.data(this,"ionRangeSlider",new n(this,i,o++))})},function(){for(var t=0,i=["ms","moz","webkit","o"],s=0;s<i.length&&!e.requestAnimationFrame;++s)e.requestAnimationFrame=e[i[s]+"RequestAnimationFrame"],e.cancelAnimationFrame=e[i[s]+"CancelAnimationFrame"]||e[i[s]+"CancelRequestAnimationFrame"];e.requestAnimationFrame||(e.requestAnimationFrame=function(i){var s=(new Date).getTime(),o=Math.max(0,16-(s-t)),a=e.setTimeout(function(){i(s+o)},o);return t=s+o,a}),e.cancelAnimationFrame||(e.cancelAnimationFrame=function(t){clearTimeout(t)})}()}(jQuery,document,window,navigator);