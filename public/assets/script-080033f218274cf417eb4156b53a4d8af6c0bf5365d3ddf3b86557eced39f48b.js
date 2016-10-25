var sliders = function() {
    $(".range_01").ionRangeSlider({
        min: 1,
        max: 12
    })
}

var autoScroll = function() {
    $(".home-menu-item").on("click", function(e) {
        e.preventDefault();
        var link = "#" + $(this).find("div").text().toLowerCase()
        $('html,body').animate({
            scrollTop: $(link).offset().top - 30
        }, 'slow');
    })
    $(".contact-link").on("click", function(e) {
        e.preventDefault();
        var link = $(this).attr("href")
        $('html,body').animate({
            scrollTop: $(link).offset().top - 55
        }, 'slow');
    })
}


function selectionPicker() {
    basecost = parseInt($("span.price").text());
    var updatePrice = function() {
        optioncount = $(".page-selector li.selected").length * 10;
        pagesnum = parseInt($(".irs-single").text())
        optionsarray = []
        $(".page-selector li.selected").each(function() {
            optionsarray.push($(this).attr("data-item"))
        })
        if (pagesnum <= 10) {
            switch (true) {
                case (pagesnum <= 1):
                    $(".pricing-meta").html("Uw Pagina Voor Ongeveer <i class='icon-question-sign'></i>")
                    total = (optioncount + basecost)
                    break;
                case (pagesnum <= 3):
                    $(".pricing-meta").html("Uw Pagina's Voor Ongeveer <i class='icon-question-sign'></i>")
                        // 15% extra per pagina
                    total = ((1 + pagesnum * 0.15) * (optioncount + basecost))
                    break;
                case (pagesnum <= 5):
                    // 25% extra per pagina
                    total = ((1 + pagesnum * 0.25) * (optioncount + basecost))
                    break;
                case (pagesnum <= 7):
                    // 32% extra per pagina
                    total = ((1 + pagesnum * 0.35) * (optioncount + basecost))
                    break;
                case (pagesnum <= 10):
                    $(".pricing-meta").html("Uw Pagina's Voor Ongeveer <i class='icon-question-sign'></i>")
                    $(".price-tenure").text("Vaste Prijs!")
                        // 40% extra per pagina
                    total = ((1 + pagesnum * 0.45) * (optioncount + basecost))
                    break;
                default:
                    break;
            }
            $(".price").text(parseInt(total))
            $("#template-contactform-options").val(pagesnum + " pages | " + optioncount / 10 + " options (" + optionsarray + ") | +-" + parseInt(total) + " euro")
        } else {
            $(".pricing-meta").text("Contacteer mij")
            $(".price-tenure").text("Voor een offerte!")
            $(".price-special").text("???")
            $("#template-contactform-options").val("Special Quote")
        }
    }

    $(".page-selector li").on("click", function() {
        if ($(this).hasClass("selected")) {
            $(this).removeClass("selected");
        } else {
            $(this).addClass("selected");
        }
        updatePrice()
    })
    $('.range_01').on("change", updatePrice)
}

function add(a, b) {
    return a + b;
}

function selectionPicker2() {
    service = $("#wrapper > div > div.heading-block.center > h2").text()
    basecost = parseInt($("span.price").text());
    var updatePrice = function() {
        optioncount = $(".page-selector li.selected").length;
        optionsarray = [];
        pricings = [];
        $(".page-selector li.selected").each(function() {
            optionsarray.push($(this).attr("data-item"))
            var price = parseInt($(this).attr("data-price"))
            pricings.push(price)
        })
        optiontotal = $(pricings.reduce(add, 0))
        if (optiontotal.length > 0) {
            total = parseInt(optiontotal[0]) + basecost
        } else {
            total = basecost
        }
        $(".price").text(total)
        $("#template-contactform-options").val(service + " | " + pricings.length + " options (" + optionsarray + ") | +-" + parseInt(total) + " euro")
    }

    $(".page-selector li").on("click", function() {
        if ($(this).hasClass("selected")) {
            $(this).removeClass("selected");
        } else {
            $(this).addClass("selected");
        }
        updatePrice()
    })
}

var fancyFade = function() {
    $(".contact-special").on("click", function() {
        $(".col-hidden").fadeIn(500)
        $('html,body').animate({
            scrollTop: $("#contact").offset().top - 60
        }, 'slow');
    })
}

function createForm() {
    $(".table-fade").slideUp()
    $(".create-form").fadeIn()
    $('html,body').animate({
        scrollTop: $("#createForm").offset().top - 60
    }, 'slow');
}

function closeForm() {
    $(".create-form").slideUp()
    $(".table-fade").slideDown()
    $('html,body').animate({
        scrollTop: 0
    }, 'slow');
}

function getText() {
    $(".trumbowyg-editor").on("input", function() {
        value = $(".trumbowyg-editor").html();
        $("#article_body").val(value);
    })
}

var showOptions = function() {
    $(".subscribe #mce-EMAIL, .subscribe #mce-FNAME").on("change", function() {
        if ($(this).val() != "") {
            $(this).closest("form").find("div.which-articles-wrapper").fadeIn()
        }
        if ($(this).val() == "") {
            $(this).closest("form").find("div.which-articles-wrapper").fadeOut()
        }
    })
}

function getTags() {
    options = {
        "mobile": "icon-line2-screen-smartphone",
        "responsive": "icon-resize-horizontal",
        "rails_app": "icon-diamond2",
        "slider": "icon-stack3",
        "video": "icon-line-video",
        "wordpress": "icon-wordpress",
        "cms": "icon-folder-open",
        "fonts": "icon-font",
        "lightbox": "icon-lightbulb",
        "bootstrap": "icon-bold",
        "parallax": "icon-line2-mouse",
        "email_capture": "icon-line-mail"
    }
    var tooltip = "Opties: " + Object.keys(options).toString().replace(/\W+/g, ', ')
    $("#features-box").attr("data-original-title", tooltip)
    $("#tags_tagsinput").on("keyup", function() {
        var fieldvalue = []
        $this = $("#tags").val().toLowerCase()
        tagsarray = $this.split(",")
        for (var i = 0; i < tagsarray.length; i++) {
            var key = tagsarray[i]
            fieldvalue.push(key + "=>" + options[key])
            var value = fieldvalue.toString()
            $("#project_features").val(value);
        }
    })
}

// If it's a phone, don't show tooltips
if ($(window).width() < 768) {
    $("[data-original-title]").each(function() {
        $(this).removeAttr("data-toggle", "data-placement")
    })
}
;