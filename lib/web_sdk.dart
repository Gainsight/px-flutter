import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'dart:js' as js;
import 'dart:js';
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'user.dart';

class WebSDK {

  final _jsCode = 'function classNameModifier(e){const t={"<":"px_lt",">":"px_gt"," ":"px_space",".":"px_dot","#":"px_number_sign","/":"px_slash",":":"px_colon",_:"px_"};for(const[o,r]of Object.entries(t))e=e.split(o).join(r);return e}function buildNativeDom(e){if(e&&e.componentTree&&e.componentTree.length>0){e.id="px_flutter_id";JSON.stringify(e.componentTree);const t="px_root_element";let o=document.body.getElementsByTagName(t)[0];o||(o=document.createElement(t),document.body.appendChild(o)),o&&(o.style.opacity="0",o.style.position="fixed",o.style.zIndex="999999",o.style.top="0px",o.style.left="0px",o.style.display="block",createElements(e.componentTree,o,!0,e.id))}}function createElements(e,t,o,r){for(let n=0;n<e.length;n++){const i=document.createElement(classNameModifier(e[n].className)),s=e[n].id,p=e[n].itemIndex,l=e[n].sectionIndex,c=e[n].children,a=e[n].rect;if(s&&i.setAttribute("id",s),p&&i.setAttribute("itemIndex",p),l&&i.setAttribute("sectionIndex",l),i.setAttribute("px_original_name",e[n].className),a&&i.setAttribute("px_element_rect",JSON.stringify(a)),a&&(i.style.position="fixed",i.style.border="1px solid",i.style.top=Math.round(a.y)+"px",i.style.left=Math.round(a.x)+"px",i.style.width=Math.round(a.w)+"px",i.style.height=Math.round(a.h)+"px"),o&&r){const e="px_component_tree_id";i.setAttribute(e,r);let o,n=!1;for(o=t.firstChild;null!==o;o=o.nextSibling){if(o.getAttribute(e)===r){n=!0;break}}n&&o?t.replaceChild(i,o):t.appendChild(i)}else t.appendChild(i);c&&createElements(c,i,!1)}}function removeTop(){const e=document.querySelector("body"),t=document.querySelector("flt-glass-pane");t&&e&&(e.style.setProperty("padding-top","0px","important"),e.style.setProperty("margin-top","0px","important"),e.style.setProperty("top","0px","important"),t.style.setProperty("padding-top","0px","important"),t.style.setProperty("margin-top","0px","important"),t.style.setProperty("top","0px","important"))}removeTop();const removeTopObserver=new MutationObserver(function(e){e.forEach(function(e){removeTop()})});removeTopObserver.observe(document.querySelector("body"),{attributes:!0,attributeFilter:["style"]});const topBarVisibilityObserver=new MutationObserver(function(e){e.forEach(function(e){const t=e.target.className,o=document.querySelector("px_root_element");t&&t.includes("apt-show")&&flutterCreateDOMStructure(),o&&(o.style.display="none")})});topBarVisibilityObserver.observe(document.querySelector(".apt-new-event-container"),{attributes:!0,attributeFilter:["class"]});';
  static MethodChannel? _channel;
  bool _isEditorMode = false;
  final _specialChars = {
    '<': 'px_lt',
    '>': 'px_gt',
    ' ': 'px_space',
    '.': 'px_dot',
    '#': 'px_number_sign',
    '/': 'px_slash',
    ':': 'px_colon',
    '_': 'px_'
  };

  static void registerWith(Registrar registrar) {
    _channel = MethodChannel('gainsightpx',
        const StandardMethodCodec(),
        registrar);
    final WebSDK instance = WebSDK();
    _channel?.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'initialise':
        _initialise(call);
        break;
      case 'identifyWithID':
      case 'identifyWithUser':
      case 'identifyWithUserAndAccount':
        _identify(call);
        break;
      case 'trackTaps':
        _trackTaps(call);
        break;
      case 'customEvent':
      case 'customEventWithProperties':
        _customEvent(call);
        break;
      case 'screenEventWithTitle':
      case 'screenEventWithProperties':
      case 'screenEventWithTitleAndProperties':
        _screen(call);
        break;
      case 'setGlobalContext':
        _setGlobalContext(call);
        break;
      case 'removeGlobalContextKeys':
        _removeGlobalContextKeys(call);
        break;
      case 'isWebEditMode':
        return _isWebEditMode();
      case 'enterEditing':
      case 'exitEditing':
      case 'flutterViewChanged':
      case 'scrollStateChanged':
      case 'hasGlobalKey':
      case 'enable':
      case 'disable':
      case 'flush':
        _notImplementedOnWeb(call);
        break;
      default:
        _notImplementedOnWeb(call);
    }
  }

  bool _notImplementedOnWeb(MethodCall call) {
    // log('${call.method} not implemented on web');
    return false;
  }

  bool _initialise(MethodCall call) {
    /// WebSDK have to be initialised from index.html.
    /// If not mapper editor wont work as expected
    return _notImplementedOnWeb(call);
  }

  bool _screen(MethodCall call) {
    /// If we want to send page view manually we need to disable auto pageView
    /// on initialise and to add 'autoTrackPage: false'
    /// than we need to send for every screen event:
    /// js.context.callMethod('aptrinsic', ['pageView', { some value }]);
    return _notImplementedOnWeb(call);
  }

  bool _identify(MethodCall call) {
    try {
      Map<Object?, Object?>? nativeUser;
      Map<Object?, Object?>? nativeAccount;
      if (call.arguments != null && !_isEditorMode) {
        if (call.arguments.containsKey('userID')) {
          final String userID = call.arguments['userID'];
          nativeUser = User(userID).toJson();
        } else {
          if (call.arguments.containsKey('user')) {
            nativeUser = call.arguments['user'];
          }
          if (call.arguments.containsKey('account')) {
            nativeAccount = call.arguments['account'];
          }
        }
        if (nativeUser != null) {
          if (nativeUser.containsKey('customAttributes')) {
            final Map<Object?, Object?>? customAttributes = nativeUser['customAttributes'] as Map<Object?, Object?>?;
            customAttributes?.forEach((key, value) {
              nativeUser![key] = value;
            });
            nativeUser.remove('customAttributes');
          }
          final user = JsObject.jsify(nativeUser);
          user['id'] = user['ide'];
          user.deleteProperty('ide');
          JsObject account;
          if (nativeAccount != null) {
            if (nativeAccount.containsKey('customAttributes')) {
              final Map<Object?, Object?>? customAttributes = nativeAccount['customAttributes'] as Map<Object?, Object?>?;
              customAttributes?.forEach((key, value) {
                nativeAccount![key] = value;
              });
              nativeAccount.remove('customAttributes');
            }
            account = JsObject.jsify(nativeAccount);
          } else {
            account = JsObject.jsify({});
          }
          js.context.callMethod('aptrinsic', ['identify', user, account]);
          log('WebSDK handledMethodCall - ${call.method}');
          return true;
        }
      }
      return false;
    } on Exception catch(e) {
      onError(call.method, e.toString());
    }
    return false;
  }

  bool _customEvent(MethodCall call) {
    try {
      if (call.arguments != null && !_isEditorMode) {
        final event = call.arguments['event'];
        final properties = call.arguments['properties'];
        JsObject jsObject;
        if (event != null) {
          if (properties != null) {
            jsObject = JsObject.jsify(properties);
          } else {
            jsObject = JsObject.jsify({});
          }
          js.context.callMethod('aptrinsic', ['track', event, jsObject]);
          log('WebSDK handledMethodCall - ${call.method}');
          return true;
        }
      }
      return false;
    } on Exception catch(e) {
      onError(call.method, e.toString());
    }
    return false;
  }

  bool _trackTaps(MethodCall call) {
    try {
      if (call.arguments != null && !_isEditorMode) {
        final List viewElements = call.arguments['viewElements'];
        final List tmp = [];
        for (final viewElement in viewElements) {
          final String name = _classNameModifier(viewElement['className']);
          final Map element = {
            'tagName': name,
            'child_n': viewElement['childN'],
            'child_tag_n': viewElement['childClassN'],
            'attributes': viewElement['attributes']
          };
          tmp.add(element);
        }
        final webViewElements = JsObject.jsify(tmp);
        js.context.callMethod(
            'aptrinsic', ['send', 'click', webViewElements]);
        log('WebSDK handledMethodCall - ${call.method}');
        return true;
            }
      return false;
    } on Exception catch(e) {
      onError(call.method, e.toString());
    }
    return false;
  }

  String _classNameModifier(String name) {
    String modifiedName = name;
    for (final char in _specialChars.entries) {
      if (modifiedName.contains(char.key)) {
        modifiedName = modifiedName.split(char.key).join(char.value);
      }
    }
    return modifiedName;
  }

  bool _setGlobalContext(MethodCall call) {
    try {
      if (call.arguments != null && !_isEditorMode) {
        js.context.callMethod('aptrinsic', ['set', 'globalContext', JsObject.jsify(call.arguments)]);
        log('WebSDK handledMethodCall - ${call.method}');
        return true;
      }
      return false;
    } on Exception catch(e) {
      onError(call.method, e.toString());
    }
    return false;
  }

  bool _removeGlobalContextKeys(MethodCall call) {
    try {
      if (call.arguments != null && !_isEditorMode) {
        js.context.callMethod('aptrinsic', ['remove', 'globalContext', JsObject.jsify(call.arguments)]);
        log('WebSDK handledMethodCall - ${call.method}');
        return true;
      }
      return false;
    } on Exception catch(e) {
      onError(call.method, e.toString());
    }
    return false;
  }

  void _createDOMStructure() {
    try {
      if (_isEditorMode) {
        _channel?.invokeMethod('createDOMStructure').then((value) => {
          if (js.context.hasProperty('buildNativeDom')) {
            js.context.callMethod('buildNativeDom', [JsObject.jsify({'componentTree': [value]})])
          }
        });
        log('WebSDK handledMethodCall - createDOMStructure');
      }
    } on Exception catch(e) {
      onError('createDOMStructure', e.toString());
    }
  }

  void _loadDOMJS() {
    try {
      if (_isEditorMode) {
        setProperty(window, 'flutterCreateDOMStructure', allowInterop(_createDOMStructure));
        final doc = html.window.document;
        final body = doc.getElementsByTagName('body').first;
        final scriptTag = doc.createElement('script')
          ..setAttribute('type', 'text/javascript')
          ..text = _jsCode;
        body.append(scriptTag);
      }
    } on Exception catch(e) {
      onError('removeHTMLTop', e.toString());
    }
  }

  void onError(String methodName, String error) {
    log('WebSDK - $methodName failed, with error:  $error');
  }

  void log(String text){
    print('------------------------------------------------------------------');
    print(text);
    print('------------------------------------------------------------------');
  }

  bool _isWebEditMode() {
    final doc = html.window.document;
    final cookies = doc.cookie;
    final isEditorMode = cookies?.contains('apt.token=') ?? false;
    _isEditorMode = isEditorMode;
    _loadDOMJS();
    return isEditorMode;
  }
}