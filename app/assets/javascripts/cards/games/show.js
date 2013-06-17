//= require jquery
//= require jquery_ujs
//= require_self
//= require cards/games/card
//= require cards/global/gConfig
//= require cards/games/pConfig
//= require cards/global/global

function Page(t) {
    function n() {
        for (i = 0; 10 > i; i++) ge("c_" + i).addEventListener("click", c.card.turn, !1);
        r = !0;
    }
    function a() {
        for (i = 0; 10 > i; i++) ge("c_" + i).removeEventListener("click", c.card.turn, !1);
    }
    function e() {
        c.opCards = new Array(10), $("div[data-isopen='1']").each(function() {
            var t = _getPos($(this).get(0)), n = $(this).css("background-image").match(/\/(\w{2,4})\./)[1];
            c.opCards[t] = {
                pic:n
            };
        });
    }
    function o() {
        a(), r = !1;
        var t = '<a href="' + window.location.pathname + '/join" data-method="post" rel="nofollow">';
        t += _config.vocab[$("html[lang]").attr("lang")].joinGame + "</a>";
        var n = '<div class="c_title wcol mb50 tac">';
        n += _config.vocab[$("html[lang]").attr("lang")].stale1 + "<br>" + _config.vocab[$("html[lang]").attr("lang")].stale2 + "&nbsp", 
        n += t + "</div>", document.getElementById("ballpark").insertAdjacentHTML("afterbegin", n);
    }
    var c = this, r = !1;
    getOpCards = function() {
        return c.opCards;
    }, updParticipants = function(t) {
        ge("parts_n").getElementsByTagName("span")[0].textContent = t.length;
        var n = /name=(user_[0-9]+)/g, a = n.exec(document.cookie)[1], e = "", c = "", l = !1;
        if (0 == t.length) e += '<li class="gi_li_v" style="font-weight: normal;">' + _config.vocab[$("html[lang]").attr("lang")].nobody + "</span></li>"; else for (i in t) t[i].name == a ? (l = !0, 
        c = _config.vocab[$("html[lang]").attr("lang")].u, e += '<li id="pl_' + i + '" class="gi_li_v">' + c + ", " + t[i].name) :e += '<li id="pl_' + i + '" class="gi_li_v">' + t[i].name, 
        e += ', <span class="sip">ip: ' + t[i].ip + "</span></li>";
        ge("parts").innerHTML = "", ge("parts").insertAdjacentHTML("afterbegin", e), !l && r && o();
    }, _getPos = function(t) {
        var n = t.getAttribute("id").match(/\d+/g)[0];
        return parseInt(n, 10);
    }, this.__init__ = function() {
        c.who = document.getElementById("gameInfo").getAttribute("data-who");
        for (i in t.objects) c[t.objects[i].toLowerCase()] = new window[t.objects[i]](), 
        window[t.objects[i]] = null;
        3 == c.who && n(), e();
        var a = window.setInterval(function() {
            c.card.pingState(a);
        }, t.settings.ping);
    };
}