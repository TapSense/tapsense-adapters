var TS_SERVER_HOST = "http://ads04.tapsense.com/ads/mopubad";
var TS_VERSION = "1.0.5";

var ts_click_tracker;
var paramMap = {};
var cookie_name = "ts-sesssion-cookie";

function addParameter(key, value) {
    if (value) {
        paramMap[key] = value;
    }
}

function getSerializedParams() {
    var str = [];
    for (var p in paramMap) {
        if (paramMap.hasOwnProperty(p)) {
            str.push(encodeURIComponent(p) + "=" + encodeURIComponent(paramMap[p]));
        }
    }
    return str.join("&");
}

function mp_fail() {
   window.location = "mopub://failLoad";
}

function ts_callback(data) {
    ufid = data.ufid;
    ts_click_url = data.click_url;
    if (data.count_ad_units == 0) {
        mp_fail();
        return;
    }
    document.write('<div id="ts-div-' + ufid + '" style="width:'+window.ts_ad_width+';height:'+window.ts_ad_height+'">');
    document.write(data.ad_units[0].html_vertical);
    document.write('</div>');

    window.webviewDidAppearHelper = function() {
        var img = document.createElement('img');
        img.src = data.ad_units[0].imp_url;
        img.width = 0;
        img.height = 0;
        img.style.display = 'none';

        var body = document.getElementsByTagName('body')[0];
        body.appendChild(img);
    }
}

function getServerUrl() {
    addParameter("ufid", generateRandomKey());
    addParameter("refer", window.location);
    addParameter("version", TS_VERSION);
    addParameter("jsonp", 1);
    addParameter("callback", "ts_callback")

    var parameters = Object.keys(window);
    for (index in parameters) {
        var ts_param = parameters[index].match(/^ts_(.*)/);
        if (ts_param) {
            var value = window[ts_param[0]];
            if (typeof value === "function") {
                continue;
            }
            addParameter(ts_param[1], value);
        }
    }
    if (window.bundle_id) {
        addParameter("bundle_id", window.bundle_id);
    }
    if (window.ts_width && window.ts_height) {
        addParameter("size", window.ts_width + "x" + window.ts_height);
    }
    if (window.ts_device_id) {
        addParameter("user", window.ts_device_id);
    } else {
        addParameter("session_id", getSession());
    }
    if (typeof mopubFinishLoad == 'function') {
        addParameter("mr", 0);
    } else {
        addParameter("mr", 1);
    }
    return TS_SERVER_HOST + "?" + getSerializedParams();
}

function generateRandomKey() {
    var possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678';
    var text = '';
    for (var i = 0; i < 20; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    text += Math.floor(Math.random() * 10e12);
    return text;
}

function setCookie(name, value, expires, path, domain, secure) {
    var cookie = name + "=" + escape(value) +
        ((expires) ? ";expires=" + expires.toGMTString() : "") +
        ((path) ? ";path=" + path : "") +
        ((domain) ? ";domain=" + domain : "") +
        ((secure) ? ";secure" : "");
    document.cookie = cookie;
}

function getCookie(name) {
    var start = document.cookie.indexOf(name + "=");
    var length = start + name.length + 1;
    if ((!start) && (name != document.cookie.substring(0, name.length))) {
        return null;
    }
    if (start == -1) {
        return null;
    }
    var end = document.cookie.indexOf(";", length);
    if (end == -1) {
        end = document.cookie.length;
    }
    return unescape(document.cookie.substring(length, end));
}

function getSession() {
    //if no session, set it
    if (!getCookie(cookie_name)) {
        setCookie(cookie_name, generateRandomKey());
    }
    return getCookie(cookie_name);
}

(function () {
    console.log('<script type="text/javascript" src="' + getServerUrl() + '"></s' + 'cript>');
    document.write('<script type="text/javascript" src="' + getServerUrl() + '"></s' + 'cript>');
})();
