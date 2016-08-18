var TS_SERVER_HOST = "//ads04.tapsense.com/ads/mopubad";
var TS_SESSION_COOKIE_NAME = "ts-sesssion-cookie";
var TS_VERSION = "0.0.2";

var paramMap = {};

function addParameter(key, value) {
    if (key && value) {
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

function isBanner(width, height) {
    return width === 320 && height === 50;
}

function dfp_fail() {
    document.write('<sc'+'ript src="https://www.googletagservices.com/tag/js/gpt.js">googletag.pubads().definePassback("/180049092/passback_tapsense", [[300, 250], [320, 50]]).display();</scr'+'ipt>');
}

function fire_url(url) {
    var img = new Image(1,1);
    img.onload = img.onerror = function() {};
    img.src = url;
}

function ts_callback(data) {
    if (data.count_ad_units == 0) {
        dfp_fail();
        return;
    }
    document.write('<div id="ts-div" style="width:'+data.width+'px;height:'+data.height+'px;">');
    document.write(data.ad_units[0].html);
    document.write('</div>');

    if (!dfp_preview_mode) {
        if (!isBanner(data.width, data.height)) {
            fire_url(data.ad_units[0].imp_url);
        }
        fire_url(dfp_impression_url);
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
    if (window.ts_device_id) {
        addParameter("user", window.ts_device_id);
    } else {
        addParameter("session_id", getSession());
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
        ((expires) ? ";expires=" + expires.toUTCString() : "") +
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
    if (!getCookie(TS_SESSION_COOKIE_NAME)) {
        setCookie(TS_SESSION_COOKIE_NAME, generateRandomKey());
    }
    return getCookie(TS_SESSION_COOKIE_NAME);
}

function ts_getXMLHttpRequest() {
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        return new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        return new ActiveXObject("Microsoft.XMLHTTP");
    }
}

function ts_isResponseValid(responseText) {
    var regex = /ts_callback\((.*)\);/;
    var resultArray = responseText.match(regex);
    return resultArray 
        && resultArray.length === 2 
        && resultArray[0] 
        && resultArray[1];
}

(function () {
    var xmlhttp = ts_getXMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {
            if (xmlhttp.status == 200 && ts_isResponseValid(xmlhttp.responseText)) {
                eval(xmlhttp.responseText);
            } else {
                dfp_fail();
            }
        }
    };
    xmlhttp.onerror = function() {
        dfp_fail();
    };
    xmlhttp.open("GET", getServerUrl(), true);
    xmlhttp.send();
})();
