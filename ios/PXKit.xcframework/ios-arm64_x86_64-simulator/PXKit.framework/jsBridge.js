/******/ (() => { // webpackBootstrap
/******/     "use strict";
/******/     var __webpack_modules__ = ([
/* 0 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "engineStarted": () => (/* binding */ engineStarted),
/* harmony export */   "ignoreSafeAreaOffset": () => (/* binding */ ignoreSafeAreaOffset),
/* harmony export */   "sendMessage": () => (/* binding */ sendMessage),
/* harmony export */   "startEngine": () => (/* binding */ startEngine)
/* harmony export */ });
/* harmony import */ var _platformType__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(1);
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(2);
/* harmony import */ var _gainsightpx__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(3);
/* harmony import */ var _gpxinternal__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(7);




var engineStarted = false;
var ignoreSafeAreaOffset = false;
window.gainsightpx = _gainsightpx__WEBPACK_IMPORTED_MODULE_2__.GainsightPX;
window.gpxSdkToJS = _gpxinternal__WEBPACK_IMPORTED_MODULE_3__.gpxSdkToJS;
function sendMessage(body) {
    var tsWindow = window;
    if ((0,_platformType__WEBPACK_IMPORTED_MODULE_0__.getPlatformType)() === _type__WEBPACK_IMPORTED_MODULE_1__.PlatformType.ios) {
        tsWindow.webkit.messageHandlers.gpxjs.postMessage(body);
    }
    else if ((0,_platformType__WEBPACK_IMPORTED_MODULE_0__.getPlatformType)() === _type__WEBPACK_IMPORTED_MODULE_1__.PlatformType.android) {
        tsWindow.gpxjs && tsWindow.gpxjs.postMessage(JSON.stringify(body));
    }
}
function startEngine() {
    if (window !== null) {
        engineStarted = true;
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_2__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_1__.kEventType.engineState, params: { "state": true } });
        setTimeout(function () {
            var value = "env(safe-area-inset-top)";
            document.documentElement.style.setProperty("--sat", value);
            ignoreSafeAreaOffset = getComputedStyle(document.documentElement).getPropertyValue('--sat') != "0px";
        }, 2000);
    }
    else {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_2__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_1__.kEventType.engineState, params: { "state": false } });
    }
}
startEngine();


/***/ }),
/* 1 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "getPlatformType": () => (/* binding */ getPlatformType)
/* harmony export */ });
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(2);

function getPlatformType() {
    var userAgent = navigator.userAgent || navigator.vendor;
    if (/android/i.test(userAgent) && window.gpxjs) {
        return _type__WEBPACK_IMPORTED_MODULE_0__.PlatformType.android;
    }
    if (window.webkit && window.webkit.messageHandlers) {
        return _type__WEBPACK_IMPORTED_MODULE_0__.PlatformType.ios;
    }
    return _type__WEBPACK_IMPORTED_MODULE_0__.PlatformType.unknown;
}


/***/ }),
/* 2 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "kEventType": () => (/* binding */ kEventType),
/* harmony export */   "PXConnection": () => (/* binding */ PXConnection),
/* harmony export */   "PlatformType": () => (/* binding */ PlatformType),
/* harmony export */   "PayloadActionType": () => (/* binding */ PayloadActionType)
/* harmony export */ });
var kEventType;
(function (kEventType) {
    kEventType[kEventType["engineState"] = 0] = "engineState";
    kEventType[kEventType["initialize"] = 1] = "initialize";
    kEventType[kEventType["identify"] = 2] = "identify";
    kEventType[kEventType["screenEvent"] = 3] = "screenEvent";
    kEventType[kEventType["customEvent"] = 4] = "customEvent";
    kEventType[kEventType["tap"] = 5] = "tap";
    kEventType[kEventType["dom"] = 6] = "dom";
    kEventType[kEventType["log"] = 7] = "log";
    kEventType[kEventType["elementPosition"] = 8] = "elementPosition";
    kEventType[kEventType["elementAtPosition"] = 9] = "elementAtPosition";
    kEventType[kEventType["enable"] = 10] = "enable";
    kEventType[kEventType["disable"] = 11] = "disable";
    kEventType[kEventType["enterEditing"] = 12] = "enterEditing";
    kEventType[kEventType["exitEditing"] = 13] = "exitEditing";
    kEventType[kEventType["flush"] = 14] = "flush";
    kEventType[kEventType["reset"] = 15] = "reset";
    kEventType[kEventType["setGlobalContext"] = 16] = "setGlobalContext";
    kEventType[kEventType["hasGlobalContextValue"] = 17] = "hasGlobalContextValue";
    kEventType[kEventType["removeGloablContextValues"] = 18] = "removeGloablContextValues";
    kEventType[kEventType["addEngagementCallback"] = 19] = "addEngagementCallback";
    kEventType[kEventType["removeEngagementCallback"] = 20] = "removeEngagementCallback";
})(kEventType || (kEventType = {}));
var PXConnection = {
    US: 'us',
    EU: 'eu',
    CUSTOM: ''
};
var PlatformType;
(function (PlatformType) {
    PlatformType["ios"] = "APPLE_OS";
    PlatformType["android"] = "ANDROID";
    PlatformType["unknown"] = "UNKNOWN";
})(PlatformType || (PlatformType = {}));
var ResponseValue;
(function (ResponseValue) {
    ResponseValue["success"] = "true";
    ResponseValue["failure"] = "false";
})(ResponseValue || (ResponseValue = {}));
var PayloadActionType;
(function (PayloadActionType) {
    PayloadActionType["engagement_callback"] = "engagement_callback";
    PayloadActionType["error_callback"] = "error_callback";
    PayloadActionType["has_global_context_key"] = "has_global_context_key";
    PayloadActionType["update_web_view_frame"] = "update_web_view_frame";
    PayloadActionType["get_element_postion"] = "get_element_postion";
    PayloadActionType["get_element_at_postion"] = "get_element_at_postion";
    PayloadActionType["create_dom_structure"] = "create_dom_structure";
    PayloadActionType["update_configurations"] = "update_configurations";
    PayloadActionType["send_screen_event"] = "send_screen_event";
})(PayloadActionType || (PayloadActionType = {}));


/***/ }),
/* 3 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "configuration": () => (/* binding */ configuration),
/* harmony export */   "hasKeyListener": () => (/* binding */ hasKeyListener),
/* harmony export */   "errorListener": () => (/* binding */ errorListener),
/* harmony export */   "engagementListener": () => (/* binding */ engagementListener),
/* harmony export */   "GainsightPX": () => (/* binding */ GainsightPX),
/* harmony export */   "updateConfigurations": () => (/* binding */ updateConfigurations),
/* harmony export */   "callHome": () => (/* binding */ callHome),
/* harmony export */   "createEvent": () => (/* binding */ createEvent)
/* harmony export */ });
/* harmony import */ var ___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(0);
/* harmony import */ var _screenTracker__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(4);
/* harmony import */ var _tapTracker__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(5);
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(2);




var configuration;
var hasKeyListener;
var errorListener;
var engagementListener;
var GainsightPX = {
    /**
    *
    * @param config configuration to iniitlize GainsightPX
    */
    initialize: function (config) {
        try {
            if (config == null) {
                callHome(Error("PXConfiguration canot be null"));
                return;
            }
            configuration = ___WEBPACK_IMPORTED_MODULE_0__.engineStarted && config;
            configuration && createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.initialize, params: config });
            configuration.shouldTrackPages && (0,_screenTracker__WEBPACK_IMPORTED_MODULE_1__.startPageTracker)();
            configuration.shouldTrackTapEvents && (0,_tapTracker__WEBPACK_IMPORTED_MODULE_2__.startTapTracker)();
            configuration.shouldTrackPages && this.screenEvent({ screenName: window.location.href, screenClass: "", properties: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    identifyUser: function (identify) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.identify, params: identify });
        }
        catch (e) {
            callHome(e);
        }
    },
    identifyWithID: function (userId) {
        try {
            var user = { id: userId };
            this.identifyUser({ user: user, account: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    screenEventWithName: function (name) {
        try {
            if (name == null) {
                callHome(Error("ScreenName canot be null"));
                return;
            }
            GainsightPX.screenEvent({ screenName: name, screenClass: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    screenEvent: function (screenEvent) {
        try {
            var sEvent = screenEvent;
            var names = screenEvent.screenName.split('www/');
            if (names.length > 1) {
                sEvent.screenName = names[1];
            }
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.screenEvent, params: sEvent });
        }
        catch (e) {
            callHome(e);
        }
    },
    customEvent: function (customEvent) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.customEvent, params: customEvent });
        }
        catch (e) {
            callHome(e);
        }
    },
    setGlobalContext: function (context) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.setGlobalContext, params: context });
        }
        catch (e) {
            callHome(e);
        }
    },
    hasGlobalContext: function (key) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.hasGlobalContextValue, params: { "key": key } });
        }
        catch (e) {
            callHome(e);
        }
    },
    removeGlobalContextKeys: function (keys) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.removeGloablContextValues, params: { "keys": keys } });
        }
        catch (e) {
            callHome(e);
        }
    },
    hasGlobalContextKeyListener: function (callback) {
        hasKeyListener = callback;
    },
    addEngagementListener: function (callback) {
        createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.addEngagementCallback, params: null });
        engagementListener = callback;
    },
    removeEngagementListener: function () {
        createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.removeEngagementCallback, params: null });
        engagementListener = null;
    },
    errorListener: function (callback) {
        errorListener = callback;
    },
    enable: function () {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.enable, params: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    disable: function () {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.disable, params: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    enterEditingMode: function (urlString) {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.enterEditing, params: { "urlString": urlString } });
        }
        catch (e) {
            callHome(e);
        }
    },
    exitEditingMode: function () {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.exitEditing, params: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    flush: function () {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.flush, params: null });
        }
        catch (e) {
            callHome(e);
        }
    },
    reset: function () {
        try {
            createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.reset, params: null });
        }
        catch (e) {
            callHome(e);
        }
    },
};
function updateConfigurations(config) {
    if (config == null) {
        callHome(Error("PXConfiguration canot be null"));
        return;
    }
    configuration = ___WEBPACK_IMPORTED_MODULE_0__.engineStarted && config;
    configuration.shouldTrackPages && (0,_screenTracker__WEBPACK_IMPORTED_MODULE_1__.startPageTracker)();
    configuration.shouldTrackTapEvents && (0,_tapTracker__WEBPACK_IMPORTED_MODULE_2__.startTapTracker)();
    configuration.shouldTrackPages && GainsightPX.screenEvent({ screenName: window.location.href, screenClass: "", properties: null });
}
function callHome(error) {
    var log = { message: "Something went wrong" };
    if (error != null && error.message != null) {
        log.message = error.message;
    }
    createEvent({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.log, params: log });
}
function createEvent(body) {
    if (___WEBPACK_IMPORTED_MODULE_0__.engineStarted) {
        (0,___WEBPACK_IMPORTED_MODULE_0__.sendMessage)(body);
    }
    else {
        throw "Engine Not started, window does not exists";
    }
}


/***/ }),
/* 4 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "startPageTracker": () => (/* binding */ startPageTracker),
/* harmony export */   "reportScreenEvent": () => (/* binding */ reportScreenEvent)
/* harmony export */ });
/* harmony import */ var _gainsightpx__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3);

var handlepushstate;
var handlereplacestate;
var oldPushState;
var oldReplaceState;
function startPageTracker() {
    trackPages();
}
function trackPages() {
    if (_gainsightpx__WEBPACK_IMPORTED_MODULE_0__.configuration.shouldTrackPages) {
        try {
            if ("onhashchange" in window && _gainsightpx__WEBPACK_IMPORTED_MODULE_0__.configuration.autoTrackHash === true) {
                window.addEventListener('hashchange', reportScreenEvent);
            }
            window.addEventListener('popstate', reportScreenEvent);
            if (history && history.pushState) {
                handlepushstate = handlePushState.bind(this);
                oldPushState = history.pushState;
                history.pushState = handlePushState;
            }
            if (history && history.replaceState) {
                handlereplacestate = handleReplaceState.bind(this);
                oldReplaceState = history.replaceState;
                history.replaceState = handleReplaceState;
            }
        }
        catch (e) {
            if (e instanceof TypeError && e.message && e.message.indexOf("read only property") >= 0) {
                (function () {
                    var currentHref = window.location.href;
                    var pageViewInterval = setInterval(function () {
                        try {
                            if (_gainsightpx__WEBPACK_IMPORTED_MODULE_0__.configuration.shouldTrackPages) {
                                if (window.location.href !== currentHref) {
                                    currentHref = window.location.href;
                                    reportScreenEvent();
                                }
                            }
                        }
                        catch (e) {
                            clearInterval(pageViewInterval);
                        }
                    }, 1000);
                })();
            }
            else {
                throw e;
            }
        }
    }
}
function handlePushState() {
    handleStateChange(arguments, oldPushState, false);
}
function handleReplaceState() {
    handleStateChange(arguments, oldReplaceState, true);
}
function handleStateChange(handlerArguments, oldHandler, ignoreStateOnlyChanges) {
    try {
        if (!(_gainsightpx__WEBPACK_IMPORTED_MODULE_0__.configuration.enabled && _gainsightpx__WEBPACK_IMPORTED_MODULE_0__.configuration.shouldTrackPages)) {
            return;
        }
        var currentHref = window.location.href;
        oldHandler.apply(history, handlerArguments);
        if (ignoreStateOnlyChanges && handlerArguments.length >= 3) {
            // Check to see if we have moved to a new page
            var tempLink = document.createElement('a');
            tempLink.href = handlerArguments[2];
            if (tempLink.href === currentHref) {
                return;
            }
        }
        try {
            reportScreenEvent();
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_0__.callHome)(e);
        }
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_0__.callHome)(e);
    }
}
var debounce = function (func, wait) {
    var timeout;
    // This is the function that is returned and will be executed many times
    // We spread (...args) to capture any number of parameters we want to pass
    return function executedFunction() {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        // The callback function to be executed after
        // the debounce time has elapsed
        var later = function () {
            // null timeout to indicate the debounce ended
            timeout = null;
            // Execute the callback
            func.apply(void 0, args);
        };
        // This will reset the waiting every function execution.
        // This is the step that prevents the function from
        // being executed because it will never reach the
        // inside of the previous setTimeout
        clearTimeout(timeout);
        // Restart the debounce waiting period.
        // setTimeout returns a truthy value (it differs in web vs Node)
        timeout = setTimeout(later, wait);
    };
};
var reportScreenEvent = debounce(function () {
    _gainsightpx__WEBPACK_IMPORTED_MODULE_0__.GainsightPX.screenEvent({ screenName: window.location.href, screenClass: '', properties: null });
}, 3);


/***/ }),
/* 5 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "startTapTracker": () => (/* binding */ startTapTracker),
/* harmony export */   "getTapEventForElement": () => (/* binding */ getTapEventForElement)
/* harmony export */ });
/* harmony import */ var _editor__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(6);
/* harmony import */ var _gainsightpx__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(3);
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(2);



function startTapTracker() {
    window.addEventListener('touchend', trackClicks);
}
function trackClicks(event) {
    try {
        var element = event.target;
        var tapEvent = getTapEventForElement(element);
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_2__.kEventType.tap, params: tapEvent });
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
    }
}
function getTapEventForElement(htmlElement) {
    try {
        var element = htmlElement;
        var elements = [];
        while (element) {
            var className = element.nodeName.toLowerCase();
            var childN = 1;
            var childClassN = 1;
            var tmpEl = element;
            while ((tmpEl = tmpEl.previousElementSibling) != null) {
                childN++;
                if (tmpEl.nodeName === element.nodeName) {
                    childClassN++;
                }
            }
            var pxElement = { className: (0,_editor__WEBPACK_IMPORTED_MODULE_0__.modifyClassName)(className), childN: childN, childClassN: childClassN, attributes: {} };
            if (element.id) {
                pxElement.attributes.id = element.id;
                pxElement.attributes.accessibilityID = element.id;
            }
            var parent_1 = element.parentNode;
            if (parent_1) {
                pxElement.attributes.superClass = (0,_editor__WEBPACK_IMPORTED_MODULE_0__.modifyClassName)(parent_1.nodeName.toLowerCase());
            }
            elements.push(pxElement);
            element = element.parentElement;
        }
        elements = elements.reverse();
        var tapEvent = { viewElements: elements, points: 1 };
        return tapEvent;
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        return null;
    }
}


/***/ }),
/* 6 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "modifyClassName": () => (/* binding */ modifyClassName),
/* harmony export */   "updateWebViewRelativeFrame": () => (/* binding */ updateWebViewRelativeFrame),
/* harmony export */   "createDOM": () => (/* binding */ createDOM),
/* harmony export */   "elementAtPosition": () => (/* binding */ elementAtPosition),
/* harmony export */   "elementPosition": () => (/* binding */ elementPosition)
/* harmony export */ });
/* harmony import */ var ___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(0);
/* harmony import */ var _gainsightpx__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(3);
/* harmony import */ var _platformType__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(1);
/* harmony import */ var _tapTracker__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(5);
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(2);





var pxLayout;
/*
On server Mobile web html tree from SDK gets added under default html body for feature mapping.
HTML under HTML doesn't work to find an element. So encoding names of `html` and `body` when sending and decoding when returned
*/
function modifyClassName(name) {
    switch (name) {
        case 'html': return 'px_js_html';
        case 'body': return 'px_js_body';
        case 'px_js_html': return 'html';
        case 'px_js_body': return 'body';
        default: return name;
    }
}
/*
Specific to iOS because the location from iOS is w.r.t global screen.
layout.frame - frame of webview on screen
layout.safeArea - safeAreaInsets for devices with notch
*/
function updateWebViewRelativeFrame(layout) {
    if (layout == null) {
        return;
    }
    pxLayout = layout;
}
function createDOM() {
    try {
        var root = document.documentElement;
        var domElement = domForRoot(root);
        var wrapper = { className: "gs_px_wrapper", children: [domElement] };
        var dom = { componentTree: [wrapper], id: "mobileWeb" };
        return dom;
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
    }
}
/*
returns element hierarchy of an element at location
for iOS we offset location.x with frame.x and safeArea.top to get actual point on webview to get element.
*/
function elementAtPosition(location) {
    try {
        var newLocation = location;
        var offset = getLayoutOffset(false);
        var relativeLocation = { x: newLocation.x - offset.x, y: newLocation.y - offset.y };
        var element = document.elementFromPoint(relativeLocation.x, relativeLocation.y);
        var htmlElement = element;
        var rect = element.getBoundingClientRect();
        var pxRect = { x: rect.x, y: rect.y, width: rect.width, height: rect.height };
        pxRect.y += offset.y;
        pxRect.x += offset.x;
        var tapEvent = (0,_tapTracker__WEBPACK_IMPORTED_MODULE_3__.getTapEventForElement)(htmlElement);
        var tree = { rect: pxRect, viewElements: tapEvent.viewElements, points: tapEvent.points };
        return tree;
    }
    catch (error) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(error);
        return null;
    }
}
/*
returns offset values for x and y, to get actual point on webview
*/
function getLayoutOffset(shouldIgnoreSafeArea) {
    var location = { x: 0, y: 0 };
    //the location will be w.r.t complete screen bounds without safe area offsets.
    //but the webview will have offsets, which could be from safeArea or may have custom frame on a screen.
    //for example we want to get an element at a point (13, 51), 51 here is (47(safeare.top) + (3)x).
    //In webview that same element actual position will be (13, 3)
    //so removing offset when asking webview for element and again adding back the offset when sending to iOS SDK.
    if (pxLayout != null && pxLayout.frame != null) {
        //shouldIgnoreSafeArea will be true only when Android DOM is created
        if (shouldIgnoreSafeArea && pxLayout.safeArea != null) {
            var offX = Math.max(pxLayout.frame.x - pxLayout.safeArea.left, 0);
            var offY = Math.max(pxLayout.frame.y - pxLayout.safeArea.top, 0);
            location.x = offX;
            location.y = offY;
        }
        else {
            location.x = pxLayout.frame.x;
            location.y = pxLayout.frame.y;
        }
        //ignoreSafeAreaOffset: For some projects safe-area-inset-top, which is added to document.documentElement in index.ts file, is 0px and some give 47px.
        //For the projects with 47px, we don't need to offset pxLayout.safeArea as the elements are w.r.t safaArea.
        if (!___WEBPACK_IMPORTED_MODULE_0__.ignoreSafeAreaOffset && !shouldIgnoreSafeArea && pxLayout.safeArea != null) {
            if (pxLayout.frame.x < pxLayout.safeArea.left) {
                location.x = pxLayout.safeArea.left;
            }
            if (pxLayout.frame.y < pxLayout.safeArea.top) { //when y=0 and top is 47(or any number), which should be added if ignoreSafeAreaOffset is false
                location.y = pxLayout.safeArea.top;
            }
        }
    }
    return location;
}
function elementPosition(elements) {
    try {
        var selector = getSelectorFromElements(elements);
        if (selector == null) {
            return null;
        }
        var element = getElementForSelector(selector);
        if (element == null) {
            return null;
        }
        var rect = element.getBoundingClientRect();
        var pxRect = { x: rect.x, y: rect.y, width: rect.width, height: rect.height };
        var offset = getLayoutOffset(false);
        pxRect.y += offset.y;
        pxRect.x += offset.x;
        return pxRect;
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        return null;
    }
}
function domForRoot(root) {
    try {
        var className = modifyClassName(root.nodeName.toLowerCase());
        var rect = root.getBoundingClientRect();
        var pxRect = { x: rect.x, y: rect.y, w: rect.width, h: rect.height };
        var offset = getLayoutOffset((0,_platformType__WEBPACK_IMPORTED_MODULE_2__.getPlatformType)() == _type__WEBPACK_IMPORTED_MODULE_4__.PlatformType.android);
        pxRect.y += offset.y;
        pxRect.x += offset.x;
        var domElement = { className: className, rect: pxRect };
        var style = window.getComputedStyle(root);
        var styleJSON = { "visibility": style.visibility, "display": style.display, "zIndex": style.zIndex };
        domElement.htmlStyleProps = JSON.stringify(styleJSON);
        if (root.id) {
            domElement.id = root.id;
            domElement.accessibilityID = root.id;
        }
        if (root.childElementCount > 0) {
            var arr = [].slice.call(root.children);
            domElement.children = arr.map(function (element) { return domForRoot(element); }).filter(function (element) { return element != null; });
        }
        return domElement;
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        return null;
    }
}
function getSelectorFromElements(elements) {
    try {
        var selectorArray_1 = [];
        elements.forEach(function (element) {
            if (element.className != "gs_px_wrapper") {
                var modifiedClassName = modifyClassName(element.className);
                var selector_1 = modifiedClassName;
                if (element.attributes) {
                    if (element.attributes.id) {
                        selector_1 = "[id='" + element.attributes.id + "']";
                    }
                }
                //In iOS html:nth-child(1) isn't working. so have to skip appending nth child index
                if (modifiedClassName == 'html' || element.childN == null) {
                    selector_1 === modifiedClassName && selector_1;
                }
                else {
                    selector_1 === modifiedClassName && (selector_1 += ":nth-child(" + element.childN + ")");
                }
                selectorArray_1.push(selector_1);
            }
        });
        var selector = selectorArray_1.join(' > ');
        return selector;
    }
    catch (e) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        return null;
    }
}
function getElementForSelector(selector) {
    try {
        var element = document.querySelector(selector);
        return element;
    }
    catch (error) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(error);
        return null;
    }
}


/***/ }),
/* 7 */
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "gpxSdkToJS": () => (/* binding */ gpxSdkToJS)
/* harmony export */ });
/* harmony import */ var _editor__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(6);
/* harmony import */ var _gainsightpx__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(3);
/* harmony import */ var _screenTracker__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(4);
/* harmony import */ var _type__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(2);




// SDK to Native
function gpxSdkToJS(payload) {
    switch (payload.action) {
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.create_dom_structure:
            GPXSDKTOJS.createDOMStructure();
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.get_element_at_postion:
            GPXSDKTOJS.getElementAtPosition(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.get_element_postion:
            GPXSDKTOJS.getElementPosition(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.update_web_view_frame:
            GPXSDKTOJS.updateWebViewRelativePosition(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.has_global_context_key:
            GPXSDKTOJS.hasGlobalContextKey(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.engagement_callback:
            GPXSDKTOJS.engagementCallback(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.error_callback:
            GPXSDKTOJS.errorCallback(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.update_configurations:
            GPXSDKTOJS.updateConfig(payload.params);
            break;
        case _type__WEBPACK_IMPORTED_MODULE_3__.PayloadActionType.send_screen_event:
            GPXSDKTOJS.sendScreenEvent();
            break;
    }
}
var GPXSDKTOJS = {
    updateWebViewRelativePosition: function (layout) {
        (0,_editor__WEBPACK_IMPORTED_MODULE_0__.updateWebViewRelativeFrame)(layout);
    },
    createDOMStructure: function () {
        try {
            var dom = (0,_editor__WEBPACK_IMPORTED_MODULE_0__.createDOM)();
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.dom, params: dom });
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    getElementAtPosition: function (location) {
        if (location == null)
            return;
        try {
            var element = (0,_editor__WEBPACK_IMPORTED_MODULE_0__.elementAtPosition)(location);
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.elementAtPosition, params: element });
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    getElementPosition: function (tree) {
        if (tree == null)
            return;
        try {
            var position = (0,_editor__WEBPACK_IMPORTED_MODULE_0__.elementPosition)(tree.viewElements);
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.createEvent)({ type: _type__WEBPACK_IMPORTED_MODULE_3__.kEventType.elementPosition, params: position });
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    hasGlobalContextKey: function (hasKey) {
        if (hasKey == null)
            return;
        try {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.hasKeyListener)(hasKey.key, hasKey.isExists);
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    engagementCallback: function (callback) {
        if (callback == null)
            return;
        try {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.engagementListener)(callback);
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    errorCallback: function (callback) {
        if (callback == null)
            return;
        try {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.errorListener)(callback);
        }
        catch (e) {
            (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.callHome)(e);
        }
    },
    updateConfig: function (config) {
        (0,_gainsightpx__WEBPACK_IMPORTED_MODULE_1__.updateConfigurations)(config);
    },
    sendScreenEvent: function () {
        (0,_screenTracker__WEBPACK_IMPORTED_MODULE_2__.reportScreenEvent)();
    }
};


/***/ })
/******/     ]);
/************************************************************************/
/******/     // The module cache
/******/     var __webpack_module_cache__ = {};
/******/
/******/     // The require function
/******/     function __webpack_require__(moduleId) {
/******/         // Check if module is in cache
/******/         var cachedModule = __webpack_module_cache__[moduleId];
/******/         if (cachedModule !== undefined) {
/******/             return cachedModule.exports;
/******/         }
/******/         // Create a new module (and put it into the cache)
/******/         var module = __webpack_module_cache__[moduleId] = {
/******/             // no module.id needed
/******/             // no module.loaded needed
/******/             exports: {}
/******/         };
/******/
/******/         // Execute the module function
/******/         __webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/
/******/         // Return the exports of the module
/******/         return module.exports;
/******/     }
/******/
/************************************************************************/
/******/     /* webpack/runtime/define property getters */
/******/     (() => {
/******/         // define getter functions for harmony exports
/******/         __webpack_require__.d = (exports, definition) => {
/******/             for(var key in definition) {
/******/                 if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/                     Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/                 }
/******/             }
/******/         };
/******/     })();
/******/
/******/     /* webpack/runtime/hasOwnProperty shorthand */
/******/     (() => {
/******/         __webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/     })();
/******/
/******/     /* webpack/runtime/make namespace object */
/******/     (() => {
/******/         // define __esModule on exports
/******/         __webpack_require__.r = (exports) => {
/******/             if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/                 Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/             }
/******/             Object.defineProperty(exports, '__esModule', { value: true });
/******/         };
/******/     })();
/******/
/************************************************************************/
/******/
/******/     // startup
/******/     // Load entry module and return exports
/******/     // This entry module is referenced by other modules so it can't be inlined
/******/     var __webpack_exports__ = __webpack_require__(0);
/******/
/******/ })()
;
