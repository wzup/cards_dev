//= require jquery
//= require jquery_ujs
//= require_self
//= require cards/global/global

function Page() {
    function t() {
        $("li").filter(function() {
            return this.id.match(/u_[0-9]+/);
        }).each(function() {
            $(this).get(0).addEventListener("click", function(t) {
                n(t, $(this).get(0));
            }, !1);
        });
    }
    function n(t, n) {
        var e = n, i = e.getElementsByTagName("span");
        document.getElementById("r_login").value = i[0].textContent, document.getElementById("r_pass").value = i[1].textContent;
    }
    function e() {
        $("#xplBtn").click(function() {
            $("#ulXpl").slideToggle();
        });
    }
    function i() {
        $("#tzXplBtn").click(function() {
            $("#tzXplTxt").slideToggle();
        });
    }
    this.__init__ = function() {
        t(), e(), i();
    };
}