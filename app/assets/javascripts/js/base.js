function isEmail(value) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(value);
}


var emailParent     = null;
$(document).ready(function() {
    var email       = $("#email input");
    var defValue    = email.val();
    email.bind("focus",function() {
        if (defValue == email.val()) {
            email.val("");
        }
    });
    email.bind("blur",function() {
        if (email.val() == "") {
            email.val(defValue);
        }
    });    
    email.keyup(function(event) {
        var key = event.keyCode || event.which;                        
        if (key === 13) {
            email.parent().find("a").click();
        } else if (isEmail(email.val())) {
            email.css("color","#7ab922");
            email.css("background","url(./images/themes/icon-valid.png) no-repeat 99.4% 3px");


        } else {
            email.removeAttr("style");
            email.css("color","#e52f2f");
            email.css("background","url(./images/themes/icon-unvalid.png) no-repeat 99.4% 3px");
        }
    });
    
});