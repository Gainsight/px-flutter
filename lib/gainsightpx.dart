import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'account.dart';
import 'configuration.dart';
import 'engagement_meta_data.dart';
import 'screen_event.dart';
import 'user.dart';

typedef EngagementCompletion = bool Function(EngagementMetaData);

class GainsightPX {
  GainsightPX._privateConstructor() {
    _channel.setMethodCallHandler(_editorMapperHandler);
  }

  final MethodChannel _channel = const MethodChannel('gainsightpx');

  var _initialized = false;
  static bool get isInitialized {
    return GainsightPX.instance._initialized;
  }

  static final GainsightPX instance = GainsightPX._privateConstructor();

  bool _shouldTrackTapEvents = false;
  EngagementCompletion? _engagementCallback;

  /// Initialise the GainsightPX with [Configurations] and [EngagementCompletion].
  /// [EngagementCompletion] is a optional value which is triggerd when an action performed in the Engagement
  ///
  /// [EngagementMetaData] contains information related to engagement, by default return type is true
  /// ```dart
  ///GainsightPX.instance.initialise(Configurations('<apikey>'), (metadata) {
  ///    print(metadata);
  ///    return true;
  ///  });
  /// ```
  Future<dynamic> initialise(Configurations configurations,
      EngagementCompletion? engagementCallback) async {
    try {
      _shouldTrackTapEvents = configurations.shouldTrackTapEvents;
      _engagementCallback = engagementCallback;
      final Map<String, dynamic> arguments = configurations.toJson();
      if (_engagementCallback != null) {
        arguments['engagementCallback'] = true;
      }
      _initialized = true;
      return await _channel.invokeMethod('initialise', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Identify

  Future<dynamic> identify(String userID) async {
    try {
      final Map<String, dynamic> arguments = {'userID': userID};
      return await _channel.invokeMethod('identifyWithID', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> identifyUser(User user, [Account? account]) async {
    var functionName = 'identifyWithUser';
    try {
      final Map<String, dynamic> arguments = {'user': user.toJson()};
      if (account != null) {
        arguments['account'] = account.toJson();
        functionName = 'identifyWithUserAndAccount';
      }
      return await _channel.invokeMethod(functionName, arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Custom Event

  Future<dynamic> customEvent(String event, [dynamic properties]) async {
    var functionName = 'customEvent';
    try {
      final Map<String, dynamic> arguments = {
        'event': event,
      };
      if (properties != null) {
        arguments['properties'] = properties;
        functionName = 'customEventWithProperties';
      }
      return await _channel.invokeMethod(functionName, arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Screen Event

  Future<dynamic> screenEvent(String title, [dynamic properties]) async {
    var functionName = 'screenEventWithTitle';
    try {
      final Map<String, dynamic> arguments = {
        'screenName': title,
      };
      if (properties != null) {
        arguments['properties'] = properties;
        functionName = 'screenEventWithTitleAndProperties';
      }
      return await _channel.invokeMethod(functionName, arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> screen(ScreenEvent screenEvent, [dynamic properties]) async {
    try {
      final Map<String, dynamic> arguments = {
        'screenName': screenEvent.screenName,
      };
      if (screenEvent.screenClass != null) {
        arguments['screenClass'] = screenEvent.screenClass;
      }
      if (properties != null) {
        arguments['properties'] = properties;
      }
      return await _channel.invokeMethod(
          'screenEventWithProperties', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Global Context

  Future<dynamic> setGlobalContext(Map<String, dynamic>? params) async {
    try {
      final Map<String, dynamic> arguments = {
        'params': params,
      };
      return await _channel.invokeMethod('setGlobalContext', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> hasGlobalKey(String key) async {
    try {
      final Map<String, dynamic> arguments = {
        'key': key,
      };
      return await _channel.invokeMethod('hasGlobalKey', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> removeGlobalContextKeys(List<String> keys) async {
    try {
      final Map<String, dynamic> arguments = {
        'keys': keys,
      };
      return await _channel.invokeMethod('removeGlobalContextKeys', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> enable() async {
    try {
      return await _channel.invokeMethod('enable');
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> disable() async {
    try {
      return await _channel.invokeMethod('disable');
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> flush() async {
    try {
      return await _channel.invokeMethod('flush');
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> reset() async {
    try {
      return _channel.invokeMethod('reset');
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> hardReset() async {
    try {
      return _channel.invokeMethod('hardReset');
    } on PlatformException catch (e) {
      return e;
    }
  }

  // ignore: avoid_positional_boolean_parameters
  Future<dynamic> enableEngagements(bool enable) async {
    try {
      final Map<String, dynamic> arguments = {
        'enable': enable,
      };
      return await _channel.invokeMethod('enableEngagements', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> enterEditing(String url) async {
    try {
      final Map<String, dynamic> arguments = {
        'url': url,
      };
      return await _channel.invokeMethod('enterEditing', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> exitEditing() async {
    try {
      return await _channel.invokeMethod('exitEditing');
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Private Methods

  Future<dynamic> _taps(String? tappedViewClass, List? viewElements,
      [Map? frame]) async {
    try {
      final Map<String, dynamic> arguments = {
        'tappedView': tappedViewClass,
        'viewElements': viewElements,
        'points': 1,
        'rect': frame,
      };
      return await _channel.invokeMethod('trackTaps', arguments);
    } on PlatformException catch (e) {
      return e;
    }
  }

  // Mapper
  Future<dynamic> _editorMapperHandler(MethodCall methodCall) async {
    try {
      switch (methodCall.method) {
        case 'getViewPosition':
          return _getViewPosition(methodCall.arguments);
        case 'getViewAtPosition':
          return _getViewAtPosition(methodCall.arguments);
        case 'createDOMStructure':
          return _createDOMStructure();
        case 'onEngagementCallback':
          return _onEngagementCallback(methodCall.arguments);
        default:
          throw MissingPluginException('NotImplemented');
      }
    } on Exception {
      //TODO: any another exception that can be sent
      rethrow;
    }
  }

  void _onEngagementCallback(dynamic arguments) {
    try {
      if (arguments != null &&
          GainsightPX.instance._engagementCallback != null) {
        final EngagementMetaData engagementMetaData = EngagementMetaData(
            arguments['engagementId'],
            arguments['engagementName'],
            arguments['scope'],
            arguments['params'],
            arguments['actionText'],
            arguments['actionData'],
            arguments['actionType']);
        _engagementCallback!(engagementMetaData);
      }
    } on Exception {
      rethrow;
    }
  }

  Matrix4 getTransformMatrix() {
//    return RendererBinding.instance!.createViewConfiguration().toMatrix();
    return RendererBinding.instance.renderViews.first.configuration.toMatrix();
  }

  List _getViewPosition(dynamic arguments) {
    final List viewElements = List.from(arguments['viewElements']);
    if (viewElements[0][_TouchInterceptorKeys.className] ==
        'flutterPXWrapper') {
      viewElements.removeAt(0);
    }
    final touchInterpreter = _TouchInterpreter.instance;
    var rect = touchInterpreter.rectForViewElementTree(viewElements);
    if (arguments['global'] != null) {
      final Matrix4 transform = getTransformMatrix();
      rect = _transformToGlobalRect(transform, rect!);
    }
    return [rect];
  }

  Map _getViewAtPosition(dynamic arguments) {
    try {
      final double dx = arguments['x'];
      final double dy = arguments['y'];
      var offset = Offset(dx, dy);
      final touchInterpreter = _TouchInterpreter.instance;
      final Matrix4 transform = getTransformMatrix();
      if (arguments['global'] != null) {
        offset = _transformToLocalPoint(transform, offset);
      }
      final view = touchInterpreter.viewAt(offset);
      if (arguments['global'] != null) {
        view[_TouchInterceptorKeys.rect] =
            _transformToGlobalRect(transform, view[_TouchInterceptorKeys.rect]);
      }
      return view;
    } on Exception {
      rethrow;
    }
  }

  Map _createDOMStructure() {
    try {
      final Map<dynamic, dynamic> tree = _TouchInterpreter.instance.createDom();
      return tree;
    } on Exception {
      rethrow;
    }
  }

  Offset _transformToLocalPoint(Matrix4 transform, Offset offset) {
    transform.invert();
    final tempOffset = MatrixUtils.transformPoint(transform, offset);
    // keeping the transform matrix aligned
    transform.invert();
    return tempOffset;
  }

  Map _transformToGlobalRect(Matrix4 transform, Map frame) {
    var rect = Rect.fromLTWH(
        frame[_TouchInterceptorKeys.X],
        frame[_TouchInterceptorKeys.Y],
        frame[_TouchInterceptorKeys.width],
        frame[_TouchInterceptorKeys.height]);
    rect = MatrixUtils.transformRect(transform, rect);
    return {
      _TouchInterceptorKeys.X: rect.left.isNaN ? 0 : rect.left,
      _TouchInterceptorKeys.Y: rect.top.isNaN ? 0 : rect.top,
      _TouchInterceptorKeys.width: rect.width,
      _TouchInterceptorKeys.height: rect.height,
    };
  }
}

class _TouchInterceptorKeys {
  static const viewElements = 'viewElements';
  static const points = 'points';
  static const rect = 'rect';
  static const X = 'x';
  static const Y = 'y';
  static const w = 'w';
  static const h = 'h';
  static const width = 'width';
  static const height = 'height';
  static const renderViewClass = 'renderViewClass';
  static const className = 'className';
  static const childN = 'childN';
  static const childClassN = 'childClassN';
  static const itemIndex = 'itemIndex';
  static const attributes = 'attributes';
  static const children = 'children';
  static const params = 'params';
  static const id = 'id';
}

class _TouchInterpreter {
  _TouchInterpreter._privateConstructor();

  static final _TouchInterpreter instance =
      _TouchInterpreter._privateConstructor();

  late BuildContext globalContext;

  //Current Position
  Offset? _currentPosition;

  //Current Entries from hit-test
  Iterator<HitTestEntry>? _currentEntries;

  //keysArray for the widget of the current screen
  //(key: renderObject.hashCode, value: widget.key)
  Map? _keysArray;

  Map viewAt(Offset position) {
    try {
      _performHitTest(position);
      final Map elementTree = _generateElementTree();
      final List? viewElements =
          elementTree[_TouchInterceptorKeys.viewElements];
      final Map? rect = elementTree[_TouchInterceptorKeys.rect];
      final String? viewClass =
          elementTree[_TouchInterceptorKeys.renderViewClass];
      return {
        _TouchInterceptorKeys.viewElements: viewElements,
        _TouchInterceptorKeys.points: 1,
        _TouchInterceptorKeys.rect: rect,
        _TouchInterceptorKeys.className: viewClass
      };
    } on Exception {
      rethrow;
    }
  }

  /// In progress
  Map? rectForViewElementTree(List tree) {
    return _getDisplayRect(tree);
  }

  void _setKeysArray() {
    _keysArray = {};
    void visit(Element element) {
      final widget = element.widget;
      final renderObject = element.renderObject;
      if (widget.key != null && widget.key is ValueKey) {
        String keyString = widget.key.toString();
        keyString = keyString.replaceAll(RegExp(r'[^\s\w]'), '');
        if (!keyString.startsWith('_')) {
          _keysArray?[renderObject.hashCode] = keyString;
        }
      }
      final List<Element> children = [];
      element.visitChildren(children.add);
      for (final Element child in children) {
        visit(child);
      }
    }

    globalContext.visitChildElements(visit);
  }

  Map<String, dynamic> createDom() {
    double rootContainerHeight = 0;
    double rootContainerWidth = 0;
    Map<String, dynamic>? visit(RenderObject? root) {
      final Map<String, dynamic> tree = {
        _TouchInterceptorKeys.className: root.runtimeType.toString()
      };
      if (root is RenderIndexedSemantics) {
        tree[_TouchInterceptorKeys.itemIndex] = root.index + 1;
      }
      if (root is RenderBox) {
        final Offset offset = root.localToGlobal(const Offset(0, 0));
        if (rootContainerHeight == 0 || rootContainerWidth == 0) {
          rootContainerHeight = root.size.height;
          rootContainerWidth = root.size.width;
        }
        if (offset.dx + root.size.width < 0 ||
            offset.dy + root.size.height < 0 ||
            offset.dx > rootContainerWidth ||
            offset.dy > rootContainerHeight) {
          // Not in frame.
          tree[_TouchInterceptorKeys.className] = 'px_not_in_frame';
        }
        final Map viewFrame = {
          _TouchInterceptorKeys.w: root.size.width,
          _TouchInterceptorKeys.h: root.size.height,
          _TouchInterceptorKeys.X: offset.dx.isNaN ? 0 : offset.dx,
          _TouchInterceptorKeys.Y: offset.dy.isNaN ? 0 : offset.dy
        };
        tree[_TouchInterceptorKeys.rect] = viewFrame;
      }
      if (_keysArray != null) {
        final key = _keysArray?[root.hashCode];
        if (key != null) {
          tree[_TouchInterceptorKeys.id] = key;
        }
      }
      //CHILDREN
      final List<RenderObject> children = [];
      root!.visitChildren(children.add);
      tree[_TouchInterceptorKeys.children] = [];
      int counter = 0;
      for (final RenderObject child in children) {
        bool isVisible = true;
        if (root is RenderIndexedStack) {
          // A Stack that shows a single child from a list of children.
          // https://api.flutter.dev/flutter/widgets/IndexedStack-class.html
          isVisible = counter == root.index;
        }
        if (isVisible) {
          final childTree = visit(child);
          if (childTree != null) {
            tree[_TouchInterceptorKeys.children].add(childTree);
          }
        }
        counter++;
      }
      return tree;
    }

    Map<String, dynamic>? tree = {};
    globalContext.visitChildElements((element) {
      tree = visit(element.renderObject);
    });
    // We use this wrapper for cases where there is more than one provider
    // that supplying DOM structure and we want that root view will be in
    // same childN as he is in native structure
    final Map<String, dynamic> flutterPXWrapper = {
      _TouchInterceptorKeys.className: 'flutterPXWrapper',
      _TouchInterceptorKeys.children: [tree]
    };
    return flutterPXWrapper;
  }

  // Private
  void _createTapEvent(Offset? position) {
    try {
      if (GainsightPX.isInitialized &&
          GainsightPX.instance._shouldTrackTapEvents) {
        if (_currentPosition != null &&
            _currentEntries != null &&
            position != null) {
          final Map elementTree = _generateElementTree();
          final String? viewClass =
              elementTree[_TouchInterceptorKeys.renderViewClass];
          final List? viewElements =
              elementTree[_TouchInterceptorKeys.viewElements];
          final Map? viewFrame = elementTree[_TouchInterceptorKeys.rect];
          GainsightPX.instance._taps(viewClass, viewElements, viewFrame);
        } else {
          throw Exception('In valid position');
        }
      }
    } on Exception {
      rethrow;
    }
  }

  void _performHitTest(Offset position) {
    _currentPosition = position;
    final HitTestResult hitTestResult = HitTestResult();
    RendererBinding.instance.hitTestInView(hitTestResult, _currentPosition!,
        RendererBinding.instance.renderViews.first.flutterView.viewId);
    final Iterator<HitTestEntry> entries = hitTestResult.path.iterator;
    //Save HitTest result
    _currentEntries = entries;
  }

  Map _generateElementTree() {
    final List result = [];
    String? renderViewClass;
    Map? viewFrame;
    while (_currentEntries!.moveNext()) {
      //On HitTest result get first element (is the one you touched on)
      if (_currentEntries!.current.target is RenderObject) {
        RenderObject? renderObject =
            _currentEntries!.current.target as RenderObject;
        //If his from type RenderObject iterate on all of his parents and create ElementTree
        while (renderObject != null) {
          int childN = 1;
          int childClassN = 1;
          int? itemIndex;
          final List<RenderObject> renderObjectChildren = [];
          final RenderObject? renderObjectParent =
              renderObject.parent;

          if (renderObjectParent != null) {
            renderObjectParent.visitChildren(renderObjectChildren.add);

            if (renderObject is RenderIndexedSemantics) {
              //This is element in listView and we can get childN from index
              itemIndex = renderObject.index + 1;
            }

            //Iterate on parent children and once you find yourself you know childN
            for (var i = 0; i < renderObjectChildren.length; i++) {
              if (renderObjectChildren[i] == renderObject) {
                break;
              }
              childN++;
              if (renderObjectChildren[i].runtimeType.toString() ==
                  renderObject.runtimeType.toString()) {
                childClassN++;
              }
            }

            final Map element = {
              _TouchInterceptorKeys.className:
                  renderObject.runtimeType.toString(),
              _TouchInterceptorKeys.childN: childN,
              _TouchInterceptorKeys.childClassN: childClassN,
              _TouchInterceptorKeys.attributes: {}
            };

            if (_keysArray != null) {
              final key = _keysArray?[renderObject.hashCode];
              if (key != null) {
                element[_TouchInterceptorKeys.attributes]
                    [_TouchInterceptorKeys.id] = key;
              }
            }

            if (itemIndex != null) {
              element[_TouchInterceptorKeys.itemIndex] = itemIndex;
            }
            renderViewClass ??= renderObject.runtimeType.toString();
            if ((null == viewFrame) && (renderObject is RenderBox)) {
              final Offset offset =
                  renderObject.localToGlobal(const Offset(0, 0));
              viewFrame = {
                _TouchInterceptorKeys.width: renderObject.size.width,
                _TouchInterceptorKeys.height: renderObject.size.height,
                _TouchInterceptorKeys.X: offset.dx.isNaN ? 0 : offset.dx,
                _TouchInterceptorKeys.Y: offset.dy.isNaN ? 0 : offset.dy
              };
            }
            result.add(element);
          }
          renderObject = renderObjectParent;
        }
        break;
      }
    }
    //reverse list to start from root view
    final List reversedResult = result.reversed.toList();
    // _elementTree = reversedResult;
    //Remove position and entries for no double validation
    _currentPosition = null;
    _currentEntries = null;
    return {
      _TouchInterceptorKeys.viewElements: reversedResult,
      _TouchInterceptorKeys.renderViewClass: renderViewClass,
      _TouchInterceptorKeys.rect: viewFrame
    };
  }

  Map? _getDisplayRect(List elementTree) {
    Map? attributes;
    void visitor(Element element) {
      if (element.renderObject is RenderObject) {
        if (element.renderObject.runtimeType.toString() ==
            elementTree[0][_TouchInterceptorKeys.className]) {
          final RenderBox? renderObject =
              _evaluate(element.renderObject, elementTree) as RenderBox?;
          if (renderObject != null) {
            final Offset offset =
                renderObject.localToGlobal(const Offset(0, 0));
            attributes = {
              _TouchInterceptorKeys.width: renderObject.size.width,
              _TouchInterceptorKeys.height: renderObject.size.height,
              _TouchInterceptorKeys.X: offset.dx.isNaN ? 0 : offset.dx,
              _TouchInterceptorKeys.Y: offset.dy.isNaN ? 0 : offset.dy
            };
          } else {
            element.visitChildren(visitor);
          }
        }
      }
    }

    globalContext.visitChildElements(visitor);
    return attributes;
  }

  RenderObject? _evaluate(RenderObject? rootRenderObject, List elementTree) {
    int counter = 1;
    RenderObject? renderObject = rootRenderObject;
    while (counter < elementTree.length) {
      final List<RenderObject> renderObjectChildren = [];
      renderObject!.visitChildren(renderObjectChildren.add);
      renderObject = null;
      for (var i = 0; i < renderObjectChildren.length; i++) {
        if (renderObjectChildren[i].runtimeType.toString() ==
            elementTree[counter][_TouchInterceptorKeys.className]) {
          int childN = i;
          num? elementChildN =
              elementTree[counter][_TouchInterceptorKeys.childN] - 1;
          if (renderObjectChildren[i] is RenderIndexedSemantics) {
            final RenderIndexedSemantics renderIndexedSemantics =
                renderObjectChildren[i] as RenderIndexedSemantics;
            childN = renderIndexedSemantics.index;
            elementChildN =
                elementTree[counter][_TouchInterceptorKeys.itemIndex] - 1;
          }
          if (childN == elementChildN) {
            renderObject = renderObjectChildren[i];
            counter++;
            break;
          }
        }
      }
      if (renderObject == null) {
        break;
      }
    }
    return counter == elementTree.length ? renderObject : null;
  }
}

class TouchListener extends StatefulWidget {
  const TouchListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  _TouchListenerState createState() => _TouchListenerState();
}

class _TouchListenerState extends State<TouchListener> {
  double _topPadding = 0;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      GainsightPX.instance._channel
          .invokeMethod('isWebEditMode')
          .then((isWebEditMode) => {
                setState(() {
                  if (isWebEditMode) {
                    /// Web editor have a 109px top padding,
                    /// we have to give it to root flutter view,
                    /// if not the touch position of the canvas and the view paint have diff
                    _topPadding = 109;
                  }
                })
              });
    }
  }

  Widget _getWebChild() {
    return Padding(
        padding: EdgeInsets.only(top: _topPadding), child: _getMobileChild());
  }

  Widget _getMobileChild() {
    return CustomPaint(
      painter: _CustomPainter(),
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            GainsightPX.instance._channel
                .invokeMethod('scrollStateChanged', {'scrollState': true});
          }
          if (notification is ScrollEndNotification) {
            GainsightPX.instance._channel
                .invokeMethod('scrollStateChanged', {'scrollState': false});
          }
          return false;
        },
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _TouchInterpreter.instance.globalContext = context;

    final tapRecognizer = _TapListener(
        legitDistance: TapGestureRecognizer().postAcceptSlopTolerance);

    Widget finalChild;
    if (kIsWeb) {
      finalChild = _getWebChild();
    } else {
      finalChild = _getMobileChild();
    }

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: tapRecognizer._onPointerDown,
      onPointerMove: tapRecognizer._onPointerMoved,
      onPointerCancel: tapRecognizer._onPointerCanceled,
      onPointerUp: tapRecognizer._onPointerUp,
      child: finalChild,
    );
  }
}

class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    try {
      _TouchInterpreter.instance._setKeysArray();
      GainsightPX.instance._channel.invokeMethod('flutterViewChanged', null);
    } on PlatformException catch (e) {
      print('error on DOM Builder: $e');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _TapListener {
  _TapListener({this.legitDistance});

  final double? legitDistance;
  Offset? origin;

  void _onPointerDown(PointerDownEvent d) {
    origin = d.position;
    try {
      // we should perform the hit-test on touch down because on every touch there is rerender and
      // the view is from type sliver then if we do the test on touch up it might not be availble yet.
      _TouchInterpreter.instance._performHitTest(d.position);
    } on Exception catch (e) {
      print('error on tap: $e');
    }
  }

  void _onPointerMoved(PointerMoveEvent d) {
    if (null != origin) {
      if ((origin! - d.position).distance > legitDistance!) {
        origin = null;
      }
    }
  }

  void _onPointerCanceled(PointerCancelEvent d) {
    origin = null;
  }

  void _onPointerUp(PointerUpEvent d) {
    if (null != origin) {
      if ((origin! - d.position).distance > legitDistance!) {
        origin = null;
      }
    }
    if (null != origin) {
      try {
        _TouchInterpreter.instance._createTapEvent(d.position);
      } on Exception catch (e) {
        print('error on tap: $e');
      }
    }
  }
}
