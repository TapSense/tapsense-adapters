var TS_SERVER_HOST = "https://ads04.tapsense.com/ads/rockyouad";
var TS_SESSION_COOKIE_NAME = "ts-sesssion-cookie";
var TS_VERSION = "1.0.15";

var paramMap = {};

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
    if(typeof noad_callback == 'function') {
         noad_callback();
    }
}

function fire_impression(imp_url) {
    var img = document.createElement('img');
    img.src = imp_url;
    img.width = 0;
    img.height = 0;
    img.style.display = 'none';

    var body = document.getElementsByTagName('body')[0];
    body.appendChild(img);
    if(typeof impression_callback == 'function') {
         impression_callback();
    }
}

function ts_callback(data) {
    ufid = data.ufid;
    ts_click_url = data.click_url;
    if (data.count_ad_units == 0) {
        mp_fail();
        return;
    }
    document.write('<div id="ts-div">');
    document.write(data.ad_units[0].html_vertical.replace('position: fixed;', 'position: absolute;'));
    document.write('</div>');

    fire_impression(data.ad_units[0].imp_url);
}

var pattern_to_ignore = ["SVG", "HTML", "CSS"];

function shouldIgnoreKey(key_name) {
    var should_ignore_key = false;
    for (index in pattern_to_ignore) {
        should_ignore_key = new RegExp('^' + pattern_to_ignore[index]).test(key_name);
        if (should_ignore_key) {
            return true;
        }
    }
    return false;
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

    if (window.lat && window.long) {
        addParameter("lat", window.lat);
        addParameter("long", window.long);
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
    if (typeof mraid !== 'undefined') {
        addParameter("mraid_versions", getMraidVersions());
    }
    return TS_SERVER_HOST + "?" + getSerializedParams();
}

function getMraidVersions() {
    var version = parseInt(mraid.getVersion());
    var versions = [];
    for (var i = version; i > 0; i--) {
        versions.push("mraid_"+i);
    }
    return versions.join(",");
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
                mp_fail();
            }
        }
    };
    xmlhttp.onerror = function() {
        mp_fail();
    };
    xmlhttp.open("GET", getServerUrl(), false);
    xmlhttp.send();

})();
