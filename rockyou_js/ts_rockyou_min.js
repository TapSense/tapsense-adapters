function addParameter(e,t){t&&(paramMap[e]=t)}function getSerializedParams(){var e=[];for(var t in paramMap)paramMap.hasOwnProperty(t)&&e.push(encodeURIComponent(t)+"="+encodeURIComponent(paramMap[t]));return e.join("&")}function mp_fail(){"function"==typeof noad_callback&&noad_callback()}function fire_impression(e){var t=document.createElement("img");t.src=e,t.width=0,t.height=0,t.style.display="none";var n=document.getElementsByTagName("body")[0];n.appendChild(t),"function"==typeof impression_callback&&impression_callback()}function ts_callback(e){return ufid=e.ufid,ts_click_url=e.click_url,0==e.count_ad_units?void mp_fail():(document.write('<div id="ts-div-'+ufid+'" style="width:'+window.ts_ad_width+";height:"+window.ts_ad_height+'">'),document.write(e.ad_units[0].html_vertical),document.write("</div>"),void fire_impression(e.ad_units[0].imp_url))}function shouldIgnoreKey(e){var t=!1;for(index in pattern_to_ignore)if(t=new RegExp("^"+pattern_to_ignore[index]).test(e))return!0;return!1}function getServerUrl(){addParameter("ufid",generateRandomKey()),addParameter("refer",window.location),addParameter("version",TS_VERSION),addParameter("jsonp",1),addParameter("callback","ts_callback");var e=Object.keys(window);for(index in e){var t=e[index].match(/^ts_(.*)/);if(t){var n=window[t[0]];if("function"==typeof n)continue;addParameter(t[1],n)}}return window.lat&&window["long"]&&(addParameter("lat",window.lat),addParameter("long",window["long"])),window.bundle_id&&addParameter("bundle_id",window.bundle_id),window.ts_width&&window.ts_height&&addParameter("size",window.ts_width+"x"+window.ts_height),window.ts_device_id?addParameter("user",window.ts_device_id):addParameter("session_id",getSession()),"function"==typeof mopubFinishLoad?addParameter("mr",0):addParameter("mr",1),"undefined"!=typeof mraid&&addParameter("mraid_versions",getMraidVersions()),TS_SERVER_HOST+"?"+getSerializedParams()}function getMraidVersions(){for(var e=parseInt(mraid.getVersion()),t=[],n=e;n>0;n--)t.push("mraid_"+n);return t.join(",")}function generateRandomKey(){for(var e="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678",t="",n=0;20>n;n++)t+=e.charAt(Math.floor(Math.random()*e.length));return t+=Math.floor(1e13*Math.random())}function setCookie(e,t,n,a,i,r){var o=e+"="+escape(t)+(n?";expires="+n.toUTCString():"")+(a?";path="+a:"")+(i?";domain="+i:"")+(r?";secure":"");document.cookie=o}function getCookie(e){var t=document.cookie.indexOf(e+"="),n=t+e.length+1;if(!t&&e!=document.cookie.substring(0,e.length))return null;if(-1==t)return null;var a=document.cookie.indexOf(";",n);return-1==a&&(a=document.cookie.length),unescape(document.cookie.substring(n,a))}function getSession(){return getCookie(TS_SESSION_COOKIE_NAME)||setCookie(TS_SESSION_COOKIE_NAME,generateRandomKey()),getCookie(TS_SESSION_COOKIE_NAME)}function ts_getXMLHttpRequest(){return window.XMLHttpRequest?new XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP")}function ts_isResponseValid(e){var t=/ts_callback\((.*)\);/,n=e.match(t);return n&&2===n.length&&n[0]&&n[1]}var TS_SERVER_HOST="http://ads04.tapsense.com/ads/rockyouad",TS_SESSION_COOKIE_NAME="ts-sesssion-cookie",TS_VERSION="1.0.13",paramMap={},pattern_to_ignore=["SVG","HTML","CSS"];!function(){var xmlhttp=ts_getXMLHttpRequest();xmlhttp.onreadystatechange=function(){xmlhttp.readyState==XMLHttpRequest.DONE&&(200==xmlhttp.status&&ts_isResponseValid(xmlhttp.responseText)?eval(xmlhttp.responseText):mp_fail())},xmlhttp.onerror=function(){mp_fail()},xmlhttp.open("GET",getServerUrl(),!1),xmlhttp.send()}();