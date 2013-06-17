function Global(n) {
    function e(n) {
        for (elemId in n) for (ev in n[elemId]) ge(elemId).addEventListener(ev, n[elemId][ev], !1);
    }
    function t() {
        function n() {
            function n() {
                var n = !1;
                try {
                    n = new XMLHttpRequest();
                } catch (e) {
                    return alert(e + "\nСтарый браузер, не поддерживает современный XMLHttpRequest."), 
                    void 0;
                }
                return arguments[0] === !0 ? n :(u = n, void 0);
            }
            function e(n, e, t) {
                u.open(n, e, t);
            }
            function t(n) {
                null === n || "undefined" === n ? u.send() :u.send(n);
            }
            function o(n) {
                if (null === n || "undefined" === n || "" === n) return null;
                var e = null;
                for (i in n) if ("formData" === i) {
                    var t = n[i];
                    for (i in t) if (e = t[i] instanceof FormData ? t[i] :new FormData(), "append" === i) {
                        var o = t[i];
                        for (i in o) e.append(i, o[i]);
                    }
                }
                return e;
            }
            function r(n) {
                if (null !== n && "undefined" !== n && "" !== n && n) for (i in n) u.setRequestHeader(i, n[i]);
            }
            function a(n) {
                if (n && "undefined" !== n && "" !== n) {
                    var e = /^(?:arraybuffer|blob|document|json|text)$/ig;
                    return e.test(n) ? (u.responseType = n, void 0) :!1;
                }
            }
            var f = this, u = null;
            this.xhr = function() {
                return n(!0);
            }, this.anonXhr = function() {
                var n = !1;
                try {
                    (n = new AnonXMLHttpRequest()) && (f._anonInst = n);
                } catch (e) {
                    return alert(e + "\nСоздание анонимного anonXMLHttpRequest не поддерживается этим браузером."), 
                    void 0;
                }
                return f._anonInst;
            }, this.send = function(i) {
                n();
                var f = i.url, d = i.method, l = i.async, s = o(i.data);
                i.headers;
                var c = i.onload;
                e(d, f, l), r(i.headers), a(i.responseType) !== !1 && (u.onload = function() {
                    c(u);
                }, t(s));
            }, this.setParams = function() {}, this.getParams = function() {};
        }
        return new n();
    }
    _config = n, _ajx = null, _parseServerResp = function(n) {
        var e;
        try {
            var e = JSON.parse(n);
        } catch (t) {
            var i = document.getElementsByTagName("html")[0].getAttribute("lang");
            return alert(_config.vocab[i].tooFast), !1;
        }
        return e;
    }, _getPathGameSegm = function(n) {
        return n.split("/")[1];
    }, ge = function(n) {
        return "string" == typeof n || "number" == typeof n ? document.getElementById(n) :n;
    }, forIn = function(n, e, t) {
        var i = "", t = t ? t :!1;
        if (e === !0) for (var o in n) {
            if ("object" != typeof n[o]) {
                e = !1;
                break;
            }
            i += "[" + o + "]" + " => Object:\n\n";
            for (var r in n[o]) i += "[" + r + "]" + " => " + n[o][r] + "\n";
            i += "\n";
        }
        if (!e) for (var o in n) i += o + " : " + n[o] + "\n";
        if (t) {
            var a = document.getElementById(t);
            a.style.display = "block", a.innerHTML = "<pre>" + i + "</pre>";
        } else alert(i);
    }, this.forIn_ = function() {
        forIn(obj, deep, divId);
    }, this.bind = function() {
        e(_config.elEv);
    }, _ajax = function() {
        return null === _ajx && (_ajx = t()), _ajx;
    };
}

var g = {
    onDocLoad:function() {
        if (window.gConfig) {
            var n = window.gConfig;
            window.gConfig = null;
        } else var n = {};
        if (window.pConfig) {
            var e = window.pConfig;
            window.pConfig = null;
        } else var e = {};
        var t = new window.Global(n);
        window.Page.prototype = t, window.p = new window.Page(e), window.Page = window.Global = null, 
        p.__init__();
    }
};

window.addEventListener("load", g.onDocLoad, !1);