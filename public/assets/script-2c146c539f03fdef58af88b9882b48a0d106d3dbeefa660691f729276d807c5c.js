function selectionPicker(){basecost=parseInt($("span.price").text());var t=function(){if(optioncount=10*$(".page-selector li.selected").length,pagesnum=parseInt($(".irs-single").text()),optionsarray=[],$(".page-selector li.selected").each(function(){optionsarray.push($(this).attr("data-item"))}),pagesnum<=10){switch(!0){case pagesnum<=1:$(".pricing-meta").html("Uw Pagina Voor Ongeveer <i class='icon-question-sign'></i>"),total=optioncount+basecost;break;case pagesnum<=3:$(".pricing-meta").html("Uw Pagina's Voor Ongeveer <i class='icon-question-sign'></i>"),total=(1+.15*pagesnum)*(optioncount+basecost);break;case pagesnum<=5:total=(1+.25*pagesnum)*(optioncount+basecost);break;case pagesnum<=7:total=(1+.35*pagesnum)*(optioncount+basecost);break;case pagesnum<=10:$(".pricing-meta").html("Uw Pagina's Voor Ongeveer <i class='icon-question-sign'></i>"),$(".price-tenure").text("Vaste Prijs!"),total=(1+.45*pagesnum)*(optioncount+basecost)}$(".price").text(parseInt(total)),$("#template-contactform-options").val(pagesnum+" pages | "+optioncount/10+" options ("+optionsarray+") | +-"+parseInt(total)+" euro")}else $(".pricing-meta").text("Contacteer mij"),$(".price-tenure").text("Voor een offerte!"),$(".price-special").text("???"),$("#template-contactform-options").val("Special Quote")};$(".page-selector li").on("click",function(){$(this).hasClass("selected")?$(this).removeClass("selected"):$(this).addClass("selected"),t()}),$(".range_01").on("change",t)}function add(t,e){return t+e}function selectionPicker2(){service=$("#wrapper > div > div.heading-block.center > h2").text(),basecost=parseInt($("span.price").text());var t=function(){optioncount=$(".page-selector li.selected").length,optionsarray=[],pricings=[],$(".page-selector li.selected").each(function(){optionsarray.push($(this).attr("data-item"));var t=parseInt($(this).attr("data-price"));pricings.push(t)}),optiontotal=$(pricings.reduce(add,0)),optiontotal.length>0?total=parseInt(optiontotal[0])+basecost:total=basecost,$(".price").text(total),$("#template-contactform-options").val(service+" | "+pricings.length+" options ("+optionsarray+") | +-"+parseInt(total)+" euro")};$(".page-selector li").on("click",function(){$(this).hasClass("selected")?$(this).removeClass("selected"):$(this).addClass("selected"),t()})}function createForm(){$(".table-fade").slideUp(),$(".create-form").fadeIn(),$("html,body").animate({scrollTop:$("#createForm").offset().top-60},"slow")}function closeForm(){$(".create-form").slideUp(),$(".table-fade").slideDown(),$("html,body").animate({scrollTop:0},"slow")}function getText(){$(".trumbowyg-editor").on("input",function(){value=$(".trumbowyg-editor").html(),$("#article_body").val(value)})}function getTags(){options={mobile:"icon-line2-screen-smartphone",responsive:"icon-resize-horizontal",rails_app:"icon-diamond2",slider:"icon-stack3",video:"icon-line-video",wordpress:"icon-wordpress",cms:"icon-folder-open",fonts:"icon-font",lightbox:"icon-lightbulb",bootstrap:"icon-bold",parallax:"icon-line2-mouse",email_capture:"icon-line-mail"};var t="Opties: "+Object.keys(options).toString().replace(/\W+/g,", ");$("#features-box").attr("data-original-title",t),$("#tags_tagsinput").on("keyup",function(){var t=[];$this=$("#tags").val().toLowerCase(),tagsarray=$this.split(",");for(var e=0;e<tagsarray.length;e++){var a=tagsarray[e];t.push(a+"=>"+options[a]);var n=t.toString();$("#project_features").val(n)}})}var sliders=function(){$(".range_01").ionRangeSlider({min:1,max:12})},autoScroll=function(){$(".home-menu-item").on("click",function(t){t.preventDefault();var e="#"+$(this).find("div").text().toLowerCase();$("html,body").animate({scrollTop:$(e).offset().top-30},"slow")}),$(".contact-link").on("click",function(t){t.preventDefault();var e=$(this).attr("href");$("html,body").animate({scrollTop:$(e).offset().top-55},"slow")})},fancyFade=function(){$(".contact-special").on("click",function(){$(".col-hidden").fadeIn(500),$("html,body").animate({scrollTop:$("#contact").offset().top-60},"slow"),$(".which-articles-wrapper").fadeOut()})},showOptions=function(){$(".subscribe #mce-EMAIL, .subscribe #mce-FNAME").on("change",function(){""!=$(this).val()&&$(this).closest("form").find("div.which-articles-wrapper").fadeIn(),""==$(this).val()&&$(this).closest("form").find("div.which-articles-wrapper").fadeOut()})};$(window).width()<768&&$("[data-original-title]").each(function(){$(this).removeAttr("data-toggle","data-placement")}),$("img").lazyload();